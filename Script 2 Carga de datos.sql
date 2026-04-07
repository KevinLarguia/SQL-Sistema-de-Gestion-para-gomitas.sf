/* Script de Carga de Datos - Versión Final
Proyecto Final SQL - Kevin Larguía
*/

USE gomitas_sf;

-- 0. Limpieza de tablas para evitar duplicados
SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE SELECCION_GOMITAS;
TRUNCATE TABLE DETALLE_PEDIDO;
TRUNCATE TABLE SERVICIOS_EVENTOS;
TRUNCATE TABLE PEDIDOS;
TRUNCATE TABLE GOMITAS;
TRUNCATE TABLE PRODUCTOS;
TRUNCATE TABLE CLIENTES;
TRUNCATE TABLE CAMPANAS_ADS;
TRUNCATE TABLE PROVEEDORES;
TRUNCATE TABLE EMPLEADOS;
TRUNCATE TABLE ZONAS_ENVIO;
TRUNCATE TABLE ESTADOS_PEDIDO;
TRUNCATE TABLE METODOS_PAGO;
TRUNCATE TABLE CATEGORIAS_PRODUCTOS;
SET FOREIGN_KEY_CHECKS = 1;

-- 1. Categorías
INSERT INTO CATEGORIAS_PRODUCTOS (NOM_CAT) VALUES 
('Box'), ('Bandeja'), ('Vaso'), ('Bolsita'), ('Candy Bar'), ('Packs Regalo'), ('Temporada');

-- 2. Métodos de Pago
INSERT INTO METODOS_PAGO (NOM_PAGO) VALUES 
('Efectivo'), ('Transferencia'), ('Mercado Pago'), ('Tarjeta de Débito');

-- 3. Estados de Pedido
INSERT INTO ESTADOS_PEDIDO (DESC_ESTADO) VALUES 
('Pendiente'), ('En preparación'), ('Enviado'), ('Entregado'), ('Cancelado');

-- 4. Zonas de Envío con costos diferenciados (Santa Fe)
INSERT INTO ZONAS_ENVIO (NOM_ZONA, COSTO_ENVIO) VALUES 
('Centro', 400.00), 
('Candioti Norte/Sur', 450.00), 
('El Pozo', 900.00), 
('Barrio Roma', 600.00), 
('Constituyentes', 500.00),
('Guadalupe', 750.00),
('Santo Tomé', 1300.00),
('Colastiné', 1600.00),
('Barrio Sur', 450.00);

-- 5. Empleados del negocio
INSERT INTO EMPLEADOS (NOM_EMP, PUESTO) VALUES 
('Kevin Larguía', 'Administración/Ventas'), 
('Victoria Radolovic', 'Producción'),
('Federico Del Carlo', 'Envíos');

-- 6. Proveedores de insumos
INSERT INTO PROVEEDORES (NOM_DIST, TEL_PROV) VALUES
('Distribuidora Mayorista Santa Fe', '3424112233'),
('Dulces del Litoral', '3425445566'),
('Distribuidora La Costa', '3420001111'),
('Golosinas Santa Fe', '3429998877'),
('Azucre Distribuciones', '3426665544');

-- 7. Campañas de Marketing Ads
INSERT INTO CAMPANAS_ADS (NOM_ADS, PLAT_ADS, COST_ADS) VALUES
('Promo Otoño', 'Instagram', 5000.00),
('Sorteo Mes del Amigo', 'Instagram', 3500.00),
('Promo Vuelta al Cole', 'Facebook', 4000.00),
('Descuento Fin de Semana', 'Instagram', 2500.00),
('Especial Día del Niño', 'Instagram', 8000.00),
('Hot Sale Gomitas', 'Instagram', 12000.00);

-- 8. Catálogo de Productos
INSERT INTO PRODUCTOS (ID_CAT, NOM_CONT, PRC_FIJO, FLG_TEMP) VALUES
(1, 'Barquitos', 14000.00, FALSE),
(2, 'Bandejas redondas', 12000.00, FALSE),
(3, 'Vaso 500cc', 6000.00, FALSE),
(3, 'Vaso 250cc', 4000.00, FALSE),
(4, 'Bolsitas', 2500.00, FALSE),
(4, 'Pinchos', 1800.00, FALSE),
(6, 'Box Premium XL', 25000.00, FALSE),
(7, 'Huevo de Pascua Gomita', 9000.00, TRUE);

-- 9. Base de Clientes
INSERT INTO CLIENTES (NOM_CLI, WA_CLI, ORIG_CLI) VALUES
('Matias Rossi', '3421112222', 'Instagram'),
('Luciana Gomez', '3423334444', 'WhatsApp'),
('Carlos Perez', '3425556666', 'Marketplace'),
('Agustin Ferrero', '3421110000', 'Instagram'),
('Tomas Gonzalez', '3425557777', 'Instagram'),
('Valentina Silva', '3428882222', 'WhatsApp'),
('Nicolas Mendoza', '3429993333', 'Marketplace'),
('Sofia Benitez', '3424441111', 'Instagram'),
('Juan Lopez', '3427778888', 'Instagram'),
('Elena Garcia', '3426662222', 'WhatsApp'),
('Pedro Sanchez', '3421115555', 'Marketplace'),
('Laura Martinez', '3423339999', 'Instagram');

