-- PROCEDIMIENTOS ALMACENADOS

-- 1. Cambiar estado de una Cotización a 'APROBADA'
CREATE OR REPLACE FUNCTION sp_aprobar_cotizacion(
    p_cotizacion_id INT
) RETURNS VOID AS $$
BEGIN
    UPDATE cotizacion 
    SET estado = 'APROBADA' 
    WHERE id = p_cotizacion_id AND estado = 'PENDIENTE';
END;
$$ LANGUAGE plpgsql;


-- 2. Finalizar Orden de Trabajo y registrar observaciones
CREATE OR REPLACE FUNCTION sp_finalizar_orden_trabajo(
    p_orden_id INT,
    p_observaciones TEXT
) RETURNS VOID AS $$
BEGIN
    UPDATE orden_trabajo
    SET estado = 'FINALIZADA',
        fecha_fin_real = CURRENT_TIMESTAMP,
        observaciones_tecnico = p_observaciones
    WHERE id = p_orden_id;
END;
$$ LANGUAGE plpgsql;


-- 3. Asignar un Técnico Líder a una Orden de Trabajo
CREATE OR REPLACE FUNCTION sp_asignar_tecnico_lider(
    p_orden_id INT,
    p_usuario_id INT
) RETURNS VOID AS $$
BEGIN
    UPDATE orden_trabajo_tecnico 
    SET es_lider = FALSE 
    WHERE orden_trabajo_id = p_orden_id;
    
    INSERT INTO orden_trabajo_tecnico (orden_trabajo_id, usuario_id, es_lider)
    VALUES (p_orden_id, p_usuario_id, TRUE)
    ON CONFLICT (orden_trabajo_id, usuario_id) 
    DO UPDATE SET es_lider = TRUE;
END;
$$ LANGUAGE plpgsql;


-- 4. Crear Ticket de Mantenimiento Preventivo
CREATE OR REPLACE FUNCTION sp_crear_ticket_mantenimiento(
    p_sistema_id INT,
    p_descripcion TEXT,
    p_urgencia VARCHAR
) RETURNS VOID AS $$
BEGIN
    INSERT INTO mantenimiento_ticket (
        sistema_instalado_id, 
        tipo_mantenimiento, 
        nivel_urgencia, 
        descripcion_incidencia, 
        estado
    )
    VALUES (
        p_sistema_id, 
        'PREVENTIVO', 
        p_urgencia, 
        p_descripcion, 
        'ABIERTO'
    );
END;
$$ LANGUAGE plpgsql;


-- 5. Ajustar Margen de Ganancia de Productos por Categoría
CREATE OR REPLACE FUNCTION sp_actualizar_margen_categoria(
    p_categoria_id INT,
    p_nuevo_margen DECIMAL(5,2)
) RETURNS VOID AS $$
BEGIN
    UPDATE producto 
    SET margen_ganancia = p_nuevo_margen 
    WHERE categoria_producto_id = p_categoria_id;
END;
$$ LANGUAGE plpgsql;