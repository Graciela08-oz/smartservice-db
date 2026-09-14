-- POBLAMIENTO COMPLETO DE LAS 23 TABLAS

-- NIVEL 0: TABLAS INDEPENDIENTES

INSERT INTO public.rol (id, nombre, descripcion) OVERRIDING SYSTEM VALUE VALUES
(1, 'ADMINISTRADOR', 'Administrador general del sistema.'),
(2, 'ENCARGADO', 'Encargado de gestionar clientes, cotizaciones e inventario.'),
(3, 'TECNICO', 'Técnico encargado de ejecutar órdenes de trabajo y mantenimientos.');

INSERT INTO public.privilegio (id, nombre, descripcion) OVERRIDING SYSTEM VALUE VALUES
(1, 'GESTION_USUARIOS', 'Permite crear, editar y eliminar usuarios.'),
(2, 'GESTION_CLIENTES', 'Permite crear y modificar clientes.'),
(3, 'CREAR_COTIZACION', 'Permite emitir cotizaciones.'),
(4, 'EJECUTAR_ORDEN', 'Permite actualizar el estado de órdenes de trabajo.');

INSERT INTO public.cliente (
    id, 
    nombre, 
    tipo_cliente, 
    razon_social, 
    documento_identidad, 
    correo, 
    telefono, 
    telefono_alternativo, 
    fecha_registro
) OVERRIDING SYSTEM VALUE VALUES
(1, NULL, 'EMPRESA', 'Hotel Los Andes S.R.L.', 'NIT-100001', 'contacto@hotelandes.com', '72010001', NULL, '2026-09-06 12:56:14.30907'),
(2, NULL, 'EMPRESA', 'Supermercados La Canasta S.A.', 'NIT-100002', 'administracion@canasta.com', '72010002', NULL, '2026-09-06 12:56:14.30907'),
(3, NULL, 'EMPRESA', 'Clínica San Gabriel', 'NIT-100003', 'contacto@clinicasangabriel.com', '72010003', NULL, '2026-09-06 12:56:14.30907'),
(4, NULL, 'EMPRESA', 'Industrias Andinas Ltda.', 'NIT-100004', 'info@industriasandinas.com', '72010004', NULL, '2026-09-06 12:56:14.30907'),
(5, 'Roberto Salazar', 'PERSONA', 'Roberto Salazar', 'CI-500001', 'roberto@gmail.com', '72010005', NULL, '2026-09-06 12:56:14.30907'),
(6, NULL, 'EMPRESA', 'Colegio Nueva Esperanza', 'NIT-100005', 'direccion@nuevaesperanza.edu', '72010006', NULL, '2026-09-06 12:56:14.30907')
ON CONFLICT (id) DO UPDATE SET
    nombre = EXCLUDED.nombre,
    tipo_cliente = EXCLUDED.tipo_cliente,
    razon_social = EXCLUDED.razon_social,
    documento_identidad = EXCLUDED.documento_identidad,
    correo = EXCLUDED.correo,
    telefono = EXCLUDED.telefono,
    telefono_alternativo = EXCLUDED.telefono_alternativo,
    fecha_registro = EXCLUDED.fecha_registro;
INSERT INTO public.categoria_producto (id, nombre, descripcion) OVERRIDING SYSTEM VALUE VALUES
(1, 'Cámaras', 'Cámaras de seguridad y videovigilancia.'),
(2, 'Control de Acceso', 'Equipos para control y registro de accesos.'),
(3, 'Alarmas', 'Equipos y accesorios para sistemas de alarma.'),
(4, 'Cableado', 'Cables y materiales para instalaciones.'),
(5, 'Redes', 'Equipos de comunicación y redes.'),
(6, 'Incendios', 'Equipos para detección y prevención de incendios.');

