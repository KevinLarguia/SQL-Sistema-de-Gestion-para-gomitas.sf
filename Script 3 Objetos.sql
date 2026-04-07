/* Script de Objetos de Base de Datos
Proyecto Final SQL - Kevin Larguía
*/

/* Script de Vistas Optimizado
Proyecto Final SQL - Kevin Larguía
*/

USE gomitas_sf;

-- 1. Rentabilidad de campañas 
CREATE OR REPLACE VIEW vw_rentabilidad_campanas AS
SELECT 
    c.NOM_ADS AS Campana,
    SUM(c.COST_ADS) AS Inversion_Total, -- Sumamos inversión si el nombre se repite
    IFNULL(SUM(p.TOT_PED), 0) AS Ingresos_Generados,
    (IFNULL(SUM(p.TOT_PED), 0) - SUM(c.COST_ADS)) AS ROI
FROM CAMPANAS_ADS c
LEFT JOIN PEDIDOS p ON c.ID_ADS = p.ID_ADS
GROUP BY c.NOM_ADS -- Corregido: agrupa por nombre
ORDER BY ROI DESC;

-- Vista 2: Reporte para Power BI 
CREATE OR REPLACE VIEW vw_exportacion_ventas AS
SELECT 
    p.ID_PED AS Nro_Pedido,
    DATE_FORMAT(p.FCH_PED, '%Y-%m-%d') AS Fecha,
    c.NOM_CLI AS Cliente,
    c.ORIG_CLI AS Canal_Captacion,
    prod.NOM_CONT AS Producto,
    dp.CANT AS Cantidad,
    (prod.PRC_FIJO * dp.CANT) AS Subtotal_Venta,
    z.NOM_ZONA AS Barrio_Santa_Fe,
    mp.NOM_PAGO AS Metodo_Pago,
    e.NOM_EMP AS Atendido_Por,
    IFNULL(ads.NOM_ADS, 'Venta Organica') AS Campana_Ads,
    IFNULL(ads.COST_ADS, 0) AS Inversion_Campana,
    -- Aquí llamamos a la nueva función
    IFNULL(fn_calcular_roi_campana(p.ID_ADS), 0) AS ROI_Campana_Total
FROM PEDIDOS p
INNER JOIN CLIENTES c ON p.ID_CLI = c.ID_CLI
INNER JOIN DETALLE_PEDIDO dp ON p.ID_PED = dp.ID_PED
INNER JOIN PRODUCTOS prod ON dp.ID_PROD = prod.ID_PROD
INNER JOIN ZONAS_ENVIO z ON p.ID_ZONA = z.ID_ZONA
INNER JOIN METODOS_PAGO mp ON p.ID_PAGO = mp.ID_PAGO
INNER JOIN EMPLEADOS e ON p.ID_EMP = e.ID_EMP
LEFT JOIN CAMPANAS_ADS ads ON p.ID_ADS = ads.ID_ADS;

-- 3. Ranking de productos 
CREATE OR REPLACE VIEW vw_productos_top AS
SELECT 
    p.NOM_CONT AS Producto,
    SUM(dp.CANT) AS Unidades_Vendidas
FROM PRODUCTOS p
JOIN DETALLE_PEDIDO dp ON p.ID_PROD = dp.ID_PROD
GROUP BY p.NOM_CONT -- Corregido: agrupa por nombre
ORDER BY Unidades_Vendidas DESC;

-- 4. Ventas por zona 
CREATE OR REPLACE VIEW vw_ventas_por_zona AS
SELECT 
    z.NOM_ZONA AS Zona,
    COUNT(p.ID_PED) AS Total_Pedidos,
    SUM(p.TOT_PED) AS Facturacion_Zona
FROM ZONAS_ENVIO z
LEFT JOIN PEDIDOS p ON z.ID_ZONA = p.ID_ZONA
GROUP BY z.NOM_ZONA -- Corregido: agrupa por nombre
ORDER BY Facturacion_Zona DESC;

-- 5. Gestión de empleados 
CREATE OR REPLACE VIEW vw_gestion_empleados AS
SELECT 
    e.NOM_EMP AS Empleado,
    e.PUESTO AS Cargo,
    COUNT(p.ID_PED) AS Pedidos_Gestionados
