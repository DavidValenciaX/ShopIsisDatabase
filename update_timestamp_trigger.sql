-- Function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_timestamp()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Function to add the update_timestamp trigger to all tables with updated_at column
CREATE OR REPLACE FUNCTION create_updated_at_triggers()
RETURNS void AS $$
DECLARE
    tbl text;
BEGIN
    FOR tbl IN 
        SELECT table_name FROM information_schema.columns
        WHERE column_name = 'updated_at' 
        AND table_schema = current_schema()
    LOOP
        EXECUTE format('DROP TRIGGER IF EXISTS set_timestamp ON %I', tbl);
        EXECUTE format('CREATE TRIGGER set_timestamp BEFORE UPDATE ON %I FOR EACH ROW EXECUTE FUNCTION update_timestamp()', tbl);
        RAISE NOTICE 'Added update_timestamp trigger to table %', tbl;
    END LOOP;
END;
$$ LANGUAGE plpgsql;

-- Execute the function to add triggers to all existing tables
SELECT create_updated_at_triggers();

-- Note: Run SELECT create_updated_at_triggers(); again whenever you create new tables with updated_at column
