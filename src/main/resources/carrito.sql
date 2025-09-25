-- Script de creación de tablas para PostgreSQL
-- Aplicación CarritoApp

-- Tabla: roles
CREATE TABLE roles (
id BIGSERIAL PRIMARY KEY,
name VARCHAR(50) NOT NULL UNIQUE,
description VARCHAR(255),
status VARCHAR(1) NOT NULL DEFAULT '1',
created_by VARCHAR(12) NOT NULL,
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_by VARCHAR(12),
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: users
CREATE TABLE users (
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
created_by VARCHAR(12) NOT NULL,
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_by VARCHAR(12),
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: user_roles
CREATE TABLE user_roles (
id BIGSERIAL PRIMARY KEY,
user_id BIGINT NOT NULL,
role_id BIGINT NOT NULL,
status VARCHAR(1) NOT NULL DEFAULT '1',
created_by VARCHAR(12) NOT NULL,
created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
updated_by VARCHAR(12),
updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
CONSTRAINT fk_user_roles_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
CONSTRAINT fk_user_roles_role FOREIGN KEY (role_id) REFERENCES roles(id) ON DELETE CASCADE
);

-- Tabla: categories
CREATE TABLE categories (
    id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    status VARCHAR(1) NOT NULL DEFAULT '1',
    created_by VARCHAR(12) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(12),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Tabla: products
CREATE TABLE products (
    id SERIAL PRIMARY KEY,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    price DECIMAL(10,2) NOT NULL,
    stock INTEGER NOT NULL DEFAULT 0,
    category_id INTEGER NOT NULL,
    image_url VARCHAR(255),
    status VARCHAR(1) NOT NULL DEFAULT '1',
    created_by VARCHAR(12) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(12),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_products_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
);

-- Tabla: shopping_carts
CREATE TABLE shopping_carts (
    id SERIAL PRIMARY KEY,
    user_id BIGINT NOT NULL,
    date TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10,2) DEFAULT 0.00,
    status VARCHAR(1) NOT NULL DEFAULT '1',
    created_by VARCHAR(12) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(12),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_shopping_carts_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

-- Tabla: shopping_cart_details
CREATE TABLE shopping_cart_details (
    id SERIAL PRIMARY KEY,
    shopping_cart_id INTEGER NOT NULL,
    product_id INTEGER NOT NULL,
    quantity INTEGER NOT NULL DEFAULT 1,
    price DECIMAL(10,2) NOT NULL,
    subtotal DECIMAL(10,2) NOT NULL,
    status VARCHAR(1) NOT NULL DEFAULT '1',
    created_by VARCHAR(12) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(12),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_cart_details_cart FOREIGN KEY (shopping_cart_id) REFERENCES shopping_carts(id) ON DELETE CASCADE,
    CONSTRAINT fk_cart_details_product FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT
);

-- Tabla: payment_details
CREATE TABLE payment_details (
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
    created_by VARCHAR(12) NOT NULL,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_by VARCHAR(12),
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_payment_details_cart FOREIGN KEY (shopping_cart_id) REFERENCES shopping_carts(id) ON DELETE CASCADE
);

-- Índices para mejorar rendimiento
CREATE INDEX idx_users_username ON users(username);
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_identity_document ON users(identity_document);
CREATE INDEX idx_roles_name ON roles(name);
CREATE INDEX idx_user_roles_user_id ON user_roles(user_id);
CREATE INDEX idx_user_roles_role_id ON user_roles(role_id);
CREATE INDEX idx_products_category_id ON products(category_id);
CREATE INDEX idx_products_name ON products(name);
CREATE INDEX idx_products_price ON products(price);
CREATE INDEX idx_shopping_carts_user_id ON shopping_carts(user_id);
CREATE INDEX idx_shopping_carts_date ON shopping_carts(date);
CREATE INDEX idx_cart_details_cart_id ON shopping_cart_details(shopping_cart_id);
CREATE INDEX idx_cart_details_product_id ON shopping_cart_details(product_id);
CREATE INDEX idx_payment_details_cart_id ON payment_details(shopping_cart_id);

-- Comentarios para documentación
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

-- Datos iniciales (opcional)
INSERT INTO roles (name, description, created_by) VALUES
('ROLE_ADMIN', 'System administrator', '48484848'),
('ROLE_USER', 'Standard user', '48484848'),
('ROLE_MODERATOR', 'System moderator', '48484848');


-- Datos de prueba de usuarios
-- Contraseña para todos: password123 (encriptada con BCrypt)
INSERT INTO users (username, email, password, document_type, identity_document, first_name, last_name, mother_last_name, phone, created_by) VALUES
('admin', 'admin@carritoapp.com', '$2a$12$023ly6Mcks.e1dsGog/EpuIB2fdwJyg1QavbJ9GvaI/JRgipGJNBK', '1', '12345678', 'Administrator', 'Sistema', 'Admin', '987654321', '48484848'),
('johndoe', 'john@gmail.com', '$2a$12$023ly6Mcks.e1dsGog/EpuIB2fdwJyg1QavbJ9GvaI/JRgipGJNBK', '1', '87654321', 'John', 'Doe', 'Smith', '123456789', '48484848'),
('janedoe', 'jane@gmail.com', '$2a$12$023ly6Mcks.e1dsGog/EpuIB2fdwJyg1QavbJ9GvaI/JRgipGJNBK', '1', '11223344', 'Jane', 'Doe', 'Johnson', '456789123', '48484848');

-- Asignar roles a usuarios
INSERT INTO user_roles (user_id, role_id, created_by) VALUES
(1, 1, '48484848'), -- admin tiene rol ADMIN
(1, 2, '48484848'), -- admin también tiene rol USER
(2, 2, '48484848'), -- johndoe tiene rol USER
(3, 2, '48484848'), -- janedoe tiene rol USER
(3, 3, '48484848'); -- janedoe también tiene rol MODERATOR

-- Datos de ejemplo para categorías de farmacia
INSERT INTO categories (name, description, created_by) VALUES
('Analgesicos', 'Medicamentos para alivio del dolor', '48484848'),
('Antibioticos', 'Medicamentos para tratamiento de infecciones', '48484848'),
('Vitaminas', 'Suplementos nutricionales y vitaminas', '48484848'),
('Dermatologia', 'Productos para cuidado y tratamiento de la piel', '48484848'),
('Respiratorio', 'Medicamentos para el sistema respiratorio', '48484848'),
('Digestivo', 'Medicamentos para el sistema digestivo', '48484848'),
('Primeros Auxilios', 'Productos de primeros auxilios y cuidado de heridas', '48484848'),
('Cuidado del Bebé', 'Productos para cuidado de bebés e infantes', '48484848'),
('Cardiovascular', 'Medicamentos para el sistema cardiovascular', '48484848'),
('Neurologia', 'Medicamentos para el sistema nervioso', '48484848'),
('Endocrinologia', 'Medicamentos para trastornos hormonales', '48484848'),
('Oftalmologia', 'Productos para cuidado ocular', '48484848'),
('Otorrinolaringologia', 'Productos para oídos, nariz y garganta', '48484848'),
('Ginecologia', 'Productos para salud femenina', '48484848'),
('Urologia', 'Productos para el sistema urinario', '48484848'),
('Reumatologia', 'Medicamentos para articulaciones y músculos', '48484848'),
('Psiquiatria', 'Medicamentos para salud mental', '48484848'),
('Oncologia', 'Medicamentos para tratamiento de cáncer', '48484848'),
('Higiene Personal', 'Productos de higiene y cuidado personal', '48484848'),
('Equipos Medicos', 'Dispositivos y equipos médicos', '48484848'),
('Homeopatia', 'Productos homeopáticos y naturales', '48484848'),
('Nutricion Deportiva', 'Suplementos para deportistas', '48484848'),
('Geriatria', 'Productos especializados para adultos mayores', '48484848'),
('Planificacion Familiar', 'Productos de planificación familiar', '48484848');

-- Datos de ejemplo para productos de farmacia
INSERT INTO products (name, description, price, stock, category_id, created_by) VALUES
-- Analgesicos (1)
('Paracetamol 500mg', 'Tabletas para alivio del dolor y fiebre', 8.50, 100, 1, '48484848'),
('Ibuprofeno 400mg', 'Antiinflamatorio y analgésico', 12.00, 80, 1, '48484848'),
('Aspirina 100mg', 'Aspirina de baja dosis para protección cardiovascular', 15.50, 60, 1, '48484848'),
('Diclofenaco Gel 1%', 'Gel antiinflamatorio tópico', 18.75, 45, 1, '48484848'),
('Ketorolaco 10mg', 'Analgésico potente para dolor moderado a severo', 22.00, 35, 1, '48484848'),
('Metamizol 500mg', 'Analgésico y antipirético', 14.50, 70, 1, '48484848'),

-- Antibioticos (2)
('Amoxicilina 500mg', 'Antibiótico de amplio espectro', 25.00, 40, 2, '48484848'),
('Azitromicina 250mg', 'Antibiótico para infecciones respiratorias', 35.00, 30, 2, '48484848'),
('Ciprofloxacino 500mg', 'Antibiótico quinolona para infecciones bacterianas', 28.50, 25, 2, '48484848'),
('Clindamicina 300mg', 'Antibiótico para infecciones de piel y tejidos blandos', 42.00, 20, 2, '48484848'),
('Eritromicina 250mg', 'Antibiótico macrólido para infecciones respiratorias', 32.75, 35, 2, '48484848'),
('Cefalexina 500mg', 'Antibiótico cefalosporina de primera generación', 38.00, 28, 2, '48484848'),

-- Vitaminas (3)
('Vitamina C 1000mg', 'Soporte para el sistema inmunológico', 18.00, 150, 3, '48484848'),
('Complejo Multivitamínico', 'Suplemento vitamínico diario completo', 22.50, 120, 3, '48484848'),
('Vitamina D3 2000 UI', 'Soporte para huesos y sistema inmune', 20.00, 90, 3, '48484848'),
('Vitamina B12 1000mcg', 'Esencial para el sistema nervioso y energía', 25.00, 80, 3, '48484848'),
('Ácido Fólico 5mg', 'Esencial para embarazo y formación de glóbulos rojos', 16.50, 100, 3, '48484848'),
('Vitamina E 400 UI', 'Antioxidante para protección celular', 19.75, 65, 3, '48484848'),
('Omega 3 1000mg', 'Ácidos grasos esenciales para salud cardiovascular', 35.00, 50, 3, '48484848'),

-- Dermatologia (4)
('Crema Hidrocortisona 1%', 'Crema antiinflamatoria para la piel', 14.00, 70, 4, '48484848'),
('Crema Antifúngica', 'Tratamiento para infecciones fúngicas de la piel', 16.50, 50, 4, '48484848'),
('Protector Solar FPS 50', 'Protección solar de amplio espectro', 28.00, 85, 4, '48484848'),
('Crema para Eczema', 'Tratamiento para dermatitis y eczema', 24.50, 40, 4, '48484848'),
('Loción Calamina', 'Alivio para picazón e irritaciones cutáneas', 12.75, 60, 4, '48484848'),
('Crema Cicatrizante', 'Acelera la cicatrización de heridas menores', 18.25, 55, 4, '48484848'),

-- Respiratorio (5)
('Jarabe para la Tos', 'Alivio para tos seca y productiva', 18.50, 85, 5, '48484848'),
('Spray Nasal Descongestionante', 'Alivio rápido para congestión nasal', 12.50, 95, 5, '48484848'),
('Salbutamol Inhalador', 'Broncodilatador para asma y EPOC', 45.00, 30, 5, '48484848'),
('Pastillas para la Garganta', 'Alivio para dolor de garganta', 8.75, 120, 5, '48484848'),
('Expectorante Guaifenesina', 'Ayuda a expulsar mucosidad', 15.50, 70, 5, '48484848'),
('Antihistamínico Loratadina', 'Para alergias y rinitis', 14.25, 80, 5, '48484848'),

-- Digestivo (6)
('Tabletas Antiácidas', 'Alivio para acidez y indigestión', 9.50, 110, 6, '48484848'),
('Cápsulas Probióticas', 'Soporte para salud digestiva', 28.00, 45, 6, '48484848'),
('Loperamida 2mg', 'Tratamiento para diarrea', 12.50, 75, 6, '48484848'),
('Omeprazol 20mg', 'Inhibidor de bomba de protones para acidez', 22.00, 60, 6, '48484848'),
('Sales de Rehidratación Oral', 'Reposición de electrolitos', 8.25, 90, 6, '48484848'),
('Simeticona 40mg', 'Alivio para gases y distensión abdominal', 11.75, 85, 6, '48484848'),

-- Primeros Auxilios (7)
('Vendas Adhesivas Variadas', 'Protección para heridas de varios tamaños', 6.50, 200, 7, '48484848'),
('Solución Antiséptica', 'Limpieza y desinfección de heridas', 11.00, 75, 7, '48484848'),
('Gasa Estéril 10x10cm', 'Cobertura estéril para heridas', 5.25, 150, 7, '48484848'),
('Alcohol Isopropílico 70%', 'Desinfectante de uso general', 7.50, 100, 7, '48484848'),
('Agua Oxigenada 10 vol', 'Antiséptico para limpieza de heridas', 4.75, 120, 7, '48484848'),
('Vendaje Elástico', 'Soporte para esguinces y lesiones', 9.25, 80, 7, '48484848'),

-- Cuidado del Bebé (8)
('Termómetro Digital Bebé', 'Termómetro digital para infantes', 35.00, 25, 8, '48484848'),
('Loción Bebé', 'Loción humectante suave para piel sensible', 16.00, 60, 8, '48484848'),
('Champú Bebé Sin Lágrimas', 'Champú suave para cabello delicado', 14.50, 70, 8, '48484848'),
('Pañales Desechables Talla M', 'Pañales absorbentes para bebés', 42.00, 40, 8, '48484848'),
('Toallitas Húmedas Bebé', 'Toallitas suaves para limpieza', 12.75, 85, 8, '48484848'),
('Crema para Pañalitis', 'Protección contra irritaciones del pañal', 18.25, 55, 8, '48484848'),

-- Cardiovascular (9)
('Enalapril 10mg', 'Inhibidor ACE para hipertensión', 15.50, 60, 9, '48484848'),
('Atorvastatina 20mg', 'Estatina para control de colesterol', 28.75, 45, 9, '48484848'),
('Metoprolol 50mg', 'Betabloqueador para hipertensión', 22.00, 40, 9, '48484848'),
('Losartán 50mg', 'Bloqueador de receptores de angiotensina', 18.25, 55, 9, '48484848'),
('Furosemida 40mg', 'Diurético para retención de líquidos', 12.50, 70, 9, '48484848'),
('Aspirina Cardio 100mg', 'Protección cardiovascular', 16.75, 80, 9, '48484848'),

-- Neurologia (10)
('Paracetamol + Cafeína', 'Analgésico con estimulante para cefaleas', 14.50, 65, 10, '48484848'),
('Sumatriptán 50mg', 'Tratamiento específico para migraña', 85.00, 15, 10, '48484848'),
('Gabapentina 300mg', 'Anticonvulsivante para dolor neuropático', 45.00, 25, 10, '48484848'),
('Clonazepam 0.5mg', 'Benzodiacepina para ansiedad y convulsiones', 18.75, 30, 10, '48484848'),
('Levodopa + Carbidopa', 'Tratamiento para enfermedad de Parkinson', 125.00, 10, 10, '48484848'),

-- Endocrinologia (11)
('Metformina 850mg', 'Antidiabético para diabetes tipo 2', 16.50, 80, 11, '48484848'),
('Levotiroxina 100mcg', 'Hormona tiroidea para hipotiroidismo', 22.00, 60, 11, '48484848'),
('Glibenclamida 5mg', 'Sulfonilurea para diabetes tipo 2', 14.75, 70, 11, '48484848'),
('Insulina Glargina', 'Insulina de acción prolongada', 95.00, 20, 11, '48484848'),
('Prednisona 20mg', 'Corticosteroide antiinflamatorio', 12.25, 50, 11, '48484848'),

-- Oftalmologia (12)
('Gotas Oculares Lubricantes', 'Lágrimas artificiales para ojo seco', 18.50, 45, 12, '48484848'),
('Colirio Antibiótico', 'Tratamiento para infecciones oculares', 25.00, 30, 12, '48484848'),
('Gotas para Conjuntivitis', 'Alivio para irritación ocular', 16.75, 40, 12, '48484848'),
('Colirio Antihistamínico', 'Para alergias oculares', 22.50, 35, 12, '48484848'),

-- Otorrinolaringologia (13)
('Gotas Óticas', 'Tratamiento para infecciones del oído', 19.50, 35, 13, '48484848'),
('Spray Nasal Salino', 'Limpieza nasal suave', 12.00, 60, 13, '48484848'),
('Pastillas para Garganta con Miel', 'Alivio natural para dolor de garganta', 9.75, 80, 13, '48484848'),
('Descongestionante Nasal', 'Alivio para congestión nasal severa', 15.25, 50, 13, '48484848'),

-- Ginecologia (14)
('Óvulos Vaginales Antifúngicos', 'Tratamiento para candidiasis vaginal', 28.50, 25, 14, '48484848'),
('Ácido Fólico Prenatal', 'Suplemento esencial durante el embarazo', 18.75, 60, 14, '48484848'),
('Prueba de Embarazo', 'Detección rápida de embarazo en orina', 12.50, 40, 14, '48484848'),
('Gel Lubricante Vaginal', 'Lubricante íntimo a base de agua', 16.25, 35, 14, '48484848'),

-- Urologia (15)
('Arándano Rojo Cápsulas', 'Prevención de infecciones urinarias', 24.00, 40, 15, '48484848'),
('Tamsulosina 0.4mg', 'Tratamiento para hiperplasia prostática', 32.50, 25, 15, '48484848'),
('Fenazopiridina 200mg', 'Analgésico urinario', 18.75, 35, 15, '48484848'),

-- Reumatologia (16)
('Glucosamina + Condroitina', 'Suplemento para salud articular', 45.00, 30, 16, '48484848'),
('Gel Antiinflamatorio', 'Alivio tópico para dolor muscular y articular', 22.50, 50, 16, '48484848'),
('Parches de Calor', 'Alivio térmico para dolor muscular', 15.75, 60, 16, '48484848'),
('Colágeno Hidrolizado', 'Suplemento para articulaciones y piel', 38.00, 25, 16, '48484848'),

-- Psiquiatria (17)
('Sertralina 50mg', 'Antidepresivo ISRS', 35.00, 30, 17, '48484848'),
('Fluoxetina 20mg', 'Antidepresivo para depresión y ansiedad', 28.50, 40, 17, '48484848'),
('Alprazolam 0.25mg', 'Ansiolítico para trastornos de ansiedad', 22.75, 25, 17, '48484848'),

-- Oncologia (18)
('Ondansetrón 8mg', 'Antiemético para náuseas por quimioterapia', 65.00, 15, 18, '48484848'),
('Morfina de Liberación Prolongada', 'Analgésico potente para dolor oncológico', 125.00, 8, 18, '48484848'),

-- Higiene Personal (19)
('Champú Anticaspa', 'Tratamiento para caspa y dermatitis seborreica', 18.50, 45, 19, '48484848'),
('Jabón Antibacterial', 'Limpieza antibacterial de manos', 8.75, 100, 19, '48484848'),
('Desodorante Antitranspirante', 'Protección 48 horas contra sudor', 14.25, 70, 19, '48484848'),
('Pasta Dental Fluorada', 'Protección contra caries y placa', 12.50, 85, 19, '48484848'),
('Enjuague Bucal Antiséptico', 'Elimina bacterias y refresca el aliento', 16.75, 60, 19, '48484848'),

-- Equipos Medicos (20)
('Tensiómetro Digital', 'Monitor de presión arterial automático', 85.00, 15, 20, '48484848'),
('Glucómetro + Tiras', 'Monitor de glucosa en sangre', 65.00, 20, 20, '48484848'),
('Nebulizador Ultrasónico', 'Dispositivo para terapia respiratoria', 120.00, 10, 20, '48484848'),
('Termómetro Infrarrojo', 'Medición de temperatura sin contacto', 45.00, 25, 20, '48484848'),
('Oxímetro de Pulso', 'Monitor de saturación de oxígeno', 55.00, 18, 20, '48484848'),

-- Homeopatia (21)
('Árnica Montana 30CH', 'Remedio homeopático para traumatismos', 16.50, 40, 21, '48484848'),
('Oscillococcinum', 'Tratamiento homeopático para síntomas gripales', 25.00, 30, 21, '48484848'),
('Belladonna 30CH', 'Para fiebre y dolor pulsátil', 14.75, 35, 21, '48484848'),
('Rescue Remedy', 'Flores de Bach para situaciones de estrés', 22.50, 25, 21, '48484848'),

-- Nutricion Deportiva (22)
('Proteína Whey Isolate', 'Proteína de suero aislada para deportistas', 85.00, 20, 22, '48484848'),
('Creatina Monohidrato', 'Suplemento para rendimiento deportivo', 35.00, 30, 22, '48484848'),
('BCAA Aminoácidos', 'Aminoácidos ramificados para recuperación', 42.50, 25, 22, '48484848'),
('Bebida Isotónica', 'Reposición de electrolitos durante ejercicio', 8.75, 60, 22, '48484848'),
('Pre-entreno Energizante', 'Suplemento pre-entrenamiento', 48.00, 20, 22, '48484848'),

-- Geriatria (23)
('Suplemento de Calcio + D3', 'Prevención de osteoporosis en adultos mayores', 28.00, 40, 23, '48484848'),
('Ginkgo Biloba', 'Suplemento para función cognitiva', 32.50, 35, 23, '48484848'),
('Complejo B para Seniors', 'Vitaminas B específicas para adultos mayores', 24.75, 45, 23, '48484848'),
('Pastillero Semanal', 'Organizador de medicamentos por días', 15.50, 30, 23, '48484848'),

-- Planificacion Familiar (24)
('Preservativos Lubricados', 'Protección y prevención de ETS', 12.50, 80, 24, '48484848'),
('Gel Espermicida', 'Método anticonceptivo complementario', 18.75, 25, 24, '48484848'),
('Anticonceptivos de Emergencia', 'Píldora del día después', 35.00, 15, 24, '48484848'),
('Test de Ovulación', 'Detección de días fértiles', 28.50, 20, 24, '48484848');
