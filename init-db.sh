#!/bin/bash
# Archivo: init-db.sh
# Descripción: Crea la base de datos para Evolution API en el servidor PostgreSQL compartido.
# Este script es ejecutado por el punto de entrada oficial de la imagen de Docker de PostgreSQL.

set -e

# La variable de entorno EVOLUTION_DB_NAME la toma del docker-compose.yml,
# pero como este script corre DENTRO del contenedor de postgres, no tiene acceso a ella.
# Por lo tanto, hardcodeamos el nombre aquí. Asegúrate de que coincida con la variable de entorno.
# La alternativa sería pasarla con `postgres -c EVOLUTION_DB_NAME=${EVOLUTION_DB_NAME}`
# pero este método es más simple y robusto.
psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<-EOSQL
    SELECT 'CREATE DATABASE evolution'
    WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'evolution')\gexec
EOSQL
