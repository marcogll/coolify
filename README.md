# Stack de n8n y Evolution API para Coolify
### Versión 3.0 - Segura y Lista para Producción

Este repositorio contiene la configuración de Docker Compose para desplegar un stack completo y unificado con **n8n** y **Evolution API**, utilizando servicios compartidos de PostgreSQL y Redis.

Está diseñado para ser desplegado de forma robusta y segura en **Coolify** a través de su integración con Git.

---

## Arquitectura Clave

Esta configuración utiliza un enfoque profesional para garantizar un despliegue estable:

1.  **Imagen de PostgreSQL Personalizada:** Se usa un `Dockerfile.postgres` para construir una imagen propia de PostgreSQL que incluye el script de inicialización. Esto elimina por completo los errores de montaje de volúmenes.

2.  **Sin Mapeo de Puertos:** No se usa la sección `ports` para dejar que el proxy de Coolify gestione el tráfico y los certificados SSL, evitando conflictos.

3.  **Gestión de Secretos Centralizada:** Todas las variables de entorno, especialmente los secretos, se gestionan **exclusivamente** en la interfaz de usuario de Coolify. **Este repositorio no contiene ninguna contraseña o clave de API.**

## Estructura del Repositorio

```
/
|-- .gitignore
|-- .env.example          <-- Plantilla de todas las variables necesarias. ¡NO CONTIENE SECRETOS!
|-- docker-compose.yaml   <-- Orquesta los servicios y construye la imagen de Postgres.
|-- Dockerfile.postgres   <-- Define cómo construir nuestra imagen de Postgres.
|-- init-db.sh            <-- Script para crear la base de datos de Evolution.
`-- README.md             <-- Esta guía.
```

## Servicios

| Nombre del Servicio | Descripción                                    | Accesible en                                     |
| ------------------- | ---------------------------------------------- | ------------------------------------------------ |
| `n8n_app`           | El servicio de automatización de flujos n8n.   | `https://flows.soul23.cloud` (vía proxy Coolify) |
| `evolution_api`     | La API de Evolution para la conexión con WA.   | `https://evo.soul23.cloud` (vía proxy Coolify)   |
| `pg_database`       | Servidor PostgreSQL 16 compartido.             | `pg_database:5432` (red interna de Docker)       |
| `redis_cache`       | Servidor de caché Redis para Evolution.        | `redis_cache:6379` (red interna de Docker)       |

---

## Guía de Despliegue en Coolify

1.  **Pre-requisitos:** Asegúrate de que tus registros DNS (`flows.soul23.cloud` y `evo.soul23.cloud`) apunten a la IP de tu servidor Coolify.

2.  **Configuración en Coolify:**
    -   Crea una nueva **Application** desde este repositorio de Git.
    -   **Build Pack:** `Docker Compose`
    -   **Base Directory:** `/`
    -   **Docker Compose Location:** `/docker-compose.yaml`

3.  **Variables de Entorno (¡Importante!):**
    -   Ve a la pestaña **Environment Variables**.
    -   Usa el archivo `.env.example` de este repositorio como **plantilla** para saber qué variables necesitas.
    -   Añade las variables una por una o en modo "raw", reemplazando los valores de ejemplo con **tus secretos reales**. **Nunca subas tus secretos a Git.**

4.  **Dominios:**
    -   Ve a la pestaña **Domains** y configura las rutas:
        -   `https://flows.soul23.cloud` -> `n8n_app` (puerto `5678`)
        -   `https://evo.soul23.cloud` -> `evolution_api` (puerto `8080`)

5.  **Guardar y Desplegar:**
    -   Guarda toda la configuración y haz clic en **Deploy**.

### Solución de Problemas (Arranque en Frío)
Si un despliegue falla, el método más fiable es limpiar el estado anterior:
1.  **Stop** la aplicación.
2.  Ve a **Persistent Storage** y **elimina todos los volúmenes**.
3.  **Redeploy**.
