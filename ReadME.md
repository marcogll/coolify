# Stack de n8n y Evolution API para Coolify

Este repositorio contiene la configuración de Docker Compose para desplegar un stack completo con n8n y Evolution API, utilizando una base de datos PostgreSQL y una instancia de Redis compartidas.

Está diseñado para ser desplegado fácilmente en [Coolify](https://coolify.io) a través de su integración con Git.

## Servicios

-   **n8n**: Servicio de automatización de flujos de trabajo.
-   **api**: Servicio de Evolution API para la conexión con WhatsApp.
-   **postgres**: Servidor de base de datos PostgreSQL 16, compartido por n8n y la API.
-   **redis**: Servidor de caché Redis, utilizado por la API de Evolution.

## Despliegue en Coolify

1.  **Crea un repositorio Git** (si estás leyendo esto, ya lo hiciste).
2.  En Coolify, crea un nuevo recurso de tipo **Application**.
3.  Elige **Deploy from a Git Repository (Docker Compose)**.
4.  Selecciona este repositorio. Coolify detectará automáticamente el `docker-compose.yml`.
5.  Ve a la pestaña **Environment Variables** y añade las variables de entorno necesarias (ver sección abajo). **No las guardes en un archivo `.env` en el repositorio.**
6.  En la pestaña **Domains**, configura los dominios para los puertos `5678` (n8n) y `8080` (Evolution API).
    -   `https://flows2.soul23.cloud` -> `n8n:5678`
    -   `https://evo2.soul23.cloud` -> `api:8080`
7.  ¡Despliega!

## Variables de Entorno

Debes configurar estas variables en la UI de Coolify. **NO LAS SUBAS AL REPOSITORIO.**

```ini
# --- Configuración Global ---
TZ=America/Monterrey

# --- FQDNs (Dominios) ---
SERVICE_FQDN_N8N=https://flows2.soul23.cloud
N8N_HOST=flows2.soul23.cloud
SERVICE_FQDN_EVO=https://evo2.soul23.cloud

# --- Credenciales de la Base de Datos (Unificadas) ---
POSTGRES_USER=usuario_seguro
POSTGRES_PASSWORD=contraseña_muy_segura_y_larga

# --- Nombres de las Bases de Datos ---
N8N_DB_NAME=n8n
EVOLUTION_DB_NAME=evolution

# --- Credenciales de API ---
EVOLUTION_API_KEY=tu_api_key_secreta_para_evolution

# --- Configuración SMTP para n8n ---
N8N_EMAIL_MODE=smtp
N8N_SMTP_HOST=smtp.hostinger.com
N8N_SMTP_PORT=465
N8N_SMTP_USER=dev@vanityexperience.mx
N8N_SMTP_PASS=tu_contraseña_smtp
N8N_SMTP_SENDER="n8n AlMa"
N8N_SMTP_SSL=true

# --- OTRAS VARIABLES DE EVOLUTION API ---
# Añade aquí el resto de tus variables de configuración de Evolution API
# Ejemplo:
# WEBHOOK_EVENTS_MESSAGES_UPSERT=true
# ... etc ...
```
