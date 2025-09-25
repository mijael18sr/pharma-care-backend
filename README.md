# 🏥 PharmaCare+ Backend - API REST para E-commerce Farmacéutico

[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5.5-green?style=for-the-badge&logo=spring)](https://spring.io/projects/spring-boot)
[![Java](https://img.shields.io/badge/Java-21-orange?style=for-the-badge&logo=openjdk)](https://adoptium.net/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue?style=for-the-badge&logo=postgresql)](https://postgresql.org/)
[![JWT](https://img.shields.io/badge/JWT-Security-black?style=for-the-badge&logo=jsonwebtokens)](https://jwt.io/)

Este es el backend del proyecto **PharmaCare+**, una API REST robusta desarrollada en Java con Spring Boot, siguiendo el patrón MVC y arquitectura de capas. Proporciona servicios seguros para la gestión completa de un e-commerce farmacéutico.

## 🌟 Características Principales

### 🔐 **Seguridad y Autenticación**
- **JWT (JSON Web Tokens)**: Autenticación stateless y segura
- **Roles de Usuario**: ADMIN, USER, MODERATOR con permisos granulares
- **Spring Security**: Configuración avanzada de seguridad
- **Autorización basada en endpoints**: Control de acceso por rol

### 🛒 **Funcionalidades E-commerce**
- **Gestión de Productos**: CRUD completo con categorías farmacéuticas
- **Carrito de Compras**: Operaciones de agregar, actualizar, eliminar productos
- **Proceso de Checkout**: Simulación completa de proceso de pago
- **Gestión de Inventario**: Control de stock y disponibilidad

### 📊 **Base de Datos Farmacéutica**
- **24+ Categorías**: Medicamentos especializados por área médica
- **100+ Productos**: Catálogo completo de productos farmacéuticos
- **Datos Realistas**: Precios, stocks y descripciones auténticas
- **Relaciones Normalizadas**: Estructura de BD optimizada

### 🔌 **API REST Completa**
- **Endpoints RESTful**: Arquitectura estándar con HTTP verbs
- **Documentación Swagger**: API autodocumentada
- **Manejo de Errores**: Respuestas consistentes y descriptivas
- **CORS Configurado**: Integración con frontend Angular

## 🛠️ Stack Tecnológico

### **Backend Framework**
| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **Java** | 21 LTS | Lenguaje de programación principal |
| **Spring Boot** | 3.5.5 | Framework de aplicación |
| **Spring Web** | 6.2.x | Desarrollo de API REST |
| **Spring Security** | 6.4.x | Autenticación y autorización |
| **Spring Data JPA** | 3.4.x | Persistencia de datos con Hibernate |
| **Spring Validation** | 6.2.x | Validación de datos de entrada |

### **Base de Datos y Persistencia**
| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **PostgreSQL** | 15+ | Base de datos principal |
| **Hibernate** | 6.6.x | ORM (Object-Relational Mapping) |
| **HikariCP** | 6.2.x | Pool de conexiones de BD |
| **Flyway** | 10.x | Migración de esquemas |

### **Herramientas y Utilidades**
| Tecnología | Versión | Propósito |
|------------|---------|-----------|
| **Maven** | 3.9+ | Gestión de dependencias y build |
| **Lombok** | 1.18.x | Reducción de código boilerplate |
| **Jackson** | 2.18.x | Serialización JSON |
| **BCrypt** | - | Encriptación de contraseñas |
| **JJWT** | 0.12.x | Manejo de tokens JWT |

## � Docker y Configuración

### **Archivo `compose.yaml` incluido**

El proyecto incluye un archivo **`compose.yaml`** configurado para desarrollo rápido:

```yaml
services:
  postgres:
    image: postgres:latest
    environment:
      - 'POSTGRES_DB=bd_carrito_compras'
      - 'POSTGRES_PASSWORD=CarritoCompra123'
      - 'POSTGRES_USER=pharma_care'
    ports:
      - "5433:5432"
```

**Ventajas del compose.yaml:**
- ✅ **Configuración lista**: Credenciales que coinciden con `application.yml`
- ✅ **Puerto correcto**: 5433 para evitar conflictos
- ✅ **PostgreSQL reciente**: Imagen `postgres:latest`
- ✅ **Inicio rápido**: Un solo comando para levantar BD

### **Configuración en `application.yml`**

```yaml
server:
  port: 8085

spring:
  application:
    name: pharma-care
  datasource:
    url: jdbc:postgresql://localhost:5433/bd_carrito_compras
    username: pharma_care
    password: CarritoCompra123
  jpa:
    defer-datasource-initialization: true
    hibernate:
      ddl-auto: none  # Usar carrito.sql para esquema
    show-sql: true

jwt:
  secret: ${JWT_SECRET:mySecretKeyForCitaSaludApplicationThatShouldBeAtLeast256BitsLong}
  expiration: 86400000  # 24 horas
```

## �🗄️ Esquema de Base de Datos

### **Archivo `carrito.sql` - Esquema Completo**

El proyecto incluye el archivo **`src/main/resources/carrito.sql`** que contiene:

#### � **Estructura de Tablas**
| Tabla | Propósito | Relaciones |
|-------|-----------|------------|
| **`roles`** | Roles del sistema (ADMIN, USER, MODERATOR) | - |
| **`users`** | Información de usuarios registrados | → `user_roles` |
| **`user_roles`** | Relación N:N entre usuarios y roles | `users` ← → `roles` |
| **`categories`** | Categorías de productos farmacéuticos | → `products` |
| **`products`** | Catálogo de productos de farmacia | `categories` ← |
| **`shopping_carts`** | Carritos de compra de usuarios | `users` ← → `shopping_cart_details` |
| **`shopping_cart_details`** | Elementos dentro de cada carrito | `shopping_carts` ← → `products` |
| **`payment_details`** | Información de pagos procesados | `shopping_carts` ← |

#### 🏥 **Datos Farmacéuticos Incluidos**
- **24 Categorías Médicas**: Analgésicos, Antibióticos, Vitaminas, Dermatología, etc.
- **100+ Productos Reales**: Medicamentos con nombres, precios y stocks realistas
- **Usuarios de Prueba**: Admin y usuarios regulares con credenciales
- **Índices Optimizados**: Para consultas eficientes

#### 🔍 **Características del Esquema**
```sql
-- Auditoría completa
created_by, created_at, updated_by, updated_at

-- Control de estados
status VARCHAR(1) -- '1'=Activo, '0'=Inactivo, '2'=Eliminado

-- Integridad referencial
CONSTRAINT fk_products_category FOREIGN KEY (category_id) 
REFERENCES categories(id) ON DELETE RESTRICT

-- Índices para rendimiento
CREATE INDEX idx_products_name ON products(name);
CREATE INDEX idx_products_price ON products(price);
```

### **Trabajar con `carrito.sql`**

#### 🚀 **Opción 1: Ejecución Manual (Recomendada)**
```bash
# 1. Conectar a PostgreSQL
psql -h localhost -p 5433 -U carrito_compra -d bd_carrito_compras

# 2. Ejecutar el script completo
\i src/main/resources/carrito.sql

# 3. Verificar datos
SELECT COUNT(*) FROM products;  -- Debe mostrar 100+
SELECT COUNT(*) FROM categories; -- Debe mostrar 24
```

#### 🔄 **Opción 2: Auto-ejecución con Spring Boot**
```yaml
# En application.yml
spring:
  jpa:
    hibernate:
      ddl-auto: none  # Desactivar auto-creación
  sql:
    init:
      mode: always
      schema-locations: classpath:carrito.sql
```

#### 🧪 **Opción 3: Para Desarrollo/Testing**
- Mantener `ddl-auto: update` para desarrollo
- `data.sql` se ejecuta automáticamente después de crear tablas
- Útil para resetear datos durante desarrollo

---

## ⚡ Inicio Rápido (2 minutos)

```bash
# 1. Clonar y navegar al proyecto
git clone <repo-url>
cd carrito-capas/carrito-compra-farmacia-backend

# 2. Levantar PostgreSQL con Docker Compose
docker compose up -d

# 3. Esperar que PostgreSQL esté listo (15-30 segundos)
docker compose logs postgres

# 4. Ejecutar esquema de base de datos
docker compose exec -T postgres psql -U pharma_care -d bd_carrito_compras < src/main/resources/carrito.sql

# 5. Ejecutar la aplicación Spring Boot
./mvnw spring-boot:run
```

**✅ Verificar que todo funciona:**
- Backend: [http://localhost:8085](http://localhost:8085)
- Test login: `curl -X POST http://localhost:8085/api/auth/login -H "Content-Type: application/json" -d '{"username":"admin","password":"admin2025"}'`

---

## 🚀 Guía de Instalación Detallada

### 📋 Prerrequisitos

| Herramienta | Versión Mínima | Enlace de Descarga | Verificar Instalación |
|-------------|----------------|-------------------|----------------------|
| **Java JDK** | 21 LTS | [adoptium.net](https://adoptium.net/temurin/releases/?version=21) | `java -version` |
| **PostgreSQL** | 15+ | [postgresql.org](https://www.postgresql.org/download/) | `psql --version` |
| **Git** | 2.x | [git-scm.com](https://git-scm.com/downloads) | `git --version` |
| **Docker** (Opcional) | 20.x | [docker.com/get-started](https://www.docker.com/get-started/) | `docker --version` |

> **💡 Nota:** Maven no requiere instalación separada - el proyecto incluye Maven Wrapper (`mvnw`)

### 🔧 Configuración de Base de Datos

#### **Opción A: PostgreSQL con Docker (Recomendada)**

1. **Crear contenedor PostgreSQL:**
```bash
# Crear y ejecutar PostgreSQL en Docker
docker run --name postgres-pharmacare \
  -e POSTGRES_DB=bd_carrito_compras \
  -e POSTGRES_USER=pharma_care \
  -e POSTGRES_PASSWORD=CarritoCompra123 \
  -p 5433:5432 \
  -d postgres:latest

# Verificar que esté ejecutándose
docker ps
```

2. **Ejecutar esquema completo:**
```bash
# Copiar carrito.sql al contenedor
docker cp src/main/resources/carrito.sql postgres-pharmacare:/carrito.sql

# Ejecutar el script
docker exec -it postgres-pharmacare psql -U pharma_care -d bd_carrito_compras -f /carrito.sql
```

#### **Opción B: PostgreSQL Instalación Local**

1. **Crear base de datos:**
```sql
-- Conectar como superusuario
psql -U postgres

-- Crear base de datos y usuario
CREATE DATABASE bd_carrito_compras;
CREATE USER pharma_care WITH PASSWORD 'CarritoCompra123';
GRANT ALL PRIVILEGES ON DATABASE bd_carrito_compras TO pharma_care;
GRANT ALL ON SCHEMA public TO pharma_care;

-- Salir y conectar con el nuevo usuario
\q
psql -h localhost -p 5433 -U pharma_care -d bd_carrito_compras
```

2. **Ejecutar esquema:**
```bash
# Ejecutar el script completo de carrito.sql
\i src/main/resources/carrito.sql

# Verificar datos cargados
SELECT 
  (SELECT COUNT(*) FROM roles) as roles,
  (SELECT COUNT(*) FROM users) as users,
  (SELECT COUNT(*) FROM categories) as categories,
  (SELECT COUNT(*) FROM products) as products;
```

#### **Opción C: Docker Compose (Recomendada)**

1. **Usar el archivo `compose.yaml` incluido:**
```yaml
services:
  postgres:
    image: postgres:latest
    environment:
      - 'POSTGRES_DB=bd_carrito_compras'
      - 'POSTGRES_PASSWORD=CarritoCompra123'
      - 'POSTGRES_USER=pharma_care'
    ports:
      - "5433:5432"
```

2. **Ejecutar:**
```bash
# Desde la raíz del proyecto backend
docker-compose up -d

# O usar el nuevo comando
docker compose up -d

# Verificar que esté ejecutándose
docker compose ps
```

3. **Ejecutar esquema después del primer inicio:**
```bash
# Esperar que PostgreSQL esté listo (unos segundos)
docker compose exec postgres psql -U pharma_care -d bd_carrito_compras -c "SELECT version();"

# Ejecutar el script carrito.sql
docker compose exec -T postgres psql -U pharma_care -d bd_carrito_compras < src/main/resources/carrito.sql
```

### 📁 Clonar y Configurar Proyecto

```bash
# 1. Clonar repositorio
git clone <url-del-repositorio>
cd carrito-capas/carrito-compra-farmacia-backend

# 2. Verificar configuración en application.yml
# Asegurar que los datos coincidan con tu BD:
spring:
  datasource:
    url: jdbc:postgresql://localhost:5433/bd_carrito_compras
    username: pharma_care
    password: CarritoCompra123
```

### 🚀 Ejecutar la Aplicación

```bash
# Opción 1: Maven Wrapper (Recomendada)
# Windows
./mvnw.cmd spring-boot:run

# Linux/macOS/Git Bash
./mvnw spring-boot:run

# Opción 2: Maven instalado localmente
mvn spring-boot:run

# Opción 3: Ejecutar JAR compilado
./mvnw clean package
java -jar target/pharmacare-plus-0.0.1-SNAPSHOT.jar

# Opción 4: Con perfil específico
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev
```

### ✅ Verificar Instalación

Una vez iniciada la aplicación, verifica que todo esté funcionando:

**🌐 URLs de Acceso:**
- **API Base:** [http://localhost:8085](http://localhost:8085)
- **Health Check:** [http://localhost:8085/actuator/health](http://localhost:8085/actuator/health)
- **API Docs:** [http://localhost:8085/swagger-ui.html](http://localhost:8085/swagger-ui.html) (si está configurado)

**� Configuración Actual del Proyecto:**

| Componente | Valor Actual | Archivo |
|------------|--------------|---------|
| **Usuario BD** | `pharma_care` | `application.yml`, `compose.yaml` |
| **Password BD** | `CarritoCompra123` | `application.yml`, `compose.yaml` |
| **Base de Datos** | `bd_carrito_compras` | `application.yml`, `compose.yaml` |
| **Puerto PostgreSQL** | `5433` | `application.yml`, `compose.yaml` |
| **Puerto Backend** | `8085` | `application.yml` |
| **Nombre App** | `pharma-care` | `application.yml` |

**�🔐 Credenciales de Prueba:**

| Tipo Usuario | Username | Password | Roles | Descripción |
|--------------|----------|----------|-------|-------------|
| **Administrador** | `admin` | `admin2025` | ROLE_ADMIN, ROLE_USER | Acceso completo a todas las funciones |
| **Usuario Regular** | `johndoe` | `admin2025` | ROLE_USER | Solo funciones de cliente |
| **Moderador** | `janedoe` | `admin2025` | ROLE_USER, ROLE_MODERATOR | Permisos intermedios |

**🧪 Test de Conexión:**
```bash
# Test de login
curl -X POST http://localhost:8085/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin2025"}'

# Debería retornar algo como:
# {"token":"eyJhbGciOiJIUzI1NiJ9...","username":"admin","roles":["ROLE_ADMIN","ROLE_USER"]}
```

---

## 🔌 Documentación de la API

### **Endpoints de Autenticación**

#### **POST /api/auth/login**
Iniciar sesión y obtener token JWT.

```bash
curl -X POST http://localhost:8085/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{
    "username": "admin",
    "password": "admin2025"
  }'
```

**Respuesta exitosa (200):**
```json
{
  "token": "eyJhbGciOiJIUzI1NiJ9...",
  "username": "admin",
  "roles": ["ROLE_ADMIN", "ROLE_USER"],
  "expiresIn": 86400
}
```

### **Endpoints de Productos (Público)**

#### **GET /api/products**
Obtener lista de productos disponibles.

```bash
curl -X GET http://localhost:8085/api/products
```

#### **GET /api/products/{id}**
Obtener un producto específico por ID.

```bash
curl -X GET http://localhost:8085/api/products/1
```

#### **GET /api/categories**
Obtener lista de categorías de productos.

```bash
curl -X GET http://localhost:8085/api/categories
```

### **Endpoints de Administración (Requiere ROLE_ADMIN)**

#### **GET /api/products-manager**
Obtener productos para administración (incluye productos inactivos).

```bash
curl -X GET http://localhost:8085/api/products-manager \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

#### **POST /api/products-manager**
Crear nuevo producto.

```bash
curl -X POST http://localhost:8085/api/products-manager \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "name": "Nuevo Producto",
    "description": "Descripción del producto",
    "price": 25.50,
    "stock": 100,
    "categoryId": 1,
    "imageUrl": "https://example.com/image.jpg"
  }'
```

#### **PUT /api/products-manager/{id}**
Actualizar producto existente.

```bash
curl -X PUT http://localhost:8085/api/products-manager/1 \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "name": "Producto Actualizado",
    "description": "Nueva descripción",
    "price": 30.00,
    "stock": 150,
    "categoryId": 1,
    "imageUrl": "https://example.com/new-image.jpg"
  }'
```

#### **DELETE /api/products-manager/{id}**
Eliminar producto (soft delete).

```bash
curl -X DELETE http://localhost:8085/api/products-manager/1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### **Endpoints de Carrito de Compras**

#### **GET /api/cart/{userId}**
Obtener carrito de un usuario.

```bash
curl -X GET http://localhost:8085/api/cart/1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

#### **POST /api/cart/add**
Agregar producto al carrito.

```bash
curl -X POST http://localhost:8085/api/cart/add \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "userId": 1,
    "productId": 1,
    "quantity": 2
  }'
```

#### **PUT /api/cart/update**
Actualizar cantidad de producto en carrito.

```bash
curl -X PUT http://localhost:8085/api/cart/update \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "cartItemId": 1,
    "quantity": 3
  }'
```

#### **DELETE /api/cart/remove/{itemId}**
Quitar producto del carrito.

```bash
curl -X DELETE http://localhost:8085/api/cart/remove/1 \
  -H "Authorization: Bearer YOUR_JWT_TOKEN"
```

### **Endpoints de Checkout**

#### **POST /api/checkout/process**
Procesar compra y pago.

```bash
curl -X POST http://localhost:8085/api/checkout/process \
  -H "Content-Type: application/json" \
  -H "Authorization: Bearer YOUR_JWT_TOKEN" \
  -d '{
    "userId": 1,
    "cartId": 1,
    "paymentDetails": {
      "cardholder": "Juan Pérez",
      "cardNumber": "4111111111111111",
      "expireDate": "12/25",
      "securityCode": "123",
      "paymentMethod": "CREDIT_CARD"
    }
  }'
```

### **Códigos de Respuesta HTTP**

| Código | Descripción | Cuándo se usa |
|--------|-------------|---------------|
| **200** | OK | Operación exitosa |
| **201** | Created | Recurso creado exitosamente |
| **400** | Bad Request | Datos de entrada inválidos |
| **401** | Unauthorized | Token JWT faltante o inválido |
| **403** | Forbidden | Usuario sin permisos suficientes |
| **404** | Not Found | Recurso no encontrado |
| **409** | Conflict | Conflicto (ej: producto ya existe) |
| **500** | Internal Server Error | Error interno del servidor |

---

## 🧪 Comandos de Desarrollo

### **Build y Compilación**
```bash
# Compilar sin ejecutar tests
./mvnw clean compile

# Compilar y ejecutar tests
./mvnw clean test

# Crear JAR de producción
./mvnw clean package

# Instalar en repositorio local Maven
./mvnw clean install

# Compilar saltando tests (desarrollo rápido)
./mvnw clean package -DskipTests
```

### **Ejecución con Perfiles**
```bash
# Perfil de desarrollo
./mvnw spring-boot:run -Dspring-boot.run.profiles=dev

# Perfil de producción
./mvnw spring-boot:run -Dspring-boot.run.profiles=prod

# Con variables de entorno personalizadas
./mvnw spring-boot:run -Dspring-boot.run.jvmArguments="-Dserver.port=8090"
```

### **Base de Datos - Comandos Útiles**
```bash
# Conectar a PostgreSQL
psql -h localhost -p 5433 -U pharma_care -d bd_carrito_compras

# Listar tablas
\dt

# Ver estructura de tabla
\d products

# Verificar datos cargados
SELECT COUNT(*) FROM products WHERE status = '1';
SELECT name, COUNT(*) as total FROM categories 
JOIN products ON categories.id = products.category_id 
GROUP BY name ORDER BY total DESC;

# Resetear datos (cuidado - elimina todo)
\i src/main/resources/carrito.sql
```

### **Testing y Calidad**
```bash
# Ejecutar solo tests unitarios
./mvnw test

# Ejecutar tests de integración
./mvnw integration-test

# Generar reporte de cobertura
./mvnw jacoco:report

# Análisis de código con SonarQube (si está configurado)
./mvnw sonar:sonar
```

---

## 🚢 Despliegue en Producción

### **Opción 1: JAR Ejecutable**
```bash
# 1. Crear JAR optimizado
./mvnw clean package -Pprod

# 2. Ejecutar en producción
java -jar target/pharmacare-plus-0.0.1-SNAPSHOT.jar \
  --spring.profiles.active=prod \
  --server.port=8085
```

### **Opción 2: Docker**
```dockerfile
# Dockerfile
FROM openjdk:21-jre-slim

WORKDIR /app
COPY target/pharmacare-plus-0.0.1-SNAPSHOT.jar app.jar

EXPOSE 8085
ENTRYPOINT ["java", "-jar", "app.jar"]
```

```bash
# Construir imagen
docker build -t pharmacare-backend .

# Ejecutar contenedor
docker run -d -p 8085:8085 \
  -e SPRING_PROFILES_ACTIVE=prod \
  pharmacare-backend
```

### **Opción 3: Docker Compose (Completo con Backend)**
```yaml
services:
  postgres:
    image: postgres:latest
    environment:
      - 'POSTGRES_DB=bd_carrito_compras'
      - 'POSTGRES_PASSWORD=CarritoCompra123'
      - 'POSTGRES_USER=pharma_care'
    ports:
      - "5433:5432"
    volumes:
      - postgres_data:/var/lib/postgresql/data
      - ./src/main/resources/carrito.sql:/docker-entrypoint-initdb.d/carrito.sql
    networks:
      - pharmacare-network

  backend:
    build: .
    ports:
      - "8085:8085"
    environment:
      SPRING_PROFILES_ACTIVE: prod
      SPRING_DATASOURCE_URL: jdbc:postgresql://postgres:5432/bd_carrito_compras
      SPRING_DATASOURCE_USERNAME: pharma_care
      SPRING_DATASOURCE_PASSWORD: CarritoCompra123
      JWT_SECRET: mySecretKeyForCitaSaludApplicationThatShouldBeAtLeast256BitsLong
    depends_on:
      - postgres
    networks:
      - pharmacare-network

volumes:
  postgres_data:

networks:
  pharmacare-network:
```

---

## 🔍 Troubleshooting

### **Problemas Comunes y Soluciones**

#### ❌ **Error de Conexión a Base de Datos**
```
org.postgresql.util.PSQLException: Connection refused
```

**Soluciones:**
```bash
# 1. Verificar que PostgreSQL esté ejecutándose
# Docker:
docker ps | grep postgres

# Local:
sudo service postgresql status  # Linux
brew services list | grep postgres  # macOS

# 2. Verificar puerto y credenciales en application.yml
spring:
  datasource:
    url: jdbc:postgresql://localhost:5433/bd_carrito_compras  # Puerto correcto?
    username: pharma_care  # Usuario correcto?
    password: CarritoCompra123  # Contraseña correcta?

# 3. Test de conexión manual
psql -h localhost -p 5433 -U pharma_care -d bd_carrito_compras
```

#### ❌ **Error de Autenticación JWT**
```
JWT signature does not match locally computed signature
```

**Soluciones:**
```bash
# 1. Verificar clave secreta en application.yml
jwt:
  secret: ${JWT_SECRET:mySecretKeyForCitaSaludApplicationThatShouldBeAtLeast256BitsLong}
  expiration: 86400000  # 24 horas en milisegundos

# 2. Regenerar token
curl -X POST http://localhost:8085/api/auth/login \
  -H "Content-Type: application/json" \
  -d '{"username":"admin","password":"admin2025"}'
```

#### ❌ **Puerto ya en uso**
```
Port 8085 is already in use
```

**Soluciones:**
```bash
# 1. Cambiar puerto en application.yml
server:
  port: 8086  # Usar puerto diferente

# 2. Matar proceso que usa el puerto
# Windows:
netstat -ano | findstr :8085
taskkill /PID <PID_NUMBER> /F

# Linux/macOS:
lsof -ti:8085 | xargs kill -9

# 3. Ejecutar en puerto específico
./mvnw spring-boot:run -Dserver.port=8086
```

#### ❌ **Tablas no creadas automáticamente**
```
Table 'products' doesn't exist
```

**Soluciones:**
```bash
# 1. Verificar configuración JPA
spring:
  jpa:
    hibernate:
      ddl-auto: update  # Para desarrollo
      ddl-auto: none    # Para producción con carrito.sql

# 2. Ejecutar carrito.sql manualmente
psql -h localhost -p 5433 -U pharma_care -d bd_carrito_compras -f src/main/resources/carrito.sql

# 3. Verificar logs de Hibernate
logging:
  level:
    org.hibernate.SQL: DEBUG
    org.hibernate.type.descriptor.sql.BasicBinder: TRACE
```

#### ❌ **Error de CORS en Frontend**
```
Access to XMLHttpRequest blocked by CORS policy
```

**Soluciones:**
```java
// Verificar @CrossOrigin en controladores
@CrossOrigin(origins = "http://localhost:4200")
@RestController
public class ProductController {
    // ...
}

// O configuración global en SecurityConfig
@Bean
public CorsConfigurationSource corsConfigurationSource() {
    CorsConfiguration configuration = new CorsConfiguration();
    configuration.setAllowedOrigins(Arrays.asList("http://localhost:4200"));
    configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "DELETE", "OPTIONS"));
    configuration.setAllowedHeaders(Arrays.asList("*"));
    configuration.setAllowCredentials(true);
    // ...
}
```

### **Logs y Debugging**

```bash
# Ver logs en tiempo real
tail -f logs/pharmacare.log

# Habilitar debug para JWT
logging:
  level:
    org.springframework.security: DEBUG
    org.softprimesolutions.carritoapp.security: DEBUG

# Habilitar debug para Base de Datos
logging:
  level:
    org.hibernate.SQL: DEBUG
    org.springframework.jdbc: DEBUG
```

### **Herramientas de Monitoreo**

```yaml
# Habilitar Actuator endpoints
management:
  endpoints:
    web:
      exposure:
        include: health,info,metrics,env
  endpoint:
    health:
      show-details: always
```

**URLs de Monitoreo:**
- Health: `http://localhost:8085/actuator/health`
- Metrics: `http://localhost:8085/actuator/metrics`
- Environment: `http://localhost:8085/actuator/env`

---

## 📊 Estructura del Proyecto

```
carrito-compra-farmacia-backend/
├── src/
│   ├── main/
│   │   ├── java/org/softprimesolutions/carritoapp/
│   │   │   ├── CarritoAppApplication.java      # Clase principal
│   │   │   ├── config/                         # Configuraciones
│   │   │   │   ├── SecurityConfig.java         # Seguridad y CORS
│   │   │   │   └── JwtConfig.java              # Configuración JWT
│   │   │   ├── controller/                     # Controladores REST
│   │   │   │   ├── AuthController.java         # Autenticación
│   │   │   │   ├── ProductController.java      # Productos públicos
│   │   │   │   ├── ProductManagerController.java # Admin productos
│   │   │   │   ├── CategoryController.java     # Categorías
│   │   │   │   ├── CartController.java         # Carrito de compras
│   │   │   │   └── CheckoutController.java     # Proceso de pago
│   │   │   ├── model/                          # Entidades JPA
│   │   │   │   ├── User.java                   # Usuario
│   │   │   │   ├── Role.java                   # Roles
│   │   │   │   ├── Product.java                # Productos
│   │   │   │   ├── Category.java               # Categorías
│   │   │   │   ├── ShoppingCart.java           # Carrito
│   │   │   │   └── PaymentDetails.java         # Detalles de pago
│   │   │   ├── repository/                     # Repositorios JPA
│   │   │   │   ├── UserRepository.java
│   │   │   │   ├── ProductRepository.java
│   │   │   │   └── CategoryRepository.java
│   │   │   ├── service/                        # Lógica de negocio
│   │   │   │   ├── AuthService.java
│   │   │   │   ├── ProductService.java
│   │   │   │   └── CartService.java
│   │   │   ├── security/                       # Seguridad JWT
│   │   │   │   ├── JwtTokenProvider.java
│   │   │   │   ├── JwtAuthenticationFilter.java
│   │   │   │   └── CustomUserDetailsService.java
│   │   │   └── dto/                           # Data Transfer Objects
│   │   │       ├── LoginRequest.java
│   │   │       ├── ProductDto.java
│   │   │       └── CartItemDto.java
│   │   └── resources/
│   │       ├── application.yml                 # Configuración principal
│   │       ├── carrito.sql                    # Esquema completo BD
│   │       └── data.sql                       # Datos iniciales (alternativo)
│   └── test/                                  # Tests unitarios e integración
├── target/                                    # Archivos compilados
├── pom.xml                                    # Dependencias Maven
├── mvnw, mvnw.cmd                            # Maven Wrapper
└── README.md                                  # Esta documentación
```

---

## 🤝 Contribución y Desarrollo

### **Estándares de Código**
- **Java**: Seguir [Google Java Style Guide](https://google.github.io/styleguide/javaguide.html)
- **Spring Boot**: Usar anotaciones estándar y patrones recomendados
- **Git**: Commits con [Conventional Commits](https://www.conventionalcommits.org/)

### **Flujo de Desarrollo**
```bash
# 1. Crear rama para nueva feature
git checkout -b feature/nueva-funcionalidad

# 2. Desarrollar y testear
./mvnw test

# 3. Commit con mensaje descriptivo
git commit -m "feat: agregar endpoint para gestión de categorías"

# 4. Push y crear Pull Request
git push origin feature/nueva-funcionalidad
```

### **Testing**
```bash
# Tests unitarios
./mvnw test

# Tests de integración
./mvnw integration-test

# Coverage report
./mvnw jacoco:report
open target/site/jacoco/index.html
```

---

## 📄 Licencia

Este proyecto está bajo la **Licencia MIT**. Ver [LICENSE](../LICENSE) para más detalles.

---

<div align="center">

**🏥 PharmaCare+ Backend**

*API REST robusta para e-commerce farmacéutico*

[![Spring Boot](https://img.shields.io/badge/Spring%20Boot-3.5.5-green?logo=spring)](https://spring.io/projects/spring-boot)
[![Java](https://img.shields.io/badge/Java-21-orange?logo=openjdk)](https://adoptium.net/)
[![PostgreSQL](https://img.shields.io/badge/PostgreSQL-15-blue?logo=postgresql)](https://postgresql.org/)

*Desarrollado con ❤️ para TECSUP*

</div>