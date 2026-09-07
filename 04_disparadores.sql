-- DISPARADORES

-- 1. Guardar nuevo cliente en bitácora
CREATE OR REPLACE FUNCTION fn_trg_cliente()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO BITACORA (usuario_id, fecha_hora, accion, descripcion)
    VALUES (1, NOW(), 'NUEVO_CLIENTE', CONCAT('Cliente creado: ', NEW.razon_social));
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_cliente
AFTER INSERT ON CLIENTE
FOR EACH ROW
EXECUTE FUNCTION fn_trg_cliente();


-- 2. Evitar que el stock sea menor a cero
CREATE OR REPLACE FUNCTION fn_trg_stock()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF NEW.stock_disponible < 0 THEN
        RAISE EXCEPTION 'El stock no puede ser menor a 0';
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_stock
BEFORE INSERT OR UPDATE ON PRODUCTO
FOR EACH ROW
EXECUTE FUNCTION fn_trg_stock();


-- 3. Registrar cambio de stock en Kardex
CREATE OR REPLACE FUNCTION fn_trg_kardex()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF NEW.stock_disponible <> OLD.stock_disponible THEN
        INSERT INTO MOVIMIENTO_KARDEX (producto_id, cantidad_movimiento, origen_movimiento, fecha_movimiento)
        VALUES (NEW.id, (NEW.stock_disponible - OLD.stock_disponible), 'AJUSTE', NOW());
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_kardex
AFTER UPDATE ON PRODUCTO
FOR EACH ROW
EXECUTE FUNCTION fn_trg_kardex();


-- 4. Guardar cambio de estado de orden en bitácora
CREATE OR REPLACE FUNCTION fn_trg_orden()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF OLD.estado IS DISTINCT FROM NEW.estado THEN
        INSERT INTO BITACORA (usuario_id, fecha_hora, accion, descripcion)
        VALUES (1, NOW(), 'CAMBIO_ESTADO', CONCAT('Orden ', NEW.codigo_orden, ' cambio de estado'));
    END IF;
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_orden
AFTER UPDATE ON ORDEN_TRABAJO
FOR EACH ROW
EXECUTE FUNCTION fn_trg_orden();


-- 5. Convertir correo de usuario a minúsculas
CREATE OR REPLACE FUNCTION fn_trg_usuario()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    NEW.correo := LOWER(NEW.correo);
    RETURN NEW;
END;
$$;

CREATE TRIGGER trg_usuario
BEFORE INSERT OR UPDATE ON USUARIO
FOR EACH ROW
EXECUTE FUNCTION fn_trg_usuario();
