-- Tabla de Roles
CREATE TABLE roles (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Permisos
CREATE TABLE permissions (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de relación entre roles y permisos
CREATE TABLE role_permissions (
    role_id INTEGER REFERENCES roles(id) ON DELETE CASCADE,
    permission_id INTEGER REFERENCES permissions(id) ON DELETE CASCADE,
    PRIMARY KEY (role_id, permission_id)
);

-- Tabla de Usuarios
CREATE TABLE users (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(255) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(50),
    confirmation_token_hash VARCHAR(255),
    password_reset_token_hash VARCHAR(255),
    confirmed BOOLEAN DEFAULT FALSE,
    profile_image_url VARCHAR(255),
    role_id INTEGER REFERENCES roles(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Categorías
CREATE TABLE categories (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(255) NOT NULL,
    picture VARCHAR(255) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Marcas (Brands)
CREATE TABLE brands (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(255) NOT NULL UNIQUE,
    logo_url VARCHAR(255),
    description TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Monedas
CREATE TABLE currencies (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    code VARCHAR(3) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    symbol VARCHAR(5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Tipos de Medidas
CREATE TABLE measurement_types (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Unidades de Medida
CREATE TABLE units_of_measure (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(50) NOT NULL,
    symbol VARCHAR(10) NOT NULL,
    measurement_type_id INTEGER NOT NULL REFERENCES measurement_types(id),
    base_unit BOOLEAN DEFAULT FALSE,
    conversion_factor DECIMAL(16, 8),
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(name, measurement_type_id),
    UNIQUE(symbol, measurement_type_id)
);

-- Tabla de Productos
CREATE TABLE products (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(255) NOT NULL,
    description TEXT,
    width DECIMAL(10, 2),
    height DECIMAL(10, 2),
    depth DECIMAL(10, 2),
    weight DECIMAL(10, 2),
    price DECIMAL(10, 2) NOT NULL,
    currency_id INTEGER NOT NULL REFERENCES currencies(id),
    brand_id INTEGER NOT NULL REFERENCES brands(id),
    width_unit_id INTEGER REFERENCES units_of_measure(id),
    height_unit_id INTEGER REFERENCES units_of_measure(id),
    depth_unit_id INTEGER REFERENCES units_of_measure(id),
    weight_unit_id INTEGER REFERENCES units_of_measure(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para imágenes de productos
CREATE TABLE product_images (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    image_url VARCHAR(255) NOT NULL,
    alt_text VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de relación entre productos y categorías
CREATE TABLE product_categories (
    product_id INTEGER REFERENCES products(id) ON DELETE CASCADE,
    category_id INTEGER REFERENCES categories(id) ON DELETE CASCADE,
    PRIMARY KEY (product_id, category_id)
);

-- Tabla de Carritos
CREATE TABLE carts (
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (user_id, product_id)
);

-- Tabla de Métodos de Pago
CREATE TABLE payment_methods (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Métodos de Pago de Usuarios
CREATE TABLE user_payment_methods (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    payment_method_id INTEGER NOT NULL REFERENCES payment_methods(id),
    
    -- Common fields for all payment methods
    is_default BOOLEAN DEFAULT FALSE,
    currency_id INTEGER NOT NULL REFERENCES currencies(id),
    payment_token_hash VARCHAR(255) NOT NULL UNIQUE,
    
    -- Credit Card specific fields
    cardholder_name VARCHAR(255),
    card_number_hash VARCHAR(255),
    expiration_date DATE,
    
    -- Digital Wallet (e.g., PayPal) specific fields
    wallet_email VARCHAR(255),
    wallet_id VARCHAR(255),
    
    -- Bank Transfer specific fields
    bank_account_number_hash VARCHAR(255),
    bank_routing_number_hash VARCHAR(255),
    bank_account_holder_name VARCHAR(255),
    bank_name VARCHAR(255),

    -- Campos para Billeteras Digitales / Criptomonedas u otros métodos
    wallet_provider VARCHAR(50),
    wallet_account VARCHAR(100),
    crypto_wallet_address VARCHAR(100),
    
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Métodos de Envío
CREATE TABLE shipping_methods (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    active BOOLEAN DEFAULT TRUE,
    price DECIMAL(10, 2) DEFAULT 0,
    currency_id INTEGER NOT NULL REFERENCES currencies(id),
    estimated_days INTEGER,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Categorías de Estado
CREATE TABLE status_categories (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Tipos de Estado
CREATE TABLE status_types (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(50) NOT NULL,
    category_id INTEGER NOT NULL REFERENCES status_categories(id),
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(name, category_id)
);

-- Tabla de Tipos de Impuestos
CREATE TABLE tax_types (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(100) NOT NULL UNIQUE,
    percentage DECIMAL(4, 2) NOT NULL,
    description VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Tipos de Descuento (Nueva tabla para normalización)
CREATE TABLE discount_types (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Descuentos (Modificada)
CREATE TABLE discounts (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    code VARCHAR(50) NOT NULL UNIQUE,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    discount_type_id INTEGER NOT NULL REFERENCES discount_types(id),
    value DECIMAL(10, 2) NOT NULL,
    min_order_amount DECIMAL(10, 2) DEFAULT 0,
    max_discount_amount DECIMAL(10, 2),
    currency_id INTEGER NOT NULL REFERENCES currencies(id),
    start_date TIMESTAMP,
    end_date TIMESTAMP,
    usage_limit INTEGER,
    times_used INTEGER DEFAULT 0,
    is_active BOOLEAN DEFAULT TRUE,
    exclusive BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CHECK (usage_limit IS NULL OR times_used <= usage_limit)
);

-- Tabla para Países
CREATE TABLE countries (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(100) NOT NULL UNIQUE,
    code VARCHAR(3) NOT NULL UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Estados/Provincias
CREATE TABLE states (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    code VARCHAR(10),
    country_id INTEGER NOT NULL REFERENCES countries(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(name, country_id)
);

-- Tabla para Ciudades
CREATE TABLE cities (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(100) NOT NULL,
    state_id INTEGER NOT NULL REFERENCES states(id) ON DELETE CASCADE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE(name, state_id)
);

-- Tabla de Direcciones
CREATE TABLE addresses (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    user_id INTEGER REFERENCES users(id),
    address VARCHAR(255) NOT NULL,
    postal_code VARCHAR(50) NOT NULL,
    city_id INTEGER NOT NULL REFERENCES cities(id),
    contact_phone VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Reseñas de Productos
CREATE TABLE product_reviews (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    user_id INTEGER NOT NULL REFERENCES users(id),
    order_id INTEGER REFERENCES orders(id),
    rating INTEGER NOT NULL CHECK (rating BETWEEN 1 AND 5),
    title VARCHAR(255),
    comment TEXT,
    is_verified_purchase BOOLEAN DEFAULT FALSE,
    helpful_votes INTEGER DEFAULT 0,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de ordenes/Pedidos
CREATE TABLE orders (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    user_id INTEGER NOT NULL REFERENCES users(id),
    user_payment_method_id INTEGER REFERENCES user_payment_methods(id),
    status_id INTEGER REFERENCES status_types(id),
    payment_status_id INTEGER REFERENCES status_types(id),
    subtotal DECIMAL(10, 2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    total_tax_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    total_discount_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    shipping_address_id INTEGER REFERENCES addresses(id),
    shipping_method_id INTEGER REFERENCES shipping_methods(id),
    shipping_cost DECIMAL(10, 2),
    currency_id INTEGER NOT NULL REFERENCES currencies(id),
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de relación entre órdenes e impuestos
CREATE TABLE order_taxes (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    tax_type_id INTEGER NOT NULL REFERENCES tax_types(id),
    applicable_percentage DECIMAL(4, 2) NOT NULL,
    tax_amount DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de relación entre órdenes y descuentos
CREATE TABLE order_discounts (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY, 
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    discount_id INTEGER NOT NULL REFERENCES discounts(id),
    original_value DECIMAL(10, 2) NOT NULL,
    discount_amount DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Productos en una Orden
CREATE TABLE order_products (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL,
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (order_id, product_id)
);

-- Tabla de Proveedores
CREATE TABLE suppliers (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(255) NOT NULL,
    contact_person VARCHAR(255),
    email VARCHAR(255) NOT NULL,
    phone VARCHAR(100) NOT NULL,
    address VARCHAR(255) NOT NULL,
    tax_id VARCHAR(100),
    notes TEXT,
    status_id INTEGER REFERENCES status_types(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Ubicaciones de Inventario
CREATE TABLE inventory_locations (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(100) NOT NULL UNIQUE,
    description VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Inventario
CREATE TABLE inventory (
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    location_id INTEGER NOT NULL REFERENCES inventory_locations(id) ON DELETE CASCADE,
    stock_quantity INTEGER NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    min_stock_level INTEGER NOT NULL DEFAULT 10,
    max_stock_level INTEGER,
    last_restock_date TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (product_id, location_id)
);

-- Tabla de Compras a Proveedores
CREATE TABLE purchase_orders (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    supplier_id INTEGER NOT NULL REFERENCES suppliers(id),
    subtotal DECIMAL(10, 2) NOT NULL DEFAULT 0,
    total_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    total_tax_amount DECIMAL(10, 2) NOT NULL DEFAULT 0,
    order_number VARCHAR(100) NOT NULL UNIQUE,
    order_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    expected_delivery_date TIMESTAMP,
    actual_delivery_date TIMESTAMP,
    notes TEXT,
    currency_id INTEGER NOT NULL REFERENCES currencies(id),
    status_id INTEGER REFERENCES status_types(id),
    payment_status_id INTEGER REFERENCES status_types(id),
    created_by INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Elementos de Compras
CREATE TABLE purchase_order_items (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    purchase_order_id INTEGER NOT NULL REFERENCES purchase_orders(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(10, 2) NOT NULL,
    received_quantity INTEGER DEFAULT 0 CHECK (received_quantity >= 0),
    status_id INTEGER REFERENCES status_types(id),
    unit_of_measure_id INTEGER REFERENCES units_of_measure(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Tipos de Transacciones de Inventario
CREATE TABLE transaction_types (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Productos de Proveedores
CREATE TABLE supplier_products (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    supplier_id INTEGER NOT NULL REFERENCES suppliers(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    supplier_product_code VARCHAR(100),
    unit_cost DECIMAL(10, 2) NOT NULL,
    currency_id INTEGER NOT NULL REFERENCES currencies(id),
    minimum_order_quantity INTEGER DEFAULT 1,
    lead_time_days INTEGER,
    is_preferred_supplier BOOLEAN DEFAULT FALSE,
    notes TEXT,
    unit_of_measure_id INTEGER REFERENCES units_of_measure(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE (supplier_id, product_id)
);

-- Tabla para Devoluciones de Ventas
CREATE TABLE sales_returns (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    return_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reason TEXT,
    processed_by INTEGER REFERENCES users(id),
    status_id INTEGER REFERENCES status_types(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Condiciones de Devolución
CREATE TABLE return_conditions (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Items de Devoluciones de Ventas
CREATE TABLE sales_return_items (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    sales_return_id INTEGER NOT NULL REFERENCES sales_returns(id) ON DELETE CASCADE,
    order_product_id INTEGER NOT NULL REFERENCES order_products(id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    reason VARCHAR(255),
    condition_id INTEGER REFERENCES return_conditions(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Devoluciones a Proveedores
CREATE TABLE purchase_returns (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    purchase_order_id INTEGER NOT NULL REFERENCES purchase_orders(id) ON DELETE CASCADE,
    return_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    reason TEXT,
    processed_by INTEGER REFERENCES users(id),
    status_id INTEGER REFERENCES status_types(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Items de Devoluciones a Proveedores
CREATE TABLE purchase_return_items (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    purchase_return_id INTEGER NOT NULL REFERENCES purchase_returns(id) ON DELETE CASCADE,
    purchase_order_item_id INTEGER REFERENCES purchase_order_items(id),
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    reason VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para retenciones de devoluciones hasta que sea revisado
CREATE TABLE return_holds (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    sales_return_item_id INTEGER NOT NULL UNIQUE REFERENCES sales_return_items(id) ON DELETE CASCADE,
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    condition_id INTEGER NOT NULL REFERENCES return_conditions(id),
    location_id INTEGER NOT NULL REFERENCES inventory_locations(id),
    status_id INTEGER NOT NULL REFERENCES status_types(id),
    resolution_notes TEXT,
    inspected_by INTEGER REFERENCES users(id) ON DELETE SET NULL,
    inspected_at TIMESTAMP,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Historial de Movimientos de Inventario
CREATE TABLE inventory_transactions (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    product_id INTEGER NOT NULL REFERENCES products(id),
    location_id INTEGER NOT NULL REFERENCES inventory_locations(id),
    quantity INTEGER NOT NULL,
    transaction_type_id INTEGER NOT NULL REFERENCES transaction_types(id),
    purchase_order_item_id INTEGER REFERENCES purchase_order_items(id),
    sales_return_item_id INTEGER REFERENCES sales_return_items(id),
    return_hold_id INTEGER REFERENCES return_holds(id) ON DELETE SET NULL,
    reason TEXT,
    previous_stock INTEGER NOT NULL,
    new_stock INTEGER NOT NULL,
    performed_by INTEGER REFERENCES users(id),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Crear tabla para transacciones de pago
CREATE TABLE payment_transactions (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    user_payment_method_id INTEGER REFERENCES user_payment_methods(id),
    transaction_id VARCHAR(255) NOT NULL UNIQUE,
    amount DECIMAL(10, 2) NOT NULL,
    currency_id INTEGER NOT NULL REFERENCES currencies(id),
    status_id INTEGER NOT NULL REFERENCES status_types(id),
    provider_response JSONB,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Historial de Precios
CREATE TABLE price_history (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    product_id INTEGER NOT NULL REFERENCES products(id),
    previous_price DECIMAL(10, 2) NOT NULL,
    new_price DECIMAL(10, 2) NOT NULL,
    currency_id INTEGER NOT NULL REFERENCES currencies(id),
    changed_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    changed_by INTEGER REFERENCES users(id),
    change_reason VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla de Facturas (normalización del campo invoice_number)
CREATE TABLE invoices (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
    invoice_number VARCHAR(100) NOT NULL UNIQUE,
    issue_date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    due_date TIMESTAMP,
    payment_terms VARCHAR(255),
    notes TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Tipos de Interacciones de Usuario con Productos
CREATE TABLE interaction_types (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla para Interacciones de Usuario con Productos (normalizada)
CREATE TABLE user_product_interactions (
    id INTEGER PRIMARY KEY GENERATED BY DEFAULT AS IDENTITY,
    user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    interaction_type_id INTEGER NOT NULL REFERENCES interaction_types(id),
    interaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    score INTEGER CHECK (score BETWEEN 1 AND 5),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- New table for storing similarity relationships between products
CREATE TABLE product_similarities (
    product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    similar_product_id INTEGER NOT NULL REFERENCES products(id) ON DELETE CASCADE,
    similarity_score DECIMAL(5,2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (product_id, similar_product_id),
    CHECK (product_id != similar_product_id)
);