INSERT INTO public.servicio (id, nombre, descripcion, precio_hora_base) OVERRIDING SYSTEM VALUE VALUES
(1, 'Instalación de CCTV', 'Instalación y configuración de cámaras de seguridad.', 80.00),
(2, 'Mantenimiento Preventivo', 'Mantenimiento preventivo de sistemas instalados.', 70.00),
(3, 'Mantenimiento Correctivo', 'Diagnóstico y reparación de fallas.', 90.00),
(4, 'Configuración de Red', 'Configuración de switches, routers y cableado.', 85.00),
(5, 'Instalación de Alarma', 'Instalación y configuración de sistemas de alarma.', 75.00),
(6, 'Instalación Sistema Contra Incendios', 'Instalación y configuración de detectores y paneles.', 100.00);

INSERT INTO public.proveedor (id, razon_social, nit, contacto, telefono, correo) OVERRIDING SYSTEM VALUE VALUES
(1, 'Seguritech Bolivia S.R.L.', 'NIT-PROV-001', 'Luis Vargas', '73000001', 'ventas@seguritech.com'),
(2, 'Importadora Andina S.A.', 'NIT-PROV-002', 'Pedro Rojas', '73000002', 'ventas@importadoraandina.com'),
(3, 'TecnoRed Bolivia', 'NIT-PROV-003', 'Ana Flores', '73000003', 'contacto@tecnored.com'),
(4, 'FireSafe Bolivia', 'NIT-PROV-004', 'Miguel Torres', '73000004', 'ventas@firesafe.com');


-- NIVEL 1: DEPENDEN DE NIVEL 0

INSERT INTO public.rol_privilegio (id_rol, id_privilegio) VALUES
(1, 1), (1, 2), (1, 3), (1, 4),
(2, 2), (2, 3),
(3, 4);

INSERT INTO public.usuario (id, rol_id, nombre, correo, contraseña, telefono, estado) OVERRIDING SYSTEM VALUE VALUES
(1, 1, 'Carlos Mendoza', 'carlos@empresa.com', '$2b$10$EjemploHashAdministrador', '70000001', 't'),
(2, 2, 'María Fernández', 'maria@empresa.com', '$2b$10$EjemploHashEncargado', '70000002', 't'),
(3, 3, 'Juan Pérez', 'juan@empresa.com', '$2b$10$EjemploHashTecnico', '70000003', 't'),
(4, 3, 'Pedro Ramírez', 'pedro@empresa.com', '$2b$10$EjemploHashTecnico1', '70000004', 't'),
(5, 3, 'Luis Fernández', 'luis@empresa.com', '$2b$10$EjemploHashTecnico2', '70000005', 't'),
(6, 3, 'Diego Castillo', 'diego@empresa.com', '$2b$10$EjemploHashTecnico3', '70000006', 't');

INSERT INTO public.establecimiento (id, cliente_id, nombre_establecimiento, direccion, tipo_inmueble, latitud, longitud) OVERRIDING SYSTEM VALUE VALUES
(1, 1, 'Hotel Los Andes - Central', 'Av. Arce N° 1250', 'HOTEL', -17.39350000, -66.15700000),
(2, 1, 'Hotel Los Andes - Norte', 'Av. América N° 850', 'HOTEL', -17.37000000, -66.14500000),
(3, 2, 'La Canasta - Centro', 'Calle Sucre N° 450', 'COMERCIAL', -17.38950000, -66.15680000),
(4, 3, 'Clínica San Gabriel', 'Av. Circunvalación N° 300', 'CLINICA', -17.37050000, -66.17000000),
(5, 4, 'Industrias Andinas - Planta', 'Parque Industrial Zona Norte', 'INDUSTRIAL', -17.35000000, -66.13000000),
(6, 5, 'Domicilio Roberto Salazar', 'Av. Blanco Galindo N° 900', 'DOMICILIO', -17.38000000, -66.21000000),
(7, 6, 'Colegio Nueva Esperanza', 'Av. Petrolera N° 1200', 'EDUCATIVO', -17.42000000, -66.18000000);

