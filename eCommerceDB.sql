-- Tabla de Roles
CREATE TABLE roles (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Permisos
CREATE TABLE permissions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de relación entre roles y permisos (muchos a muchos)
CREATE TABLE role_permissions (
    role_id INTEGER REFERENCES roles(id) ON DELETE CASCADE,
    permission_id INTEGER REFERENCES permissions(id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id)
);

-- Tabla de Usuarios
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    address VARCHAR(255),
    postal_code VARCHAR(50),
    phone VARCHAR(50),
    token VARCHAR(255),
    confirmed BOOLEAN DEFAULT FALSE,
    role_id INTEGER REFERENCES roles(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Categorías
CREATE TABLE categories (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    picture VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Productos
CREATE TABLE products (
    id VARCHAR(255) PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    thumbnail VARCHAR(255) NOT NULL,
    brand VARCHAR(255) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de relación entre productos y categorías (muchos a muchos)
CREATE TABLE product_categories (
    product_id VARCHAR(255) REFERENCES products(id) ON DELETE CASCADE,
    category_id VARCHAR(255) REFERENCES categories(id) ON DELETE CASCADE,
    PRIMARY KEY (product_id, category_id)
);

-- Tabla de Carritos
CREATE TABLE carts (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Elementos del Carrito
CREATE TABLE cart_items (
    id SERIAL PRIMARY KEY,
    cart_id INTEGER NOT NULL REFERENCES carts(id) ON DELETE CASCADE,
    product_id VARCHAR(255) NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL CHECK (quantity > 0)
);

-- Tabla de Órdenes/Pedidos
CREATE TABLE orders (
    id SERIAL PRIMARY KEY,
    user_id INTEGER REFERENCES users(id) ON DELETE SET NULL,
    total_amount DECIMAL(10, 2) NOT NULL,
    shipping_address VARCHAR(255) NOT NULL,
    shipping_postal_code VARCHAR(50) NOT NULL,
    contact_phone VARCHAR(50) NOT NULL,
    billing_email VARCHAR(255) NOT NULL,
    invoice_number VARCHAR(100),
    shipping_cost DECIMAL(10, 2) DEFAULT 0,
    tax_amount DECIMAL(10, 2) DEFAULT 0,
    discount_amount DECIMAL(10, 2) DEFAULT 0,
    notes TEXT,
    user_payment_method_id INTEGER REFERENCES user_payment_methods(id),
    shipping_method_id INTEGER REFERENCES shipping_methods(id) ON DELETE RESTRICT,
    status_id INTEGER REFERENCES status_types(id) ON DELETE RESTRICT,
    payment_status_id INTEGER REFERENCES status_types(id) ON DELETE RESTRICT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Productos en una Orden
CREATE TABLE product_orders (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id VARCHAR(255) NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL CHECK (quantity > 0)
);

-- Tabla de Proveedores
CREATE TABLE suppliers (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    contact_person VARCHAR(255),
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    tax_id VARCHAR(100),
    notes TEXT,
    status_id INTEGER REFERENCES status_types(id) ON DELETE RESTRICT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Inventario
CREATE TABLE inventory (
    id SERIAL PRIMARY KEY,
    product_id VARCHAR(255) NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    min_stock_level INTEGER NOT NULL DEFAULT 10,
    max_stock_level INTEGER,
    location VARCHAR(100),
    last_restock_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(product_id)
);

-- Tabla de Compras a Proveedores
CREATE TABLE purchase_orders (
    id SERIAL PRIMARY KEY,
    supplier_id INTEGER NOT NULL REFERENCES suppliers(id) ON DELETE RESTRICT,
    order_number VARCHAR(100) NOT NULL UNIQUE,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expected_delivery_date TIMESTAMP,
    actual_delivery_date TIMESTAMP,
    total_amount DECIMAL(12, 2) NOT NULL DEFAULT 0,
    notes TEXT,
    status_id INTEGER REFERENCES status_types(id) ON DELETE RESTRICT,
    payment_status_id INTEGER REFERENCES status_types(id) ON DELETE RESTRICT,
    created_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Elementos de Compras
CREATE TABLE purchase_order_items (
    id SERIAL PRIMARY KEY,
    purchase_order_id INTEGER NOT NULL REFERENCES purchase_orders(id) ON DELETE CASCADE,
    product_id VARCHAR(255) NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL,
    received_quantity INTEGER DEFAULT 0 CHECK (received_quantity >= 0),
    status_id INTEGER REFERENCES status_types(id) ON DELETE RESTRICT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Tipos de Transacciones de Inventario
CREATE TABLE transaction_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Historial de Movimientos de Inventario (versión normalizada)
CREATE TABLE inventory_transactions (
    id SERIAL PRIMARY KEY,
    product_id VARCHAR(255) NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL,
    transaction_type_id INTEGER NOT NULL REFERENCES transaction_types(id) ON DELETE RESTRICT,
    reference_id INTEGER,
    reference_type VARCHAR(50),
    reason TEXT,
    previous_stock INTEGER NOT NULL,
    new_stock INTEGER NOT NULL,
    performed_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Productos de Proveedores (catálogo de productos por proveedor)
CREATE TABLE supplier_products (
    id SERIAL PRIMARY KEY,
    supplier_id INTEGER NOT NULL REFERENCES suppliers(id) ON DELETE CASCADE,
    product_id VARCHAR(255) NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    supplier_product_code VARCHAR(100),
    supplier_product_name VARCHAR(255),
    unit_cost DECIMAL(10, 2) NOT NULL,
    minimum_order_quantity INTEGER DEFAULT 1,
    lead_time_days INTEGER,
    is_preferred_supplier BOOLEAN DEFAULT FALSE,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (supplier_id, product_id)
);

-- Tabla para Devoluciones de Ventas
CREATE TABLE sales_returns (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE RESTRICT,
    return_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    reason TEXT,
    processed_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    status_id INTEGER REFERENCES status_types(id) ON DELETE RESTRICT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Condiciones de Devolución
CREATE TABLE return_conditions (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Items de Devoluciones de Ventas
CREATE TABLE sales_return_items (
    id SERIAL PRIMARY KEY,
    sales_return_id INTEGER NOT NULL REFERENCES sales_returns(id) ON DELETE CASCADE,
    product_id VARCHAR(255) NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    product_order_id INTEGER REFERENCES product_orders(id) ON DELETE SET NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL,
    reason VARCHAR(255),
    condition_id INTEGER REFERENCES return_conditions(id) ON DELETE RESTRICT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Devoluciones a Proveedores
CREATE TABLE purchase_returns (
    id SERIAL PRIMARY KEY,
    purchase_order_id INTEGER NOT NULL REFERENCES purchase_orders(id) ON DELETE RESTRICT,
    return_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL,
    reason TEXT,
    processed_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    status_id INTEGER REFERENCES status_types(id) ON DELETE RESTRICT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Items de Devoluciones a Proveedores
CREATE TABLE purchase_return_items (
    id SERIAL PRIMARY KEY,
    purchase_return_id INTEGER NOT NULL REFERENCES purchase_returns(id) ON DELETE CASCADE,
    product_id VARCHAR(255) NOT NULL REFERENCES products(id) ON DELETE RESTRICT,
    purchase_order_item_id INTEGER REFERENCES purchase_order_items(id) ON DELETE SET NULL,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL,
    reason VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Inventario Devuelto (returned_inventory)
CREATE TABLE returned_inventory (
    id SERIAL PRIMARY KEY,
    product_id VARCHAR(255) NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL DEFAULT 0,
    condition VARCHAR(50) NOT NULL,
    sales_return_item_id INTEGER REFERENCES sales_return_items(id),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Métodos de Pago
CREATE TABLE payment_methods (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE user_payment_methods (
    id SERIAL PRIMARY KEY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    payment_token VARCHAR(255) NOT NULL,
    payment_gateway_name VARCHAR(100) NOT NULL,
    is_default BOOLEAN DEFAULT FALSE,
    details JSONB NOT NULL,
    payment_method_id INTEGER REFERENCES payment_methods(id) ON DELETE RESTRICT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Monedas (Currencies)
CREATE TABLE currencies (
    id SERIAL PRIMARY KEY,
    code VARCHAR(3) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    symbol VARCHAR(5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla para transacciones de pago
CREATE TABLE payment_transactions (
    id SERIAL PRIMARY KEY,
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    user_payment_method_id INTEGER REFERENCES user_payment_methods(id) ON DELETE RESTRICT,
    transaction_id VARCHAR(255) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    currency_id INTEGER NOT NULL REFERENCES currencies(id) ON DELETE RESTRICT,
    status VARCHAR(50) NOT NULL,
    provider_response JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Métodos de Envío
CREATE TABLE shipping_methods (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    active BOOLEAN DEFAULT TRUE,
    price DECIMAL(10, 2) DEFAULT 0,
    estimated_days INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Categorías de Estado
CREATE TABLE status_categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Tipos de Estado
CREATE TABLE status_types (
    id SERIAL PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    category_id INTEGER NOT NULL REFERENCES status_categories(id) ON DELETE RESTRICT,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(name, category_id)
);