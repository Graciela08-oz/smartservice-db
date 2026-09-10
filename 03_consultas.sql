-- 1. CONSULTAS SIMPLES

-- 1. Mantenimientos y órdenes de trabajo registradas
SELECT id, tipo_trabajo, codigo_orden, fecha_programada, estado 
FROM orden_trabajo;

-- 2. Listar clientes con sus datos de contacto principales
SELECT razon_social, documento_identidad, telefono, correo, tipo_cliente 
FROM cliente;

-- 3. Identificar productos disponibles ordenados por su precio de compra
SELECT nombre, precio_compra_actual, margen_ganancia, stock_disponible 
FROM producto 
ORDER BY precio_compra_actual DESC;

-- 4. Ver el catálogo de sistemas de seguridad instalados
SELECT id, nombre_sistema, numero_serie, fecha_instalacion 
FROM sistema_instalado;

-- 5. Consultar los servicios técnicos disponibles y sus precios base
SELECT id, nombre, descripcion, precio_hora_base 
FROM servicio;

-- 6. Obtener la lista de productos con precio de venta calculado según margen
SELECT 
    nombre, 
    precio_compra_actual, 
    margen_ganancia,
    ROUND(precio_compra_actual * (1 + margen_ganancia / 100), 2) AS precio_venta_calculado
FROM producto;

-- 7. Listar las cotizaciones en estado 'PENDIENTE'
SELECT numero_cotizacion, fecha_emision, fecha_vencimiento 
FROM cotizacion 
WHERE estado = 'PENDIENTE';

-- 8. Consultar tickets de mantenimiento con urgencia 'ALTA' o 'CRITICA'
SELECT id, tipo_mantenimiento, nivel_urgencia, descripcion_incidencia, estado 
FROM mantenimiento_ticket 
WHERE nivel_urgencia IN ('ALTA', 'CRITICA');


-- 2. CONSULTAS MÚLTIPLES (JOINS)

-- 9. Productos cruzados con sus respectivas categorías
SELECT 
    p.nombre AS producto, 
    c.nombre AS categoria, 
    p.unidad_medida, 
    p.stock_disponible
FROM producto p
INNER JOIN categoria_producto c ON p.categoria_producto_id = c.id;

-- 10. Listar los proveedores y sus productos asignados
SELECT 
    pr.razon_social AS proveedor, 
    p.nombre AS producto, 
    pp.codigo_item_proveedor
FROM producto_proveedor pp
INNER JOIN proveedor pr ON pp.proveedor_id = pr.id
INNER JOIN producto p ON pp.producto_id = p.id;

-- 11. Relación de usuarios del sistema con sus roles asignados
SELECT 
    u.nombre AS usuario, 
    u.correo, 
    u.telefono, 
    r.nombre AS rol
FROM usuario u
INNER JOIN rol r ON u.rol_id = r.id;

-- 12. Mostrar los inmuebles o establecimientos vinculados a cada cliente
SELECT 
    c.razon_social AS cliente, 
    e.nombre_establecimiento, 
    e.direccion, 
    e.tipo_inmueble
FROM establecimiento e
INNER JOIN cliente c ON e.cliente_id = c.id;

-- 13. Detalle de servicios incluidos en cada cotización realizada
SELECT 
    c.numero_cotizacion, 
    s.nombre AS servicio, 
    dcs.horas_estimadas, 
    dcs.precio_hora
FROM detalle_cotizacion_servicio dcs
INNER JOIN cotizacion c ON dcs.cotizacion_id = c.id
INNER JOIN servicio s ON dcs.servicio_id = s.id;

-- 14. Consultar órdenes de trabajo indicando cliente, establecimiento y técnicos asignados
SELECT 
    ot.codigo_orden,
    ot.tipo_trabajo,
    ot.estado,
    c.razon_social AS cliente,
    e.nombre_establecimiento,
    u.nombre AS tecnico,
    ott.es_lider
FROM orden_trabajo ot
LEFT JOIN cotizacion cot ON ot.cotizacion_id = cot.id
LEFT JOIN cliente c ON cot.cliente_id = c.id
LEFT JOIN establecimiento e ON cot.establecimiento_id = e.id
INNER JOIN orden_trabajo_tecnico ott ON ot.id = ott.orden_trabajo_id
INNER JOIN usuario u ON ott.usuario_id = u.id;

-- 15. Mostrar los productos utilizados en cada orden de trabajo
SELECT
    ot.codigo_orden,
    p.nombre AS producto,
    d.cantidad_utilizada,
    d.fecha_registro
FROM orden_trabajo ot
INNER JOIN detalle_consumo_material d ON ot.id = d.orden_trabajo_id
INNER JOIN producto p ON d.producto_id = p.id;

