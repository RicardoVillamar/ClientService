#!/bin/bash

# SonarQube Analysis Script for Client Service using Docker
# Basado en: https://github.com/insideapp-oss/sonar-flutter
# y https://medium.com/@meaghosh/static-code-analysis-with-sonarqube-with-flutter-11a74beb9950

echo "🚀 Starting SonarQube Analysis for Client Service using Docker..."

# Verificar que Docker esté instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker no está instalado. Por favor instala Docker primero."
    exit 1
fi

# Verificar que docker compose esté instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker Compose no está instalado. Por favor instala Docker Compose primero."
    exit 1
fi

# Step 1: Verificar que Docker esté instalado
if ! command -v docker &> /dev/null; then
    echo "❌ Docker no está instalado. Por favor instala Docker primero."
    exit 1
fi

# Verificar que SONAR_TOKEN esté definido
if [ -z "$SONAR_TOKEN" ]; then
    echo "❌ La variable de entorno SONAR_TOKEN no está definida. Por favor, exporta tu token de SonarQube/SonarCloud antes de ejecutar este script."
    docker compose down
    exit 1
fi

# Step 2: Iniciar SonarQube con Docker
echo "🐳 Iniciando SonarQube con Docker..."
docker compose up -d sonarqube

# Esperar a que SonarQube esté listo
echo "⏳ Esperando a que SonarQube esté listo..."
until curl -s http://localhost:9000/api/system/status | grep -q "UP"; do
    echo "   SonarQube aún no está listo, esperando..."
    sleep 10
done

echo "✅ SonarQube está listo!"

# Step 3: Descargar dependencias de Flutter
echo "📦 Descargando Flutter dependencies..."
flutter pub get

if [ $? -ne 0 ]; then
    echo "❌ Failed to download dependencies"
    docker compose down
    exit 1
fi

# Step 4: Run tests with coverage
echo "🧪 Running tests with coverage..."
flutter test --coverage

if [ $? -ne 0 ]; then
    echo "❌ Tests failed"
    docker compose down
    exit 1
fi

# Step 5: Generate test report
echo "📊 Generating test report..."
flutter test --machine --coverage > tests.output

if [ $? -ne 0 ]; then
    echo "❌ Failed to generate test report"
    docker compose down
    exit 1
fi

# Step 6: Verify coverage file exists
if [ ! -f "coverage/lcov.info" ]; then
    echo "❌ Coverage file not found at coverage/lcov.info"
    docker compose down
    exit 1
fi

# Step 7: Run SonarQube analysis using Docker
echo "🔍 Running SonarQube analysis using Docker..."
docker compose run --rm -e SONAR_TOKEN="$SONAR_TOKEN" sonar-scanner \
    -Dsonar.projectKey=client_service \
    -Dsonar.projectName="Client Service" \
    -Dsonar.projectVersion=1.0 \
    -Dsonar.sources=lib,pubspec.yaml \
    -Dsonar.tests=test \
    -Dsonar.sourceEncoding=UTF-8 \
    -Dsonar.flutter.coverage.reportPath=coverage/lcov.info \
    -Dsonar.flutter.tests.reportPath=tests.output \
    -Dsonar.exclusions="**/*.g.dart,**/*.freezed.dart,**/generated_**,**/build/**,**/.dart_tool/**,**/ios/**,**/android/**,**/web/**,**/windows/**,**/linux/**,**/macos/**" \
    -Dsonar.test.exclusions="**/*_test.dart,**/*_test.dart" \
    -Dsonar.coverage.exclusions="**/*_test.dart,**/*_test.dart,**/*.g.dart,**/*.freezed.dart,**/generated_**,**/test/**"

if [ $? -eq 0 ]; then
    echo "✅ SonarQube analysis completed successfully!"
    echo "📈 Check SonarQube at: http://localhost:9000"
    echo "   Project: Client Service"
    echo ""
    echo "🛑 Para detener SonarQube:"
    echo "   docker compose down"
else
    echo "❌ SonarQube analysis failed"
    docker compose down
    exit 1
fi
