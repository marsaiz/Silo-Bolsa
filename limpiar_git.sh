#!/bin/bash
# Script para limpiar archivos innecesarios del repositorio Git
# Este script elimina del rastreo de Git los archivos que deberían estar en .gitignore

echo "================================================"
echo "LIMPIEZA DE REPOSITORIO GIT - SILO BOLSA"
echo "================================================"
echo ""
echo "Este script eliminará del rastreo de Git (pero NO del disco) los siguientes archivos:"
echo "  - Carpetas bin/ y obj/ (.NET)"
echo "  - Carpeta release/ (builds compilados)"
echo "  - Archivos .idea/ (Android Studio)"
echo "  - DLLs, PDBs y otros archivos de compilación"
echo ""
read -p "¿Deseas continuar? (s/n): " -n 1 -r
echo ""

if [[ ! $REPLY =~ ^[Ss]$ ]]
then
    echo "Operación cancelada."
    exit 1
fi

echo ""
echo "Iniciando limpieza..."
echo ""

# Eliminar del índice de Git (pero no del disco) las carpetas bin/ y obj/
echo "1. Eliminando carpetas bin/ y obj/ del rastreo..."
git rm -r --cached Codigo/Web/*/bin/ 2>/dev/null
git rm -r --cached Codigo/Web/*/obj/ 2>/dev/null

# Eliminar carpeta release/
echo "2. Eliminando carpeta release/ del rastreo..."
git rm -r --cached Codigo/Web/release/ 2>/dev/null

# Eliminar archivos .idea de Android
echo "3. Eliminando archivos .idea/ del rastreo..."
git rm -r --cached Codigo/Android/.idea/ 2>/dev/null

# Eliminar DLLs y otros archivos de compilación
echo "4. Eliminando archivos compilados (.dll, .pdb, .exe, etc.)..."
git rm --cached $(git ls-files | grep -E '\.(dll|pdb|exe|cache)$') 2>/dev/null

echo ""
echo "================================================"
echo "Limpieza completada!"
echo "================================================"
echo ""
echo "PRÓXIMOS PASOS:"
echo "1. Revisa los cambios con: git status"
echo "2. Si todo está correcto, haz commit: git add .gitignore && git commit -m 'chore: actualizar .gitignore y limpiar archivos innecesarios'"
echo "3. Sube los cambios: git push"
echo ""
echo "NOTA: Los archivos siguen en tu disco, solo se eliminaron del rastreo de Git."
echo "================================================"
