-- 1. AUDITORÍA: Registrar creación de cliente en la bitácora
CREATE OR REPLACE FUNCTION fn_trg_cliente()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO public.bitacora (usuario_id, fecha_hora, accion, descripcion)
    VALUES (
        1, 
        NOW(), 
        'NUEVO_CLIENTE', 
        CONCAT('Cliente creado: ', COALESCE(NEW.nombre, NEW.razon_social))
    );
    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_cliente
AFTER INSERT ON public.cliente
FOR EACH ROW
EXECUTE FUNCTION fn_trg_cliente();


-- 2. INTEGRIDAD: Evitar que el stock disponible sea menor a cero
CREATE OR REPLACE FUNCTION fn_trg_stock()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF NEW.stock_disponible < 0 THEN
        RAISE EXCEPTION 'Error de regla de negocio: El stock del producto "%" no puede ser menor a 0.', NEW.nombre;
    END IF;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_stock
BEFORE INSERT OR UPDATE ON public.producto
FOR EACH ROW
EXECUTE FUNCTION fn_trg_stock();


-- 3. TRAZABILIDAD / KARDEX: Registrar ajustes manuales de stock en Kardex
CREATE OR REPLACE FUNCTION fn_trg_kardex()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
    v_diferencia INT;
    v_tipo VARCHAR(20);
BEGIN
    IF NEW.stock_disponible <> OLD.stock_disponible THEN
        v_diferencia := NEW.stock_disponible - OLD.stock_disponible;
        
        IF v_diferencia > 0 THEN
            v_tipo := 'ENTRADA';
        ELSE
            v_tipo := 'SALIDA';
        END IF;

        INSERT INTO public.movimiento_kardex (
            producto_id, 
            usuario_id, 
            tipo_movimiento, 
            cantidad, 
            stock_anterior, 
            origen_movimiento, 
            fecha_movimiento, 
            observacion
        ) VALUES (
            NEW.id, 
            1, 
            v_tipo, 
            ABS(v_diferencia), 
            OLD.stock_disponible, 
            'AJUSTE', 
            NOW(), 
            'Ajuste manual de stock registrado por el sistema'
        );
    END IF;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_kardex
AFTER UPDATE ON public.producto
FOR EACH ROW
EXECUTE FUNCTION fn_trg_kardex();


-- 4. AUDITORÍA DE PROCESO: Guardar cambio de estado de orden de trabajo en bitácora
CREATE OR REPLACE FUNCTION fn_trg_orden()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF OLD.estado IS DISTINCT FROM NEW.estado THEN
        INSERT INTO public.bitacora (usuario_id, fecha_hora, accion, descripcion)
        VALUES (
            1, 
            NOW(), 
            'CAMBIO_ESTADO', 
            CONCAT('Orden ', NEW.codigo_orden, ' cambió de estado: ', OLD.estado, ' -> ', NEW.estado)
        );
    END IF;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_orden
AFTER UPDATE ON public.orden_trabajo
FOR EACH ROW
EXECUTE FUNCTION fn_trg_orden();


-- 5. NORMALIZACIÓN DE DATOS: Convertir correo de usuario a minúsculas
CREATE OR REPLACE FUNCTION fn_trg_usuario()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    NEW.correo := LOWER(NEW.correo);
    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_usuario
BEFORE INSERT OR UPDATE ON public.usuario
FOR EACH ROW
EXECUTE FUNCTION fn_trg_usuario();


-- 6. AUTOMATIZACIÓN OPERATIVA: Actualización de stock al registrar consumo de material
CREATE OR REPLACE FUNCTION fn_trg_consumo_material()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
    v_stock_actual INT;
BEGIN
    SELECT stock_disponible INTO v_stock_actual 
    FROM public.producto 
    WHERE id = NEW.producto_id;

    IF v_stock_actual < NEW.cantidad_utilizada THEN
        RAISE EXCEPTION 'Stock insuficiente para el producto ID %. Stock actual: %, Solicitado: %', 
            NEW.producto_id, v_stock_actual, NEW.cantidad_utilizada;
    END IF;

    UPDATE public.producto 
    SET stock_disponible = stock_disponible - NEW.cantidad_utilizada
    WHERE id = NEW.producto_id;

    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_consumo_material
BEFORE INSERT ON public.detalle_consumo_material
FOR EACH ROW
EXECUTE FUNCTION fn_trg_consumo_material();


-- 7. CÁLCULO FINANCIERO: Asignación automática del monto total a la Nota de Servicio desde la Cotización
CREATE OR REPLACE FUNCTION fn_actualizar_monto_nota_servicio()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
DECLARE
    v_total_cotizacion DECIMAL(12,2);
BEGIN
    SELECT 
        COALESCE((SELECT SUM(cantidad * precio_unitario) FROM public.detalle_cotizacion_producto WHERE cotizacion_id = ot.cotizacion_id), 0) +
        COALESCE((SELECT SUM(horas_estimadas * precio_hora) FROM public.detalle_cotizacion_servicio WHERE cotizacion_id = ot.cotizacion_id), 0)
    INTO v_total_cotizacion
    FROM public.orden_trabajo ot
    WHERE ot.id = NEW.orden_trabajo_id;

    NEW.monto_total := v_total_cotizacion;

    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_actualizar_monto_nota_servicio
BEFORE INSERT ON public.nota_servicio
FOR EACH ROW
EXECUTE FUNCTION fn_actualizar_monto_nota_servicio();