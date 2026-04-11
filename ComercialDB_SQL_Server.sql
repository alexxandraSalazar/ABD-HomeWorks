USE master;
GO

IF EXISTS (SELECT name FROM sys.databases WHERE name = 'ComercialDB_SQLServer')
BEGIN
    ALTER DATABASE ComercialDB_SQLServer SET SINGLE_USER WITH ROLLBACK IMMEDIATE;
    DROP DATABASE ComercialDB_SQLServer;
END
GO

CREATE DATABASE ComercialDB_SQLServer;
GO

USE ComercialDB_SQLServer;
GO

CREATE TABLE sucursales (
    id_sucursal INT IDENTITY(1,1) PRIMARY KEY,
    nombre_sucursal VARCHAR(100) NOT NULL,
    ciudad VARCHAR(100) NOT NULL
);

CREATE TABLE categorias (
    id_categoria INT IDENTITY(1,1) PRIMARY KEY,
    nombre_categoria VARCHAR(100) NOT NULL UNIQUE
);

CREATE TABLE proveedores (
    id_proveedor INT IDENTITY(1,1) PRIMARY KEY,
    nombre_proveedor VARCHAR(100) NOT NULL,
    pais VARCHAR(100) NOT NULL
);

CREATE TABLE metodos_pago (
    id_metodo_pago INT IDENTITY(1,1) PRIMARY KEY,
    nombre_metodo VARCHAR(50) NOT NULL UNIQUE
);

CREATE TABLE clientes (
    id_cliente INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    correo VARCHAR(150) NOT NULL UNIQUE,
    telefono VARCHAR(30),
    ciudad VARCHAR(100) NOT NULL,
    fecha_registro DATE NOT NULL
);

CREATE TABLE empleados (
    id_empleado INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    cargo VARCHAR(100) NOT NULL,
    salario DECIMAL(10,2) NOT NULL,
    sucursal_id INT NOT NULL,
    CONSTRAINT fk_empleados_sucursal
        FOREIGN KEY (sucursal_id) REFERENCES sucursales(id_sucursal)
        ON UPDATE NO ACTION 
        ON DELETE NO ACTION
);

