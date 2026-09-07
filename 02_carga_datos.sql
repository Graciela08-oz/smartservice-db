--
-- PostgreSQL database dump
--

\restrict n4JBoQ0L0F8fghdYh6cRZwEI0rgbQyaZevddAavgqMTWUYUTDIaZyXvKg8l50c9

-- Dumped from database version 16.15
-- Dumped by pg_dump version 18.3

-- Started on 2026-09-06 13:17:35

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET transaction_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- TOC entry 256 (class 1259 OID 16736)
-- Name: alerta_notificacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.alerta_notificacion (
    id integer NOT NULL,
    sistema_instalado_id integer NOT NULL,
    mensaje text NOT NULL,
    fecha_alerta date NOT NULL,
    leido boolean DEFAULT false NOT NULL
);


ALTER TABLE public.alerta_notificacion OWNER TO postgres;

--
-- TOC entry 255 (class 1259 OID 16735)
-- Name: alerta_notificacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.alerta_notificacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.alerta_notificacion_id_seq OWNER TO postgres;

--
-- TOC entry 5158 (class 0 OID 0)
-- Dependencies: 255
-- Name: alerta_notificacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.alerta_notificacion_id_seq OWNED BY public.alerta_notificacion.id;


--
-- TOC entry 220 (class 1259 OID 16434)
-- Name: bitacora; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.bitacora (
    id integer NOT NULL,
    usuario_id integer NOT NULL,
    fecha_hora timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    accion character varying(100) NOT NULL,
    descripcion text
);


ALTER TABLE public.bitacora OWNER TO postgres;

--
-- TOC entry 219 (class 1259 OID 16433)
-- Name: bitacora_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.bitacora_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.bitacora_id_seq OWNER TO postgres;

--
-- TOC entry 5159 (class 0 OID 0)
-- Dependencies: 219
-- Name: bitacora_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.bitacora_id_seq OWNED BY public.bitacora.id;


--
-- TOC entry 228 (class 1259 OID 16488)
-- Name: categoria_producto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.categoria_producto (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text
);


ALTER TABLE public.categoria_producto OWNER TO postgres;

--
-- TOC entry 227 (class 1259 OID 16487)
-- Name: categoria_producto_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.categoria_producto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.categoria_producto_id_seq OWNER TO postgres;

--
-- TOC entry 5160 (class 0 OID 0)
-- Dependencies: 227
-- Name: categoria_producto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.categoria_producto_id_seq OWNED BY public.categoria_producto.id;


--
-- TOC entry 222 (class 1259 OID 16449)
-- Name: cliente; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cliente (
    id integer NOT NULL,
    tipo_cliente character varying(50) NOT NULL,
    razon_social character varying(200) NOT NULL,
    documento_identidad character varying(50) NOT NULL,
    correo character varying(150),
    telefono character varying(30),
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL
);


ALTER TABLE public.cliente OWNER TO postgres;

--
-- TOC entry 221 (class 1259 OID 16448)
-- Name: cliente_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cliente_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cliente_id_seq OWNER TO postgres;

--
-- TOC entry 5161 (class 0 OID 0)
-- Dependencies: 221
-- Name: cliente_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cliente_id_seq OWNED BY public.cliente.id;


--
-- TOC entry 240 (class 1259 OID 16578)
-- Name: cotizacion; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.cotizacion (
    id integer NOT NULL,
    cliente_id integer NOT NULL,
    establecimiento_id integer,
    usuario_id integer NOT NULL,
    numero_cotizacion character varying(50) NOT NULL,
    fecha_emision date DEFAULT CURRENT_DATE NOT NULL,
    fecha_vencimiento date NOT NULL,
    estado character varying(50) DEFAULT 'PENDIENTE'::character varying NOT NULL
);


ALTER TABLE public.cotizacion OWNER TO postgres;

--
-- TOC entry 239 (class 1259 OID 16577)
-- Name: cotizacion_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.cotizacion_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.cotizacion_id_seq OWNER TO postgres;

--
-- TOC entry 5162 (class 0 OID 0)
-- Dependencies: 239
-- Name: cotizacion_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.cotizacion_id_seq OWNED BY public.cotizacion.id;


--
-- TOC entry 250 (class 1259 OID 16679)
-- Name: detalle_consumo_material; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detalle_consumo_material (
    id integer NOT NULL,
    orden_trabajo_id integer NOT NULL,
    producto_id integer NOT NULL,
    cantidad_utilizada integer NOT NULL,
    fecha_registro timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT detalle_consumo_material_cantidad_utilizada_check CHECK ((cantidad_utilizada > 0))
);


ALTER TABLE public.detalle_consumo_material OWNER TO postgres;

--
-- TOC entry 249 (class 1259 OID 16678)
-- Name: detalle_consumo_material_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detalle_consumo_material_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.detalle_consumo_material_id_seq OWNER TO postgres;

--
-- TOC entry 5163 (class 0 OID 0)
-- Dependencies: 249
-- Name: detalle_consumo_material_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detalle_consumo_material_id_seq OWNED BY public.detalle_consumo_material.id;


--
-- TOC entry 242 (class 1259 OID 16604)
-- Name: detalle_cotizacion_producto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detalle_cotizacion_producto (
    id integer NOT NULL,
    cotizacion_id integer NOT NULL,
    producto_id integer NOT NULL,
    cantidad integer NOT NULL,
    precio_unitario numeric(12,2) NOT NULL,
    CONSTRAINT detalle_cotizacion_producto_cantidad_check CHECK ((cantidad > 0)),
    CONSTRAINT detalle_cotizacion_producto_precio_unitario_check CHECK ((precio_unitario >= (0)::numeric))
);


ALTER TABLE public.detalle_cotizacion_producto OWNER TO postgres;

--
-- TOC entry 241 (class 1259 OID 16603)
-- Name: detalle_cotizacion_producto_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detalle_cotizacion_producto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.detalle_cotizacion_producto_id_seq OWNER TO postgres;

--
-- TOC entry 5164 (class 0 OID 0)
-- Dependencies: 241
-- Name: detalle_cotizacion_producto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detalle_cotizacion_producto_id_seq OWNED BY public.detalle_cotizacion_producto.id;


--
-- TOC entry 244 (class 1259 OID 16623)
-- Name: detalle_cotizacion_servicio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.detalle_cotizacion_servicio (
    id integer NOT NULL,
    cotizacion_id integer NOT NULL,
    servicio_id integer NOT NULL,
    horas_estimadas numeric(8,2) NOT NULL,
    precio_hora numeric(12,2) NOT NULL,
    CONSTRAINT detalle_cotizacion_servicio_horas_estimadas_check CHECK ((horas_estimadas > (0)::numeric)),
    CONSTRAINT detalle_cotizacion_servicio_precio_hora_check CHECK ((precio_hora >= (0)::numeric))
);


ALTER TABLE public.detalle_cotizacion_servicio OWNER TO postgres;

--
-- TOC entry 243 (class 1259 OID 16622)
-- Name: detalle_cotizacion_servicio_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.detalle_cotizacion_servicio_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.detalle_cotizacion_servicio_id_seq OWNER TO postgres;

--
-- TOC entry 5165 (class 0 OID 0)
-- Dependencies: 243
-- Name: detalle_cotizacion_servicio_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.detalle_cotizacion_servicio_id_seq OWNED BY public.detalle_cotizacion_servicio.id;


--
-- TOC entry 224 (class 1259 OID 16459)
-- Name: establecimiento; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.establecimiento (
    id integer NOT NULL,
    cliente_id integer NOT NULL,
    nombre_establecimiento character varying(150) NOT NULL,
    direccion character varying(255) NOT NULL,
    tipo_inmueble character varying(100),
    latitud numeric(10,8),
    longitud numeric(11,8)
);


