-- DISPARADORES

-- 1. Guardar nuevo cliente en bitácora
CREATE OR REPLACE FUNCTION fn_trg_cliente()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    INSERT INTO bitacora (usuario_id, fecha_hora, accion, descripcion)
    VALUES (1, NOW(), 'NUEVO_CLIENTE', CONCAT('Cliente creado: ', new.razon_social));
    RETURN new;
END;
$$;

CREATE TRIGGER trg_cliente
AFTER INSERT ON cliente
FOR EACH ROW
EXECUTE FUNCTION fn_trg_cliente();


-- 2. Evitar que el stock sea menor a cero
CREATE OR REPLACE FUNCTION fn_trg_stock()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF new.stock_disponible < 0 THEN
        RAISE EXCEPTION 'El stock no puede ser menor a 0';
    END IF;
    RETURN new;
END;
$$;

CREATE TRIGGER trg_stock
BEFORE INSERT OR UPDATE ON producto
FOR EACH ROW
EXECUTE FUNCTION fn_trg_stock();


-- 3. Registrar cambio de stock en Kardex
CREATE OR REPLACE FUNCTION fn_trg_kardex()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF new.stock_disponible <> old.stock_disponible THEN
        INSERT INTO movimiento_kardex (producto_id, cantidad_movimiento, origen_movimiento, fecha_movimiento)
        VALUES (new.id, (new.stock_disponible - old.stock_disponible), 'AJUSTE', NOW());
    END IF;
    RETURN new;
END;
$$;

CREATE TRIGGER trg_kardex
AFTER UPDATE ON producto
FOR EACH ROW
EXECUTE FUNCTION fn_trg_kardex();


-- 4. Guardar cambio de estado de orden en bitácora
CREATE OR REPLACE FUNCTION fn_trg_orden()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    IF old.estado IS DISTINCT FROM new.estado THEN
        INSERT INTO bitacora (usuario_id, fecha_hora, accion, descripcion)
        VALUES (1, NOW(), 'CAMBIO_ESTADO', CONCAT('Orden ', new.codigo_orden, ' cambio de estado'));
    END IF;
    RETURN new;
END;
$$;

CREATE TRIGGER trg_orden
AFTER UPDATE ON orden_trabajo
FOR EACH ROW
EXECUTE FUNCTION fn_trg_orden();


-- 5. Convertir correo de usuario a minúsculas
CREATE OR REPLACE FUNCTION fn_trg_usuario()
RETURNS TRIGGER LANGUAGE plpgsql AS $$
BEGIN
    new.correo := LOWER(new.correo);
    RETURN new;
END;
$$;

CREATE TRIGGER trg_usuario
BEFORE INSERT OR UPDATE ON usuario
FOR EACH ROW
EXECUTE FUNCTION fn_trg_usuario();