INSERT INTO public.producto (id, categoria_producto_id, nombre, descripcion_tecnica, unidad_medida, margen_ganancia, precio_compra_actual, stock_disponible, stock_minimo) OVERRIDING SYSTEM VALUE VALUES
(1, 1, 'Cámara IP 4MP', 'Cámara IP de 4 megapíxeles con visión nocturna.', 'UNIDAD', 30.00, 850.00, 18, 5),
(2, 1, 'Cámara Domo 2MP', 'Cámara domo para interiores.', 'UNIDAD', 25.00, 450.00, 25, 8),
(3, 2, 'Lector RFID', 'Lector de tarjetas RFID para control de acceso.', 'UNIDAD', 35.00, 620.00, 10, 3),
(4, 2, 'Tarjeta RFID', 'Tarjeta de proximidad RFID.', 'UNIDAD', 50.00, 12.00, 150, 30),
(5, 3, 'Sirena Electrónica', 'Sirena electrónica para sistemas de alarma.', 'UNIDAD', 30.00, 180.00, 20, 5),
(6, 3, 'Sensor Magnético', 'Sensor magnético para puertas y ventanas.', 'UNIDAD', 40.00, 45.00, 35, 10),
(7, 4, 'Cable UTP Cat6', 'Cable de red categoría 6.', 'METRO', 25.00, 4.50, 800, 200),
(8, 4, 'Cable FTP Cat6', 'Cable FTP categoría 6 blindado.', 'METRO', 30.00, 7.50, 500, 150),
(9, 5, 'Switch 24 Puertos', 'Switch administrable de 24 puertos.', 'UNIDAD', 25.00, 1250.00, 8, 2),
(10, 5, 'Router Empresarial', 'Router para redes empresariales.', 'UNIDAD', 30.00, 950.00, 6, 2),
(11, 6, 'Detector de Humo', 'Detector de humo fotoeléctrico.', 'UNIDAD', 35.00, 120.00, 40, 10),
(12, 6, 'Panel Contra Incendios', 'Panel central para sistema contra incendios.', 'UNIDAD', 30.00, 3200.00, 4, 1);


-- NIVEL 2: DEPENDEN DE NIVEL 1

INSERT INTO public.bitacora (id, usuario_id, fecha_hora, accion, descripcion) OVERRIDING SYSTEM VALUE VALUES
(1, 1, '2026-01-02 08:00:00', 'INICIO_SESION', 'El administrador inició sesión en el sistema.'),
(2, 2, '2026-01-02 08:30:00', 'INICIO_SESION', 'El encargado inició sesión en el sistema.'),
(3, 2, '2026-01-03 09:15:00', 'REGISTRO_CLIENTE', 'Se registró un nuevo cliente.'),
(4, 2, '2026-01-04 10:20:00', 'COTIZACION', 'Se generó una nueva cotización.'),
(5, 1, '2026-01-05 11:00:00', 'INVENTARIO', 'Se actualizó información del catálogo.'),
(6, 3, '2026-01-06 08:10:00', 'ORDEN_TRABAJO', 'El técnico consultó una orden asignada.'),
(7, 3, '2026-01-07 15:30:00', 'CONSUMO_MATERIAL', 'El técnico registró materiales utilizados.'),
(8, 2, '2026-01-08 09:00:00', 'ASIGNACION', 'Se asignó una orden al técnico.'),
(9, 1, '2026-01-10 10:00:00', 'SUPERVISION', 'El administrador revisó las operaciones.'),
(10, 2, '2026-01-12 14:00:00', 'MANTENIMIENTO', 'Se revisaron alertas de mantenimiento.');

