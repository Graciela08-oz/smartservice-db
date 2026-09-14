-- 1. REGISTRO DE CLIENTE CON ESTABLECIMIENTO Y SISTEMA
CREATE OR REPLACE PROCEDURE sp_registrar_cliente_completo(
    p_tipo_cliente VARCHAR,
    p_nombre VARCHAR,
    p_razon_social VARCHAR,
    p_doc_identidad VARCHAR,
    p_telefono VARCHAR,
    p_telefono_alt VARCHAR,
    p_correo VARCHAR,
    p_nom_establecimiento VARCHAR,
    p_direccion VARCHAR,
    p_tipo_inmueble VARCHAR,
    p_latITUD DECIMAL,
    p_longitud DECIMAL,
    p_nom_sistema VARCHAR,
    p_num_serie VARCHAR,
    p_fecha_inst DATE,
    p_fecha_prox_maint DATE
)
LANGUAGE plpgsql AS $$
DECLARE
    v_cliente_id INT;
    v_est_id INT;
BEGIN
    INSERT INTO public.cliente (
        tipo_cliente, nombre, razon_social, documento_identidad, 
        telefono, telefono_alternativo, correo
    ) VALUES (
        p_tipo_cliente, p_nombre, p_razon_social, p_doc_identidad, 
        p_telefono, p_telefono_alt, p_correo
    ) RETURNING id INTO v_cliente_id;

    INSERT INTO public.establecimiento (
        cliente_id, nombre_establecimiento, direccion, 
        tipo_inmueble, latitud, longitud
    ) VALUES (
        v_cliente_id, p_nom_establecimiento, p_direccion, 
        p_tipo_inmueble, p_latITUD, p_longitud
    ) RETURNING id INTO v_est_id;

    IF p_nom_sistema IS NOT NULL THEN
        INSERT INTO public.sistema_instalado (
            establecimiento_id, nombre_sistema, numero_serie, 
            fecha_instalacion, fecha_proximo_mantenimiento
        ) VALUES (
            v_est_id, p_nom_sistema, p_num_serie, 
            p_fecha_inst, p_fecha_prox_maint
        );
    END IF;
END;
$$;


-- 2. EMISIÓN DE COTIZACIÓN COMPLETA (PRODUCTOS Y SERVICIOS)
CREATE OR REPLACE PROCEDURE sp_crear_cotizacion(
    p_establecimiento_id INT,
    p_usuario_id INT,
    p_numero_cotizacion VARCHAR,
    p_fecha_emision DATE,
    p_fecha_vencimiento DATE,
    p_productos_json JSONB,
    p_servicios_json JSONB
)
LANGUAGE plpgsql AS $$
DECLARE
    v_cotizacion_id INT;
    v_item JSONB;
BEGIN
    INSERT INTO public.cotizacion (
        establecimiento_id, usuario_id, numero_cotizacion, 
        fecha_emision, fecha_vencimiento, estado
    ) VALUES (
        p_establecimiento_id, p_usuario_id, p_numero_cotizacion, 
        p_fecha_emision, p_fecha_vencimiento, 'PENDIENTE'
    ) RETURNING id INTO v_cotizacion_id;

    IF p_productos_json IS NOT NULL THEN
        FOR v_item IN SELECT * FROM jsonb_array_elements(p_productos_json)
        LOOP
            INSERT INTO public.detalle_cotizacion_producto (
                cotizacion_id, producto_id, cantidad, precio_unitario
            ) VALUES (
                v_cotizacion_id,
                (v_item->>'producto_id')::INT,
                (v_item->>'cantidad')::INT,
                (v_item->>'precio_unitario')::DECIMAL
            );
        END LOOP;
    END IF;

    IF p_servicios_json IS NOT NULL THEN
        FOR v_item IN SELECT * FROM jsonb_array_elements(p_servicios_json)
        LOOP
            INSERT INTO public.detalle_cotizacion_servicio (
                cotizacion_id, servicio_id, horas_estimadas, precio_hora
            ) VALUES (
                v_cotizacion_id,
                (v_item->>'servicio_id')::INT,
                (v_item->>'horas_estimadas')::INT,
                (v_item->>'precio_hora')::DECIMAL
            );
        END LOOP;
    END IF;
END;
$$;


-- 3. APROBACIÓN DE COTIZACIÓN Y GENERACIÓN AUTOMÁTICA DE ORDEN DE TRABAJO
CREATE OR REPLACE PROCEDURE sp_aprobar_cotizacion_y_generar_orden(
    p_cotizacion_id INT,
    p_codigo_orden VARCHAR,
    p_tipo_trabajo VARCHAR,
    p_fecha_programada TIMESTAMP
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE public.cotizacion
    SET estado = 'APROBADA'
    WHERE id = p_cotizacion_id;

    INSERT INTO public.orden_trabajo (
        cotizacion_id, codigo_orden, tipo_trabajo, 
        fecha_programada, estado
    ) VALUES (
        p_cotizacion_id, p_codigo_orden, p_tipo_trabajo, 
        p_fecha_programada, 'PROGRAMADA'
    );
END;
$$;


-- 4. REGISTRO DE ENTRADA DE STOCK POR COMPRA O AJUSTE MANUAL EN KARDEX
CREATE OR REPLACE PROCEDURE sp_registrar_entrada_stock(
    p_producto_id INT,
    p_usuario_id INT,
    p_cantidad INT,
    p_origen VARCHAR,
    p_observacion TEXT
)
LANGUAGE plpgsql AS $$
DECLARE
    v_stock_anterior INT;
BEGIN
    SELECT stock_disponible INTO v_stock_anterior
    FROM public.producto
    WHERE id = p_producto_id;

    UPDATE public.producto
    SET stock_disponible = stock_disponible + p_cantidad
    WHERE id = p_producto_id;

    INSERT INTO public.movimiento_kardex (
        producto_id, usuario_id, tipo_movimiento, 
        cantidad, stock_anterior, origen_movimiento, 
        fecha_movimiento, observacion
    ) VALUES (
        p_producto_id, p_usuario_id, 'ENTRADA', 
        p_cantidad, v_stock_anterior, p_origen, 
        NOW(), p_observacion
    );
END;
$$;


-- 5. CIERRE FINANCIERO Y EMISIÓN DE NOTA DE SERVICIO
CREATE OR REPLACE PROCEDURE sp_cerrar_orden_y_emitir_nota(
    p_orden_trabajo_id INT,
    p_numero_nota VARCHAR,
    p_anticipo_pagado DECIMAL,
    p_observacion TEXT
)
LANGUAGE plpgsql AS $$
BEGIN
    UPDATE public.orden_trabajo
    SET estado = 'FINALIZADA'
    WHERE id = p_orden_trabajo_id;

    INSERT INTO public.nota_servicio (
        orden_trabajo_id, numero_nota, fecha_emision, 
        monto_total, anticipo_pagado, observacion
    ) VALUES (
        p_orden_trabajo_id, p_numero_nota, CURRENT_DATE, 
        0.00, p_anticipo_pagado, p_observacion
    );
END;
$$;