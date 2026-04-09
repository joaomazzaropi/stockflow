CREATE OR REPLACE FUNCTION fn_stock_report_by_category()
RETURNS TABLE (
    category       VARCHAR,
    total_products BIGINT,
    total_units    BIGINT,
    total_value    NUMERIC
)
LANGUAGE plpgsql
AS $$
BEGIN
    RETURN QUERY
    SELECT
        c.name::VARCHAR                      AS category,
        COUNT(p.id)                          AS total_products,
        SUM(p.stock_quantity)                AS total_units,
        SUM(p.stock_quantity * p.unit_price) AS total_value
    FROM categories c
    LEFT JOIN products p ON p.category_id = c.id
    GROUP BY c.name
    ORDER BY total_value DESC;
END;
$$;