ALTER TABLE public.establecimiento OWNER TO postgres;

--
-- TOC entry 223 (class 1259 OID 16458)
-- Name: establecimiento_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.establecimiento_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.establecimiento_id_seq OWNER TO postgres;

--
-- TOC entry 5166 (class 0 OID 0)
-- Dependencies: 223
-- Name: establecimiento_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.establecimiento_id_seq OWNED BY public.establecimiento.id;


--
-- TOC entry 254 (class 1259 OID 16715)
-- Name: mantenimiento_ticket; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.mantenimiento_ticket (
    id integer NOT NULL,
    sistema_instalado_id integer NOT NULL,
    orden_trabajo_id integer,
    tipo_mantenimiento character varying(50) NOT NULL,
    nivel_urgencia character varying(50) NOT NULL,
    descripcion_incidencia text NOT NULL,
    fecha_reporte timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    estado character varying(50) DEFAULT 'ABIERTO'::character varying NOT NULL
);


ALTER TABLE public.mantenimiento_ticket OWNER TO postgres;

--
-- TOC entry 253 (class 1259 OID 16714)
-- Name: mantenimiento_ticket_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.mantenimiento_ticket_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.mantenimiento_ticket_id_seq OWNER TO postgres;

--
-- TOC entry 5167 (class 0 OID 0)
-- Dependencies: 253
-- Name: mantenimiento_ticket_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.mantenimiento_ticket_id_seq OWNED BY public.mantenimiento_ticket.id;


--
-- TOC entry 238 (class 1259 OID 16558)
-- Name: movimiento_kardex; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.movimiento_kardex (
    id integer NOT NULL,
    producto_id integer NOT NULL,
    usuario_id integer NOT NULL,
    tipo_movimiento character varying(50) NOT NULL,
    cantidad integer NOT NULL,
    stock_anterior integer NOT NULL,
    origen_movimiento character varying(100),
    fecha_movimiento timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    observacion text
);


ALTER TABLE public.movimiento_kardex OWNER TO postgres;

--
-- TOC entry 237 (class 1259 OID 16557)
-- Name: movimiento_kardex_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.movimiento_kardex_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.movimiento_kardex_id_seq OWNER TO postgres;

--
-- TOC entry 5168 (class 0 OID 0)
-- Dependencies: 237
-- Name: movimiento_kardex_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.movimiento_kardex_id_seq OWNED BY public.movimiento_kardex.id;


--
-- TOC entry 252 (class 1259 OID 16698)
-- Name: nota_servicio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.nota_servicio (
    id integer NOT NULL,
    orden_trabajo_id integer NOT NULL,
    numero_nota character varying(50) NOT NULL,
    anticipo_pagado numeric(12,2) DEFAULT 0.00,
    fecha_emision timestamp without time zone DEFAULT CURRENT_TIMESTAMP NOT NULL,
    CONSTRAINT nota_servicio_anticipo_pagado_check CHECK ((anticipo_pagado >= (0)::numeric))
);


ALTER TABLE public.nota_servicio OWNER TO postgres;

--
-- TOC entry 251 (class 1259 OID 16697)
-- Name: nota_servicio_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.nota_servicio_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.nota_servicio_id_seq OWNER TO postgres;

--
-- TOC entry 5169 (class 0 OID 0)
-- Dependencies: 251
-- Name: nota_servicio_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.nota_servicio_id_seq OWNED BY public.nota_servicio.id;


--
-- TOC entry 246 (class 1259 OID 16642)
-- Name: orden_trabajo; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orden_trabajo (
    id integer NOT NULL,
    cotizacion_id integer,
    codigo_orden character varying(50) NOT NULL,
    tipo_trabajo character varying(100) NOT NULL,
    estado character varying(50) DEFAULT 'PROGRAMADA'::character varying NOT NULL,
    fecha_programada date NOT NULL,
    fecha_inicio_real timestamp without time zone,
    fecha_fin_real timestamp without time zone,
    observaciones_tecnico text
);


ALTER TABLE public.orden_trabajo OWNER TO postgres;

--
-- TOC entry 245 (class 1259 OID 16641)
-- Name: orden_trabajo_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orden_trabajo_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orden_trabajo_id_seq OWNER TO postgres;

--
-- TOC entry 5170 (class 0 OID 0)
-- Dependencies: 245
-- Name: orden_trabajo_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orden_trabajo_id_seq OWNED BY public.orden_trabajo.id;


--
-- TOC entry 248 (class 1259 OID 16659)
-- Name: orden_trabajo_tecnico; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.orden_trabajo_tecnico (
    id integer NOT NULL,
    orden_trabajo_id integer NOT NULL,
    usuario_id integer NOT NULL,
    es_lider boolean DEFAULT false NOT NULL
);


ALTER TABLE public.orden_trabajo_tecnico OWNER TO postgres;

--
-- TOC entry 247 (class 1259 OID 16658)
-- Name: orden_trabajo_tecnico_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.orden_trabajo_tecnico_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.orden_trabajo_tecnico_id_seq OWNER TO postgres;

--
-- TOC entry 5171 (class 0 OID 0)
-- Dependencies: 247
-- Name: orden_trabajo_tecnico_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.orden_trabajo_tecnico_id_seq OWNED BY public.orden_trabajo_tecnico.id;


--
-- TOC entry 230 (class 1259 OID 16499)
-- Name: producto; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.producto (
    id integer NOT NULL,
    categoria_producto_id integer NOT NULL,
    nombre character varying(150) NOT NULL,
    descripcion_tecnica text,
    unidad_medida character varying(50) NOT NULL,
    margen_ganancia numeric(5,2) DEFAULT 0.00,
    precio_compra_actual numeric(12,2) NOT NULL,
    stock_disponible integer DEFAULT 0 NOT NULL,
    stock_minimo integer DEFAULT 0 NOT NULL,
    CONSTRAINT producto_precio_compra_actual_check CHECK ((precio_compra_actual >= (0)::numeric)),
    CONSTRAINT producto_stock_disponible_check CHECK ((stock_disponible >= 0))
);


ALTER TABLE public.producto OWNER TO postgres;

--
-- TOC entry 229 (class 1259 OID 16498)
-- Name: producto_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.producto_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.producto_id_seq OWNER TO postgres;

--
-- TOC entry 5172 (class 0 OID 0)
-- Dependencies: 229
-- Name: producto_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.producto_id_seq OWNED BY public.producto.id;


--
-- TOC entry 236 (class 1259 OID 16539)
-- Name: producto_proveedor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.producto_proveedor (
    id integer NOT NULL,
    producto_id integer NOT NULL,
    proveedor_id integer NOT NULL,
    codigo_item_proveedor character varying(100)
);


ALTER TABLE public.producto_proveedor OWNER TO postgres;

--
-- TOC entry 235 (class 1259 OID 16538)
-- Name: producto_proveedor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.producto_proveedor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.producto_proveedor_id_seq OWNER TO postgres;

--
-- TOC entry 5173 (class 0 OID 0)
-- Dependencies: 235
-- Name: producto_proveedor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.producto_proveedor_id_seq OWNED BY public.producto_proveedor.id;


--
-- TOC entry 234 (class 1259 OID 16528)
-- Name: proveedor; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.proveedor (
    id integer NOT NULL,
    razon_social character varying(200) NOT NULL,
    nit character varying(50) NOT NULL,
    contacto character varying(150),
    telefono character varying(30),
    correo character varying(150)
);


ALTER TABLE public.proveedor OWNER TO postgres;

--
-- TOC entry 233 (class 1259 OID 16527)
-- Name: proveedor_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.proveedor_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.proveedor_id_seq OWNER TO postgres;

