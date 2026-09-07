-- 1. CONSULTAS SIMPLES

-- 1. Mantenimientos y órdenes de trabajo registradas
SELECT id, tipo_trabajo, codigo_orden, fecha_programada, estado 
FROM ORDEN_TRABAJO;

-- 2. Listar clientes con sus datos de contacto principales
SELECT razon_social, documento_identidad, telefono, correo, tipo_cliente 
FROM CLIENTE;

-- 3. Identificar productos disponibles ordenados por su precio de compra
SELECT nombre, precio_compra_actual, margen_ganancia, stock_disponible 
FROM PRODUCTO 
ORDER BY precio_compra_actual DESC;

-- 4. Ver el catálogo de sistemas de seguridad instalados
SELECT id, nombre_sistema, numero_serie, fecha_instalacion 
FROM SISTEMA_INSTALADO;

-- 5. Consultar los servicios técnicos disponibles y sus precios base
SELECT id, nombre, descripcion, precio_hora_base 
FROM SERVICIO;

-- 6. Obtener la lista de productos con precio de venta calculado según margen
SELECT 
    nombre, 
    precio_compra_actual, 
    margen_ganancia,
    ROUND(precio_compra_actual * (1 + margen_ganancia / 100), 2) AS precio_venta_calculado
FROM PRODUCTO;

-- 7. Listar las cotizaciones en estado 'PENDIENTE'
SELECT numero_cotizacion, fecha_emision, fecha_vencimiento 
FROM COTIZACION 
WHERE estado = 'PENDIENTE';

-- 8. Consultar tickets de mantenimiento con urgencia 'ALTA' o 'CRITICA'
SELECT id, tipo_mantenimiento, nivel_urgencia, descripcion_incidencia, estado 
FROM MANTENIMIENTO_TICKET 
WHERE nivel_urgencia IN ('ALTA', 'CRITICA');


-- 2. CONSULTAS MÚLTIPLES (JOINS)

-- 9. Productos cruzados con sus respectivas categorías
SELECT 
    p.nombre AS producto, 
    c.nombre AS categoria, 
    p.unidad_medida, 
    p.stock_disponible
FROM PRODUCTO p
INNER JOIN CATEGORIA_PRODUCTO c ON p.categoria_producto_id = c.id;

-- 10. Listar los proveedores y sus productos asignados
SELECT 
    pr.razon_social AS proveedor, 
    p.nombre AS producto, 
    pp.codigo_item_proveedor
FROM PRODUCTO_PROVEEDOR pp
INNER JOIN PROVEEDOR pr ON pp.proveedor_id = pr.id
INNER JOIN PRODUCTO p ON pp.producto_id = p.id;

-- 11. Relación de usuarios del sistema con sus roles asignados
SELECT 
    u.nombre AS usuario, 
    u.correo, 
    u.telefono, 
    r.nombre AS rol
FROM USUARIO u
INNER JOIN ROL r ON u.rol_id = r.id;

-- 12. Mostrar los inmuebles o establecimientos vinculados a cada cliente
SELECT 
    c.razon_social AS cliente, 
    e.nombre_establecimiento, 
    e.direccion, 
    e.tipo_inmueble
FROM ESTABLECIMIENTO e
INNER JOIN CLIENTE c ON e.cliente_id = c.id;

-- 13. Detalle de servicios incluidos en cada cotización realizada
SELECT 
    c.numero_cotizacion, 
    s.nombre AS servicio, 
    dcs.horas_estimadas, 
    dcs.precio_hora
FROM DETALLE_COTIZACION_SERVICIO dcs
INNER JOIN COTIZACION c ON dcs.cotizacion_id = c.id
INNER JOIN SERVICIO s ON dcs.servicio_id = s.id;

-- 14. Consultar órdenes de trabajo indicando cliente, establecimiento y técnicos asignados
SELECT 
    ot.codigo_orden,
    ot.tipo_trabajo,
    ot.estado,
    c.razon_social AS cliente,
    e.nombre_establecimiento,
    u.nombre AS tecnico,
    ott.es_lider
FROM ORDEN_TRABAJO ot
LEFT JOIN COTIZACION cot ON ot.cotizacion_id = cot.id
LEFT JOIN CLIENTE c ON cot.cliente_id = c.id
LEFT JOIN ESTABLECIMIENTO e ON cot.establecimiento_id = e.id
INNER JOIN ORDEN_TRABAJO_TECNICO ott ON ot.id = ott.orden_trabajo_id
INNER JOIN USUARIO u ON ott.usuario_id = u.id;

-- 15. Mostrar los productos utilizados en cada orden de trabajo
SELECT
    ot.codigo_orden,
    p.nombre AS producto,
    d.cantidad_utilizada,
    d.fecha_registro
FROM ORDEN_TRABAJO ot
INNER JOIN DETALLE_CONSUMO_MATERIAL d ON ot.id = d.orden_trabajo_id
INNER JOIN PRODUCTO p ON d.producto_id = p.id;

-- 16. Obtener el historial de movimientos en Kardex con nombre de producto y usuario
SELECT 
    k.fecha_movimiento,
    p.nombre AS producto,
    u.nombre AS usuario,
    k.tipo_movimiento,
    k.cantidad,
    k.stock_anterior
