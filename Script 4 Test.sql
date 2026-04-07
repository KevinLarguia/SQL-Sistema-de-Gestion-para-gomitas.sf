/* Script de Verificación de Funcionamiento
Proyecto Final SQL - Kevin Larguía
*/

USE gomitas_sf;

-- 1. VERIFICACIÓN DE VISTAS 

-- Ver rentabilidad y ROI de las campañas de Instagram
SELECT * FROM vw_rentabilidad_campanas;

-- Ver tabla desnormalizada para llevar a Excel/Power BI
SELECT * FROM vw_exportacion_ventas;

-- Ver cuáles son los productos que más salen
SELECT * FROM vw_productos_top;

-- Ver facturación por barrio en Santa Fe
SELECT * FROM vw_ventas_por_zona;

-- Ver carga de trabajo de los empleados
SELECT * FROM vw_gestion_empleados;


-- 2. VERIFICACIÓN DE FUNCIONES (Cálculos y lógica)

-- Probar cálculo de costo para paquete de 500g del insumo ID 1
SELECT NOM_GOM, PRC_KG, fn_calcular_precio_500g(ID_GOM) AS Precio_500g 
FROM GOMITAS WHERE ID_GOM = 1;

-- Probar regla de negocio para stickers según tipo de servicio
SELECT fn_estado_sticker_envio('Candy Bar') AS Prueba_Candy, 
       fn_estado_sticker_envio('Mesa Dulce') AS Prueba_Mesa;


-- 3. VERIFICACIÓN DE STORED PROCEDURES (Procesos masivos)

-- Ver historial financiero del cliente 1
CALL sp_resumen_cliente(1);

-- Aplicar aumento del 10% por inflación a los insumos del Proveedor 1
CALL sp_actualizar_precios_proveedor(1, 10.00);

-- Comprobar que los precios del Proveedor 1 se actualizaron
SELECT * FROM GOMITAS WHERE ID_PROV = 1;


-- 4. VERIFICACIÓN DE TRIGGERS (Automatización y seguridad)

-- Probar Trigger de Auditoría: Modificamos un precio para activar el log
UPDATE GOMITAS SET PRC_KG = 9999.00 WHERE ID_GOM = 2;

-- Ver si el cambio se registró automáticamente en la tabla 30
SELECT * FROM AUDITORIA_PRECIOS;

-- Probar Trigger de Protección: Intentamos insertar un precio negativo
INSERT INTO PRODUCTOS (ID_CAT, NOM_CONT, PRC_FIJO, FLG_TEMP) 
VALUES (1, 'Producto Error', -1500.00, FALSE);

-- Comprobar que el trigger lo corrigió a 0.00 automáticamente
SELECT * FROM PRODUCTOS WHERE NOM_CONT = 'Producto Error';