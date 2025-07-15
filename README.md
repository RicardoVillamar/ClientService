# Light Vitae

This is a simple crud application built with Flutter and Firebase.

## Features

- User authentication with Firebase Auth
- User profile management
- Client management
- Instalation Light management
- Vehicule management
- Employee management
- Cam management

## Quality Assurance

This project uses SonarQube for static code analysis and quality monitoring.

### Running SonarQube Analysis

#### Prerequisites

- Docker and Docker Compose installed
- Flutter SDK installed

#### Quick Start

```bash
# Make scripts executable
chmod +x download-sonar-flutter-plugin.sh
chmod +x run_sonar_analysis.sh

# Run complete analysis
./run_sonar_analysis.sh
```

#### Access SonarQube

- **URL**: http://localhost:9000
- **Default credentials**: admin/admin
- **Project**: Client Service

### Manual Commands

```bash
# Start only SonarQube
docker-compose up -d sonarqube

# Stop SonarQube
docker-compose down

# View logs
docker-compose logs -f sonarqube
```

## Testing

The project includes comprehensive tests organized by category:

```bash
# Run all tests
flutter test

# Run tests by category
flutter test test/crud/
flutter test test/viewmodels/
flutter test test/utils/
flutter test test/services/
flutter test test/repositories/

# Run tests with coverage
flutter test --coverage
```

## CI/CD

The project uses GitHub Actions for continuous integration:

- **Build and Test**: Runs on every push and pull request
- **SonarQube Analysis**: Quality gate analysis with coverage
- **Release**: Automatic release creation with assets

## Documentation

- [SonarQube Setup Guide](docs/sonarqube-setup.md) - Complete setup instructions
- [Test Documentation](test/) - Test organization and examples
