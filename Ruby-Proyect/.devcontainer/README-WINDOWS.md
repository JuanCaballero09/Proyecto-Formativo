# Solución de problemas para Dev Container en Windows

## Error: Montaje de Wayland

Si encuentras un error como:
```
--mount type=bind,source=\\wsl.localhost\Ubuntu\mnt\wslg\runtime-dir\wayland-0
```

Esto ocurre cuando VS Code detecta WSL en Windows e intenta montar componentes de WSL automáticamente.

### Soluciones:

#### Opción 1: Configuración de usuario de VS Code (Recomendada)

1. Abre los settings de VS Code (Ctrl + ,)
2. Busca "Dev Containers"
3. Añade esta configuración en tu `settings.json` de usuario (no del workspace):

```json
{
  "dev.containers.mountWaylandSocket": false
}
```

#### Opción 2: Variable de entorno

Antes de abrir VS Code, ejecuta en PowerShell:
```powershell
$env:DONT_PROMPT_WSL_INSTALL="1"
code .
```

#### Opción 3: Abrir desde WSL (si tienes WSL instalado)

1. Abre una terminal WSL (Ubuntu)
2. Navega al proyecto:
   ```bash
   cd /mnt/c/Users/Wi2s11/Documents/GitHub/Proyecto-Formativo/Ruby-Proyect
   ```
3. Abre VS Code:
   ```bash
   code .
   ```

## Verificación

Los contenedores se pueden levantar correctamente con:
```powershell
docker compose -f .devcontainer/docker-compose.yml up -d
docker ps
```

Si ves ambos contenedores (`devcontainer-app-1` y `devcontainer-db-1`), la configuración de Docker es correcta y el problema es solo con VS Code.
