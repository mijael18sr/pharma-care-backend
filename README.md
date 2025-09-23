# Proyecto PharmaCare+

Este es un proyecto de Carrito de Compras desarrollado en Java con Spring Boot, siguiendo el patrón MVC y exponiendo una API REST para la gestión de la lógica de negocio.

## ⭐️ Características

*   **Autenticación y Autorización:** Sistema de login seguro basado en JWT (JSON Web Tokens) con roles de usuario (Admin/Usuario).
*   **Gestión de Productos:** Mantenimiento completo (CRUD) de productos y categorías.
*   **Carrito de Compras:** Funcionalidad para agregar, visualizar, actualizar y eliminar productos del carrito de un usuario.
*   **Proceso de Pago:** Simulación de un proceso de checkout para finalizar la compra.
*   **API REST:** Endpoints para interactuar con los recursos de la aplicación de forma programática.


## 🛠️ Tecnologías Utilizadas

*   **Backend:**
    *   Java 17
    *   Spring Boot
    *   Spring Web
    *   Spring Security (con JWT)
    *   Spring Data JPA (Hibernate)
    *   Spring Validation
    *   Lombok
*   **Frontend (Server-Side):**
    *   Thymeleaf
*   **Base de Datos:**
    *   PostgreSQL
*   **Build Tool:**
    *   Maven
*   **Contenerización:**
    *   Docker & Docker Compose

---

## 🚀 Guía de Instalación y Puesta en Marcha

Sigue estos pasos para configurar y ejecutar el proyecto en tu entorno local.

### 1. Prerrequisitos

Asegúrate de tener instalado el siguiente software. Se incluyen los enlaces para su descarga e instalación:

| Dependencia | Versión Mínima | Enlace de Descarga                                                              |
| :---------- | :------------- | :------------------------------------------------------------------------------ |
| **Git**         | `2.x`          | [git-scm.com/downloads](https://git-scm.com/downloads)                          |
| **JDK**         | `17`           | [adoptium.net (Eclipse Temurin)](https://adoptium.net/temurin/releases/?version=17) |
| **Docker**      | `20.x`         | [docs.docker.com/get-docker](https://docs.docker.com/get-docker/)               |

> **Nota:** No es necesario instalar Maven por separado, ya que el proyecto incluye el Maven Wrapper (`mvnw`), que lo descargará automáticamente.

### 2. Clonar el Repositorio

Abre una terminal y clona el proyecto usando Git:

```bash
git clone https://github.com/tu-usuario/carrito-compra.git
cd carrito-compra
```

### 3. Configurar y Levantar la Base de Datos

La forma más sencilla de iniciar la base de datos es usando Docker, ya que el proyecto incluye un archivo de configuración listo para usar.

En la raíz del proyecto, ejecuta el siguiente comando:

```bash
docker-compose up -d
```

Este comando creará e iniciará un contenedor de Docker con una base de datos PostgreSQL. La base de datos estará accesible en el puerto `5433` de tu máquina local (`localhost`).

> **Importante:** El archivo `application.yml` está configurado para conectarse al puerto `5433`. Debes **modificar el puerto en el archivo de configuración** para que coincida con el que expone Docker.

### 4. Carga de Datos Iniciales

El proyecto está configurado para que Spring Boot se encargue de todo. Al arrancar:
1.  Hibernate (`ddl-auto: update`) revisará y creará las tablas que no existan en la base de datos.
2.  El script `src/main/resources/data.sql` se ejecutará automáticamente para poblar las tablas con datos iniciales (roles, categorías, productos de ejemplo, etc.).

No se requiere ninguna acción manual para este paso.

### 5. Ejecutar la Aplicación

Usa el Maven Wrapper para compilar y ejecutar el proyecto.

```bash
# En Windows (cmd o PowerShell)
./mvnw.cmd spring-boot:run

# En Linux / macOS / Git Bash
./mvnw spring-boot:run
```

Una vez que la aplicación se inicie, podrás acceder a ella desde tu navegador en la siguiente URL:

**[http://localhost:8085/login](http://localhost:8085/login)**

> **Credenciales:**
>
> Usuario: admin
> 
> Contraseña: admin2025
---

### Alternativa: Instalación Manual de PostgreSQL

Si prefieres no usar Docker, puedes instalar PostgreSQL manualmente.

1.  **Descarga e instala PostgreSQL** desde [postgresql.org/download](https://www.postgresql.org/download/).
2.  Usando una herramienta como `psql` o `pgAdmin`, crea la base de datos, el usuario y la contraseña que se especifican en `application.yml`:
    *   Base de datos: `bd_carrito_compras`
    *   Usuario: `carrito_compra`
    *   Contraseña: `CarritoCompra*`
3.  Asegúrate de que el puerto configurado en `application.yml` coincida con el puerto en el que se está ejecutando tu instancia de PostgreSQL.erto en el que se está ejecutando tu instancia de PostgreSQL.