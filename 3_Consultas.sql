-- 1. CONSULTAS SIMPLES

-- 1. Mantenimientos y órdenes de trabajo registradas
SELECT id, tipo_trabajo, codigo_orden, fecha_programada, estado 
FROM public.orden_trabajo;

-- 2. Listar clientes con sus datos de contacto principales
SELECT 
    id,
    tipo_cliente,
    COALESCE(nombre, razon_social) AS nombre_o_razon_social,
    documento_identidad,
    telefono,
    telefono_alternativo,
    correo 
FROM public.cliente;

-- 3. Identificar productos disponibles ordenados por su precio de compra
SELECT nombre, precio_compra_actual, margen_ganancia, stock_disponible 
FROM public.producto 
ORDER BY precio_compra_actual DESC;

-- 4. Ver el catálogo de sistemas de seguridad instalados
SELECT id, nombre_sistema, numero_serie, fecha_instalacion 
FROM public.sistema_instalado;

-- 5. Consultar los servicios técnicos disponibles y sus precios base
SELECT id, nombre, descripcion, precio_hora_base 
FROM public.servicio;

-- 6. Obtener la lista de productos con precio de venta calculado según margen
SELECT 
    nombre, 
    precio_compra_actual, 
    margen_ganancia,
    ROUND(precio_compra_actual * (1 + margen_ganancia / 100.0), 2) AS precio_venta_calculado
FROM public.producto;

-- 7. Listar las cotizaciones en estado 'PENDIENTE'
SELECT numero_cotizacion, fecha_emision, fecha_vencimiento 
FROM public.cotizacion 
WHERE estado = 'PENDIENTE';

-- 8. Consultar tickets de mantenimiento con urgencia 'ALTA' o 'CRITICA'
SELECT id, tipo_mantenimiento, nivel_urgencia, descripcion_incidencia, estado 
FROM public.mantenimiento_ticket 
WHERE nivel_urgencia IN ('ALTA', 'CRITICA');


-- 2. CONSULTAS MÚLTIPLES (JOINS)

-- 9. Productos cruzados con sus respectivas categorías
SELECT 
    p.nombre AS producto, 
    c.nombre AS categoria, 
    p.unidad_medida, 
    p.stock_disponible
FROM public.producto p
INNER JOIN public.categoria_producto c ON p.categoria_producto_id = c.id;

-- 10. Listar los proveedores y sus productos asignados
SELECT 
    pr.razon_social AS proveedor, 
    p.nombre AS producto, 
    pp.codigo_item_proveedor,
    pp.precio_compra
FROM public.producto_proveedor pp
INNER JOIN public.proveedor pr ON pp.proveedor_id = pr.id
INNER JOIN public.producto p ON pp.producto_id = p.id;

-- 11. Relación de usuarios del sistema con sus roles asignados
SELECT 
    u.nombre AS usuario, 
    u.correo, 
    u.telefono, 
    r.nombre AS rol
FROM public.usuario u
INNER JOIN public.rol r ON u.rol_id = r.id;

-- 12. Mostrar los inmuebles o establecimientos vinculados a cada cliente
SELECT 
    COALESCE(c.nombre, c.razon_social) AS cliente, 
    e.nombre_establecimiento, 
    e.tipo_inmueble,
    e.latitud,
    e.longitud
FROM public.establecimiento e
INNER JOIN public.cliente c ON e.cliente_id = c.id;

-- 13. Detalle de servicios incluidos en cada cotización realizada
SELECT 
    c.numero_cotizacion, 
    s.nombre AS servicio, 
    dcs.horas_estimadas, 
    dcs.precio_hora,
    (dcs.horas_estimadas * dcs.precio_hora) AS subtotal_servicio
FROM public.detalle_cotizacion_servicio dcs
INNER JOIN public.cotizacion c ON dcs.cotizacion_id = c.id
INNER JOIN public.servicio s ON dcs.servicio_id = s.id;

-- 14. Consultar órdenes de trabajo indicando cliente, establecimiento y técnicos asignados
SELECT 
    ot.codigo_orden,
    ot.tipo_trabajo,
    ot.estado,
    COALESCE(c.nombre, c.razon_social) AS cliente,
    e.nombre_establecimiento,
    u.nombre AS tecnico,
    ott.es_lider
FROM public.orden_trabajo ot
INNER JOIN public.cotizacion cot ON ot.cotizacion_id = cot.id
INNER JOIN public.establecimiento e ON cot.establecimiento_id = e.id
INNER JOIN public.cliente c ON e.cliente_id = c.id
INNER JOIN public.orden_trabajo_tecnico ott ON ot.id = ott.orden_trabajo_id
INNER JOIN public.usuario u ON ott.usuario_id = u.id;

-- 15. Mostrar los productos utilizados en cada orden de trabajo
SELECT
    ot.codigo_orden,
    p.nombre AS producto,
    d.cantidad_utilizada,
    d.fecha_registro,
    d.observacion