INSERT INTO public.movimiento_kardex (id, producto_id, usuario_id, tipo_movimiento, cantidad, stock_anterior, origen_movimiento, fecha_movimiento, observacion) OVERRIDING SYSTEM VALUE VALUES
(1, 1, 1, 'ENTRADA', 20, 0, 'COMPRA', '2026-09-06 12:57:05.951858', 'Compra inicial de cámaras IP.'),
(2, 1, 2, 'SALIDA', 2, 20, 'ORDEN_TRABAJO', '2026-09-06 12:57:05.951858', 'Material utilizado en instalación.'),
(3, 2, 1, 'ENTRADA', 30, 0, 'COMPRA', '2026-09-06 12:57:05.951858', 'Ingreso de cámaras domo.'),
(4, 2, 2, 'SALIDA', 5, 30, 'ORDEN_TRABAJO', '2026-09-06 12:57:05.951858', 'Cámaras utilizadas en instalación.'),
(5, 3, 1, 'ENTRADA', 12, 0, 'COMPRA', '2026-09-06 12:57:05.951858', 'Ingreso de lectores RFID.'),
(6, 3, 2, 'SALIDA', 2, 12, 'ORDEN_TRABAJO', '2026-09-06 12:57:05.951858', 'Lectores utilizados.'),
(7, 4, 1, 'ENTRADA', 200, 0, 'COMPRA', '2026-09-06 12:57:05.951858', 'Ingreso de tarjetas RFID.'),
(8, 4, 2, 'SALIDA', 50, 200, 'ORDEN_TRABAJO', '2026-09-06 12:57:05.951858', 'Tarjetas entregadas al cliente.'),
(9, 7, 1, 'ENTRADA', 1000, 0, 'COMPRA', '2026-09-06 12:57:05.951858', 'Compra de cable UTP.'),
(10, 7, 3, 'SALIDA', 200, 1000, 'ORDEN_TRABAJO', '2026-09-06 12:57:05.951858', 'Cable utilizado en instalación.'),
(11, 9, 1, 'ENTRADA', 10, 0, 'COMPRA', '2026-09-06 12:57:05.951858', 'Ingreso de switches.'),
(12, 9, 2, 'SALIDA', 2, 10, 'ORDEN_TRABAJO', '2026-09-06 12:57:05.951858', 'Switches utilizados.'),
(13, 11, 1, 'ENTRADA', 50, 0, 'COMPRA', '2026-09-06 12:57:05.951858', 'Ingreso de detectores de humo.'),
(14, 11, 3, 'SALIDA', 10, 50, 'ORDEN_TRABAJO', '2026-09-06 12:57:05.951858', 'Detectores utilizados.');

INSERT INTO public.cotizacion (id, establecimiento_id, usuario_id, numero_cotizacion, fecha_emision, fecha_vencimiento, estado, total) OVERRIDING SYSTEM VALUE VALUES
(1, 1, 2, 'COT-2026-001', '2026-01-05', '2026-01-20', 'APROBADA', 12802.50),
(2, 3, 2, 'COT-2026-002', '2026-01-08', '2026-01-23', 'APROBADA', 5413.00),
(3, 4, 2, 'COT-2026-003', '2026-01-10', '2026-01-25', 'PENDIENTE', 7790.00),
(4, 5, 2, 'COT-2026-004', '2026-01-12', '2026-01-27', 'APROBADA', 20923.75),
(5, 6, 2, 'COT-2026-005', '2026-01-15', '2026-01-30', 'RECHAZADA', 4158.00),
(6, 7, 2, 'COT-2026-006', '2026-01-18', '2026-02-02', 'PENDIENTE', 2166.00);

INSERT INTO public.producto_proveedor (producto_id, proveedor_id, precio_compra, codigo_item_proveedor) VALUES
(1, 1, 850.00, 'CAM-IP-4MP'),
(1, 2, 840.00, 'IPCAM-4000'),
(2, 1, 450.00, 'CAM-DOMO-2MP'),
(3, 1, 620.00, 'RFID-LECTOR-01'),
(3, 2, 615.00, 'RFID-620'),
(4, 2, 12.00, 'CARD-RFID'),
(5, 1, 180.00, 'SIRENA-180'),
(6, 1, 45.00, 'SENSOR-MAG'),
(7, 3, 4.50, 'UTP-CAT6'),
(8, 3, 7.50, 'FTP-CAT6'),
(9, 3, 1250.00, 'SW-24P'),
(10, 3, 950.00, 'ROUT-EMP'),
(11, 4, 120.00, 'DETECTOR-HUMO'),
(12, 4, 3200.00, 'PANEL-INC');


-- NIVEL 3: DEPENDEN DE COTIZACION