--
-- TOC entry 5174 (class 0 OID 0)
-- Dependencies: 233
-- Name: proveedor_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.proveedor_id_seq OWNED BY public.proveedor.id;


--
-- TOC entry 216 (class 1259 OID 16408)
-- Name: rol; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.rol (
    id integer NOT NULL,
    nombre character varying(100) NOT NULL,
    descripcion text
);


ALTER TABLE public.rol OWNER TO postgres;

--
-- TOC entry 215 (class 1259 OID 16407)
-- Name: rol_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.rol_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.rol_id_seq OWNER TO postgres;

--
-- TOC entry 5175 (class 0 OID 0)
-- Dependencies: 215
-- Name: rol_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.rol_id_seq OWNED BY public.rol.id;


--
-- TOC entry 232 (class 1259 OID 16518)
-- Name: servicio; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.servicio (
    id integer NOT NULL,
    nombre character varying(150) NOT NULL,
    descripcion text,
    precio_hora_base numeric(12,2) NOT NULL,
    CONSTRAINT servicio_precio_hora_base_check CHECK ((precio_hora_base >= (0)::numeric))
);


ALTER TABLE public.servicio OWNER TO postgres;

--
-- TOC entry 231 (class 1259 OID 16517)
-- Name: servicio_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.servicio_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.servicio_id_seq OWNER TO postgres;

--
-- TOC entry 5176 (class 0 OID 0)
-- Dependencies: 231
-- Name: servicio_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.servicio_id_seq OWNED BY public.servicio.id;


--
-- TOC entry 226 (class 1259 OID 16473)
-- Name: sistema_instalado; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sistema_instalado (
    id integer NOT NULL,
    establecimiento_id integer NOT NULL,
    nombre_sistema character varying(150) NOT NULL,
    fecha_instalacion date,
    numero_serie character varying(100),
    periodicidad_meses integer DEFAULT 6,
    fecha_ultimo_mantenimiento date,
    fecha_proximo_mantenimiento date,
    observaciones text
);


ALTER TABLE public.sistema_instalado OWNER TO postgres;

--
-- TOC entry 225 (class 1259 OID 16472)
-- Name: sistema_instalado_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sistema_instalado_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sistema_instalado_id_seq OWNER TO postgres;

--
-- TOC entry 5177 (class 0 OID 0)
-- Dependencies: 225
-- Name: sistema_instalado_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sistema_instalado_id_seq OWNED BY public.sistema_instalado.id;


--
-- TOC entry 218 (class 1259 OID 16417)
-- Name: usuario; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.usuario (
    id integer NOT NULL,
    rol_id integer NOT NULL,
    nombre character varying(150) NOT NULL,
    correo character varying(150) NOT NULL,
    password character varying(255) NOT NULL,
    telefono character varying(30),
    estado boolean DEFAULT true NOT NULL
);


ALTER TABLE public.usuario OWNER TO postgres;

--
-- TOC entry 217 (class 1259 OID 16416)
-- Name: usuario_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.usuario_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.usuario_id_seq OWNER TO postgres;

--
-- TOC entry 5178 (class 0 OID 0)
-- Dependencies: 217
-- Name: usuario_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.usuario_id_seq OWNED BY public.usuario.id;


--
-- TOC entry 4872 (class 2604 OID 16739)
-- Name: alerta_notificacion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerta_notificacion ALTER COLUMN id SET DEFAULT nextval('public.alerta_notificacion_id_seq'::regclass);


--
-- TOC entry 4838 (class 2604 OID 16437)
-- Name: bitacora id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bitacora ALTER COLUMN id SET DEFAULT nextval('public.bitacora_id_seq'::regclass);


--
-- TOC entry 4845 (class 2604 OID 16491)
-- Name: categoria_producto id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_producto ALTER COLUMN id SET DEFAULT nextval('public.categoria_producto_id_seq'::regclass);


--
-- TOC entry 4840 (class 2604 OID 16452)
-- Name: cliente id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente ALTER COLUMN id SET DEFAULT nextval('public.cliente_id_seq'::regclass);


--
-- TOC entry 4855 (class 2604 OID 16581)
-- Name: cotizacion id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cotizacion ALTER COLUMN id SET DEFAULT nextval('public.cotizacion_id_seq'::regclass);


--
-- TOC entry 4864 (class 2604 OID 16682)
-- Name: detalle_consumo_material id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_consumo_material ALTER COLUMN id SET DEFAULT nextval('public.detalle_consumo_material_id_seq'::regclass);


--
-- TOC entry 4858 (class 2604 OID 16607)
-- Name: detalle_cotizacion_producto id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_cotizacion_producto ALTER COLUMN id SET DEFAULT nextval('public.detalle_cotizacion_producto_id_seq'::regclass);


--
-- TOC entry 4859 (class 2604 OID 16626)
-- Name: detalle_cotizacion_servicio id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_cotizacion_servicio ALTER COLUMN id SET DEFAULT nextval('public.detalle_cotizacion_servicio_id_seq'::regclass);


--
-- TOC entry 4842 (class 2604 OID 16462)
-- Name: establecimiento id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.establecimiento ALTER COLUMN id SET DEFAULT nextval('public.establecimiento_id_seq'::regclass);


--
-- TOC entry 4869 (class 2604 OID 16718)
-- Name: mantenimiento_ticket id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mantenimiento_ticket ALTER COLUMN id SET DEFAULT nextval('public.mantenimiento_ticket_id_seq'::regclass);


--
-- TOC entry 4853 (class 2604 OID 16561)
-- Name: movimiento_kardex id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimiento_kardex ALTER COLUMN id SET DEFAULT nextval('public.movimiento_kardex_id_seq'::regclass);


--
-- TOC entry 4866 (class 2604 OID 16701)
-- Name: nota_servicio id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_servicio ALTER COLUMN id SET DEFAULT nextval('public.nota_servicio_id_seq'::regclass);


--
-- TOC entry 4860 (class 2604 OID 16645)
-- Name: orden_trabajo id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_trabajo ALTER COLUMN id SET DEFAULT nextval('public.orden_trabajo_id_seq'::regclass);


--
-- TOC entry 4862 (class 2604 OID 16662)
-- Name: orden_trabajo_tecnico id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_trabajo_tecnico ALTER COLUMN id SET DEFAULT nextval('public.orden_trabajo_tecnico_id_seq'::regclass);


--
-- TOC entry 4846 (class 2604 OID 16502)
-- Name: producto id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto ALTER COLUMN id SET DEFAULT nextval('public.producto_id_seq'::regclass);


--
-- TOC entry 4852 (class 2604 OID 16542)
-- Name: producto_proveedor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto_proveedor ALTER COLUMN id SET DEFAULT nextval('public.producto_proveedor_id_seq'::regclass);


--
-- TOC entry 4851 (class 2604 OID 16531)
-- Name: proveedor id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedor ALTER COLUMN id SET DEFAULT nextval('public.proveedor_id_seq'::regclass);


--
-- TOC entry 4835 (class 2604 OID 16411)
-- Name: rol id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol ALTER COLUMN id SET DEFAULT nextval('public.rol_id_seq'::regclass);


--
-- TOC entry 4850 (class 2604 OID 16521)
-- Name: servicio id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicio ALTER COLUMN id SET DEFAULT nextval('public.servicio_id_seq'::regclass);


--
-- TOC entry 4843 (class 2604 OID 16476)
-- Name: sistema_instalado id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sistema_instalado ALTER COLUMN id SET DEFAULT nextval('public.sistema_instalado_id_seq'::regclass);


--
-- TOC entry 4836 (class 2604 OID 16420)
-- Name: usuario id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario ALTER COLUMN id SET DEFAULT nextval('public.usuario_id_seq'::regclass);


