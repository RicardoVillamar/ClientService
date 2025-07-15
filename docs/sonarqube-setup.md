# Configuración de SonarQube para Client Service

Este documento explica cómo configurar SonarQube para el análisis de calidad de código del proyecto Client Service.

## Prerrequisitos

1. **SonarQube Server**: Debes tener acceso a un servidor de SonarQube (local o en la nube)
2. **SonarQube Token**: Token de autenticación para acceder al servidor
3. **SonarQube Plugin**: El plugin `sonar-flutter` debe estar instalado en tu servidor SonarQube

## Configuración de GitHub Secrets

Para que el análisis de SonarQube funcione en GitHub Actions, necesitas configurar los siguientes secrets en tu repositorio:

### 1. Ir a Settings > Secrets and variables > Actions

### 2. Agregar los siguientes secrets:

- **SONAR_TOKEN**: Token de autenticación de SonarQube

  - Ve a tu servidor SonarQube
  - Inicia sesión como administrador
  - Ve a **My Account** > **Security**
  - Genera un nuevo token
  - Copia el token y agrégalo como secret

- **SONAR_HOST_URL**: URL de tu servidor SonarQube
  - Ejemplo: `https://sonarqube.yourcompany.com`
  - Para SonarCloud: `https://sonarcloud.io`

## Configuración del Proyecto

### 1. Archivo sonar-project.properties

El archivo `sonar-project.properties` ya está configurado con:

- Project Key: `client_service`
- Project Name: `Client Service`
- Configuración de análisis automático
- Rutas de reportes de cobertura y tests

### 2. Configuración con Docker (Recomendado)

El proyecto incluye configuración completa para Docker:

#### Archivos de Docker:

- `docker-compose.yml`: Configuración de SonarQube con el plugin sonar-flutter
- `download-sonar-flutter-plugin.sh`: Script para descargar el plugin
- `run_sonar_analysis.sh`: Script completo de análisis con Docker

#### Ventajas de usar Docker:

- ✅ No requiere instalación manual de SonarQube
- ✅ Plugin sonar-flutter incluido automáticamente
- ✅ Configuración aislada y reproducible
- ✅ Fácil de usar en cualquier entorno

### 3. Plugin sonar-flutter

El plugin se descarga automáticamente al ejecutar el script `run_sonar_analysis.sh`.

## Ejecución del Análisis

### Automático (GitHub Actions)

El análisis se ejecuta automáticamente en cada:

- Push a la rama `main`
- Pull Request a la rama `main`
- Release creado

### Manual

Para ejecutar el análisis manualmente:

```bash
# Hacer ejecutables los scripts
chmod +x download-sonar-flutter-plugin.sh
chmod +x run_sonar_analysis.sh

# Ejecutar el análisis completo
./run_sonar_analysis.sh
```

## Configuración del Workflow

El workflow de GitHub Actions (`flutter_ci.yml`) incluye:

1. **Job build-and-test**: Ejecuta tests y genera reportes
2. **Job sonarqube**: Descarga reportes y ejecuta análisis de SonarQube
3. **Job release**: Crea releases automáticamente

## Interpretación de Resultados

### Quality Gate

SonarQube utiliza un "Quality Gate" que verifica:

- **Coverage**: Porcentaje de cobertura de código
- **Duplications**: Código duplicado
- **Issues**: Problemas de calidad (bugs, vulnerabilidades, code smells)
- **Maintainability**: Mantenibilidad del código
- **Reliability**: Confiabilidad del código
- **Security**: Seguridad del código

### Métricas Importantes

- **Code Coverage**: Debe estar por encima del 80%
- **Technical Debt**: Debe ser mínimo
- **Code Smells**: Deben ser pocos o nulos
- **Bugs**: Deben ser cero
- **Vulnerabilities**: Deben ser cero

## Troubleshooting

### Error: "No coverage data found"

1. Verifica que los tests se ejecuten correctamente
2. Asegúrate de que el archivo `coverage/lcov.info` se genere
3. Verifica que `sonar.flutter.coverage.reportPath` apunte al archivo correcto

### Error: "Authentication failed"

1. Verifica que `SONAR_TOKEN` esté configurado correctamente
2. Asegúrate de que el token tenga permisos para el proyecto
3. Verifica que `SONAR_HOST_URL` sea correcto

### Error: "Plugin not found"

1. Instala el plugin `sonar-flutter` en tu servidor SonarQube
2. Reinicia el servidor después de la instalación
3. Verifica que el plugin esté habilitado

## Recursos Adicionales

- [Documentación oficial de sonar-flutter](https://github.com/insideapp-oss/sonar-flutter)
- [Documentación de SonarQube para Dart](https://docs.sonarsource.com/sonarqube-server/10.8/analyzing-source-code/languages/dart/)
- [SonarQube Quality Gates](https://docs.sonarsource.com/sonarqube-server/10.8/user-guide/quality-gates/)