INSERT INTO public.detalle_cotizacion_producto (id, cotizacion_id, producto_id, cantidad, precio_unitario) OVERRIDING SYSTEM VALUE VALUES
(1, 1, 1, 8, 1105.00),
(2, 1, 7, 300, 6.00),
(3, 1, 9, 1, 1562.50),
(4, 2, 2, 6, 562.50),
(5, 2, 7, 200, 6.00),
(6, 2, 5, 2, 234.00),
(7, 3, 11, 15, 162.00),
(8, 3, 12, 1, 4160.00),
(9, 4, 1, 12, 1105.00),
(10, 4, 8, 250, 9.75),
(11, 4, 9, 2, 1562.50),
(12, 5, 3, 4, 837.00),
(13, 5, 4, 20, 18.00),
(14, 6, 5, 4, 234.00),
(15, 6, 6, 10, 63.00);

INSERT INTO public.detalle_cotizacion_servicio (id, cotizacion_id, servicio_id, horas_estimadas, precio_hora) OVERRIDING SYSTEM VALUE VALUES
(1, 1, 1, 16.00, 80.00),
(2, 1, 4, 4.00, 85.00),
(3, 2, 1, 10.00, 80.00),
(4, 2, 5, 5.00, 75.00),
(5, 3, 6, 12.00, 100.00),
(6, 4, 1, 20.00, 80.00),
(7, 4, 4, 6.00, 85.00),
(8, 5, 3, 5.00, 90.00),
(9, 6, 5, 8.00, 75.00);

INSERT INTO public.orden_trabajo (id, cotizacion_id, codigo_orden, tipo_trabajo, estado, fecha_programada, fecha_inicio_real, horas_fin_real, observaciones_tecnico) OVERRIDING SYSTEM VALUE VALUES
(1, 1, 'OT-2026-001', 'INSTALACION CCTV', 'FINALIZADA', '2026-01-22', '2026-01-22 08:00:00', '2026-01-22 17:00:00', 'Instalación completada correctamente.'),
(2, 2, 'OT-2026-002', 'INSTALACION ALARMA', 'FINALIZADA', '2026-01-25', '2026-01-25 09:00:00', '2026-01-25 15:00:00', 'Sistema probado y funcionando.'),
(3, 4, 'OT-2026-003', 'INSTALACION CCTV', 'EN_PROCESO', '2026-02-02', '2026-02-02 08:30:00', NULL, 'Instalación en planta industrial.'),
(4, 1, 'OT-2026-004', 'MANTENIMIENTO PREVENTIVO', 'PROGRAMADA', '2026-02-15', NULL, NULL, NULL),
(5, 2, 'OT-2026-005', 'MANTENIMIENTO CORRECTIVO', 'PROGRAMADA', '2026-02-18', NULL, NULL, NULL);


-- NIVEL 4: DEPENDEN DE ORDEN_TRABAJO

INSERT INTO public.orden_trabajo_tecnico (id, orden_trabajo_id, usuario_id, es_lider) OVERRIDING SYSTEM VALUE VALUES
(1, 1, 3, TRUE),
(2, 1, 4, FALSE),
(3, 2, 5, TRUE),
(4, 2, 6, FALSE),
(5, 3, 4, TRUE),
(6, 3, 5, FALSE);

INSERT INTO public.detalle_consumo_material (id, orden_trabajo_id, producto_id, observacion, cantidad_utilizada, fecha_registro) OVERRIDING SYSTEM VALUE VALUES
(1, 1, 1, 'Instalado en recepción', 2, '2026-09-06 12:57:37.214779'),
(2, 1, 7, 'Cableado principal', 200, '2026-09-06 12:57:37.214779'),
(3, 1, 9, 'Rack principal', 1, '2026-09-06 12:57:37.214779'),
(4, 2, 5, 'Sirena exterior', 2, '2026-09-06 12:57:37.214779'),
(5, 2, 6, 'Puertas de acceso', 5, '2026-09-06 12:57:37.214779'),
(6, 3, 1, 'Cámaras nave A', 4, '2026-09-06 12:57:37.214779'),
(7, 3, 8, 'Tirado de cable blindado', 150, '2026-09-06 12:57:37.214779'),
(8, 3, 9, 'Switch secundario', 1, '2026-09-06 12:57:37.214779');

