SET timezone TO 'UTC';

-- NIVEL 0: TABLAS INDEPENDIENTES (Sin llaves foráneas)

-- 1. ROL
CREATE TABLE public.rol (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    
    CONSTRAINT rol_pkey PRIMARY KEY (id)
);

-- 2. PRIVILEGIO
CREATE TABLE public.privilegio (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    
    CONSTRAINT privilegio_pkey PRIMARY KEY (id)
);

-- 3. CLIENTE
CREATE TABLE public.cliente (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR(150) NOT NULL,
    tipo_cliente VARCHAR(50),
    razon_social VARCHAR(150),
    documento_identidad VARCHAR(50),
    correo VARCHAR(150),
    telefono VARCHAR(50),
    telefono_alternativo VARCHAR(50),
    fecha_registro TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    
    CONSTRAINT cliente_pkey PRIMARY KEY (id)
);

-- 4. CATEGORIA_PRODUCTO
CREATE TABLE public.categoria_producto (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR(100) NOT NULL,
    descripcion TEXT,
    
    CONSTRAINT categoria_producto_pkey PRIMARY KEY (id)
);

-- 5. SERVICIO
CREATE TABLE public.servicio (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    nombre VARCHAR(150) NOT NULL,
    descripcion TEXT,
    precio_hora_base DECIMAL(12,2) NOT NULL,
    
    CONSTRAINT servicio_pkey PRIMARY KEY (id)
);

-- 6. PROVEEDOR
CREATE TABLE public.proveedor (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    razon_social VARCHAR(150) NOT NULL,
    nit VARCHAR(50),
    contacto VARCHAR(100),
    telefono VARCHAR(50),
    correo VARCHAR(150),
    
    CONSTRAINT proveedor_pkey PRIMARY KEY (id)
);

-- NIVEL 1: DEPENDEN DE NIVEL 0

-- 7. ROL_PRIVILEGIO (Intermedia N:M)
CREATE TABLE public.rol_privilegio (
    id_rol BIGINT NOT NULL,
    id_privilegio BIGINT NOT NULL,
    
    CONSTRAINT rol_privilegio_pkey PRIMARY KEY (id_rol, id_privilegio),
    CONSTRAINT fk_rolpriv_rol FOREIGN KEY (id_rol) REFERENCES public.rol(id) ON DELETE CASCADE,
    CONSTRAINT fk_rolpriv_privilegio FOREIGN KEY (id_privilegio) REFERENCES public.privilegio(id) ON DELETE CASCADE
);

-- 8. USUARIO
CREATE TABLE public.usuario (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    rol_id BIGINT NOT NULL,
    nombre VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL,
    contraseña VARCHAR(255) NOT NULL,
    telefono VARCHAR(50),
    estado VARCHAR(50),
    
    CONSTRAINT usuario_pkey PRIMARY KEY (id),
    CONSTRAINT fk_usuario_rol FOREIGN KEY (rol_id) REFERENCES public.rol(id) ON DELETE RESTRICT
);

-- 9. ESTABLECIMIENTO
CREATE TABLE public.establecimiento (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    cliente_id BIGINT NOT NULL,
    nombre_establecimiento VARCHAR(150) NOT NULL,
    direccion TEXT NOT NULL,
    tipo_inmueble VARCHAR(50),
    latitud DECIMAL(10,8),
    longitud DECIMAL(11,8),
    
    CONSTRAINT establecimiento_pkey PRIMARY KEY (id),
    CONSTRAINT fk_establecimiento_cliente FOREIGN KEY (cliente_id) REFERENCES public.cliente(id) ON DELETE CASCADE
);

-- 10. PRODUCTO
CREATE TABLE public.producto (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    categoria_producto_id BIGINT NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    descripcion_tecnica TEXT,
    unidad_medida VARCHAR(50),
    margen_ganancia DECIMAL(5,2),
    precio_compra_actual DECIMAL(12,2),
    stock_disponible DECIMAL(12,2) DEFAULT 0 NOT NULL,
    stock_minimo DECIMAL(12,2) DEFAULT 0 NOT NULL,
    
    CONSTRAINT producto_pkey PRIMARY KEY (id),
    CONSTRAINT fk_producto_categoria FOREIGN KEY (categoria_producto_id) REFERENCES public.categoria_producto(id) ON DELETE RESTRICT
);

-- NIVEL 2: DEPENDEN DE NIVEL 1

-- 11. BITACORA
CREATE TABLE public.bitacora (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    usuario_id BIGINT NOT NULL,
    fecha_hora TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    accion VARCHAR(100) NOT NULL,
    descripcion TEXT,
    
    CONSTRAINT bitacora_pkey PRIMARY KEY (id),
    CONSTRAINT fk_bitacora_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) ON DELETE CASCADE
);