CREATE TABLE productos (
    id_producto INT IDENTITY(1,1) PRIMARY KEY,
    nombre_producto VARCHAR(150) NOT NULL,
    precio DECIMAL(10,2) NOT NULL,
    stock INT NOT NULL,
    categoria_id INT NOT NULL,
    proveedor_id INT NOT NULL,
    CONSTRAINT fk_productos_categoria
        FOREIGN KEY (categoria_id) REFERENCES categorias(id_categoria)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_productos_proveedor
        FOREIGN KEY (proveedor_id) REFERENCES proveedores(id_proveedor)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE ventas (
    id_venta INT IDENTITY(1,1) PRIMARY KEY,
    cliente_id INT NOT NULL,
    empleado_id INT NOT NULL,
    sucursal_id INT NOT NULL,
    metodo_pago_id INT NOT NULL,
    fecha_venta DATETIME NOT NULL,
    total DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_ventas_cliente
        FOREIGN KEY (cliente_id) REFERENCES clientes(id_cliente)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_ventas_empleado
        FOREIGN KEY (empleado_id) REFERENCES empleados(id_empleado)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_ventas_sucursal
        FOREIGN KEY (sucursal_id) REFERENCES sucursales(id_sucursal)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION,
    CONSTRAINT fk_ventas_metodo_pago
        FOREIGN KEY (metodo_pago_id) REFERENCES metodos_pago(id_metodo_pago)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE detalle_venta (
    id_detalle INT IDENTITY(1,1) PRIMARY KEY,
    venta_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_unitario DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL,
    CONSTRAINT chk_detalle_cantidad CHECK (cantidad > 0),
    CONSTRAINT chk_detalle_subtotal CHECK (subtotal >= 0),
    CONSTRAINT fk_detalle_venta
        FOREIGN KEY (venta_id) REFERENCES ventas(id_venta)
        ON UPDATE NO ACTION
        ON DELETE CASCADE,
    CONSTRAINT fk_detalle_producto
        FOREIGN KEY (producto_id) REFERENCES productos(id_producto)
        ON UPDATE NO ACTION
        ON DELETE NO ACTION
);

CREATE TABLE envios (
    id_envio INT IDENTITY(1,1) PRIMARY KEY,
    venta_id INT NOT NULL UNIQUE,
    direccion VARCHAR(200) NOT NULL,
    ciudad VARCHAR(100) NOT NULL,
    estado_envio VARCHAR(50) NOT NULL,
    fecha_envio DATE,
    fecha_entrega DATE,
    CONSTRAINT fk_envios_venta
        FOREIGN KEY (venta_id) REFERENCES ventas(id_venta)
        ON UPDATE NO ACTION
        ON DELETE CASCADE
);

CREATE INDEX idx_clientes_ciudad ON clientes(ciudad);
CREATE INDEX idx_productos_nombre ON productos(nombre_producto);
CREATE INDEX idx_ventas_fecha ON ventas(fecha_venta);
CREATE INDEX idx_ventas_cliente ON ventas(cliente_id);
CREATE INDEX idx_detalle_venta_venta ON detalle_venta(venta_id);
CREATE INDEX idx_detalle_venta_producto ON detalle_venta(producto_id);

INSERT INTO sucursales (nombre_sucursal, ciudad) VALUES ('Sucursal Central', 'Managua'), ('Sucursal Norte', 'Esteli'), ('Sucursal Occidente', 'Leon');
INSERT INTO categorias (nombre_categoria) VALUES ('Laptops'), ('Monitores'), ('Accesorios'), ('Impresoras'), ('Redes');
INSERT INTO proveedores (nombre_proveedor, pais) VALUES ('TechGlobal', 'Estados Unidos'), ('CompuDistribuciones', 'Mexico'), ('Digital Supplies', 'Costa Rica'), ('Office Solutions', 'Panama'), ('NetPro', 'El Salvador');
INSERT INTO metodos_pago (nombre_metodo) VALUES ('Efectivo'), ('Tarjeta'), ('Transferencia'), ('Pago Movil');

INSERT INTO clientes (nombre, apellido, correo, telefono, ciudad, fecha_registro) VALUES
('Juan', 'Lopez', 'juan.lopez@email.com', '88880001', 'Managua', '2025-01-15'),
('Maria', 'Gomez', 'maria.gomez@email.com', '88880002', 'Leon', '2025-01-20'),
('Carlos', 'Perez', 'carlos.perez@email.com', '88880003', 'Esteli', '2025-02-01'),
('Ana', 'Martinez', 'ana.martinez@email.com', '88880004', 'Managua', '2025-02-03'),
('Luis', 'Hernandez', 'luis.hernandez@email.com', '88880005', 'Masaya', '2025-02-10'),
('Sofia', 'Ruiz', 'sofia.ruiz@email.com', '88880006', 'Granada', '2025-02-12'),
('Miguel', 'Torres', 'miguel.torres@email.com', '88880007', 'Leon', '2025-02-15'),
('Elena', 'Castillo', 'elena.castillo@email.com', '88880008', 'Managua', '2025-02-18'),
('Pedro', 'Ramirez', 'pedro.ramirez@email.com', '88880009', 'Esteli', '2025-02-20'),
('Lucia', 'Vargas', 'lucia.vargas@email.com', '88880010', 'Chinandega', '2025-02-25'),
('Roberto', 'Molina', 'roberto.molina@email.com', '88880011', 'Managua', '2025-03-01'),
('Daniela', 'Navarro', 'daniela.navarro@email.com', '88880012', 'Leon', '2025-03-05');

INSERT INTO empleados (nombre, apellido, cargo, salario, sucursal_id) VALUES
('Andrea', 'Silva', 'Vendedor', 850.00, 1),
('Jose', 'Mendez', 'Vendedor', 820.00, 1),
('Patricia', 'Flores', 'Cajero', 700.00, 1),
('Mario', 'Reyes', 'Vendedor', 780.00, 2),
('Karen', 'Duarte', 'Administrador', 1200.00, 2),
('Oscar', 'Pineda', 'Vendedor', 790.00, 3);

INSERT INTO productos (nombre_producto, precio, stock, categoria_id, proveedor_id) VALUES
('Laptop Dell Inspiron 15', 850.00, 15, 1, 1), ('Laptop HP 14', 780.00, 12, 1, 2), ('Laptop Lenovo ThinkBook', 920.00, 10, 1, 1), ('Monitor Samsung 24', 180.00, 20, 2, 3), ('Monitor LG 27', 240.00, 18, 2, 3), ('Teclado Mecanico Redragon', 45.00, 50, 3, 2), ('Mouse Logitech M185', 18.00, 70, 3, 1), ('Mouse Gamer HP', 25.00, 35, 3, 2), ('Impresora Epson L3250', 210.00, 9, 4, 4), ('Impresora HP LaserJet', 260.00, 7, 4, 4), ('Router TP-Link AX10', 75.00, 25, 5, 5), ('Switch TP-Link 8 Puertos', 40.00, 30, 5, 5), ('Cable HDMI 2m', 8.00, 100, 3, 3), ('Memoria USB 64GB', 12.00, 60, 3, 2), ('Disco SSD Kingston 480GB', 55.00, 40, 3, 1), ('Laptop Asus Vivobook', 870.00, 8, 1, 1), ('Monitor AOC 22', 145.00, 16, 2, 3), ('UPS Forza 1000VA', 95.00, 14, 5, 5), ('Camara Web Logitech C270', 35.00, 22, 3, 1), ('Audifonos Bluetooth JBL', 60.00, 28, 3, 2);

INSERT INTO ventas (cliente_id, empleado_id, sucursal_id, metodo_pago_id, fecha_venta, total) VALUES
(1, 1, 1, 2, '2025-03-01 09:15:00', 913.00), (2, 2, 1, 1, '2025-03-02 10:20:00', 258.00), (3, 4, 2, 3, '2025-03-03 11:05:00', 1073.00), (4, 1, 1, 2, '2025-03-04 14:10:00', 285.00), (5, 4, 2, 4, '2025-03-05 15:30:00', 135.00), (6, 6, 3, 2, '2025-03-06 16:45:00', 300.00), (7, 2, 1, 3, '2025-03-07 12:00:00', 65.00), (8, 1, 1, 2, '2025-03-08 13:25:00', 955.00), (9, 4, 2, 1, '2025-03-09 09:40:00', 228.00), (10, 6, 3, 3, '2025-03-10 17:10:00', 119.00), (11, 2, 1, 2, '2025-03-11 11:55:00', 260.00), (12, 6, 3, 4, '2025-03-12 08:50:00', 908.00), (1, 1, 1, 3, '2025-03-13 10:15:00', 153.00), (3, 4, 2, 2, '2025-03-14 15:00:00', 283.00), (6, 6, 3, 1, '2025-03-15 16:20:00', 95.00);

INSERT INTO detalle_venta (venta_id, producto_id, cantidad, precio_unitario, subtotal) VALUES
(1, 1, 1, 850.00, 850.00), (1, 7, 1, 18.00, 18.00), (1, 13, 1, 8.00, 8.00), (1, 19, 1, 35.00, 35.00), (1, 14, 1, 12.00, 12.00),
(2, 4, 1, 180.00, 180.00), (2, 6, 1, 45.00, 45.00), (2, 19, 1, 35.00, 35.00), (2, 13, 1, 8.00, 8.00),
(3, 3, 1, 920.00, 920.00), (3, 15, 1, 55.00, 55.00), (3, 20, 1, 60.00, 60.00), (3, 14, 1, 12.00, 12.00), (3, 13, 1, 8.00, 8.00), (3, 7, 1, 18.00, 18.00),
(4, 9, 1, 210.00, 210.00), (4, 13, 1, 8.00, 8.00), (4, 14, 1, 12.00, 12.00), (4, 19, 1, 35.00, 35.00), (4, 7, 1, 18.00, 18.00),
(5, 11, 1, 75.00, 75.00), (5, 12, 1, 40.00, 40.00), (5, 13, 1, 8.00, 8.00), (5, 14, 1, 12.00, 12.00),
(6, 5, 1, 240.00, 240.00), (6, 13, 3, 8.00, 24.00), (6, 7, 2, 18.00, 36.00),
(7, 6, 1, 45.00, 45.00), (7, 14, 1, 12.00, 12.00), (7, 13, 1, 8.00, 8.00),
(8, 16, 1, 870.00, 870.00), (8, 7, 1, 18.00, 18.00), (8, 19, 1, 35.00, 35.00), (8, 14, 2, 12.00, 24.00), (8, 13, 1, 8.00, 8.00),
(9, 18, 1, 95.00, 95.00), (9, 11, 1, 75.00, 75.00), (9, 14, 2, 12.00, 24.00), (9, 13, 2, 8.00, 16.00), (9, 7, 1, 18.00, 18.00),
(10, 20, 1, 60.00, 60.00), (10, 14, 2, 12.00, 24.00), (10, 13, 3, 8.00, 24.00), (10, 19, 1, 35.00, 35.00),
(11, 10, 1, 260.00, 260.00),
(12, 2, 1, 780.00, 780.00), (12, 15, 1, 55.00, 55.00), (12, 19, 1, 35.00, 35.00), (12, 14, 1, 12.00, 12.00), (12, 13, 1, 8.00, 8.00), (12, 7, 1, 18.00, 18.00),
(13, 17, 1, 145.00, 145.00), (13, 13, 1, 8.00, 8.00),
(14, 9, 1, 210.00, 210.00), (14, 7, 1, 18.00, 18.00), (14, 13, 1, 8.00, 8.00), (14, 14, 1, 12.00, 12.00), (14, 19, 1, 35.00, 35.00),
(15, 18, 1, 95.00, 95.00);

INSERT INTO envios (venta_id, direccion, ciudad, estado_envio, fecha_envio, fecha_entrega) VALUES
(1, 'Altamira D Este, Casa 12', 'Managua', 'Entregado', '2025-03-02', '2025-03-03'),
(2, 'Reparto Guadalupe, Casa 3', 'Leon', 'Entregado', '2025-03-03', '2025-03-05'),
(3, 'Barrio Omar Torrijos, Casa 5', 'Esteli', 'Entregado', '2025-03-04', '2025-03-06'),
(4, 'Residencial Las Colinas, Casa 20', 'Managua', 'Entregado', '2025-03-05', '2025-03-07'),
(5, 'Masaya Centro, Casa 8', 'Masaya', 'En Camino', '2025-03-06', NULL),
(6, 'Calle La Calzada, Casa 10', 'Granada', 'Entregado', '2025-03-07', '2025-03-08'),
(7, 'Sutiaba, Casa 15', 'Leon', 'Entregado', '2025-03-08', '2025-03-09'),
(8, 'Villa Fontana, Casa 7', 'Managua', 'Procesando', NULL, NULL),
(9, 'Esteli Norte, Casa 2', 'Esteli', 'Entregado', '2025-03-10', '2025-03-11'),
(10, 'Chinandega Centro, Casa 9', 'Chinandega', 'Entregado', '2025-03-11', '2025-03-12'),
(11, 'Carretera Sur, Km 8', 'Managua', 'En Camino', '2025-03-12', NULL),
(12, 'Subtiava, Casa 6', 'Leon', 'Procesando', NULL, NULL),
(13, 'Altamira, Casa 14', 'Managua', 'Entregado', '2025-03-14', '2025-03-15'),
(14, 'Esteli Centro, Casa 11', 'Esteli', 'En Camino', NULL, NULL),
(15, 'Granada Centro, Casa 4', 'Granada', 'Procesando', NULL, NULL);

UPDATE p
SET p.stock = p.stock - t.total_vendido
FROM productos p
JOIN (
    SELECT producto_id, SUM(cantidad) AS total_vendido
    FROM detalle_venta
    GROUP BY producto_id
) t ON p.id_producto = t.producto_id;

SELECT
    v.id_venta,
    v.total AS total_venta,
    SUM(dv.subtotal) AS total_detalle
FROM ventas v
JOIN detalle_venta dv ON v.id_venta = dv.venta_id
GROUP BY v.id_venta, v.total
HAVING v.total <> SUM(dv.subtotal);


-- =========================================================
-- NUEVAS TABLAS: GESTIÓN DE COMPRAS, INVENTARIO Y DEVOLUCIONES
-- =========================================================

CREATE TABLE compra_proveedor (
    id_compra INT IDENTITY(1,1) PRIMARY KEY,
    proveedor_id INT NOT NULL,
    empleado_id INT NOT NULL,
    fecha_compra DATETIME NOT NULL,
    estado VARCHAR(50) NOT NULL,
    observaciones TEXT,
    CONSTRAINT fk_compra_proveedor_proveedor 
        FOREIGN KEY (proveedor_id) REFERENCES proveedores(id_proveedor)
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT fk_compra_proveedor_empleado 
        FOREIGN KEY (empleado_id) REFERENCES empleados(id_empleado)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
GO

CREATE TABLE detalle_compra_proveedor (
    id_detalle INT IDENTITY(1,1) PRIMARY KEY,
    compra_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    precio_compra DECIMAL(12,2) NOT NULL,
    subtotal DECIMAL(12,2) NOT NULL,
    CONSTRAINT fk_detalle_compra_proveedor_compra 
        FOREIGN KEY (compra_id) REFERENCES compra_proveedor(id_compra)
        ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT fk_detalle_compra_proveedor_producto 
        FOREIGN KEY (producto_id) REFERENCES productos(id_producto)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
GO

CREATE TABLE tipos_movimientos (
    id_tipo INT IDENTITY(1,1) PRIMARY KEY,
    nombre VARCHAR(100) NOT NULL UNIQUE
);
GO

CREATE TABLE movimientos_inventario (
    id_movimiento INT IDENTITY(1,1) PRIMARY KEY,
    producto_id INT NOT NULL,
    empleado_id INT NOT NULL,
    cantidad INT NOT NULL,
    fecha DATETIME NOT NULL,
    tipo_movimiento_id INT NOT NULL,
    CONSTRAINT fk_movimiento_inventario_producto 
        FOREIGN KEY (producto_id) REFERENCES productos(id_producto)
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT fk_movimiento_inventario_empleado 
        FOREIGN KEY (empleado_id) REFERENCES empleados(id_empleado)
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT fk_movimiento_inventario_tipo_movimiento 
        FOREIGN KEY (tipo_movimiento_id) REFERENCES tipos_movimientos(id_tipo)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
GO

CREATE TABLE devolucion_venta (
    id_devolucion INT IDENTITY(1,1) PRIMARY KEY,
    venta_id INT NOT NULL,
    empleado_id INT NOT NULL,
    fecha_devolucion DATETIME NOT NULL,
    motivo TEXT,
    CONSTRAINT fk_devolucion_venta_venta 
        FOREIGN KEY (venta_id) REFERENCES ventas(id_venta)
        ON UPDATE NO ACTION ON DELETE NO ACTION,
    CONSTRAINT fk_devolucion_venta_empleado 
        FOREIGN KEY (empleado_id) REFERENCES empleados(id_empleado)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
GO

CREATE TABLE detalle_devolucion (
    id_detalle INT IDENTITY(1,1) PRIMARY KEY,
    devolucion_id INT NOT NULL,
    producto_id INT NOT NULL,
    cantidad INT NOT NULL,
    CONSTRAINT fk_detalle_devolucion_devolucion 
        FOREIGN KEY (devolucion_id) REFERENCES devolucion_venta(id_devolucion)
        ON UPDATE NO ACTION ON DELETE CASCADE,
    CONSTRAINT fk_detalle_devolucion_producto 
        FOREIGN KEY (producto_id) REFERENCES productos(id_producto)
        ON UPDATE NO ACTION ON DELETE NO ACTION
);
GO

-- =========================================================
-- INSERTAR DATOS DE PRUEBA
-- =========================================================

-- Tipos de Movimientos
INSERT INTO tipos_movimientos (nombre) VALUES 
('Entrada por Compra'), ('Salida por Venta'), ('Entrada por Devolución'), 
('Salida por Ajuste (Dañado)'), ('Entrada por Ajuste (Conteo)');

-- Compras a Proveedores
INSERT INTO compra_proveedor (proveedor_id, empleado_id, fecha_compra, estado, observaciones) VALUES 
(1, 5, '2025-03-20 10:00:00', 'Completado', 'Reposición de inventario de Laptops Dell'),
(3, 1, '2025-03-22 14:30:00', 'Completado', 'Pedido urgente de monitores y cables HDMI'),
(4, 6, '2025-03-25 09:00:00', 'Pendiente', 'Pendiente de recibir factura física');

-- Detalles de Compra
INSERT INTO detalle_compra_proveedor (compra_id, producto_id, cantidad, precio_compra, subtotal) VALUES 
(1, 1, 5, 800.00, 4000.00), (1, 3, 3, 850.00, 2550.00),
(2, 4, 10, 160.00, 1600.00), (2, 13, 20, 5.00, 100.00),
(3, 9, 2, 190.00, 380.00);

-- Movimientos de Inventario
INSERT INTO movimientos_inventario (producto_id, empleado_id, cantidad, fecha, tipo_movimiento_id) VALUES 
(1, 5, 5, '2025-03-20 11:00:00', 1),
(4, 1, 10, '2025-03-22 15:00:00', 1),
(15, 2, -1, '2025-03-24 16:00:00', 4),
(7, 3, 2, '2025-03-26 10:00:00', 5);

-- Devoluciones de Venta
INSERT INTO devolucion_venta (venta_id, empleado_id, fecha_devolucion, motivo) VALUES 
(1, 1, '2025-03-05 10:00:00', 'Cámara Web con defecto de fábrica'),
(4, 4, '2025-03-10 11:30:00', 'Cliente se arrepintió de la compra de cables');

-- Detalle de Devoluciones
INSERT INTO detalle_devolucion (devolucion_id, producto_id, cantidad) VALUES 
(1, 19, 1), (2, 13, 1);
GO