-- 16. Obtener el historial de movimientos en Kardex con nombre de producto y usuario
SELECT 
    k.fecha_movimiento,
    p.nombre AS producto,
    u.nombre AS usuario,
    k.tipo_movimiento,
    k.cantidad,
    k.stock_anterior
FROM movimiento_kardex k
INNER JOIN producto p ON k.producto_id = p.id
INNER JOIN usuario u ON k.usuario_id = u.id
ORDER BY k.fecha_movimiento DESC;


-- 3. SUBCONSULTAS

-- 17. Encontrar el servicio técnico con el costo por hora más elevado
SELECT nombre, precio_hora_base 
FROM servicio 
WHERE precio_hora_base = (
    SELECT MAX(precio_hora_base) 
    FROM servicio
);

-- 18. Productos cuyo precio de compra supera o iguala el promedio del catálogo
SELECT nombre, precio_compra_actual 
FROM producto 
WHERE precio_compra_actual >= (
    SELECT AVG(precio_compra_actual) 
    FROM producto
);

-- 19. Mostrar el producto que tiene el mayor stock disponible
SELECT nombre, stock_disponible
FROM producto
WHERE stock_disponible = (
    SELECT MAX(stock_disponible)
    FROM producto
);

-- 20. Obtener los roles que tienen al menos un usuario registrado
SELECT id, nombre, descripcion 
FROM rol 
WHERE id IN (
    SELECT DISTINCT rol_id 
    FROM usuario
);

-- 21. Identificar los productos que registraron cualquier movimiento en el Kardex
SELECT id, nombre, stock_disponible 
FROM producto 
WHERE id IN (
    SELECT DISTINCT producto_id 
    FROM movimiento_kardex
);

-- 22. Mostrar los clientes que tienen al menos un establecimiento registrado
SELECT id, razon_social
FROM cliente
WHERE id IN (
    SELECT cliente_id
    FROM establecimiento
);

-- 23. Obtener los productos que nunca han sido cotizados
SELECT nombre, stock_disponible 
FROM producto 
WHERE id NOT IN (
    SELECT DISTINCT producto_id 
    FROM detalle_cotizacion_producto
);

-- 24. Listar clientes con cotizaciones en servicios con monto superior a $500
SELECT razon_social, correo 
FROM cliente 
WHERE id IN (
    SELECT c.cliente_id 
    FROM cotizacion c
    INNER JOIN detalle_cotizacion_servicio dcs ON c.id = dcs.cotizacion_id
    GROUP BY c.cliente_id, c.id
    HAVING SUM(dcs.horas_estimadas * dcs.precio_hora) > 500
);

-- 25. Mostrar sistemas cuya fecha de próximo mantenimiento sea la más antigua
SELECT nombre_sistema, fecha_proximo_mantenimiento
FROM sistema_instalado
WHERE fecha_proximo_mantenimiento = (
    SELECT MIN(fecha_proximo_mantenimiento)
    FROM sistema_instalado
);

-- 26. Sistemas instalados con mantenimiento próximo dentro de 90 días respecto a cotizaciones
SELECT nombre_sistema, fecha_proximo_mantenimiento 
FROM sistema_instalado 
WHERE fecha_proximo_mantenimiento <= (
    SELECT MAX(fecha_emision) + INTERVAL '90 days' 
    FROM cotizacion
);

-- 27. Mostrar proveedores que suministran productos con stock crítico (menor a 5 unidades)
SELECT razon_social, telefono, correo 
FROM proveedor 
WHERE id IN (
    SELECT proveedor_id 
    FROM producto_proveedor 
    WHERE producto_id IN (
        SELECT id FROM producto WHERE stock_disponible < 5
    )
);

-- 28. Obtener técnicos asignados a la última orden de trabajo registrada
SELECT nombre, correo, telefono 
FROM usuario 
WHERE id IN (
    SELECT usuario_id 
    FROM orden_trabajo_tecnico 
    WHERE orden_trabajo_id = (
        SELECT MAX(id) FROM orden_trabajo
    )
);

-- 29. Listar productos cuyo margen de ganancia es superior al margen promedio del catálogo
SELECT nombre, margen_ganancia, precio_compra_actual 
FROM producto 
WHERE margen_ganancia > (
    SELECT AVG(margen_ganancia) 
    FROM producto
);

-- 30. Obtener cotizaciones con un monto total estimado superior al promedio global de cotizaciones
SELECT numero_cotizacion, fecha_emision, estado 
FROM cotizacion 
WHERE id IN (
    SELECT cotizacion_id 
    FROM detalle_cotizacion_servicio 
    GROUP BY cotizacion_id 
    HAVING SUM(horas_estimadas * precio_hora) > (
        SELECT AVG(monto_total) 
        FROM (
            SELECT SUM(horas_estimadas * precio_hora) AS monto_total 
            FROM detalle_cotizacion_servicio 
            GROUP BY cotizacion_id
        ) sub
    )
);