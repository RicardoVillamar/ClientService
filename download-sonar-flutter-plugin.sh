#!/bin/bash

# Script para descargar el plugin sonar-flutter
# Basado en: https://github.com/insideapp-oss/sonar-flutter

echo "🔍 Descargando plugin sonar-flutter..."

# URL del último release del plugin
PLUGIN_URL="https://github.com/insideapp-oss/sonar-flutter/releases/latest/download/sonar-flutter-plugin.jar"

# Descargar el plugin
echo "📥 Descargando desde: $PLUGIN_URL"
curl -L -o sonar-flutter-plugin.jar "$PLUGIN_URL"

if [ $? -eq 0 ]; then
    echo "✅ Plugin descargado exitosamente: sonar-flutter-plugin.jar"
    echo "📊 Tamaño del archivo: $(ls -lh sonar-flutter-plugin.jar | awk '{print $5}')"
else
    echo "❌ Error al descargar el plugin"
    exit 1
fi

echo ""
echo "🚀 Para iniciar SonarQube con Docker:"
echo "   docker-compose up -d"
echo ""
echo "🌐 Acceder a SonarQube: http://localhost:9000"
echo "   Usuario por defecto: admin"
echo "   Contraseña por defecto: admin"
