# Proyecto Final SQL: Sistema de Gestión para gomitas.sf
**Estudiante:** Kevin Larguía Comisión 96045 SQL (Diplomatura) 

---

## Sumario
1. [Introducción](#introducción)
2. [Objetivo](#objetivo)
3. [Situación Problemática](#situación-problemática)
4. [Modelo de Negocio](#modelo-de-negocio)
5. [Diagrama Entidad-Relación (DER)](#diagrama-entidad-relación-der)
6. [Listado de Tablas y Propósito Funcional](#listado-de-tablas-y-propósito-funcional)
7. [Scripts de Creación de Objetos](#scripts-de-creación-de-objetos)
8. [Scripts de Inserción de Datos](#scripts-de-inserción-de-datos)
9. [Informe Analítico (Power BI)](#informe-analítico-power-bi)
10. [Herramientas y Tecnologías](#herramientas-y-tecnologías)

---

## Introducción
El presente proyecto desarrolla una infraestructura de datos relacional para gomitas.sf, un emprendimiento ubicado en Santa Fe Capital especializado en la comercialización de arreglos y mesas dulces de golosinas. El sistema centraliza la operativa de ventas, el control de stock de insumos y el seguimiento logístico en la región.

## Objetivo
El objetivo primordial es implementar una solución integral de base de datos que resuelva las necesidades del negocio:
* **Logística**: Gestionar costos de envío diferenciados por barrios en Santa Fe y alrededores.
* **Contable/Financiera**: Automatizar el cálculo de márgenes y Retorno de Inversión (ROI) mediante funciones personalizadas.
* **Operativa**: Controlar la carga de trabajo de los socios y empleados.
* **Analítica**: Extraer información estratégica mediante herramientas de Business Intelligence.

## Situación Problemática
Antes de esta implementación, el negocio operaba con registros informales, lo que generaba tres brechas críticas:
1. **Falta de métricas en marketing**: Dificultad para determinar si la inversión en Instagram Ads se traducía en ganancias reales.
2. **Inconsistencia en envíos**: Errores frecuentes en el cobro de fletes para zonas alejadas como Santo Tomé, El Pozo o Colastiné.
3. **Falta de trazabilidad**: Dificultad para auditar cambios de precios en insumos ante la inflación.

## Modelo de Negocio
gomitas.sf opera mediante la venta directa y personalizada. Los clientes eligen un producto (Box, Bandeja, Vaso) y pueden personalizar las variedades de dulces. El negocio ofrece servicios adicionales de Mesa Dulce y Candy Bar para eventos, los cuales incluyen una gestión de envíos y stickers diferenciada según el tipo de servicio.

---

El archivo **Script 1 Creación de tablas y Relaciones.sql** ejecuta la creación del esquema de base de datos gomitas_sf y la definición de su estructura relacional. Incluye la creación de las 15 entidades del modelo y la configuración de todas las restricciones de claves primarias y foráneas necesarias para asegurar la integridad de los datos.

---

## Diagrama Entidad-Relación (DER)
<img width="1805" height="1001" alt="DER sql" src="https://github.com/user-attachments/assets/d974aa95-1047-4265-9441-3f7efc72e507" />
El diagrama representa la estructura de 15 tablas vinculadas mediante claves primarias y foráneas. La arquitectura se divide en 6 capas lógicas identificadas por colores para facilitar el mantenimiento y la escalabilidad del sistema.

---

## Listado de Tablas y Propósito Funcional

### 1. Núcleo de Ventas (Capa Celeste)
Representa el flujo transaccional principal del sistema.
* **pedidos**: Tabla de hechos central que almacena el encabezado de cada venta, incluyendo fecha, monto total y referencias a todas las dimensiones del negocio.
* **detalle_pedido**: Desglose de los productos específicos incluidos en cada orden y sus cantidades.
* **metodos_pago**: Maestro de opciones de cobro disponibles como Efectivo, Transferencia o Billeteras Virtuales.
* **estados_pedido**: Permite el seguimiento del ciclo de vida de la orden desde Pendiente hasta Entregado.

### 2. Logística y Distribución (Capa Verde)
Gestiona el alcance territorial y el personal involucrado.
* **zonas_envio**: Define los barrios de Santa Fe y asigna costos de envío automáticos para la facturación.
* **empleados**: Registra al staff del emprendimiento y sus funciones operativas como Ventas, Producción o Envíos.

### 3. Marketing y Clientes (Capa Rosa)
Mide el origen de las ventas y el impacto publicitario.
* **clientes**: Almacena la base de datos de compradores y el canal por el cual conocieron el negocio.
* **campanas_ads**: Registra las inversiones en pauta digital para el posterior cálculo del ROI.

### 4. Catálogo y Abastecimiento (Capa Amarilla)
Define la oferta comercial y la cadena de suministros.
* **productos**: Catálogo de artículos finales con sus respectivos precios de venta.
* **categorias_productos**: Clasificación jerárquica de los artículos como Box, Bandeja o Vaso.
* **gomitas**: Inventario de insumos con detalle de marca, sabor y costo por kilo.
* **proveedores**: Registro de las distribuidoras mayoristas que abastecen el negocio.

### 5. Personalización y Servicios Especiales (Capa Roja)
Registra los detalles específicos para pedidos de gran volumen.
* **seleccion_gomitas**: Permite la personalización granular guardando qué dulces específicos integran cada producto pedido.
* **servicios_eventos**: Almacena información técnica para eventos como la temática y cantidad de personas.

### 6. Control y Auditoría (Capa Gris)
Sección técnica para la integridad de los datos.
* **auditoria_precios**: Registra automáticamente el historial de cambios en los costos de los insumos para control administrativo.

---

## Scripts de Inserción de Datos
El archivo **Script 2 Carga de datos.sql** ejecuta la carga de más de 20 registros transaccionales reales. Incluye la limpieza previa de tablas para asegurar una ejecución libre de errores de integridad referencial.

---
## Scripts de Creación de Objetos
El archivo **Script 3 Objetos.sql** contiene la lógica programada para automatizar el negocio.

### Vistas (5)
* **vw_rentabilidad_campanas**: Reporte financiero que calcula el ROI restando la inversión a los ingresos generados por pauta.
* **vw_exportacion_ventas**: Estructura de datos completa y desnormalizada optimizada para el consumo en herramientas de BI.
* **vw_productos_top**: Ranking dinámico de productos basado exclusivamente en unidades totales vendidas.
* **vw_ventas_por_zona**: Análisis de facturación distribuida geográficamente por los barrios de Santa Fe.
* **vw_gestion_empleados**: Métrica de productividad que contabiliza la carga operativa por cada integrante del staff.

### Stored Procedures (2)
* **sp_actualizar_precios_proveedor**: Facilita ajustes masivos por inflación según el proveedor de insumos.
* **sp_resumen_cliente**: Genera un informe histórico de actividad de un cliente específico.

### Funciones (3)
* **fn_calcular_precio_500g**: Calcula costos proporcionales para presentaciones fraccionadas.
* **fn_estado_sticker_envio**: Determina beneficios de personalización y logística según el tipo de servicio contratado.
* **fn_calcular_roi_campana**: Función de cálculo financiero para determinar la ganancia neta individual.

### Triggers (2)
* **tr_auditoria_precio_gomitas**: Asegura la trazabilidad de los costos de insumos registrando cambios históricos.
* **tr_verificar_precio_positivo**: Validación de integridad para evitar precios de catálogo menores a cero.

---

## Informe Analítico (Power BI)
<img width="1437" height="806" alt="dashboard para entrega final" src="https://github.com/user-attachments/assets/bba03d5a-f9b6-4447-997e-67f0cd0553f9" />

Se procesó la información mediante **Microsoft Power BI**, generando un dashboard interactivo que analiza los siguientes indicadores estratégicos:
1. **Rentabilidad por Campaña (ROI)**: Identificación de las pautas más eficientes.
2. **Facturación por Barrio**: Análisis geográfico de ventas en la ciudad de Santa Fe.
3. **Volumen de Ventas por Producto**: Ranking de los artículos más solicitados.
4. **Distribución por Canal de Captación**: Comparativa entre Instagram, WhatsApp y Marketplace.
5. **Eficiencia de Gestión del Staff**: Control de productividad por empleado.
6. **Tendencia Temporal de Ingresos**: Evolución diaria de la facturación.

---

## Herramientas y Tecnologías:
* **Motor de Base de Datos**: MySQL 8.0.
* **Modelado**: MySQL Workbench (Ingeniería Inversa para DER).
* **Analítica**: Microsoft Power BI Desktop.
* **Control de Versiones**: GitHub.
* **Documentación**: README.