FROM MOVIMIENTO_KARDEX k
INNER JOIN PRODUCTO p ON k.producto_id = p.id
INNER JOIN USUARIO u ON k.usuario_id = u.id
ORDER BY k.fecha_movimiento DESC;


-- 3. SUBCONSULTAS

-- 17. Encontrar el servicio técnico con el costo por hora más elevado
SELECT nombre, precio_hora_base 
FROM SERVICIO 
WHERE precio_hora_base = (
    SELECT MAX(precio_hora_base) 
    FROM SERVICIO
);

-- 18. Productos cuyo precio de compra supera o iguala el promedio del catálogo
SELECT nombre, precio_compra_actual 
FROM PRODUCTO 
WHERE precio_compra_actual >= (
    SELECT AVG(precio_compra_actual) 
    FROM PRODUCTO
);

-- 19. Mostrar el producto que tiene el mayor stock disponible
SELECT nombre, stock_disponible
FROM PRODUCTO
WHERE stock_disponible = (
    SELECT MAX(stock_disponible)
    FROM PRODUCTO
);

-- 20. Obtener los roles que tienen al menos un usuario registrado
SELECT id, nombre, descripcion 
FROM ROL 
WHERE id IN (
    SELECT DISTINCT rol_id 
    FROM USUARIO
);

-- 21. Identificar los productos que registraron cualquier movimiento en el Kardex
SELECT id, nombre, stock_disponible 
FROM PRODUCTO 
WHERE id IN (
    SELECT DISTINCT producto_id 
    FROM MOVIMIENTO_KARDEX
);

-- 22. Mostrar los clientes que tienen al menos un establecimiento registrado
SELECT id, razon_social
FROM CLIENTE
WHERE id IN (
    SELECT cliente_id
    FROM ESTABLECIMIENTO
);

-- 23. Obtener los productos que nunca han sido cotizados
SELECT nombre, stock_disponible 
FROM PRODUCTO 
WHERE id NOT IN (
    SELECT DISTINCT producto_id 
    FROM DETALLE_COTIZACION_PRODUCTO
);

-- 24. Listar clientes con cotizaciones en servicios con monto superior a $500
SELECT razon_social, correo 
FROM CLIENTE 
WHERE id IN (
    SELECT c.cliente_id 
    FROM COTIZACION c
    INNER JOIN DETALLE_COTIZACION_SERVICIO dcs ON c.id = dcs.cotizacion_id
    GROUP BY c.cliente_id, c.id
    HAVING SUM(dcs.horas_estimadas * dcs.precio_hora) > 500
);

-- 25. Mostrar sistemas cuya fecha de próximo mantenimiento sea la más antigua
SELECT nombre_sistema, fecha_proximo_mantenimiento
FROM SISTEMA_INSTALADO
WHERE fecha_proximo_mantenimiento = (
    SELECT MIN(fecha_proximo_mantenimiento)
    FROM SISTEMA_INSTALADO
);

-- 26. Sistemas instalados con mantenimiento próximo dentro de 90 días respecto a cotizaciones
SELECT nombre_sistema, fecha_proximo_mantenimiento 
FROM SISTEMA_INSTALADO 
WHERE fecha_proximo_mantenimiento <= (
    SELECT MAX(fecha_emision) + INTERVAL '90 days' 
    FROM COTIZACION
);

-- 27. Mostrar proveedores que suministran productos con stock crítico (menor a 5 unidades)
SELECT razon_social, telefono, correo 
FROM PROVEEDOR 
WHERE id IN (
    SELECT proveedor_id 
    FROM PRODUCTO_PROVEEDOR 
    WHERE producto_id IN (
        SELECT id FROM PRODUCTO WHERE stock_disponible < 5
    )
);

-- 28. Obtener técnicos asignados a la última orden de trabajo registrada
SELECT nombre, correo, telefono 
FROM USUARIO 
WHERE id IN (
    SELECT usuario_id 
    FROM ORDEN_TRABAJO_TECNICO 
    WHERE orden_trabajo_id = (
        SELECT MAX(id) FROM ORDEN_TRABAJO
    )
);

-- 29. Listar productos cuyo margen de ganancia es superior al margen promedio del catálogo
SELECT nombre, margen_ganancia, precio_compra_actual 
FROM PRODUCTO 
WHERE margen_ganancia > (
    SELECT AVG(margen_ganancia) 
    FROM PRODUCTO
);

-- 30. Obtener cotizaciones con un monto total estimado superior al promedio global de cotizaciones
SELECT numero_cotizacion, fecha_emision, estado 
FROM COTIZACION 
WHERE id IN (
    SELECT cotizacion_id 
    FROM DETALLE_COTIZACION_SERVICIO 
    GROUP BY cotizacion_id 
    HAVING SUM(horas_estimadas * precio_hora) > (
        SELECT AVG(monto_total) 
        FROM (
            SELECT SUM(horas_estimadas * precio_hora) AS monto_total 
            FROM DETALLE_COTIZACION_SERVICIO 
            GROUP BY cotizacion_id
        ) sub
    )
);