FROM public.orden_trabajo ot
INNER JOIN public.detalle_consumo_material d ON ot.id = d.orden_trabajo_id
INNER JOIN public.producto p ON d.producto_id = p.id;

-- 16. Obtener el historial de movimientos en Kardex con nombre de producto y usuario
SELECT 
    k.fecha_movimiento,
    p.nombre AS producto,
    u.nombre AS usuario,
    k.tipo_movimiento,
    k.cantidad,
    k.stock_anterior,
    k.observacion
FROM public.movimiento_kardex k
INNER JOIN public.producto p ON k.producto_id = p.id
INNER JOIN public.usuario u ON k.usuario_id = u.id
ORDER BY k.fecha_movimiento DESC;


-- 3. SUBCONSULTAS

-- 17. Encontrar el servicio técnico con el costo por hora más elevado
SELECT nombre, precio_hora_base 
FROM public.servicio 
WHERE precio_hora_base = (
    SELECT MAX(precio_hora_base) 
    FROM public.servicio
);

-- 18. Productos cuyo precio de compra supera o iguala el promedio del catálogo
SELECT nombre, precio_compra_actual 
FROM public.producto 
WHERE precio_compra_actual >= (
    SELECT AVG(precio_compra_actual) 
    FROM public.producto
);

-- 19. Mostrar el producto que tiene el mayor stock disponible
SELECT nombre, stock_disponible
FROM public.producto
WHERE stock_disponible = (
    SELECT MAX(stock_disponible)
    FROM public.producto
);

-- 20. Obtener los roles que tienen al menos un usuario registrado
SELECT id, nombre, descripcion 
FROM public.rol 
WHERE id IN (
    SELECT DISTINCT rol_id 
    FROM public.usuario
);

-- 21. Identificar los productos que registraron cualquier movimiento en el Kardex
SELECT id, nombre, stock_disponible 
FROM public.producto 
WHERE id IN (
    SELECT DISTINCT producto_id 
    FROM public.movimiento_kardex
);

-- 22. Mostrar los clientes que tienen al menos un establecimiento registrado
SELECT id, COALESCE(nombre, razon_social) AS cliente, tipo_cliente
FROM public.cliente
WHERE id IN (
    SELECT DISTINCT cliente_id
    FROM public.establecimiento
);

-- 23. Obtener los productos que nunca han sido cotizados
SELECT nombre, stock_disponible 
FROM public.producto 
WHERE id NOT IN (
    SELECT DISTINCT producto_id 
    FROM public.detalle_cotizacion_producto
);

-- 24. Listar clientes con cotizaciones en servicios con monto superior a $500
SELECT COALESCE(nombre, razon_social) AS cliente, correo 
FROM public.cliente 
WHERE id IN (
    SELECT e.cliente_id 
    FROM public.cotizacion c
    INNER JOIN public.establecimiento e ON c.establecimiento_id = e.id
    INNER JOIN public.detalle_cotizacion_servicio dcs ON c.id = dcs.cotizacion_id
    GROUP BY e.cliente_id, c.id
    HAVING SUM(dcs.horas_estimadas * dcs.precio_hora) > 500
);

-- 25. Mostrar sistemas cuya fecha de próximo mantenimiento sea la más antigua
SELECT nombre_sistema, fecha_proximo_mantenimiento
FROM public.sistema_instalado
WHERE fecha_proximo_mantenimiento = (
    SELECT MIN(fecha_proximo_mantenimiento)
    FROM public.sistema_instalado
);

-- 26. Sistemas instalados con mantenimiento próximo dentro de 90 días respecto a cotizaciones
SELECT nombre_sistema, fecha_proximo_mantenimiento 
FROM public.sistema_instalado 
WHERE fecha_proximo_mantenimiento <= (
    SELECT MAX(fecha_emision) + INTERVAL '90 days' 
    FROM public.cotizacion
);

-- 27. Mostrar proveedores que suministran productos con stock crítico (menor a 5 unidades)
SELECT razon_social, telefono, correo 
FROM public.proveedor 
WHERE id IN (
    SELECT proveedor_id 
    FROM public.producto_proveedor 
    WHERE producto_id IN (
        SELECT id FROM public.producto WHERE stock_disponible < 5
    )
);

-- 28. Obtener técnicos asignados a la última orden de trabajo registrada
SELECT nombre, correo, telefono 
FROM public.usuario 
WHERE id IN (
    SELECT usuario_id 
    FROM public.orden_trabajo_tecnico 
    WHERE orden_trabajo_id = (
        SELECT MAX(id) FROM public.orden_trabajo
    )
);

-- 29. Listar productos cuyo margen de ganancia es superior al margen promedio del catálogo
SELECT nombre, margen_ganancia, precio_compra_actual 
FROM public.producto 
WHERE margen_ganancia > (
    SELECT AVG(margen_ganancia) 
    FROM public.producto
);