-- 10. Variedades de Gomitas (Insumos)
INSERT INTO GOMITAS (ID_PROV, NOM_GOM, MAR_GOM, TIP_SAB, PRC_KG) VALUES
(1, 'Moras', 'Arcor', 'Dulce', 8500.00),
(1, 'Gusanitos', 'Fini', 'Ácida', 9200.00),
(1, 'Dientes', 'Fini', 'Dulce', 8800.00),
(1, 'Besos', 'Fini', 'Dulce', 8900.00),
(2, 'Ositos', 'Mogul', 'Dulce', 8000.00),
(2, 'Huevos Fritos', 'Arcor', 'Dulce', 8200.00),
(3, 'Tiburones', 'Fini', 'Dulce', 9400.00),
(3, 'Ladrillos', 'Fini', 'Ácida', 9800.00),
(4, 'Anillos', 'Mogul', 'Dulce', 9100.00),
(5, 'Cintas Ácidas', 'Yummy', 'Ácida', 9500.00);

-- 11. Carga Masiva de Pedidos (20 órdenes)
INSERT INTO PEDIDOS (ID_CLI, ID_ADS, ID_PAGO, ID_ESTADO, ID_ZONA, ID_EMP, FCH_PED, NOT_PED, TOT_PED) VALUES
(1, 1, 3, 4, 2, 1, '2024-03-01 10:00:00', 'Sticker personalizado.', 20000.00),
(2, 2, 2, 4, 6, 2, '2024-03-02 11:30:00', 'Sticker personalizado.', 6000.00),
(3, NULL, 1, 4, 3, 3, '2024-03-05 18:00:00', 'Mesa dulce corporativa sin sticker.', 85000.00),
(4, 1, 2, 4, 1, 1, '2024-03-08 09:15:00', 'Sticker personalizado.', 38000.00),
(5, 5, 3, 4, 7, 3, '2024-03-10 20:00:00', 'Regalo sorpresa.', 25000.00),
(8, 6, 4, 4, 8, 3, '2024-03-12 15:45:00', 'Envio a Colastiné.', 18000.00),
(9, NULL, 1, 4, 9, 2, '2024-03-15 12:00:00', 'Sticker personalizado.', 12000.00),
(10, 5, 2, 3, 2, 1, '2024-03-18 10:30:00', 'En preparacion.', 30000.00),
(11, 4, 3, 4, 4, 3, '2024-03-20 17:20:00', 'Sticker personalizado.', 4000.00),
(12, 6, 2, 4, 5, 1, '2024-03-22 11:00:00', 'Sticker personalizado.', 14000.00),
(1, NULL, 1, 4, 1, 2, '2024-03-25 19:00:00', 'Compra recurrente.', 6000.00),
(2, 5, 3, 4, 6, 1, '2024-03-26 14:00:00', 'Sticker personalizado.', 25000.00),
(3, 6, 2, 2, 3, 2, '2024-03-28 10:00:00', 'Evento infantil.', 95000.00),
(4, NULL, 1, 4, 7, 3, '2024-03-30 13:00:00', 'Sticker personalizado.', 18000.00),
(5, 1, 3, 1, 2, 1, '2024-04-01 09:00:00', 'Pendiente de pago.', 14000.00),
(6, 2, 2, 4, 8, 3, '2024-04-02 16:30:00', 'Entregado en zona costa.', 12000.00),
(7, 5, 3, 4, 1, 1, '2024-04-03 11:15:00', 'Sticker personalizado.', 40000.00),
(8, NULL, 4, 4, 4, 3, '2024-04-04 15:00:00', 'Pago debito.', 8000.00),
(9, 6, 2, 4, 5, 2, '2024-04-05 10:00:00', 'Sticker personalizado.', 2500.00),
(10, 4, 1, 3, 9, 3, '2024-04-06 18:45:00', 'Cerca de casa de gobierno.', 14000.00);

-- 12. Servicios para Eventos
INSERT INTO SERVICIOS_EVENTOS (ID_PED, TIP_SERV, PAQ_500, PERS_EVT, TEMA_EVT) VALUES
(3, 'Mesa Dulce', 20, 60, 'Corporativo Tech'),
(13, 'Candy Bar', 25, 80, 'Cumple Disney');

-- 13. Detalles de Pedido (Vinculación de productos)
INSERT INTO DETALLE_PEDIDO (ID_PED, ID_PROD, CANT) VALUES
(1, 1, 1), (1, 3, 1), (2, 3, 1), (3, 7, 3), (3, 2, 1), (4, 2, 2), (4, 1, 1),
(5, 7, 1), (6, 1, 1), (6, 4, 1), (7, 2, 1), (8, 7, 1), (8, 3, 1), (9, 4, 1),
(10, 2, 2), (10, 1, 1), (11, 4, 1), (12, 1, 1), (13, 3, 1), (14, 7, 4),
(15, 2, 1), (16, 1, 1), (17, 7, 1), (18, 7, 2), (19, 3, 1), (20, 5, 1), (20, 3, 2);

-- 14. Selección de Variedades de Gomitas
INSERT INTO SELECCION_GOMITAS (ID_DET, ID_GOM) VALUES
(1, 1), (1, 5), (2, 2), (3, 7), (3, 8), (4, 3), (4, 6), (5, 1), (6, 4), (7, 2), 
(8, 5), (9, 3), (10, 1), (11, 8), (12, 9), (13, 10), (14, 1), (15, 2);