--
-- TOC entry 5152 (class 0 OID 16736)
-- Dependencies: 256
-- Data for Name: alerta_notificacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.alerta_notificacion (id, sistema_instalado_id, mensaje, fecha_alerta, leido) FROM stdin;
1	1	El sistema CCTV requiere mantenimiento.	2026-02-10	f
2	2	Próximo mantenimiento del sistema de control de acceso.	2026-02-11	t
3	3	El sistema de alarma requiere mantenimiento.	2026-02-12	f
4	4	Mantenimiento preventivo próximo.	2026-02-13	f
5	5	ALERTA: revisar sistema contra incendios.	2026-02-13	f
6	6	Mantenimiento del CCTV industrial pendiente.	2026-02-14	f
7	7	Mantenimiento del sistema de alarma próximo.	2026-02-15	t
\.


--
-- TOC entry 5116 (class 0 OID 16434)
-- Dependencies: 220
-- Data for Name: bitacora; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.bitacora (id, usuario_id, fecha_hora, accion, descripcion) FROM stdin;
1	1	2026-01-02 08:00:00	INICIO_SESION	El administrador inició sesión en el sistema.
2	2	2026-01-02 08:30:00	INICIO_SESION	El encargado inició sesión en el sistema.
3	2	2026-01-03 09:15:00	REGISTRO_CLIENTE	Se registró un nuevo cliente.
4	2	2026-01-04 10:20:00	COTIZACION	Se generó una nueva cotización.
5	1	2026-01-05 11:00:00	INVENTARIO	Se actualizó información del catálogo.
6	3	2026-01-06 08:10:00	ORDEN_TRABAJO	El técnico consultó una orden asignada.
7	3	2026-01-07 15:30:00	CONSUMO_MATERIAL	El técnico registró materiales utilizados.
8	2	2026-01-08 09:00:00	ASIGNACION	Se asignó una orden al técnico.
9	1	2026-01-10 10:00:00	SUPERVISION	El administrador revisó las operaciones.
10	2	2026-01-12 14:00:00	MANTENIMIENTO	Se revisaron alertas de mantenimiento.
\.


--
-- TOC entry 5124 (class 0 OID 16488)
-- Dependencies: 228
-- Data for Name: categoria_producto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.categoria_producto (id, nombre, descripcion) FROM stdin;
1	Cámaras	Cámaras de seguridad y videovigilancia.
2	Control de Acceso	Equipos para control y registro de accesos.
3	Alarmas	Equipos y accesorios para sistemas de alarma.
4	Cableado	Cables y materiales para instalaciones.
5	Redes	Equipos de comunicación y redes.
6	Incendios	Equipos para detección y prevención de incendios.
\.


--
-- TOC entry 5118 (class 0 OID 16449)
-- Dependencies: 222
-- Data for Name: cliente; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cliente (id, tipo_cliente, razon_social, documento_identidad, correo, telefono, fecha_registro) FROM stdin;
1	EMPRESA	Hotel Los Andes S.R.L.	NIT-100001	contacto@hotelandes.com	72010001	2026-09-06 12:56:14.30907
2	EMPRESA	Supermercados La Canasta S.A.	NIT-100002	administracion@canasta.com	72010002	2026-09-06 12:56:14.30907
3	EMPRESA	Clínica San Gabriel	NIT-100003	contacto@clinicasangabriel.com	72010003	2026-09-06 12:56:14.30907
4	EMPRESA	Industrias Andinas Ltda.	NIT-100004	info@industriasandinas.com	72010004	2026-09-06 12:56:14.30907
5	PERSONA	Roberto Salazar	CI-500001	roberto@gmail.com	72010005	2026-09-06 12:56:14.30907
6	EMPRESA	Colegio Nueva Esperanza	NIT-100005	direccion@nuevaesperanza.edu	72010006	2026-09-06 12:56:14.30907
\.


--
-- TOC entry 5136 (class 0 OID 16578)
-- Dependencies: 240
-- Data for Name: cotizacion; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.cotizacion (id, cliente_id, establecimiento_id, usuario_id, numero_cotizacion, fecha_emision, fecha_vencimiento, estado) FROM stdin;
1	1	1	2	COT-2026-001	2026-01-05	2026-01-20	APROBADA
2	2	3	2	COT-2026-002	2026-01-08	2026-01-23	APROBADA
3	3	4	2	COT-2026-003	2026-01-10	2026-01-25	PENDIENTE
4	4	5	2	COT-2026-004	2026-01-12	2026-01-27	APROBADA
5	5	6	2	COT-2026-005	2026-01-15	2026-01-30	RECHAZADA
6	6	7	2	COT-2026-006	2026-01-18	2026-02-02	PENDIENTE
\.


--
-- TOC entry 5146 (class 0 OID 16679)
-- Dependencies: 250
-- Data for Name: detalle_consumo_material; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.detalle_consumo_material (id, orden_trabajo_id, producto_id, cantidad_utilizada, fecha_registro) FROM stdin;
1	1	1	2	2026-09-06 12:57:37.214779
2	1	7	200	2026-09-06 12:57:37.214779
3	1	9	1	2026-09-06 12:57:37.214779
4	2	5	2	2026-09-06 12:57:37.214779
5	2	6	5	2026-09-06 12:57:37.214779
6	3	1	4	2026-09-06 12:57:37.214779
7	3	8	150	2026-09-06 12:57:37.214779
8	3	9	1	2026-09-06 12:57:37.214779
\.


--
-- TOC entry 5138 (class 0 OID 16604)
-- Dependencies: 242
-- Data for Name: detalle_cotizacion_producto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.detalle_cotizacion_producto (id, cotizacion_id, producto_id, cantidad, precio_unitario) FROM stdin;
1	1	1	8	1105.00
2	1	7	300	6.00
3	1	9	1	1562.50
4	2	2	6	562.50
5	2	7	200	6.00
6	2	5	2	234.00
7	3	11	15	162.00
8	3	12	1	4160.00
9	4	1	12	1105.00
10	4	8	250	9.75
11	4	9	2	1562.50
12	5	3	4	837.00
13	5	4	20	18.00
14	6	5	4	234.00
15	6	6	10	63.00
\.


--
-- TOC entry 5140 (class 0 OID 16623)
-- Dependencies: 244
-- Data for Name: detalle_cotizacion_servicio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.detalle_cotizacion_servicio (id, cotizacion_id, servicio_id, horas_estimadas, precio_hora) FROM stdin;
1	1	1	16.00	80.00
2	1	4	4.00	85.00
3	2	1	10.00	80.00
4	2	5	5.00	75.00
5	3	6	12.00	100.00
6	4	1	20.00	80.00
7	4	4	6.00	85.00
8	5	3	5.00	90.00
9	6	5	8.00	75.00
\.


--
-- TOC entry 5120 (class 0 OID 16459)
-- Dependencies: 224
-- Data for Name: establecimiento; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.establecimiento (id, cliente_id, nombre_establecimiento, direccion, tipo_inmueble, latitud, longitud) FROM stdin;
1	1	Hotel Los Andes - Central	Av. Arce N° 1250	HOTEL	-17.39350000	-66.15700000
2	1	Hotel Los Andes - Norte	Av. América N° 850	HOTEL	-17.37000000	-66.14500000
3	2	La Canasta - Centro	Calle Sucre N° 450	COMERCIAL	-17.38950000	-66.15680000
4	3	Clínica San Gabriel	Av. Circunvalación N° 300	CLINICA	-17.37050000	-66.17000000
5	4	Industrias Andinas - Planta	Parque Industrial Zona Norte	INDUSTRIAL	-17.35000000	-66.13000000
6	5	Domicilio Roberto Salazar	Av. Blanco Galindo N° 900	DOMICILIO	-17.38000000	-66.21000000
7	6	Colegio Nueva Esperanza	Av. Petrolera N° 1200	EDUCATIVO	-17.42000000	-66.18000000
\.


