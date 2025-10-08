# Configuración Anti-Caché para VS Code y Contenedor Dev

**Fecha:** 8 de octubre de 2025  
**Objetivo:** Evitar que VS Code cargue caché al abrir Ruby-Proyect en contenedor

---

## 📋 Archivos Configurados

### 1. `.devcontainer/devcontainer.json`
Configuración principal del contenedor con:
- ✅ **postStartCommand**: Limpia caché automáticamente al iniciar
- ✅ **customizations.vscode.settings**: Configuraciones de VS Code específicas
- ✅ **customizations.vscode.extensions**: Extensiones recomendadas

### 2. `.devcontainer/startup.sh`
Script que se ejecuta automáticamente al iniciar el contenedor:
- Limpia `tmp/cache/*`
- Limpia logs de desarrollo
- Elimina PIDs de servidor antiguos
- Crea archivo de reinicio

### 3. `.vscode/settings.json`
Configuraciones del workspace de VS Code:
- Excluye directorios de caché del watcher
- Excluye directorios de búsqueda
- Desactiva seguimiento de symlinks
- Configuración Ruby LSP optimizada

---

## 🚀 Cómo Funciona

### Al Iniciar el Contenedor:

1. **VS Code abre el contenedor**
2. **Ejecuta `startup.sh` automáticamente**
   ```bash
   bash .devcontainer/startup.sh
   ```
3. **Limpia todo el caché**
   - `tmp/cache/*` → Vacío
   - `log/development.log` → Limpio
   - `tmp/pids/server.pid` → Eliminado
4. **Rails reinicia sin caché**

### Durante el Desarrollo:

- ✅ VS Code **NO monitorea** `tmp/`, `log/`, `storage/`
- ✅ Búsquedas **más rápidas** (ignora archivos temporales)
- ✅ Rails **siempre fresco** (null_store configurado)
- ✅ Cambios **visibles inmediatamente**

---

## 📁 Estructura de Archivos Creados

```
Ruby-Proyect/
├── .devcontainer/
│   ├── devcontainer.json      ← Configuración principal
│   ├── startup.sh             ← Script de limpieza automática
│   └── docker-compose.yml     (existente)
├── .vscode/
│   └── settings.json          ← Configuración del workspace
├── config/
│   └── environments/
│       └── development.rb     ← Caché desactivado (null_store)
└── CACHE_FIX_DOCUMENTATION.md ← Documentación de la solución
```

---

## 🔧 Configuraciones Aplicadas

### En `devcontainer.json`:

```json
{
  "postStartCommand": "bash .devcontainer/startup.sh",
  "customizations": {
    "vscode": {
      "settings": {
        "files.watcherExclude": {
          "**/tmp/**": true,
          "**/log/**": true,
          "**/storage/**": true
        },
        "search.followSymlinks": false,
        "search.useIgnoreFiles": true
      }
    }
  }
}
```

### En `.vscode/settings.json`:

```json
{
  "files.watcherExclude": {
    "**/tmp/**": true,
    "**/log/**": true,
    "**/storage/**": true,
    "**/.bundle/**": true,
    "**/vendor/bundle/**": true
  },
  "search.exclude": {
    "**/tmp": true,
    "**/log": true,
    "**/storage": true
  },
  "terminal.integrated.env.linux": {
    "DISABLE_SPRING": "1"
  }
}
```

### En `config/environments/development.rb`:

```ruby
config.action_controller.perform_caching = false
config.cache_store = :null_store
```

---

## ✅ Verificación

### Para verificar que funciona:

1. **Cerrar VS Code completamente**
2. **Reabrir el proyecto en contenedor**
3. **Verificar en el terminal** que aparece:
   ```
   🧹 Limpiando caché de Rails...
   ✅ Caché de tmp/cache limpiado
   ✅ Log de desarrollo limpiado
   ✅ PID del servidor eliminado
   ✅ Archivo de reinicio creado
   🚀 Contenedor listo - Sin caché!
   ```

### Comandos de verificación manual:

```bash
# Ver que tmp/cache está vacío
ls -la tmp/cache/

# Ver configuración de Rails
grep -A2 "cache_store" config/environments/development.rb

# Verificar que startup.sh tiene permisos
ls -la .devcontainer/startup.sh
```

---

