-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Create triggers for all tables with updated_at column

-- Roles table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON roles
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Permissions table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON permissions
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Role permissions table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON role_permissions
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Users table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON users
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Categories table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON categories
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Brands table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON brands
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Currencies table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON currencies
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Measurement types table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON measurement_types
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Units of measure table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON units_of_measure
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Products table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Product images table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON product_images
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Product categories table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON product_categories
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Carts table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON carts
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Payment methods table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON payment_methods
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- User payment methods table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON user_payment_methods
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Shipping methods table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON shipping_methods
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Status categories table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON status_categories
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Status types table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON status_types
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Tax types table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON tax_types
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Discount types table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON discount_types
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Discounts table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON discounts
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Countries table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON countries
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- States table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON states
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Cities table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON cities
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Addresses table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON addresses
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Product reviews table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON product_reviews
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Orders table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON orders
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Order taxes table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON order_taxes
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Order discounts table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON order_discounts
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Order products table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON order_products
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Suppliers table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON suppliers
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Inventory locations table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON inventory_locations
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Inventory table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON inventory
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Purchase orders table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON purchase_orders
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Purchase order items table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON purchase_order_items
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Transaction types table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON transaction_types
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Supplier products table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON supplier_products
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Sales returns table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON sales_returns
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Return conditions table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON return_conditions
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Sales return items table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON sales_return_items
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Purchase returns table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON purchase_returns
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Purchase return items table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON purchase_return_items
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Return holds table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON return_holds
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Inventory transactions table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON inventory_transactions
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Payment transactions table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON payment_transactions
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Price history table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON price_history
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Invoices table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON invoices
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Interaction types table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON interaction_types
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- User product interactions table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON user_product_interactions
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Product similarities table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON product_similarities
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();

-- Wishlist items table
CREATE TRIGGER set_timestamp
BEFORE UPDATE ON wishlist_items
FOR EACH ROW
EXECUTE FUNCTION update_timestamp();