--
-- TOC entry 5150 (class 0 OID 16715)
-- Dependencies: 254
-- Data for Name: mantenimiento_ticket; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.mantenimiento_ticket (id, sistema_instalado_id, orden_trabajo_id, tipo_mantenimiento, nivel_urgencia, descripcion_incidencia, fecha_reporte, estado) FROM stdin;
1	1	4	PREVENTIVO	MEDIA	Mantenimiento preventivo programado del sistema CCTV.	2026-02-10 09:00:00	ABIERTO
2	2	5	CORRECTIVO	ALTA	El lector RFID presenta fallas intermitentes.	2026-02-11 10:30:00	ASIGNADO
3	4	\N	PREVENTIVO	BAJA	Revisión periódica de cámaras del supermercado.	2026-02-12 08:00:00	ABIERTO
4	5	\N	CORRECTIVO	CRITICA	Se detectó una falla en el sistema contra incendios.	2026-02-13 14:00:00	ABIERTO
5	6	\N	PREVENTIVO	MEDIA	Mantenimiento programado del sistema CCTV industrial.	2026-02-14 09:30:00	ABIERTO
\.


--
-- TOC entry 5134 (class 0 OID 16558)
-- Dependencies: 238
-- Data for Name: movimiento_kardex; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.movimiento_kardex (id, producto_id, usuario_id, tipo_movimiento, cantidad, stock_anterior, origen_movimiento, fecha_movimiento, observacion) FROM stdin;
1	1	1	ENTRADA	20	0	COMPRA	2026-09-06 12:57:05.951858	Compra inicial de cámaras IP.
2	1	2	SALIDA	2	20	ORDEN_TRABAJO	2026-09-06 12:57:05.951858	Material utilizado en instalación.
3	2	1	ENTRADA	30	0	COMPRA	2026-09-06 12:57:05.951858	Ingreso de cámaras domo.
4	2	2	SALIDA	5	30	ORDEN_TRABAJO	2026-09-06 12:57:05.951858	Cámaras utilizadas en instalación.
5	3	1	ENTRADA	12	0	COMPRA	2026-09-06 12:57:05.951858	Ingreso de lectores RFID.
6	3	2	SALIDA	2	12	ORDEN_TRABAJO	2026-09-06 12:57:05.951858	Lectores utilizados.
7	4	1	ENTRADA	200	0	COMPRA	2026-09-06 12:57:05.951858	Ingreso de tarjetas RFID.
8	4	2	SALIDA	50	200	ORDEN_TRABAJO	2026-09-06 12:57:05.951858	Tarjetas entregadas al cliente.
9	7	1	ENTRADA	1000	0	COMPRA	2026-09-06 12:57:05.951858	Compra de cable UTP.
10	7	3	SALIDA	200	1000	ORDEN_TRABAJO	2026-09-06 12:57:05.951858	Cable utilizado en instalación.
11	9	1	ENTRADA	10	0	COMPRA	2026-09-06 12:57:05.951858	Ingreso de switches.
12	9	2	SALIDA	2	10	ORDEN_TRABAJO	2026-09-06 12:57:05.951858	Switches utilizados.
13	11	1	ENTRADA	50	0	COMPRA	2026-09-06 12:57:05.951858	Ingreso de detectores de humo.
14	11	3	SALIDA	10	50	ORDEN_TRABAJO	2026-09-06 12:57:05.951858	Detectores utilizados.
\.


--
-- TOC entry 5148 (class 0 OID 16698)
-- Dependencies: 252
-- Data for Name: nota_servicio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.nota_servicio (id, orden_trabajo_id, numero_nota, anticipo_pagado, fecha_emision) FROM stdin;
1	1	NS-2026-001	2500.00	2026-01-22 17:30:00
2	2	NS-2026-002	1200.00	2026-01-25 15:30:00
3	3	NS-2026-003	3000.00	2026-02-02 16:00:00
\.


--
-- TOC entry 5142 (class 0 OID 16642)
-- Dependencies: 246
-- Data for Name: orden_trabajo; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orden_trabajo (id, cotizacion_id, codigo_orden, tipo_trabajo, estado, fecha_programada, fecha_inicio_real, fecha_fin_real, observaciones_tecnico) FROM stdin;
1	1	OT-2026-001	INSTALACION CCTV	FINALIZADA	2026-01-22	2026-01-22 08:00:00	2026-01-22 17:00:00	Instalación completada correctamente.
2	2	OT-2026-002	INSTALACION ALARMA	FINALIZADA	2026-01-25	2026-01-25 09:00:00	2026-01-25 15:00:00	Sistema probado y funcionando.
3	4	OT-2026-003	INSTALACION CCTV	EN_PROCESO	2026-02-02	2026-02-02 08:30:00	\N	Instalación en planta industrial.
4	1	OT-2026-004	MANTENIMIENTO PREVENTIVO	PROGRAMADA	2026-02-15	\N	\N	\N
5	2	OT-2026-005	MANTENIMIENTO CORRECTIVO	PROGRAMADA	2026-02-18	\N	\N	\N
\.


--
-- TOC entry 5144 (class 0 OID 16659)
-- Dependencies: 248
-- Data for Name: orden_trabajo_tecnico; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.orden_trabajo_tecnico (id, orden_trabajo_id, usuario_id, es_lider) FROM stdin;
1	1	3	t
2	1	4	f
3	2	5	t
4	2	6	f
5	3	4	t
6	3	5	f
\.


--
-- TOC entry 5126 (class 0 OID 16499)
-- Dependencies: 230
-- Data for Name: producto; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producto (id, categoria_producto_id, nombre, descripcion_tecnica, unidad_medida, margen_ganancia, precio_compra_actual, stock_disponible, stock_minimo) FROM stdin;
1	1	Cámara IP 4MP	Cámara IP de 4 megapíxeles con visión nocturna.	UNIDAD	30.00	850.00	18	5
2	1	Cámara Domo 2MP	Cámara domo para interiores.	UNIDAD	25.00	450.00	25	8
3	2	Lector RFID	Lector de tarjetas RFID para control de acceso.	UNIDAD	35.00	620.00	10	3
4	2	Tarjeta RFID	Tarjeta de proximidad RFID.	UNIDAD	50.00	12.00	150	30
5	3	Sirena Electrónica	Sirena electrónica para sistemas de alarma.	UNIDAD	30.00	180.00	20	5
6	3	Sensor Magnético	Sensor magnético para puertas y ventanas.	UNIDAD	40.00	45.00	35	10
7	4	Cable UTP Cat6	Cable de red categoría 6.	METRO	25.00	4.50	800	200
8	4	Cable FTP Cat6	Cable FTP categoría 6 blindado.	METRO	30.00	7.50	500	150
9	5	Switch 24 Puertos	Switch administrable de 24 puertos.	UNIDAD	25.00	1250.00	8	2
10	5	Router Empresarial	Router para redes empresariales.	UNIDAD	30.00	950.00	6	2
11	6	Detector de Humo	Detector de humo fotoeléctrico.	UNIDAD	35.00	120.00	40	10
12	6	Panel Contra Incendios	Panel central para sistema contra incendios.	UNIDAD	30.00	3200.00	4	1
\.