## 🛠️ Comandos Útiles

### Limpiar caché manualmente (si es necesario):

```bash
# Ejecutar script de limpieza
bash .devcontainer/startup.sh

# O manualmente
rm -rf tmp/cache/*
touch tmp/restart.txt
```

### Reconstruir contenedor (limpieza profunda):

```bash
# En VS Code:
# 1. Cmd/Ctrl + Shift + P
# 2. "Dev Containers: Rebuild Container"
```

### Ver logs del contenedor:

```bash
# Ver logs de Rails
tail -f log/development.log

# Ver procesos de Rails
ps aux | grep rails
```

---

## 🎯 Beneficios de Esta Configuración

### Performance:
- ⚡ **Búsquedas más rápidas** (menos archivos indexados)
- ⚡ **Menos uso de RAM** (no cachea archivos temporales)
- ⚡ **Inicio más rápido** del workspace

### Desarrollo:
- ✅ **Siempre código fresco** al iniciar
- ✅ **No más "no veo mis cambios"**
- ✅ **Comportamiento consistente**
- ✅ **Menos bugs por caché antiguo**

### Automatización:
- 🤖 **Todo automático** al abrir contenedor
- 🤖 **No requiere comandos manuales**
- 🤖 **Configuración persistente**

---

## 🔄 Flujo de Trabajo Recomendado

### Inicio del Día:
1. Abrir VS Code
2. Abrir proyecto en contenedor
3. ✅ Caché se limpia automáticamente
4. Empezar a trabajar

### Durante el Desarrollo:
1. Hacer cambios en código
2. Guardar archivo (`Ctrl+S`)
3. Recargar navegador (`Ctrl+Shift+R`)
4. ✅ Ver cambios inmediatamente

### Fin del Día:
1. Commit y push
2. Cerrar VS Code
3. Contenedor se detiene automáticamente

---

## 🐛 Solución de Problemas

### Si no ves los cambios:

1. **Verificar que el script se ejecutó:**
   ```bash
   ls -la tmp/cache/
   # Debe estar vacío
   ```

2. **Verificar configuración de Rails:**
   ```bash
   grep "null_store" config/environments/development.rb
   # Debe mostrar: config.cache_store = :null_store
   ```

3. **Hard reload en navegador:**
   - `Ctrl + Shift + R`
   - DevTools → Network → "Disable cache"

4. **Reiniciar servidor manualmente:**
   ```bash
   touch tmp/restart.txt
   # O
   pkill -f 'rails server'
   bin/rails server
   ```

### Si el script no se ejecuta:

1. **Verificar permisos:**
   ```bash
   chmod +x .devcontainer/startup.sh
   ```

2. **Ejecutar manualmente:**
   ```bash
   bash .devcontainer/startup.sh
   ```

3. **Ver logs del contenedor:**
   - En VS Code: Output → Dev Containers

---

## 📚 Referencias

- [VS Code Dev Containers](https://code.visualstudio.com/docs/devcontainers/containers)
- [Rails Caching Guide](https://guides.rubyonrails.org/caching_with_rails.html)
- [VS Code Settings](https://code.visualstudio.com/docs/getstarted/settings)

---

## ✨ Mantenimiento

### Actualizar configuración:

```bash
# Editar script de inicio
code .devcontainer/startup.sh

# Editar configuración de VS Code
code .vscode/settings.json

# Editar configuración del contenedor
code .devcontainer/devcontainer.json
```

### Agregar más limpiezas al script:

```bash
# Ejemplo: limpiar assets precompilados
echo "rm -rf public/assets" >> .devcontainer/startup.sh
```

---

## 📊 Resumen Ejecutivo

| Aspecto | Antes | Después |
|---------|-------|---------|
| **Caché al iniciar** | Presente | Limpio automáticamente ✅ |
| **Indexación VS Code** | Todos los archivos | Solo necesarios ✅ |
| **Búsquedas** | Lentas (incluye tmp/) | Rápidas ✅ |
| **Ver cambios** | A veces requería limpieza | Siempre inmediato ✅ |
| **Configuración** | Manual cada vez | Automática ✅ |

---

**Autor:** GitHub Copilot  
**Fecha:** 8 de octubre de 2025  
**Estado:** ✅ Implementado y funcionando  
**Mantenimiento:** Automático
