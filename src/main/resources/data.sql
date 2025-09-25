

-- Borrar tablas si existen (orden inverso por FK)
DROP TABLE IF EXISTS payment_details CASCADE;
DROP TABLE IF EXISTS shopping_cart_details CASCADE;
DROP TABLE IF EXISTS shopping_carts CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS categories CASCADE;
DROP TABLE IF EXISTS user_roles CASCADE;
DROP TABLE IF EXISTS users CASCADE;
DROP TABLE IF EXISTS roles CASCADE;

-- =========================================
-- TABLAS
-- =========================================

CREATE TABLE IF NOT EXISTS roles (
                                     id BIGSERIAL PRIMARY KEY,
                                     name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255),
    status VARCHAR(1) NOT NULL DEFAULT '1',
    created_by VARCHAR(12),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(12),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

CREATE TABLE IF NOT EXISTS users (
                                     id BIGSERIAL PRIMARY KEY,
                                     username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    document_type VARCHAR(1) NOT NULL,
    identity_document VARCHAR(12) UNIQUE,
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(70) NOT NULL,
    mother_last_name VARCHAR(70) NOT NULL,
    phone VARCHAR(12),
    status VARCHAR(1) NOT NULL DEFAULT '1',
    created_by VARCHAR(12),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(12),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

CREATE TABLE IF NOT EXISTS user_roles (
                                          id BIGSERIAL PRIMARY KEY,
                                          user_id BIGINT NOT NULL,
                                          role_id BIGINT NOT NULL,
                                          status VARCHAR(1) NOT NULL DEFAULT '1',
    created_by VARCHAR(12),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(12),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS categories (
                                          id SERIAL PRIMARY KEY,
                                          name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    status VARCHAR(1) NOT NULL DEFAULT '1',
    created_by VARCHAR(12),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(12),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
    );

CREATE TABLE IF NOT EXISTS products (
                                        id SERIAL PRIMARY KEY,
                                        name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    category_id INTEGER NOT NULL,
    image_url VARCHAR(255),
    status VARCHAR(1) NOT NULL DEFAULT '1',
    created_by VARCHAR(12),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(12),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
    );

CREATE TABLE IF NOT EXISTS shopping_carts (
                                              id SERIAL PRIMARY KEY,
                                              user_id BIGINT NOT NULL,
                                              date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
                                              total_amount DECIMAL(10,2) DEFAULT 0.00,
    status VARCHAR(1) NOT NULL DEFAULT '1',
    created_by VARCHAR(12),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(12),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_shopping_carts_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    );

CREATE TABLE IF NOT EXISTS shopping_cart_details (
                                                     id SERIAL PRIMARY KEY,
                                                     shopping_cart_id INTEGER NOT NULL,
                                                     product_id INTEGER NOT NULL,
                                                     quantity INTEGER NOT NULL DEFAULT 1,
                                                     price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    status VARCHAR(1) NOT NULL DEFAULT '1',
    created_by VARCHAR(12),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(12),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cart_details_cart FOREIGN KEY (shopping_cart_id) REFERENCES shopping_carts(id) ON DELETE CASCADE,
    CONSTRAINT fk_cart_details_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
    );

CREATE TABLE IF NOT EXISTS payment_details (
                                               id SERIAL PRIMARY KEY,
                                               shopping_cart_id INTEGER NOT NULL UNIQUE,
                                               cardholder VARCHAR(100) NOT NULL,
    card_number VARCHAR(20) NOT NULL,
    expire_date VARCHAR(7) NOT NULL,
    security_code VARCHAR(4) NOT NULL,
    payment_method VARCHAR(50) DEFAULT 'CREDIT_CARD',
    payment_status VARCHAR(20) DEFAULT 'PENDING',
    transaction_id VARCHAR(100),
    status VARCHAR(1) NOT NULL DEFAULT '1',
    created_by VARCHAR(12),
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(12),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_details_cart FOREIGN KEY (shopping_cart_id) REFERENCES shopping_carts(id) ON DELETE CASCADE
    );

-- =========================================
-- ÍNDICES
-- =========================================
CREATE INDEX IF NOT EXISTS idx_users_username ON users(username);
CREATE INDEX IF NOT EXISTS idx_users_email ON users(email);
CREATE INDEX IF NOT EXISTS idx_users_identity_document ON users(identity_document);
CREATE INDEX IF NOT EXISTS idx_roles_name ON roles(name);
CREATE INDEX IF NOT EXISTS idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_role_id ON user_roles(role_id);
CREATE INDEX IF NOT EXISTS idx_products_category_id ON products(category_id);
CREATE INDEX IF NOT EXISTS idx_products_name ON products(name);
CREATE INDEX IF NOT EXISTS idx_products_price ON products(price);
CREATE INDEX IF NOT EXISTS idx_shopping_carts_user_id ON shopping_carts(user_id);
CREATE INDEX IF NOT EXISTS idx_shopping_carts_date ON shopping_carts(date);
CREATE INDEX IF NOT EXISTS idx_cart_details_cart_id ON shopping_cart_details(shopping_cart_id);
CREATE INDEX IF NOT EXISTS idx_cart_details_product_id ON shopping_cart_details(product_id);
CREATE INDEX IF NOT EXISTS idx_payment_details_cart_id ON payment_details(shopping_cart_id);

-- =========================================
-- COMENTARIOS
-- =========================================
COMMENT ON TABLE roles IS 'Table that stores system roles';
COMMENT ON COLUMN roles.status IS 'Record status: 0=Inactive, 1=Active, 2=Deleted';
COMMENT ON TABLE users IS 'Table that stores user information';
COMMENT ON COLUMN users.document_type IS 'Identity document type';
COMMENT ON COLUMN users.status IS 'Record status: 0=Inactive, 1=Active, 2=Deleted';
COMMENT ON TABLE user_roles IS 'Many-to-many relationship table between users and roles';
COMMENT ON COLUMN user_roles.status IS 'Record status: 0=Inactive, 1=Active, 2=Deleted';
COMMENT ON TABLE categories IS 'Table that stores product categories for pharmacy items';
COMMENT ON TABLE products IS 'Table that stores pharmacy products information';
COMMENT ON TABLE shopping_carts IS 'Table that stores user shopping carts';
COMMENT ON TABLE shopping_cart_details IS 'Table that stores items in each shopping cart';
COMMENT ON TABLE payment_details IS 'Table that stores payment information for each cart';

-- =========================================
-- DATOS INICIALES
-- =========================================
INSERT INTO roles (name, description, created_by)
VALUES
    ('ROLE_ADMIN','System administrator','48484848'),
    ('ROLE_USER','Standard user','48484848'),
    ('ROLE_MODERATOR','System moderator','48484848')
    ON CONFLICT (name) DO NOTHING;

INSERT INTO users (username, email, password, document_type, identity_document, first_name, last_name, mother_last_name, phone, created_by)
VALUES
    ('admin', 'admin@carritoapp.com', '$2a$12$023ly6Mcks.e1dsGog/EpuIB2fdwJyg1QavbJ9GvaI/JRgipGJNBK', '1', '12345678', 'Administrator', 'Sistema', 'Admin', '987654321', '48484848'),
    ('johndoe', 'john@gmail.com', '$2a$12$023ly6Mcks.e1dsGog/EpuIB2fdwJyg1QavbJ9GvaI/JRgipGJNBK', '1', '87654321', 'John', 'Doe', 'Smith', '123456789', '48484848'),
    ('janedoe', 'jane@gmail.com', '$2a$12$023ly6Mcks.e1dsGog/EpuIB2fdwJyg1QavbJ9GvaI/JRgipGJNBK', '1', '11223344', 'Jane', 'Doe', 'Johnson', '456789123', '48484848')
    ON CONFLICT (username) DO NOTHING;

INSERT INTO user_roles (user_id, role_id, created_by)
SELECT u.id, r.id, '48484848'
FROM users u
         JOIN roles r ON
    ( (u.username='admin' AND r.name='ROLE_ADMIN')
        OR (u.username='admin' AND r.name='ROLE_USER')
        OR (u.username='johndoe' AND r.name='ROLE_USER')
        OR (u.username='janedoe' AND r.name='ROLE_USER')
        OR (u.username='janedoe' AND r.name='ROLE_MODERATOR') )
    ON CONFLICT DO NOTHING;

INSERT INTO categories (name, description, created_by) VALUES
('Analgesics', 'Pain relief medications', '48484848'),
('Antibiotics', 'Infection treatment medications', '48484848'),
('Vitamins', 'Nutritional supplements and vitamins', '48484848'),
('Dermatology', 'Skin care and treatment products', '48484848'),
('Respiratory', 'Respiratory system medications', '48484848'),
('Digestive', 'Digestive system medications', '48484848'),
('First Aid', 'First aid and wound care products', '48484848'),
('Baby Care', 'Baby and infant care products', '48484848');


-- Datos de ejemplo para productos de farmacia
INSERT INTO products (name, description, price, stock, category_id, created_by) VALUES
-- Analgesicos
('Paracetamol 500mg', 'Pain and fever relief tablets', 8.50, 100, 1, '48484848'),
('Ibuprofen 400mg', 'Anti-inflammatory and pain relief', 12.00, 80, 1, '48484848'),
('Aspirin 100mg', 'Low-dose aspirin for cardiovascular protection', 15.50, 60, 1, '48484848'),

-- Antibióticos
('Amoxicillin 500mg', 'Broad-spectrum antibiotic', 25.00, 40, 2, '48484848'),
('Azithromycin 250mg', 'Antibiotic for respiratory infections', 35.00, 30, 2, '48484848'),

-- Vitaminas
('Vitamin C 1000mg', 'Immune system support', 18.00, 150, 3, '48484848'),
('Multivitamin Complex', 'Complete daily vitamin supplement', 22.50, 120, 3, '48484848'),
('Vitamin D3 2000 IU', 'Bone health and immune support', 20.00, 90, 3, '48484848'),

-- Dermatología
('Hydrocortisone Cream 1%', 'Anti-inflammatory skin cream', 14.00, 70, 4, '48484848'),
('Antifungal Cream', 'Treatment for fungal skin infections', 16.50, 50, 4, '48484848'),

-- Respiratorio
('Cough Syrup', 'Relief for dry and productive cough', 18.50, 85, 5, '48484848'),
('Nasal Decongestant Spray', 'Fast relief for nasal congestion', 12.50, 95, 5, '48484848'),

-- Digestivo
('Antacid Tablets', 'Relief for heartburn and acid indigestion', 9.50, 110, 6, '48484848'),
('Probiotic Capsules', 'Digestive health support', 28.00, 45, 6, '48484848'),

-- Primeros Auxilios
('Adhesive Bandages Pack', 'Assorted sizes for wound protection', 6.50, 200, 7, '48484848'),
('Antiseptic Solution', 'Wound cleaning and disinfection', 11.00, 75, 7, '48484848'),

-- Cuidado del Bebé
('Baby Thermometer', 'Digital thermometer for infants', 35.00, 25, 8, '48484848'),
('Baby Lotion', 'Gentle moisturizing lotion for sensitive skin', 16.00, 60, 8, '48484848');