-- Registra uma movimentacao e atualiza o estoque atomicamente.
-- O uso de PL/pgSQL garante que o saldo nunca fique inconsistente
-- mesmo com acessos simultaneos (FOR UPDATE trava a linha).
CREATE OR REPLACE PROCEDURE sp_register_movement(
    p_product_id INT,
    p_type       VARCHAR(3),
    p_quantity   INT,
    p_reason     VARCHAR(255) DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
DECLARE
    v_current_stock INT;
BEGIN
    SELECT stock_quantity INTO v_current_stock
    FROM products
    WHERE id = p_product_id
    FOR UPDATE;

    IF NOT FOUND THEN
        RAISE EXCEPTION 'Produto com id % nao encontrado.', p_product_id;
    END IF;

    IF p_type = 'OUT' AND v_current_stock < p_quantity THEN
        RAISE EXCEPTION 'Estoque insuficiente. Disponivel: %, Solicitado: %',
            v_current_stock, p_quantity;
    END IF;

    IF p_type = 'IN' THEN
        UPDATE products SET stock_quantity = stock_quantity + p_quantity WHERE id = p_product_id;
    ELSE
        UPDATE products SET stock_quantity = stock_quantity - p_quantity WHERE id = p_product_id;
    END IF;

    INSERT INTO stock_movements (product_id, type, quantity, reason)
    VALUES (p_product_id, p_type, p_quantity, p_reason);
END;
$$;