--
-- TOC entry 5132 (class 0 OID 16539)
-- Dependencies: 236
-- Data for Name: producto_proveedor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.producto_proveedor (id, producto_id, proveedor_id, codigo_item_proveedor) FROM stdin;
1	1	1	CAM-IP-4MP
2	1	2	IPCAM-4000
3	2	1	CAM-DOMO-2MP
4	3	1	RFID-LECTOR-01
5	3	2	RFID-620
6	4	2	CARD-RFID
7	5	1	SIRENA-180
8	6	1	SENSOR-MAG
9	7	3	UTP-CAT6
10	8	3	FTP-CAT6
11	9	3	SW-24P
12	10	3	ROUT-EMP
13	11	4	DETECTOR-HUMO
14	12	4	PANEL-INC
\.


--
-- TOC entry 5130 (class 0 OID 16528)
-- Dependencies: 234
-- Data for Name: proveedor; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.proveedor (id, razon_social, nit, contacto, telefono, correo) FROM stdin;
1	Seguritech Bolivia S.R.L.	NIT-PROV-001	Luis Vargas	73000001	ventas@seguritech.com
2	Importadora Andina S.A.	NIT-PROV-002	Pedro Rojas	73000002	ventas@importadoraandina.com
3	TecnoRed Bolivia	NIT-PROV-003	Ana Flores	73000003	contacto@tecnored.com
4	FireSafe Bolivia	NIT-PROV-004	Miguel Torres	73000004	ventas@firesafe.com
\.


--
-- TOC entry 5112 (class 0 OID 16408)
-- Dependencies: 216
-- Data for Name: rol; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.rol (id, nombre, descripcion) FROM stdin;
1	ADMINISTRADOR	Administrador general del sistema.
2	ENCARGADO	Encargado de gestionar clientes, cotizaciones e inventario.
3	TECNICO	Técnico encargado de ejecutar órdenes de trabajo y mantenimientos.
\.


--
-- TOC entry 5128 (class 0 OID 16518)
-- Dependencies: 232
-- Data for Name: servicio; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.servicio (id, nombre, descripcion, precio_hora_base) FROM stdin;
1	Instalación de CCTV	Instalación y configuración de cámaras de seguridad.	80.00
2	Mantenimiento Preventivo	Mantenimiento preventivo de sistemas instalados.	70.00
3	Mantenimiento Correctivo	Diagnóstico y reparación de fallas.	90.00
4	Configuración de Red	Configuración de switches, routers y cableado.	85.00
5	Instalación de Alarma	Instalación y configuración de sistemas de alarma.	75.00
6	Instalación Sistema Contra Incendios	Instalación y configuración de detectores y paneles.	100.00
\.


--
-- TOC entry 5122 (class 0 OID 16473)
-- Dependencies: 226
-- Data for Name: sistema_instalado; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sistema_instalado (id, establecimiento_id, nombre_sistema, fecha_instalacion, numero_serie, periodicidad_meses, fecha_ultimo_mantenimiento, fecha_proximo_mantenimiento, observaciones) FROM stdin;
1	1	Sistema de CCTV	2025-01-15	CCTV-HLA-001	6	2025-12-15	2026-06-15	Sistema de vigilancia de 24 cámaras.
2	1	Sistema de Control de Acceso	2025-03-10	ACC-HLA-001	6	2025-11-10	2026-05-10	Control de acceso mediante tarjetas.
3	2	Sistema de Alarma	2025-04-20	ALM-HLA-002	6	2025-10-20	2026-04-20	Sistema de alarma contra intrusión.
4	3	Sistema de CCTV	2024-11-05	CCTV-CAN-001	6	2025-11-05	2026-05-05	Sistema de vigilancia del supermercado.
5	4	Sistema de Detección de Incendios	2025-02-12	INC-CLI-001	3	2025-12-12	2026-03-12	Detectores instalados en áreas críticas.
6	5	Sistema de CCTV Industrial	2024-08-18	CCTV-IND-001	6	2025-08-18	2026-02-18	Vigilancia de áreas de producción.
7	7	Sistema de Alarma	2025-05-25	ALM-COL-001	6	2025-11-25	2026-05-25	Alarma para protección del establecimiento.
\.


--
-- TOC entry 5114 (class 0 OID 16417)
-- Dependencies: 218
-- Data for Name: usuario; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.usuario (id, rol_id, nombre, correo, password, telefono, estado) FROM stdin;
1	1	Carlos Mendoza	carlos@empresa.com	$2b$10$EjemploHashAdministrador	70000001	t
2	2	María Fernández	maria@empresa.com	$2b$10$EjemploHashEncargado	70000002	t
3	3	Juan Pérez	juan@empresa.com	$2b$10$EjemploHashTecnico	70000003	t
4	3	Pedro Ramírez	pedro@empresa.com	$2b$10$EjemploHashTecnico1	70000004	t
5	3	Luis Fernández	luis@empresa.com	$2b$10$EjemploHashTecnico2	70000005	t
6	3	Diego Castillo	diego@empresa.com	$2b$10$EjemploHashTecnico3	70000006	t
\.


--
-- TOC entry 5179 (class 0 OID 0)
-- Dependencies: 255
-- Name: alerta_notificacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.alerta_notificacion_id_seq', 7, true);


--
-- TOC entry 5180 (class 0 OID 0)
-- Dependencies: 219
-- Name: bitacora_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.bitacora_id_seq', 10, true);


--
-- TOC entry 5181 (class 0 OID 0)
-- Dependencies: 227
-- Name: categoria_producto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.categoria_producto_id_seq', 6, true);


--
-- TOC entry 5182 (class 0 OID 0)
-- Dependencies: 221
-- Name: cliente_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cliente_id_seq', 6, true);


--
-- TOC entry 5183 (class 0 OID 0)
-- Dependencies: 239
-- Name: cotizacion_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.cotizacion_id_seq', 6, true);


--
-- TOC entry 5184 (class 0 OID 0)
-- Dependencies: 249
-- Name: detalle_consumo_material_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalle_consumo_material_id_seq', 8, true);


--
-- TOC entry 5185 (class 0 OID 0)
-- Dependencies: 241
-- Name: detalle_cotizacion_producto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalle_cotizacion_producto_id_seq', 15, true);


--
-- TOC entry 5186 (class 0 OID 0)
-- Dependencies: 243
-- Name: detalle_cotizacion_servicio_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.detalle_cotizacion_servicio_id_seq', 9, true);


--
-- TOC entry 5187 (class 0 OID 0)
-- Dependencies: 223
-- Name: establecimiento_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.establecimiento_id_seq', 7, true);


--
-- TOC entry 5188 (class 0 OID 0)
-- Dependencies: 253
-- Name: mantenimiento_ticket_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.mantenimiento_ticket_id_seq', 5, true);


--
-- TOC entry 5189 (class 0 OID 0)
-- Dependencies: 237
-- Name: movimiento_kardex_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.movimiento_kardex_id_seq', 14, true);


--
-- TOC entry 5190 (class 0 OID 0)
-- Dependencies: 251
-- Name: nota_servicio_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.nota_servicio_id_seq', 3, true);


--
-- TOC entry 5191 (class 0 OID 0)
-- Dependencies: 245
-- Name: orden_trabajo_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orden_trabajo_id_seq', 5, true);


--
-- TOC entry 5192 (class 0 OID 0)
-- Dependencies: 247
-- Name: orden_trabajo_tecnico_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.orden_trabajo_tecnico_id_seq', 6, true);


--
-- TOC entry 5193 (class 0 OID 0)
-- Dependencies: 229
-- Name: producto_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.producto_id_seq', 12, true);


--
-- TOC entry 5194 (class 0 OID 0)
-- Dependencies: 235
-- Name: producto_proveedor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.producto_proveedor_id_seq', 14, true);


--
-- TOC entry 5195 (class 0 OID 0)
-- Dependencies: 233
-- Name: proveedor_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.proveedor_id_seq', 4, true);


