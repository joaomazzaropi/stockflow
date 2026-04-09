CREATE TABLE categories (
    id         SERIAL PRIMARY KEY,
    name       VARCHAR(100) NOT NULL UNIQUE,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE products (
    id              SERIAL PRIMARY KEY,
    name            VARCHAR(150) NOT NULL,
    category_id     INT NOT NULL REFERENCES categories(id),
    unit_price      NUMERIC(10,2) NOT NULL CHECK (unit_price >= 0),
    stock_quantity  INT NOT NULL DEFAULT 0 CHECK (stock_quantity >= 0),
    created_at      TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE stock_movements (
    id         SERIAL PRIMARY KEY,
    product_id INT NOT NULL REFERENCES products(id),
    type       VARCHAR(3) NOT NULL CHECK (type IN ('IN', 'OUT')),
    quantity   INT NOT NULL CHECK (quantity > 0),
    reason     VARCHAR(255),
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- Tabela de auditoria - preenchida automaticamente via trigger
CREATE TABLE stock_audit (
    id           SERIAL PRIMARY KEY,
    product_id   INT NOT NULL,
    old_quantity INT NOT NULL,
    new_quantity INT NOT NULL,
    changed_at   TIMESTAMPTZ DEFAULT NOW()
);

-- Dados iniciais
INSERT INTO categories (name) VALUES ('Eletronicos'), ('Ferramentas'), ('Escritorio');

INSERT INTO products (name, category_id, unit_price, stock_quantity) VALUES
    ('Teclado Mecanico',  1, 299.90,  50),
    ('Mouse Gamer',       1, 189.90,  80),
    ('Chave de Fenda',    2,  19.90, 200),
    ('Papel A4 (resma)',  3,  29.90, 150);