-- 30. Obtener cotizaciones con un monto total estimado superior al promedio global de cotizaciones
SELECT numero_cotizacion, fecha_emision, estado 
FROM public.cotizacion 
WHERE id IN (
    SELECT cotizacion_id 
    FROM public.detalle_cotizacion_servicio 
    GROUP BY cotizacion_id 
    HAVING SUM(horas_estimadas * precio_hora) > (
        SELECT AVG(monto_total) 
        FROM (
            SELECT SUM(horas_estimadas * precio_hora) AS monto_total 
            FROM public.detalle_cotizacion_servicio 
            GROUP BY cotizacion_id
        ) sub
    )
);

-- 31. Liquidación financiera y cálculo de saldos pendientes por Orden de Trabajo
SELECT 
    ot.codigo_orden,
    cot.numero_cotizacion,
    COALESCE(cli.nombre, cli.razon_social) AS cliente,
    
    COALESCE((
        SELECT SUM(cantidad * precio_unitario) 
        FROM public.detalle_cotizacion_producto 
        WHERE cotizacion_id = cot.id
    ), 0) AS total_productos,

    COALESCE((
        SELECT SUM(horas_estimadas * precio_hora) 
        FROM public.detalle_cotizacion_servicio 
        WHERE cotizacion_id = cot.id
    ), 0) AS total_servicios,

    (
        COALESCE((SELECT SUM(cantidad * precio_unitario) FROM public.detalle_cotizacion_producto WHERE cotizacion_id = cot.id), 0) +
        COALESCE((SELECT SUM(horas_estimadas * precio_hora) FROM public.detalle_cotizacion_servicio WHERE cotizacion_id = cot.id), 0)
    ) AS monto_total_general,

    COALESCE(ns.anticipo_pagado, 0) AS anticipo_pagado,

    (
        COALESCE((SELECT SUM(cantidad * precio_unitario) FROM public.detalle_cotizacion_producto WHERE cotizacion_id = cot.id), 0) +
        COALESCE((SELECT SUM(horas_estimadas * precio_hora) FROM public.detalle_cotizacion_servicio WHERE cotizacion_id = cot.id), 0) -
        COALESCE(ns.anticipo_pagado, 0)
    ) AS saldo_pendiente

FROM public.orden_trabajo ot
INNER JOIN public.cotizacion cot ON ot.cotizacion_id = cot.id
INNER JOIN public.establecimiento e ON cot.establecimiento_id = e.id
INNER JOIN public.cliente cli ON e.cliente_id = cli.id
LEFT JOIN public.nota_servicio ns ON ot.id = ns.orden_trabajo_id;


-- 4. CONSULTAS DE AGREGACIÓN Y AGRUPACIÓN (GROUP BY / HAVING)

-- 32. Total de cotizaciones emitidas por cada cliente
SELECT 
    COALESCE(c.nombre, c.razon_social) AS cliente, 
    COUNT(cot.id) AS total_cotizaciones
FROM public.cliente c
LEFT JOIN public.establecimiento e ON c.id = e.cliente_id
LEFT JOIN public.cotizacion cot ON e.id = cot.establecimiento_id
GROUP BY c.id, c.nombre, c.razon_social;

-- 33. Cantidad de productos disponibles por categoría
SELECT 
    cp.nombre AS categoria, 
    COUNT(p.id) AS total_productos,
    COALESCE(SUM(p.stock_disponible), 0) AS stock_total
FROM public.categoria_producto cp
LEFT JOIN public.producto p ON cp.id = p.categoria_producto_id
GROUP BY cp.id, cp.nombre;

-- 34. Clientes que tienen más de 1 establecimiento registrado (HAVING)
SELECT 
    COALESCE(c.nombre, c.razon_social) AS cliente, 
    COUNT(e.id) AS total_establecimientos
FROM public.cliente c
INNER JOIN public.establecimiento e ON c.id = e.cliente_id
GROUP BY c.id, c.nombre, c.razon_social
HAVING COUNT(e.id) > 1;

-- 35. Total consumido en materiales agrupado por orden de trabajo
SELECT 
    ot.codigo_orden, 
    COUNT(dcm.producto_id) AS items_distintos_usados,
    SUM(dcm.cantidad_utilizada) AS total_unidades_usadas
FROM public.orden_trabajo ot
INNER JOIN public.detalle_consumo_material dcm ON ot.id = dcm.orden_trabajo_id
GROUP BY ot.id, ot.codigo_orden;

-- 36. Total de horas trabajadas/asignadas por técnico
SELECT 
    u.nombre AS técnico, 
    COUNT(ott.orden_trabajo_id) AS total_ordenes_asignadas
FROM public.usuario u
INNER JOIN public.orden_trabajo_tecnico ott ON u.id = ott.usuario_id
GROUP BY u.id, u.nombre;