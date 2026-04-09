CREATE OR REPLACE FUNCTION fn_audit_stock_change()
RETURNS TRIGGER
LANGUAGE plpgsql
AS $$
BEGIN
    IF OLD.stock_quantity IS DISTINCT FROM NEW.stock_quantity THEN
        INSERT INTO stock_audit (product_id, old_quantity, new_quantity)
        VALUES (NEW.id, OLD.stock_quantity, NEW.stock_quantity);
    END IF;
    RETURN NEW;
END;
$$;

CREATE OR REPLACE TRIGGER trg_audit_stock
AFTER UPDATE ON products
FOR EACH ROW
EXECUTE FUNCTION fn_audit_stock_change();
