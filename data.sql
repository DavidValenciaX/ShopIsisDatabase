-- Insertar datos iniciales en status_categories
INSERT INTO status_categories (name, description) VALUES
('payment', 'Estados de pago'),
('supplier', 'Estados de proveedores'),
('order', 'Estados de órdenes'),
('purchase_order', 'Estados de órdenes de compra'),
('purchase_item', 'Estados de ítems de compra'),
('return', 'Estados de devoluciones'),
('payment_transaction', 'Estados de transacciones de pago');

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
('cancelled', (SELECT id FROM status_categories WHERE name = 'order'), 'Cancelado'),

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
('sent', (SELECT id FROM status_categories WHERE name = 'return'), 'Devolución enviada'),
('discarded', (SELECT id FROM status_categories WHERE name = 'return'), 'Producto descartado por problemas de calidad'),

-- Payment transaction statuses
('initiated', (SELECT id FROM status_categories WHERE name = 'payment_transaction'), 'Transacción iniciada'),
('processing', (SELECT id FROM status_categories WHERE name = 'payment_transaction'), 'Transacción en proceso'),
('succeeded', (SELECT id FROM status_categories WHERE name = 'payment_transaction'), 'Transacción exitosa'),
('failed', (SELECT id FROM status_categories WHERE name = 'payment_transaction'), 'Transacción fallida'),
('cancelled', (SELECT id FROM status_categories WHERE name = 'payment_transaction'), 'Transacción cancelada'),
('refunded', (SELECT id FROM status_categories WHERE name = 'payment_transaction'), 'Transacción reembolsada');

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

-- Inicializar los tipos de medidas
INSERT INTO measurement_types (name, description) VALUES
('Length', 'Units for measuring distances and dimensions'),
('Weight', 'Units for measuring mass'),
('Volume', 'Units for measuring volume of liquids or solids'),
('Area', 'Units for measuring surface area'),
('Temperature', 'Units for measuring temperature');

-- Inicializar unidades de medida comunes
-- Length units
INSERT INTO units_of_measure (name, symbol, measurement_type_id, base_unit, conversion_factor, description) VALUES
('Meter', 'm', 1, TRUE, 1.0, 'Base unit for length'),
('Centimeter', 'cm', 1, FALSE, 0.01, '1/100 of a meter'),
('Millimeter', 'mm', 1, FALSE, 0.001, '1/1000 of a meter'),
('Inch', 'in', 1, FALSE, 0.0254, 'Imperial unit for length'),
('Foot', 'ft', 1, FALSE, 0.3048, 'Imperial unit for length');

-- Weight units
INSERT INTO units_of_measure (name, symbol, measurement_type_id, base_unit, conversion_factor, description) VALUES
('Kilogram', 'kg', 2, TRUE, 1.0, 'Base unit for weight'),
('Gram', 'g', 2, FALSE, 0.001, '1/1000 of a kilogram'),
('Pound', 'lb', 2, FALSE, 0.45359237, 'Imperial unit for weight'),
('Ounce', 'oz', 2, FALSE, 0.028349523125, 'Imperial unit for weight');

-- Volume units
INSERT INTO units_of_measure (name, symbol, measurement_type_id, base_unit, conversion_factor, description) VALUES
('Liter', 'L', 3, TRUE, 1.0, 'Base unit for volume'),
('Milliliter', 'mL', 3, FALSE, 0.001, '1/1000 of a liter'),
('Gallon (US)', 'gal', 3, FALSE, 3.78541, 'US unit for volume'),
('Fluid Ounce (US)', 'fl oz', 3, FALSE, 0.0295735, 'US unit for volume');

-- Insertar tipos de interacciones de usuario con productos
INSERT INTO interaction_types (name, description) VALUES
('view', 'Usuario vio la página del producto'),
('search', 'Usuario encontró el producto a través de búsqueda'),
('add_to_cart', 'Usuario añadió el producto al carrito'),
('add_to_wishlist', 'Usuario añadió el producto a su lista de deseos'),
('purchase', 'Usuario compró el producto'),
('review', 'Usuario dejó una reseña del producto'),
('share', 'Usuario compartió el producto en redes sociales'),
('compare', 'Usuario añadió el producto a comparación'),
('question', 'Usuario hizo una pregunta sobre el producto'),
('return', 'Usuario devolvió el producto');