--
-- TOC entry 5196 (class 0 OID 0)
-- Dependencies: 215
-- Name: rol_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.rol_id_seq', 3, true);


--
-- TOC entry 5197 (class 0 OID 0)
-- Dependencies: 231
-- Name: servicio_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.servicio_id_seq', 6, true);


--
-- TOC entry 5198 (class 0 OID 0)
-- Dependencies: 225
-- Name: sistema_instalado_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sistema_instalado_id_seq', 7, true);


--
-- TOC entry 5199 (class 0 OID 0)
-- Dependencies: 217
-- Name: usuario_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.usuario_id_seq', 6, true);


--
-- TOC entry 4942 (class 2606 OID 16744)
-- Name: alerta_notificacion alerta_notificacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerta_notificacion
    ADD CONSTRAINT alerta_notificacion_pkey PRIMARY KEY (id);


--
-- TOC entry 4890 (class 2606 OID 16442)
-- Name: bitacora bitacora_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bitacora
    ADD CONSTRAINT bitacora_pkey PRIMARY KEY (id);


--
-- TOC entry 4900 (class 2606 OID 16497)
-- Name: categoria_producto categoria_producto_nombre_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_producto
    ADD CONSTRAINT categoria_producto_nombre_key UNIQUE (nombre);


--
-- TOC entry 4902 (class 2606 OID 16495)
-- Name: categoria_producto categoria_producto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.categoria_producto
    ADD CONSTRAINT categoria_producto_pkey PRIMARY KEY (id);


--
-- TOC entry 4892 (class 2606 OID 16457)
-- Name: cliente cliente_documento_identidad_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_documento_identidad_key UNIQUE (documento_identidad);


--
-- TOC entry 4894 (class 2606 OID 16455)
-- Name: cliente cliente_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cliente
    ADD CONSTRAINT cliente_pkey PRIMARY KEY (id);


--
-- TOC entry 4918 (class 2606 OID 16587)
-- Name: cotizacion cotizacion_numero_cotizacion_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cotizacion
    ADD CONSTRAINT cotizacion_numero_cotizacion_key UNIQUE (numero_cotizacion);


--
-- TOC entry 4920 (class 2606 OID 16585)
-- Name: cotizacion cotizacion_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cotizacion
    ADD CONSTRAINT cotizacion_pkey PRIMARY KEY (id);


--
-- TOC entry 4934 (class 2606 OID 16686)
-- Name: detalle_consumo_material detalle_consumo_material_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_consumo_material
    ADD CONSTRAINT detalle_consumo_material_pkey PRIMARY KEY (id);


--
-- TOC entry 4922 (class 2606 OID 16611)
-- Name: detalle_cotizacion_producto detalle_cotizacion_producto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_cotizacion_producto
    ADD CONSTRAINT detalle_cotizacion_producto_pkey PRIMARY KEY (id);


--
-- TOC entry 4924 (class 2606 OID 16630)
-- Name: detalle_cotizacion_servicio detalle_cotizacion_servicio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_cotizacion_servicio
    ADD CONSTRAINT detalle_cotizacion_servicio_pkey PRIMARY KEY (id);


--
-- TOC entry 4896 (class 2606 OID 16466)
-- Name: establecimiento establecimiento_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.establecimiento
    ADD CONSTRAINT establecimiento_pkey PRIMARY KEY (id);


--
-- TOC entry 4940 (class 2606 OID 16724)
-- Name: mantenimiento_ticket mantenimiento_ticket_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mantenimiento_ticket
    ADD CONSTRAINT mantenimiento_ticket_pkey PRIMARY KEY (id);


--
-- TOC entry 4916 (class 2606 OID 16566)
-- Name: movimiento_kardex movimiento_kardex_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimiento_kardex
    ADD CONSTRAINT movimiento_kardex_pkey PRIMARY KEY (id);


--
-- TOC entry 4936 (class 2606 OID 16708)
-- Name: nota_servicio nota_servicio_numero_nota_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_servicio
    ADD CONSTRAINT nota_servicio_numero_nota_key UNIQUE (numero_nota);


--
-- TOC entry 4938 (class 2606 OID 16706)
-- Name: nota_servicio nota_servicio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_servicio
    ADD CONSTRAINT nota_servicio_pkey PRIMARY KEY (id);


--
-- TOC entry 4926 (class 2606 OID 16652)
-- Name: orden_trabajo orden_trabajo_codigo_orden_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_trabajo
    ADD CONSTRAINT orden_trabajo_codigo_orden_key UNIQUE (codigo_orden);


--
-- TOC entry 4928 (class 2606 OID 16650)
-- Name: orden_trabajo orden_trabajo_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_trabajo
    ADD CONSTRAINT orden_trabajo_pkey PRIMARY KEY (id);


--
-- TOC entry 4930 (class 2606 OID 16665)
-- Name: orden_trabajo_tecnico orden_trabajo_tecnico_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_trabajo_tecnico
    ADD CONSTRAINT orden_trabajo_tecnico_pkey PRIMARY KEY (id);


--
-- TOC entry 4904 (class 2606 OID 16511)
-- Name: producto producto_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_pkey PRIMARY KEY (id);


--
-- TOC entry 4912 (class 2606 OID 16544)
-- Name: producto_proveedor producto_proveedor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto_proveedor
    ADD CONSTRAINT producto_proveedor_pkey PRIMARY KEY (id);


--
-- TOC entry 4908 (class 2606 OID 16537)
-- Name: proveedor proveedor_nit_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_nit_key UNIQUE (nit);


--
-- TOC entry 4910 (class 2606 OID 16535)
-- Name: proveedor proveedor_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.proveedor
    ADD CONSTRAINT proveedor_pkey PRIMARY KEY (id);


--
-- TOC entry 4884 (class 2606 OID 16415)
-- Name: rol rol_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.rol
    ADD CONSTRAINT rol_pkey PRIMARY KEY (id);


--
-- TOC entry 4906 (class 2606 OID 16526)
-- Name: servicio servicio_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.servicio
    ADD CONSTRAINT servicio_pkey PRIMARY KEY (id);


--
-- TOC entry 4898 (class 2606 OID 16481)
-- Name: sistema_instalado sistema_instalado_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sistema_instalado
    ADD CONSTRAINT sistema_instalado_pkey PRIMARY KEY (id);


--
-- TOC entry 4932 (class 2606 OID 16667)
-- Name: orden_trabajo_tecnico unique_orden_tecnico; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_trabajo_tecnico
    ADD CONSTRAINT unique_orden_tecnico UNIQUE (orden_trabajo_id, usuario_id);


--
-- TOC entry 4914 (class 2606 OID 16546)
-- Name: producto_proveedor unique_producto_proveedor; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto_proveedor
    ADD CONSTRAINT unique_producto_proveedor UNIQUE (producto_id, proveedor_id);


--
-- TOC entry 4886 (class 2606 OID 16427)
-- Name: usuario usuario_correo_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_correo_key UNIQUE (correo);


--
-- TOC entry 4888 (class 2606 OID 16425)
-- Name: usuario usuario_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_pkey PRIMARY KEY (id);


--
-- TOC entry 4967 (class 2606 OID 16745)
-- Name: alerta_notificacion alerta_notificacion_sistema_instalado_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.alerta_notificacion
    ADD CONSTRAINT alerta_notificacion_sistema_instalado_id_fkey FOREIGN KEY (sistema_instalado_id) REFERENCES public.sistema_instalado(id) ON DELETE CASCADE;


--
-- TOC entry 4944 (class 2606 OID 16443)
-- Name: bitacora bitacora_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.bitacora
    ADD CONSTRAINT bitacora_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) ON DELETE CASCADE;


