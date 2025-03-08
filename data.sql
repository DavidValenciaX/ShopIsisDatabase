-- Insertar datos iniciales en status_categories
INSERT INTO status_categories (name, description) VALUES
('payment', 'Estados de pago'),
('supplier', 'Estados de proveedores'),
('order', 'Estados de órdenes'),
('purchase_order', 'Estados de órdenes de compra'),
('purchase_item', 'Estados de ítems de compra'),
('return', 'Estados de devoluciones');

-- Insertar datos iniciales en status_types
INSERT INTO status_types (name, category_id, description) VALUES
-- Payment statuses
('pending', (SELECT id FROM status_categories WHERE name = 'payment'), 'Pago pendiente'),
('partial', (SELECT id FROM status_categories WHERE name = 'payment'), 'Pago parcial'),
('paid', (SELECT id FROM status_categories WHERE name = 'payment'), 'Pago completado'),
('refunded', (SELECT id FROM status_categories WHERE name = 'payment'), 'Pago reembolsado'),

-- Supplier statuses
('active', (SELECT id FROM status_categories WHERE name = 'supplier'), 'Proveedor activo'),
('inactive', (SELECT id FROM status_categories WHERE name = 'supplier'), 'Proveedor inactivo'),
('suspended', (SELECT id FROM status_categories WHERE name = 'supplier'), 'Proveedor suspendido'),

-- order status
('pending', (SELECT id FROM status_categories WHERE name = 'order'), 'Orden recibida'),
('processing', (SELECT id FROM status_categories WHERE name = 'order'), 'En preparación'),
('shipped', (SELECT id FROM status_categories WHERE name = 'order'), 'Enviado'),
('delivered', (SELECT id FROM status_categories WHERE name = 'order'), 'Entregado'),
('cancelled', (SELECT id FROM status_categories WHERE name = 'order'), 'Cancelado');

-- Purchase order statuses
('draft', (SELECT id FROM status_categories WHERE name = 'purchase_order'), 'Orden en borrador'),
('ordered', (SELECT id FROM status_categories WHERE name = 'purchase_order'), 'Orden realizada'),
('partial', (SELECT id FROM status_categories WHERE name = 'purchase_order'), 'Orden parcialmente entregada'),
('delivered', (SELECT id FROM status_categories WHERE name = 'purchase_order'), 'Orden entregada'),
('cancelled', (SELECT id FROM status_categories WHERE name = 'purchase_order'), 'Orden cancelada'),

-- Purchase order item statuses
('pending', (SELECT id FROM status_categories WHERE name = 'purchase_item'), 'Ítem pendiente'),
('partial', (SELECT id FROM status_categories WHERE name = 'purchase_item'), 'Ítem parcialmente recibido'),
('complete', (SELECT id FROM status_categories WHERE name = 'purchase_item'), 'Ítem completado'),
('rejected', (SELECT id FROM status_categories WHERE name = 'purchase_item'), 'Ítem rechazado'),

-- Return statuses
('pending', (SELECT id FROM status_categories WHERE name = 'return'), 'Devolución pendiente'),
('approved', (SELECT id FROM status_categories WHERE name = 'return'), 'Devolución aprobada'),
('rejected', (SELECT id FROM status_categories WHERE name = 'return'), 'Devolución rechazada'),
('completed', (SELECT id FROM status_categories WHERE name = 'return'), 'Devolución completada'),
('sent', (SELECT id FROM status_categories WHERE name = 'return'), 'Devolución enviada');

-- Insertar datos iniciales en shipping_methods
INSERT INTO shipping_methods (name, description, price, estimated_days) VALUES
('Standard Shipping', 'Regular delivery service (3-5 business days)', 5.99, 5),
('Express Shipping', 'Fast delivery service (1-2 business days)', 12.99, 2),
('Next Day Delivery', 'Guaranteed next business day delivery', 19.99, 1),
('Free Shipping', 'Free standard shipping on qualifying orders', 0.00, 7),
('In-Store Pickup', 'Pick up your order at the store', 0.00, 0),
('Curbside Pickup', 'Pick up your order at the store curb', 0.00, 0),
('Local Delivery', 'Local delivery service (same day)', 4.99, 1),
('International Shipping', 'International delivery service (7-14 days)', 19.99, 14),
('Custom Shipping', 'Custom delivery service', 0.00, 0),
('Cash on Delivery', 'Pay when you receive your order', 0.00, 0);

-- Insertar los tipos de transacciones predefinidos
INSERT INTO transaction_types (name, description) VALUES
('purchase', 'Ingreso de inventario por compra a proveedores'),
('sale', 'Salida de inventario por venta a clientes'),
('adjustment', 'Ajuste manual de inventario'),
('return', 'Devolución de productos'),
('transfer', 'Transferencia entre ubicaciones'),
('Return Received', 'Productos devueltos recibidos en cuarentena'),
('Return Restocked', 'Productos aprobados y reintegrados al inventario'),
('Return Discarded', 'Productos descartados definitivamente');

-- Insertar valores iniciales para las condiciones de devolución
INSERT INTO return_conditions (name) VALUES
('new'),
('damaged'),
('defective'),
('other');

-- Insertar monedas comunes
INSERT INTO currencies (code, name, symbol) VALUES
('USD', 'US Dollar', '$'),
('EUR', 'Euro', '€'),
('GBP', 'British Pound', '£'),
('JPY', 'Japanese Yen', '¥'),
('CAD', 'Canadian Dollar', 'C$'),
('AUD', 'Australian Dollar', 'A$'),
('COP', 'Colombian Peso', '$');

-- Insertar los tipos de descuento iniciales
INSERT INTO discount_types (name, description) VALUES 
('percentage', 'Discount as a percentage of the total amount'),
('fixed_amount', 'Discount as a fixed monetary amount');