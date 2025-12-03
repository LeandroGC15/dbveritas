#!/bin/bash
# Script para verificar la estructura del backend antes de construir

echo "🔍 Verificando estructura del backend..."
echo ""

BACKEND_PATH="${BACKEND_PATH:-../backend_veritas_go}"

echo "📁 Ruta del backend: $BACKEND_PATH"
echo ""

# Verificar que el directorio existe
if [ ! -d "$BACKEND_PATH" ]; then
    echo "❌ Error: El directorio $BACKEND_PATH no existe"
    echo "   Verifica que BACKEND_PATH en .env sea correcto"
    exit 1
fi

echo "✅ Directorio existe"
echo ""

# Verificar Dockerfile
if [ ! -f "$BACKEND_PATH/Dockerfile" ]; then
    echo "❌ Error: Dockerfile no encontrado en $BACKEND_PATH"
    exit 1
fi

echo "✅ Dockerfile encontrado"
echo ""

# Verificar estructura cmd/server
if [ ! -d "$BACKEND_PATH/cmd" ]; then
    echo "❌ Error: Directorio cmd/ no encontrado"
    exit 1
fi

echo "✅ Directorio cmd/ existe"
echo ""

if [ ! -d "$BACKEND_PATH/cmd/server" ]; then
    echo "❌ Error: Directorio cmd/server/ no encontrado"
    exit 1
fi

echo "✅ Directorio cmd/server/ existe"
echo ""

if [ ! -f "$BACKEND_PATH/cmd/server/main.go" ]; then
    echo "❌ Error: Archivo cmd/server/main.go no encontrado"
    exit 1
fi

echo "✅ Archivo cmd/server/main.go encontrado"
echo ""

# Verificar go.mod
if [ ! -f "$BACKEND_PATH/go.mod" ]; then
    echo "❌ Error: go.mod no encontrado"
    exit 1
fi

echo "✅ go.mod encontrado"
echo ""

# Listar estructura
echo "📂 Estructura del proyecto:"
echo ""
tree -L 3 "$BACKEND_PATH" 2>/dev/null || find "$BACKEND_PATH" -maxdepth 3 -type d | head -20
echo ""

echo "✅ Todas las verificaciones pasaron. El backend está listo para construir."
echo ""

