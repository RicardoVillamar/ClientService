# Tests de LightViate

Esta carpeta contiene todos los tests del proyecto LightViate, organizados por categorías para facilitar el mantenimiento y la ejecución.

## Estructura de Carpetas

```
test/
├── crud/                    # Tests de casos de uso CRUD
│   ├── cliente_crud_test.dart
│   ├── empleado_crud_test.dart
│   ├── factura_crud_test.dart
│   ├── camara_crud_test.dart
│   ├── vehiculo_crud_test.dart
│   └── instalacion_crud_test.dart
├── views/                   # Tests de pantallas/views
│   ├── login_admin_screen_test.dart
│   ├── login_empleado_screen_test.dart
│   ├── register_client_screen_test.dart
│   ├── edit_client_screen_test.dart
│   ├── register_employet_screen_test.dart
│   ├── edit_employet_screen_test.dart
│   ├── register_camara_screen_test.dart
│   ├── edit_camara_screen_test.dart
│   ├── register_installation_screen_test.dart
│   ├── edit_installation_screen_test.dart
│   ├── register_vehicle_screen_test.dart
│   ├── edit_vehicle_screen_test.dart
│   ├── create_factura_screen_test.dart
│   ├── edit_factura_screen_test.dart
│   └── anular_factura_screen_test.dart
├── viewmodels/              # Tests de ViewModels
│   ├── camara_viewmodel_test.dart
│   └── calendario_viewmodel_test.dart
├── services/                # Tests de servicios
│   ├── auth_service_test.dart
│   └── notificacion_service_test.dart
├── repositories/            # Tests de repositorios
│   ├── camara_repository_test.dart
│   └── instalacion_repository_test.dart
├── utils/                   # Tests de utilidades
│   └── excel_export_utility_test.dart
├── mocks.dart               # Configuración de mocks
├── mocks.mocks.dart         # Mocks generados automáticamente
├── test_setup.dart          # Configuración de tests
└── widget_test.dart         # Test principal de widget
```

## Ejecución de Tests

### Ejecutar todos los tests

```bash
flutter test
```

### Ejecutar tests por categoría

```bash
# Tests de CRUD (casos de uso)
flutter test test/crud/

# Tests de Views (pantallas)
flutter test test/views/

# Tests de ViewModels
flutter test test/viewmodels/

# Tests de Servicios
flutter test test/services/

# Tests de Repositorios
flutter test test/repositories/

# Tests de Utilidades
flutter test test/utils/
```

### Ejecutar tests específicos

```bash
# Test específico de cliente
flutter test test/crud/cliente_crud_test.dart

# Test específico de login
flutter test test/views/login_admin_screen_test.dart
```

## Configuración de Mocks

Los tests utilizan **mockito** con `@GenerateMocks` para crear mocks automáticamente:

1. **Archivo de configuración**: `test/mocks.dart`
2. **Mocks generados**: `test/mocks.mocks.dart`

### Regenerar mocks

Si agregas nuevos repositorios o servicios, regenera los mocks:

```bash
flutter pub run build_runner build
```

## Casos de Prueba Implementados

### CRUD Tests (29 tests)

- ✅ **Cliente**: Registrar, editar, eliminar, listar
- ✅ **Empleado**: Registrar, editar, eliminar, listar, verificar administrador
- ✅ **Factura**: Registrar, cancelar, listar, eliminar, calcular totales
- ✅ **Cámara**: Registrar mantenimiento, editar, cancelar, listar, eliminar
- ✅ **Vehículo**: Registrar alquiler, actualizar, cancelar, listar, eliminar
- ✅ **Instalación**: Registrar poste, editar, cancelar, listar, eliminar

### ViewModel Tests (2 tests)

- ✅ **CamaraViewModel**: Inicialización
- ✅ **CalendarioViewModel**: Filtrado de eventos

### Service Tests (2 tests)

- ✅ **AuthService**: Autenticación
- ✅ **NotificacionService**: Notificaciones

### Repository Tests (2 tests)

- ✅ **CamaraRepository**: Operaciones básicas
- ✅ **InstalacionRepository**: Operaciones básicas

### Utils Tests (1 test)

- ⚠️ **ExcelExportUtility**: Exportación (falla en entorno de test por descarga de archivos)

## Notas Importantes

1. **Mocks**: Todos los tests usan mocks generados automáticamente para evitar problemas de null safety
2. **Dependencias**: Los tests están configurados para usar `GetIt` para inyección de dependencias
3. **Excel Tests**: Los tests de exportación a Excel pueden fallar en CI/CD porque requieren descarga de archivos
4. **Organización**: Los tests están organizados por funcionalidad para facilitar el mantenimiento

## Agregar Nuevos Tests

1. **Identifica la categoría** del test (crud, views, viewmodels, services, repositories, utils)
2. **Crea el archivo** en la carpeta correspondiente
3. **Usa los mocks generados** importando `../mocks.mocks.dart`
4. **Sigue el patrón** de los tests existentes
5. **Ejecuta los tests** para verificar que funcionan
