import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../mocks.mocks.dart';
import 'package:client_service/models/factura.dart';

void main() {
  group('Casos de Prueba - Gestión de Facturas', () {
    test('Registrar factura', () async {
      final repository = MockFacturaRepository();
      final factura = Factura(
        numeroFactura: 'FAC-2025-0045',
        fechaEmision: DateTime(2025, 6, 16),
        fechaVencimiento: DateTime(2025, 6, 30),
        clienteId: 'cli-001',
        nombreCliente: 'Comercial Andina S.A.',
        direccionCliente: 'Av. Principal 123',
        telefonoCliente: '0991122334',
        correoCliente: 'contacto@andina.com',
        tipoServicio: TipoServicio.camara,
        servicioId: 'cam-001',
        items: [
          ItemFactura(
            descripcion: 'Instalación de Cámaras de Seguridad HD',
            cantidad: 2,
            precioUnitario: 85.00,
            descuento: 10.0,
          ),
        ],
        impuesto: 12.0,
        estado: EstadoFactura.pendiente,
        fechaCreacion: DateTime(2025, 6, 16),
        creadoPor: 'admin',
      );
      when(repository.create(any)).thenAnswer((_) async => 'fac-001');
      final result = await repository.create(factura);
      expect(result, 'fac-001');
      verify(repository.create(factura)).called(1);
      // Verificar cálculos
      expect(factura.subtotal, 170.00); // 2 * 85.00
      expect(factura.totalDescuentos, 17.00); // 10% de 170.00
      expect(factura.baseImponible, 153.00); // 170.00 - 17.00
      expect(factura.montoImpuesto, 18.36); // 12% de 153.00
      expect(factura.total, 171.36); // 153.00 + 18.36
    });

    test('Cancelar factura', () async {
      final repository = MockFacturaRepository();
      final factura = Factura(
        id: 'fac-001',
        numeroFactura: 'FAC-2025-0045',
        fechaEmision: DateTime(2025, 6, 16),
        fechaVencimiento: DateTime(2025, 6, 30),
        clienteId: 'cli-001',
        nombreCliente: 'Comercial Andina S.A.',
        direccionCliente: 'Av. Principal 123',
        telefonoCliente: '0991122334',
        correoCliente: 'contacto@andina.com',
        tipoServicio: TipoServicio.camara,
        servicioId: 'cam-001',
        items: [
          ItemFactura(
            descripcion: 'Instalación de Cámaras de Seguridad HD',
            cantidad: 2,
            precioUnitario: 85.00,
            descuento: 10.0,
          ),
        ],
        impuesto: 12.0,
        estado: EstadoFactura.pendiente,
        fechaCreacion: DateTime(2025, 6, 16),
        creadoPor: 'admin',
      );
      final facturaCancelada = factura.copyWith(
        estado: EstadoFactura.cancelada,
        observaciones: 'Error en el valor del servicio',
      );
      when(repository.update(any, any)).thenAnswer((_) async {});
      await repository.update('fac-001', facturaCancelada);
      verify(repository.update('fac-001', facturaCancelada)).called(1);
      expect(facturaCancelada.estado, EstadoFactura.cancelada);
      expect(facturaCancelada.observaciones, 'Error en el valor del servicio');
    });

    test('Listar facturas', () async {
      final repository = MockFacturaRepository();
      final factura = Factura(
        numeroFactura: 'FAC-2025-0045',
        fechaEmision: DateTime(2025, 6, 16),
        fechaVencimiento: DateTime(2025, 6, 30),
        clienteId: 'cli-001',
        nombreCliente: 'Comercial Andina S.A.',
        direccionCliente: 'Av. Principal 123',
        telefonoCliente: '0991122334',
        correoCliente: 'contacto@andina.com',
        tipoServicio: TipoServicio.camara,
        servicioId: 'cam-001',
        items: [
          ItemFactura(
            descripcion: 'Instalación de Cámaras de Seguridad HD',
            cantidad: 2,
            precioUnitario: 85.00,
            descuento: 10.0,
          ),
        ],
        impuesto: 12.0,
        estado: EstadoFactura.pendiente,
        fechaCreacion: DateTime(2025, 6, 16),
        creadoPor: 'admin',
      );
      when(repository.getAll()).thenAnswer((_) async => [factura]);
      final result = await repository.getAll();
      expect(result, isA<List<Factura>>());
      expect(result.length, 1);
      expect(result.first.numeroFactura, 'FAC-2025-0045');
      expect(result.first.nombreCliente, 'Comercial Andina S.A.');
    });

    test('Eliminar factura', () async {
      final repository = MockFacturaRepository();
      when(repository.delete(any)).thenAnswer((_) async {});
      await repository.delete('fac-001');
      verify(repository.delete('fac-001')).called(1);
    });

    test('Calcular totales de ItemFactura', () {
      final item = ItemFactura(
        descripcion: 'Servicio de instalación',
        cantidad: 3,
        precioUnitario: 100.00,
        descuento: 15.0,
      );
      expect(item.subtotal, 300.00); // 3 * 100.00
      expect(item.montoDescuento, 45.00); // 15% de 300.00
      expect(item.total, 255.00); // 300.00 - 45.00
    });
  });
}