-- 12. MOVIMIENTO_KARDEX
CREATE TABLE public.movimiento_kardex (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    producto_id BIGINT NOT NULL,
    usuario_id BIGINT NOT NULL,
    tipo_movimiento VARCHAR(50) NOT NULL,
    cantidad DECIMAL(12,2) NOT NULL,
    stock_anterior DECIMAL(12,2) NOT NULL,
    origen_movimiento VARCHAR(100),
    fecha_movimiento TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    observacion TEXT,
    
    CONSTRAINT movimiento_kardex_pkey PRIMARY KEY (id),
    CONSTRAINT fk_kardex_producto FOREIGN KEY (producto_id) REFERENCES public.producto(id) ON DELETE RESTRICT,
    CONSTRAINT fk_kardex_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) ON DELETE RESTRICT
);

-- 13. COTIZACION
CREATE TABLE public.cotizacion (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    establecimiento_id BIGINT NOT NULL,
    usuario_id BIGINT NOT NULL,
    numero_cotizacion VARCHAR(50) NOT NULL,
    fecha_emision TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    fecha_vencimiento DATE,
    estado VARCHAR(50),
    total DECIMAL(12,2) DEFAULT 0.00 NOT NULL,
    
    CONSTRAINT cotizacion_pkey PRIMARY KEY (id),
    CONSTRAINT fk_cotizacion_establecimiento FOREIGN KEY (establecimiento_id) REFERENCES public.establecimiento(id) ON DELETE CASCADE,
    CONSTRAINT fk_cotizacion_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) ON DELETE RESTRICT
);

-- 14. PRODUCTO_PROVEEDOR
CREATE TABLE public.producto_proveedor (
    producto_id BIGINT NOT NULL,
    proveedor_id BIGINT NOT NULL,
    precio_compra DECIMAL(12,2) NOT NULL,
    codigo_item_proveedor VARCHAR(100),
    
    CONSTRAINT producto_proveedor_pkey PRIMARY KEY (producto_id, proveedor_id),
    CONSTRAINT fk_prodprov_producto FOREIGN KEY (producto_id) REFERENCES public.producto(id) ON DELETE CASCADE,
    CONSTRAINT fk_prodprov_proveedor FOREIGN KEY (proveedor_id) REFERENCES public.proveedor(id) ON DELETE CASCADE
);

-- NIVEL 3: DEPENDEN DE COTIZACION

-- 15. DETALLE_COTIZACION_PRODUCTO
CREATE TABLE public.detalle_cotizacion_producto (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    cotizacion_id BIGINT NOT NULL,
    producto_id BIGINT NOT NULL,
    cantidad DECIMAL(12,2) NOT NULL,
    precio_unitario DECIMAL(12,2) NOT NULL,
    
    CONSTRAINT detalle_cotizacion_producto_pkey PRIMARY KEY (id),
    CONSTRAINT fk_detcot_prod_cotizacion FOREIGN KEY (cotizacion_id) REFERENCES public.cotizacion(id) ON DELETE CASCADE,
    CONSTRAINT fk_detcot_prod_producto FOREIGN KEY (producto_id) REFERENCES public.producto(id) ON DELETE RESTRICT
);

-- 16. DETALLE_COTIZACION_SERVICIO
CREATE TABLE public.detalle_cotizacion_servicio (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    cotizacion_id BIGINT NOT NULL,
    servicio_id BIGINT NOT NULL,
    horas_estimadas DECIMAL(12,2) NOT NULL,
    precio_hora DECIMAL(12,2) NOT NULL,
    
    CONSTRAINT detalle_cotizacion_servicio_pkey PRIMARY KEY (id),
    CONSTRAINT fk_detcot_serv_cotizacion FOREIGN KEY (cotizacion_id) REFERENCES public.cotizacion(id) ON DELETE CASCADE,
    CONSTRAINT fk_detcot_serv_servicio FOREIGN KEY (servicio_id) REFERENCES public.servicio(id) ON DELETE RESTRICT
);

-- 17. ORDEN_TRABAJO
CREATE TABLE public.orden_trabajo (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    cotizacion_id BIGINT NOT NULL,
    codigo_orden VARCHAR(50) NOT NULL,
    tipo_trabajo VARCHAR(50),
    estado VARCHAR(50),
    fecha_programada TIMESTAMPTZ,
    fecha_inicio_real TIMESTAMPTZ,
    horas_fin_real TIMESTAMPTZ,
    observaciones_tecnico TEXT,
    
    CONSTRAINT orden_trabajo_pkey PRIMARY KEY (id),
    CONSTRAINT fk_orden_cotizacion FOREIGN KEY (cotizacion_id) REFERENCES public.cotizacion(id) ON DELETE RESTRICT
);

