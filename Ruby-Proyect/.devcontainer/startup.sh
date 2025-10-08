#!/bin/bash

# Script de inicio del contenedor - Limpieza de caché
# Este script se ejecuta automáticamente al iniciar el contenedor

echo "🧹 Limpiando caché de Rails..."

# Limpiar caché de Rails
rm -rf tmp/cache/*
echo "✅ Caché de tmp/cache limpiado"

# Limpiar logs viejos (opcional)
if [ -f "log/development.log" ]; then
  > log/development.log
  echo "✅ Log de desarrollo limpiado"
fi

# Reiniciar servidor Rails si está corriendo
if [ -f "tmp/pids/server.pid" ]; then
  rm tmp/pids/server.pid
  echo "✅ PID del servidor eliminado"
fi

# Crear archivo de reinicio
touch tmp/restart.txt
echo "✅ Archivo de reinicio creado"

echo "🚀 Contenedor listo - Sin caché!"