FROM EMPLEADOS e
LEFT JOIN PEDIDOS p ON e.ID_EMP = p.ID_EMP
GROUP BY e.NOM_EMP, e.PUESTO -- Corregido: agrupa por nombre y cargo
ORDER BY Pedidos_Gestionados DESC;

-- 2. FUNCIONES

DELIMITER //

-- Función 1: Cálculo de costo para fraccionado de 500g
CREATE FUNCTION fn_calcular_precio_500g(p_id_gomita INT) 
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_precio_kg DECIMAL(10,2);
    SELECT PRC_KG INTO v_precio_kg FROM GOMITAS WHERE ID_GOM = p_id_gomita;
    RETURN v_precio_kg / 2;
END //

-- Función 2: Lógica de negocio para stickers y envíos
CREATE FUNCTION fn_estado_sticker_envio(p_tipo_servicio VARCHAR(50)) 
RETURNS VARCHAR(100)
DETERMINISTIC
BEGIN
    IF p_tipo_servicio = 'Mesa Dulce' THEN
        RETURN 'Envio incluido - SIN sticker personalizado';
    ELSE
        RETURN 'Envio incluido - CON sticker personalizado';
    END IF;
END //

DELIMITER ;

DELIMITER //

-- Función 3: Cálculo dinámico de ROI por campaña
CREATE FUNCTION fn_calcular_roi_campana(p_id_ads INT) 
RETURNS DECIMAL(10,2)
READS SQL DATA
BEGIN
    DECLARE v_inversion DECIMAL(10,2);
    DECLARE v_ingresos DECIMAL(10,2);
    
    -- Obtenemos el costo de la pauta
    SELECT COST_ADS INTO v_inversion FROM CAMPANAS_ADS WHERE ID_ADS = p_id_ads;
    
    -- Sumamos todos los pedidos asociados a esa pauta
    SELECT IFNULL(SUM(TOT_PED), 0) INTO v_ingresos FROM PEDIDOS WHERE ID_ADS = p_id_ads;
    
    -- Retornamos la diferencia (Ingresos - Inversión)
    RETURN v_ingresos - v_inversion;
END //

DELIMITER ;


-- 3. STORED PROCEDURES

DELIMITER //

-- Procedimiento 1: Actualización masiva de precios por inflación
CREATE PROCEDURE sp_actualizar_precios_proveedor(IN p_id_prov INT, IN p_porcentaje DECIMAL(5,2))
BEGIN
    UPDATE GOMITAS 
    SET PRC_KG = PRC_KG * (1 + (p_porcentaje / 100))
    WHERE ID_PROV = p_id_prov;
END //

-- Procedimiento 2: Informe histórico de un cliente específico
CREATE PROCEDURE sp_resumen_cliente(IN p_id_cliente INT)
BEGIN
    SELECT 
        c.NOM_CLI AS Cliente,
        COUNT(p.ID_PED) AS Total_Pedidos,
        IFNULL(SUM(p.TOT_PED), 0) AS Monto_Total_Comprado
    FROM CLIENTES c
    LEFT JOIN PEDIDOS p ON c.ID_CLI = p.ID_CLI
    WHERE c.ID_CLI = p_id_cliente
    GROUP BY c.ID_CLI, c.NOM_CLI;
END //

DELIMITER ;


-- 4. TRIGGERS

DELIMITER //

-- Trigger 1: Auditoría de fluctuación de precios en insumos
CREATE TRIGGER tr_auditoria_precio_gomitas
BEFORE UPDATE ON GOMITAS
FOR EACH ROW
BEGIN
    IF OLD.PRC_KG <> NEW.PRC_KG THEN
        INSERT INTO AUDITORIA_PRECIOS (ID_GOM, PRECIO_ANTERIOR, PRECIO_NUEVO, USUARIO)
        VALUES (OLD.ID_GOM, OLD.PRC_KG, NEW.PRC_KG, CURRENT_USER());
    END IF;
END //

-- Trigger 2: Validación para evitar precios negativos en catálogo
CREATE TRIGGER tr_verificar_precio_positivo
BEFORE INSERT ON PRODUCTOS
FOR EACH ROW
BEGIN
    IF NEW.PRC_FIJO < 0 THEN
        SET NEW.PRC_FIJO = 0;
    END IF;
END //

DELIMITER ;