-- NIVEL 4: DEPENDEN DE ORDEN_TRABAJO

-- 18. ORDEN_TRABAJO_TECNICO
CREATE TABLE public.orden_trabajo_tecnico (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    orden_trabajo_id BIGINT NOT NULL,
    usuario_id BIGINT NOT NULL,
    es_lider BOOLEAN DEFAULT FALSE NOT NULL,
    
    CONSTRAINT orden_trabajo_tecnico_pkey PRIMARY KEY (id),
    CONSTRAINT fk_ortrabtec_orden FOREIGN KEY (orden_trabajo_id) REFERENCES public.orden_trabajo(id) ON DELETE CASCADE,
    CONSTRAINT fk_ortrabtec_usuario FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) ON DELETE RESTRICT
);

-- 19. DETALLE_CONSUMO_MATERIAL
CREATE TABLE public.detalle_consumo_material (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    orden_trabajo_id BIGINT NOT NULL,
    producto_id BIGINT NOT NULL,
    observacion TEXT,
    cantidad_utilizada DECIMAL(12,2) NOT NULL,
    fecha_registro TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    
    CONSTRAINT detalle_consumo_material_pkey PRIMARY KEY (id),
    CONSTRAINT fk_detcons_orden FOREIGN KEY (orden_trabajo_id) REFERENCES public.orden_trabajo(id) ON DELETE CASCADE,
    CONSTRAINT fk_detcons_producto FOREIGN KEY (producto_id) REFERENCES public.producto(id) ON DELETE RESTRICT
);

-- 20. NOTA_SERVICIO
CREATE TABLE public.nota_servicio (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    orden_trabajo_id BIGINT NOT NULL,
    numero_nota VARCHAR(50) NOT NULL,
    anticipo_pagado DECIMAL(12,2),
    fecha_emision TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    estado VARCHAR(50),
    monto_total DECIMAL(12,2) NOT NULL,
    
    CONSTRAINT nota_servicio_pkey PRIMARY KEY (id),
    CONSTRAINT fk_notaserv_orden FOREIGN KEY (orden_trabajo_id) REFERENCES public.orden_trabajo(id) ON DELETE RESTRICT
);

-- 21. SISTEMA_INSTALADO
CREATE TABLE public.sistema_instalado (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    orden_trabajo_id BIGINT NOT NULL,
    establecimiento_id BIGINT NOT NULL,
    nombre_sistema VARCHAR(150) NOT NULL,
    fecha_instalacion DATE,
    numero_serie VARCHAR(100),
    periodicidad_meses INT,
    fecha_ultimo_mantenimiento DATE,
    fecha_proximo_mantenimiento DATE,
    observaciones TEXT,
    
    CONSTRAINT sistema_instalado_pkey PRIMARY KEY (id),
    CONSTRAINT fk_sistema_orden FOREIGN KEY (orden_trabajo_id) REFERENCES public.orden_trabajo(id) ON DELETE RESTRICT,
    CONSTRAINT fk_sistema_establecimiento FOREIGN KEY (establecimiento_id) REFERENCES public.establecimiento(id) ON DELETE CASCADE
);

-- NIVEL 5: DEPENDEN DE SISTEMA_INSTALADO Y OTRAS

-- 22. ALERTA_NOTIFICACION
CREATE TABLE public.alerta_notificacion (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    sistema_instalado_id BIGINT NOT NULL,
    mensaje TEXT NOT NULL,
    fecha_alerta TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    leido BOOLEAN DEFAULT FALSE NOT NULL,
    
    CONSTRAINT alerta_notificacion_pkey PRIMARY KEY (id),
    CONSTRAINT fk_alerta_sistema FOREIGN KEY (sistema_instalado_id) REFERENCES public.sistema_instalado(id) ON DELETE CASCADE
);

-- 23. MANTENIMIENTO_TICKET
CREATE TABLE public.mantenimiento_ticket (
    id BIGINT GENERATED ALWAYS AS IDENTITY,
    sistema_instalado_id BIGINT NOT NULL,
    orden_trabajo_id BIGINT,
    tipo_mantenimiento VARCHAR(50),
    nivel_urgencia VARCHAR(50),
    descripcion_incidencia TEXT,
    fecha_reporte TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP NOT NULL,
    estado VARCHAR(50),
    
    CONSTRAINT mantenimiento_ticket_pkey PRIMARY KEY (id),
    CONSTRAINT fk_ticket_sistema FOREIGN KEY (sistema_instalado_id) REFERENCES public.sistema_instalado(id) ON DELETE RESTRICT,
    CONSTRAINT fk_ticket_orden FOREIGN KEY (orden_trabajo_id) REFERENCES public.orden_trabajo(id) ON DELETE SET NULL
);