--
-- TOC entry 4952 (class 2606 OID 16588)
-- Name: cotizacion cotizacion_cliente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cotizacion
    ADD CONSTRAINT cotizacion_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.cliente(id) ON DELETE RESTRICT;


--
-- TOC entry 4953 (class 2606 OID 16593)
-- Name: cotizacion cotizacion_establecimiento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cotizacion
    ADD CONSTRAINT cotizacion_establecimiento_id_fkey FOREIGN KEY (establecimiento_id) REFERENCES public.establecimiento(id) ON DELETE SET NULL;


--
-- TOC entry 4954 (class 2606 OID 16598)
-- Name: cotizacion cotizacion_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.cotizacion
    ADD CONSTRAINT cotizacion_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) ON DELETE RESTRICT;


--
-- TOC entry 4962 (class 2606 OID 16687)
-- Name: detalle_consumo_material detalle_consumo_material_orden_trabajo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_consumo_material
    ADD CONSTRAINT detalle_consumo_material_orden_trabajo_id_fkey FOREIGN KEY (orden_trabajo_id) REFERENCES public.orden_trabajo(id) ON DELETE CASCADE;


--
-- TOC entry 4963 (class 2606 OID 16692)
-- Name: detalle_consumo_material detalle_consumo_material_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_consumo_material
    ADD CONSTRAINT detalle_consumo_material_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.producto(id) ON DELETE RESTRICT;


--
-- TOC entry 4955 (class 2606 OID 16612)
-- Name: detalle_cotizacion_producto detalle_cotizacion_producto_cotizacion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_cotizacion_producto
    ADD CONSTRAINT detalle_cotizacion_producto_cotizacion_id_fkey FOREIGN KEY (cotizacion_id) REFERENCES public.cotizacion(id) ON DELETE CASCADE;


--
-- TOC entry 4956 (class 2606 OID 16617)
-- Name: detalle_cotizacion_producto detalle_cotizacion_producto_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_cotizacion_producto
    ADD CONSTRAINT detalle_cotizacion_producto_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.producto(id) ON DELETE RESTRICT;


--
-- TOC entry 4957 (class 2606 OID 16631)
-- Name: detalle_cotizacion_servicio detalle_cotizacion_servicio_cotizacion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_cotizacion_servicio
    ADD CONSTRAINT detalle_cotizacion_servicio_cotizacion_id_fkey FOREIGN KEY (cotizacion_id) REFERENCES public.cotizacion(id) ON DELETE CASCADE;


--
-- TOC entry 4958 (class 2606 OID 16636)
-- Name: detalle_cotizacion_servicio detalle_cotizacion_servicio_servicio_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.detalle_cotizacion_servicio
    ADD CONSTRAINT detalle_cotizacion_servicio_servicio_id_fkey FOREIGN KEY (servicio_id) REFERENCES public.servicio(id) ON DELETE RESTRICT;


--
-- TOC entry 4945 (class 2606 OID 16467)
-- Name: establecimiento establecimiento_cliente_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.establecimiento
    ADD CONSTRAINT establecimiento_cliente_id_fkey FOREIGN KEY (cliente_id) REFERENCES public.cliente(id) ON DELETE CASCADE;


--
-- TOC entry 4965 (class 2606 OID 16730)
-- Name: mantenimiento_ticket mantenimiento_ticket_orden_trabajo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mantenimiento_ticket
    ADD CONSTRAINT mantenimiento_ticket_orden_trabajo_id_fkey FOREIGN KEY (orden_trabajo_id) REFERENCES public.orden_trabajo(id) ON DELETE SET NULL;


--
-- TOC entry 4966 (class 2606 OID 16725)
-- Name: mantenimiento_ticket mantenimiento_ticket_sistema_instalado_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.mantenimiento_ticket
    ADD CONSTRAINT mantenimiento_ticket_sistema_instalado_id_fkey FOREIGN KEY (sistema_instalado_id) REFERENCES public.sistema_instalado(id) ON DELETE CASCADE;


--
-- TOC entry 4950 (class 2606 OID 16567)
-- Name: movimiento_kardex movimiento_kardex_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimiento_kardex
    ADD CONSTRAINT movimiento_kardex_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.producto(id) ON DELETE RESTRICT;


--
-- TOC entry 4951 (class 2606 OID 16572)
-- Name: movimiento_kardex movimiento_kardex_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.movimiento_kardex
    ADD CONSTRAINT movimiento_kardex_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) ON DELETE RESTRICT;


--
-- TOC entry 4964 (class 2606 OID 16709)
-- Name: nota_servicio nota_servicio_orden_trabajo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.nota_servicio
    ADD CONSTRAINT nota_servicio_orden_trabajo_id_fkey FOREIGN KEY (orden_trabajo_id) REFERENCES public.orden_trabajo(id) ON DELETE CASCADE;


--
-- TOC entry 4959 (class 2606 OID 16653)
-- Name: orden_trabajo orden_trabajo_cotizacion_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_trabajo
    ADD CONSTRAINT orden_trabajo_cotizacion_id_fkey FOREIGN KEY (cotizacion_id) REFERENCES public.cotizacion(id) ON DELETE SET NULL;


--
-- TOC entry 4960 (class 2606 OID 16668)
-- Name: orden_trabajo_tecnico orden_trabajo_tecnico_orden_trabajo_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_trabajo_tecnico
    ADD CONSTRAINT orden_trabajo_tecnico_orden_trabajo_id_fkey FOREIGN KEY (orden_trabajo_id) REFERENCES public.orden_trabajo(id) ON DELETE CASCADE;


--
-- TOC entry 4961 (class 2606 OID 16673)
-- Name: orden_trabajo_tecnico orden_trabajo_tecnico_usuario_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.orden_trabajo_tecnico
    ADD CONSTRAINT orden_trabajo_tecnico_usuario_id_fkey FOREIGN KEY (usuario_id) REFERENCES public.usuario(id) ON DELETE RESTRICT;


--
-- TOC entry 4947 (class 2606 OID 16512)
-- Name: producto producto_categoria_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto
    ADD CONSTRAINT producto_categoria_producto_id_fkey FOREIGN KEY (categoria_producto_id) REFERENCES public.categoria_producto(id) ON DELETE RESTRICT;


--
-- TOC entry 4948 (class 2606 OID 16547)
-- Name: producto_proveedor producto_proveedor_producto_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto_proveedor
    ADD CONSTRAINT producto_proveedor_producto_id_fkey FOREIGN KEY (producto_id) REFERENCES public.producto(id) ON DELETE CASCADE;


--
-- TOC entry 4949 (class 2606 OID 16552)
-- Name: producto_proveedor producto_proveedor_proveedor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.producto_proveedor
    ADD CONSTRAINT producto_proveedor_proveedor_id_fkey FOREIGN KEY (proveedor_id) REFERENCES public.proveedor(id) ON DELETE CASCADE;


--
-- TOC entry 4946 (class 2606 OID 16482)
-- Name: sistema_instalado sistema_instalado_establecimiento_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sistema_instalado
    ADD CONSTRAINT sistema_instalado_establecimiento_id_fkey FOREIGN KEY (establecimiento_id) REFERENCES public.establecimiento(id) ON DELETE CASCADE;


--
-- TOC entry 4943 (class 2606 OID 16428)
-- Name: usuario usuario_rol_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.usuario
    ADD CONSTRAINT usuario_rol_id_fkey FOREIGN KEY (rol_id) REFERENCES public.rol(id) ON DELETE RESTRICT;


-- Completed on 2026-09-06 13:17:35

--
-- PostgreSQL database dump complete
--

\unrestrict n4JBoQ0L0F8fghdYh6cRZwEI0rgbQyaZevddAavgqMTWUYUTDIaZyXvKg8l50c9

