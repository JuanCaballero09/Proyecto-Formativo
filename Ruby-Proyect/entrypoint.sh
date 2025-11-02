#!/bin/bash

echo "🔧 Iniciando entorno Ruby on Rails..."

# Esperar a que PostgreSQL esté disponible
echo "⏳ Esperando a PostgreSQL en $DB_HOST..."
until pg_isready -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER"; do
  sleep 2
done
echo "✅ PostgreSQL está listo."

# Instalar gems si no están
if [ ! -d "vendor/bundle" ]; then
  echo "📦 Ejecutando bundle install..."
  bundle install
fi

# Preparar base de datos
echo "🗃️ Ejecutando rails db:setup..."
bundle exec rails db:setup

# Arrancar servidor Rails
echo "🚀 Levantando servidor Rails..."
exec bundle exec rails server -b 0.0.0.0

# Finalmente, delega al entrypoint original
exec /rails/bin/docker-entrypoint "$@"