INSERT INTO public.nota_servicio (id, orden_trabajo_id, numero_nota, anticipo_pagado, fecha_emision, estado, monto_total) OVERRIDING SYSTEM VALUE VALUES
(1, 1, 'NS-2026-001', 2500.00, '2026-01-22 17:30:00', 'EMITIDA', 12802.50),
(2, 2, 'NS-2026-002', 1200.00, '2026-01-25 15:30:00', 'EMITIDA', 5413.00),
(3, 3, 'NS-2026-003', 3000.00, '2026-02-02 16:00:00', 'PENDIENTE', 20923.75);

INSERT INTO public.sistema_instalado (id, orden_trabajo_id, establecimiento_id, nombre_sistema, fecha_instalacion, numero_serie, periodicidad_meses, fecha_ultimo_mantenimiento, fecha_proximo_mantenimiento, observaciones) OVERRIDING SYSTEM VALUE VALUES
(1, 1, 1, 'Sistema de CCTV', '2025-01-15', 'CCTV-HLA-001', 6, '2025-12-15', '2026-06-15', 'Sistema de vigilancia de 24 cámaras.'),
(2, 1, 1, 'Sistema de Control de Acceso', '2025-03-10', 'ACC-HLA-001', 6, '2025-11-10', '2026-05-10', 'Control de acceso mediante tarjetas.'),
(3, 2, 2, 'Sistema de Alarma', '2025-04-20', 'ALM-HLA-002', 6, '2025-10-20', '2026-04-20', 'Sistema de alarma contra intrusión.'),
(4, 2, 3, 'Sistema de CCTV', '2024-11-05', 'CCTV-CAN-001', 6, '2025-11-05', '2026-05-05', 'Sistema de vigilancia del supermercado.'),
(5, 3, 4, 'Sistema de Detección de Incendios', '2025-02-12', 'INC-CLI-001', 3, '2025-12-12', '2026-03-12', 'Detectores instalados en áreas críticas.'),
(6, 3, 5, 'Sistema de CCTV Industrial', '2024-08-18', 'CCTV-IND-001', 6, '2025-08-18', '2026-02-18', 'Vigilancia de áreas de producción.'),
(7, 2, 7, 'Sistema de Alarma', '2025-05-25', 'ALM-COL-001', 6, '2025-11-25', '2026-05-25', 'Alarma para protección del establecimiento.');


-- NIVEL 5: DEPENDEN DE SISTEMA_INSTALADO Y OTRAS

INSERT INTO public.alerta_notificacion (id, sistema_instalado_id, mensaje, fecha_alerta, leido) OVERRIDING SYSTEM VALUE VALUES
(1, 1, 'El sistema CCTV requiere mantenimiento.', '2026-02-10', FALSE),
(2, 2, 'Próximo mantenimiento del sistema de control de acceso.', '2026-02-11', TRUE),
(3, 3, 'El sistema de alarma requiere mantenimiento.', '2026-02-12', FALSE),
(4, 4, 'Mantenimiento preventivo próximo.', '2026-02-13', FALSE),
(5, 5, 'ALERTA: revisar sistema contra incendios.', '2026-02-13', FALSE),
(6, 6, 'Mantenimiento del CCTV industrial pendiente.', '2026-02-14', FALSE),
(7, 7, 'Mantenimiento del sistema de alarma próximo.', '2026-02-15', TRUE);

