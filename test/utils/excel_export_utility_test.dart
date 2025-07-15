import 'package:flutter_test/flutter_test.dart';
import 'package:client_service/utils/excel_export_utility.dart';

void main() {
  group('ExcelExportUtility', () {
    test('crea datos de Excel correctamente', () {
      final sheets = [
        ExcelSheetData(
          sheetName: 'Empleado_123',
          headers: ['Fecha', 'Hora Entrada', 'Hora Salida', 'Email'],
          rows: [
            ['2024-06-01', '08:00', '17:00', 'empleado1@empresa.com'],
            ['2024-06-02', '08:05', '17:10', 'empleado1@empresa.com'],
          ],
        ),
        ExcelSheetData(
          sheetName: 'Empleado_456',
          headers: ['Fecha', 'Hora Entrada', 'Hora Salida', 'Email'],
          rows: [
            ['2024-06-01', '08:10', '17:20', 'empleado2@empresa.com'],
          ],
        ),
      ];

      // Verificar que los datos se crean correctamente
      expect(sheets.length, 2);
      expect(sheets[0].sheetName, 'Empleado_123');
      expect(sheets[0].headers.length, 4);
      expect(sheets[0].rows.length, 2);
      expect(sheets[1].sheetName, 'Empleado_456');
      expect(sheets[1].rows.length, 1);
    });

    test('valida estructura de ExcelSheetData', () {
      final sheetData = ExcelSheetData(
        sheetName: 'Test',
        headers: ['Col1', 'Col2'],
        rows: [
          ['Valor1', 'Valor2']
        ],
      );

      expect(sheetData.sheetName, 'Test');
      expect(sheetData.headers, ['Col1', 'Col2']);
      expect(sheetData.rows, [
        ['Valor1', 'Valor2']
      ]);
    });
  });
}
