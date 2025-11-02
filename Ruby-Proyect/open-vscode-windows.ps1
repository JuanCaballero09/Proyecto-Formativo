# Script para abrir VS Code sin montajes de WSL
# Ejecutar en PowerShell antes de abrir el proyecto

$env:DONT_PROMPT_WSL_INSTALL = "1"
$env:VSCODE_WSL_DONT_MOUNT_WAYLAND = "1"

Write-Host "Variables de entorno configuradas. Abriendo VS Code..." -ForegroundColor Green
code "C:\Users\Wi2s11\Documents\GitHub\Proyecto-Formativo\Ruby-Proyect"