INSERT INTO public.mantenimiento_ticket (id, sistema_instalado_id, orden_trabajo_id, tipo_mantenimiento, nivel_urgencia, descripcion_incidencia, fecha_reporte, estado) OVERRIDING SYSTEM VALUE VALUES
(1, 1, 4, 'PREVENTIVO', 'MEDIA', 'Mantenimiento preventivo programado del sistema CCTV.', '2026-02-10 09:00:00', 'ABIERTO'),
(2, 2, 5, 'CORRECTIVO', 'ALTA', 'El lector RFID presenta fallas intermitentes.', '2026-02-11 10:30:00', 'ASIGNADO'),
(3, 4, NULL, 'PREVENTIVO', 'BAJA', 'Revisión periódica de cámaras del supermercado.', '2026-02-12 08:00:00', 'ABIERTO'),
(4, 5, NULL, 'CORRECTIVO', 'CRITICA', 'Se detectó una falla en el sistema contra incendios.', '2026-02-13 14:00:00', 'ABIERTO'),
(5, 6, NULL, 'PREVENTIVO', 'MEDIA', 'Mantenimiento programado del sistema CCTV industrial.', '2026-02-14 09:30:00', 'ABIERTO');


-- SINCRONIZACIÓN DE SECUENCIAS
SELECT setval(pg_get_serial_sequence('public.rol', 'id'), COALESCE(MAX(id), 1)) FROM public.rol;
SELECT setval(pg_get_serial_sequence('public.privilegio', 'id'), COALESCE(MAX(id), 1)) FROM public.privilegio;
SELECT setval(pg_get_serial_sequence('public.cliente', 'id'), COALESCE(MAX(id), 1)) FROM public.cliente;
SELECT setval(pg_get_serial_sequence('public.categoria_producto', 'id'), COALESCE(MAX(id), 1)) FROM public.categoria_producto;
SELECT setval(pg_get_serial_sequence('public.servicio', 'id'), COALESCE(MAX(id), 1)) FROM public.servicio;
SELECT setval(pg_get_serial_sequence('public.proveedor', 'id'), COALESCE(MAX(id), 1)) FROM public.proveedor;
SELECT setval(pg_get_serial_sequence('public.usuario', 'id'), COALESCE(MAX(id), 1)) FROM public.usuario;
SELECT setval(pg_get_serial_sequence('public.establecimiento', 'id'), COALESCE(MAX(id), 1)) FROM public.establecimiento;
SELECT setval(pg_get_serial_sequence('public.producto', 'id'), COALESCE(MAX(id), 1)) FROM public.producto;
SELECT setval(pg_get_serial_sequence('public.bitacora', 'id'), COALESCE(MAX(id), 1)) FROM public.bitacora;
SELECT setval(pg_get_serial_sequence('public.movimiento_kardex', 'id'), COALESCE(MAX(id), 1)) FROM public.movimiento_kardex;
SELECT setval(pg_get_serial_sequence('public.cotizacion', 'id'), COALESCE(MAX(id), 1)) FROM public.cotizacion;
SELECT setval(pg_get_serial_sequence('public.detalle_cotizacion_producto', 'id'), COALESCE(MAX(id), 1)) FROM public.detalle_cotizacion_producto;
SELECT setval(pg_get_serial_sequence('public.detalle_cotizacion_servicio', 'id'), COALESCE(MAX(id), 1)) FROM public.detalle_cotizacion_servicio;
SELECT setval(pg_get_serial_sequence('public.orden_trabajo', 'id'), COALESCE(MAX(id), 1)) FROM public.orden_trabajo;
SELECT setval(pg_get_serial_sequence('public.orden_trabajo_tecnico', 'id'), COALESCE(MAX(id), 1)) FROM public.orden_trabajo_tecnico;
SELECT setval(pg_get_serial_sequence('public.detalle_consumo_material', 'id'), COALESCE(MAX(id), 1)) FROM public.detalle_consumo_material;
SELECT setval(pg_get_serial_sequence('public.nota_servicio', 'id'), COALESCE(MAX(id), 1)) FROM public.nota_servicio;
SELECT setval(pg_get_serial_sequence('public.sistema_instalado', 'id'), COALESCE(MAX(id), 1)) FROM public.sistema_instalado;
SELECT setval(pg_get_serial_sequence('public.alerta_notificacion', 'id'), COALESCE(MAX(id), 1)) FROM public.alerta_notificacion;
SELECT setval(pg_get_serial_sequence('public.mantenimiento_ticket', 'id'), COALESCE(MAX(id), 1)) FROM public.mantenimiento_ticket;
