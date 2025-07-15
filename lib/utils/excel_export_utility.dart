import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:excel/excel.dart';
import 'package:universal_html/html.dart' as html;

/// A custom utility class for exporting Firestore collections to Excel files.
///
/// This utility is designed to be compatible with the latest versions of
/// the excel package and Dart SDK.
class ExcelSheetData {
  final String sheetName;
  final List<String> headers;
  final List<List<dynamic>> rows;
  ExcelSheetData(
      {required this.sheetName, required this.headers, required this.rows});
}

class ExcelExportUtility {
  /// Exports a Firestore collection to an Excel file.
  ///
  /// [collectionName] - The name of the Firestore collection to fetch data from.
  /// [headers] - The list of headers for the Excel file.
  /// [mapper] - A function that maps Firestore document data to a list of values for each row.
  /// [sheetName] - The name of the Excel sheet.
  /// [fileName] - The name of the resulting Excel file (default: 'export.xlsx').
  /// [queryBuilder] - An optional function to customize the Firestore query.
  static Future<void> exportToExcel({
    required String collectionName,
    required List<String> headers,
    required List<dynamic> Function(Map<String, dynamic>) mapper,
    required String sheetName,
    String fileName = 'export.xlsx',
    Query Function(Query query)? queryBuilder,
  }) async {
    try {
      // Build Firestore query
      Query query = FirebaseFirestore.instance.collection(collectionName);
      if (queryBuilder != null) {
        query = queryBuilder(query);
      }

      // Fetch data from Firestore
      QuerySnapshot snapshot = await query.get();

      if (snapshot.docs.isEmpty) {
        throw Exception(
            'No data found in the Firestore collection: $collectionName');
      }

      // Initialize Excel
      var excel = Excel.createExcel();
      Sheet sheetObject = excel['Sheet1'];

      // Create header cell style
      CellStyle headerCellStyle = CellStyle(
        backgroundColorHex: ExcelColor.blue,
        fontFamily: getFontFamily(FontFamily.Calibri),
        fontSize: 12,
        horizontalAlign: HorizontalAlign.Center,
        verticalAlign: VerticalAlign.Center,
        bold: true,
      );

      // Write headers to the first row
      for (int i = 0; i < headers.length; i++) {
        var cell = sheetObject.cell(
          CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0),
        );
        cell.cellStyle = headerCellStyle;
        cell.value = TextCellValue(headers[i]);
      }

      // Create data cell style
      var dataCellStyle = CellStyle(
        fontFamily: getFontFamily(FontFamily.Calibri),
        fontSize: 12,
        horizontalAlign: HorizontalAlign.Left,
        verticalAlign: VerticalAlign.Center,
      );

      // Write data rows
      int rowIndex = 1;
      for (var doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final row = mapper(data);

        for (int i = 0; i < row.length; i++) {
          var cell = sheetObject.cell(
            CellIndex.indexByColumnRow(columnIndex: i, rowIndex: rowIndex),
          );
          cell.cellStyle = dataCellStyle;
          cell.value = row[i] != null
              ? TextCellValue(row[i].toString())
              : TextCellValue('');
        }
        rowIndex++;
      }

      // set column widths)
      for (int i = 0; i < headers.length; i++) {
        sheetObject.setColumnWidth(i, 20.0);
      }

      // Rename the default sheet to the desired name
      excel.rename(sheetObject.sheetName, sheetName);

      // Encode Excel file
      List<int>? fileBytes = excel.encode();
      if (fileBytes == null) {
        throw Exception("Failed to encode Excel file.");
      }

      // Create and trigger download (for web platform)
      await _downloadFile(fileBytes, fileName);
    } catch (e) {
      throw Exception('Error exporting to Excel: $e');
    }
  }

  /// Exporta múltiples hojas a un solo archivo Excel (una hoja por empleado, por ejemplo)
  static Future<void> exportMultipleSheets({
    required List<ExcelSheetData> sheets,
    String fileName = 'export.xlsx',
  }) async {
    try {
      var excel = Excel.createExcel();
      // Eliminar la hoja por defecto
      excel.delete('Sheet1');
      for (final sheetData in sheets) {
        final sheet = excel[sheetData.sheetName];
        // Header
        for (int i = 0; i < sheetData.headers.length; i++) {
          var cell = sheet
              .cell(CellIndex.indexByColumnRow(columnIndex: i, rowIndex: 0));
          cell.value = TextCellValue(sheetData.headers[i]);
        }
        // Data
        for (int r = 0; r < sheetData.rows.length; r++) {
          final row = sheetData.rows[r];
          for (int c = 0; c < row.length; c++) {
            var cell = sheet.cell(
                CellIndex.indexByColumnRow(columnIndex: c, rowIndex: r + 1));
            cell.value = TextCellValue(row[c]?.toString() ?? '');
          }
        }
        // Column widths
        for (int i = 0; i < sheetData.headers.length; i++) {
          sheet.setColumnWidth(i, 20.0);
        }
      }
      List<int>? fileBytes = excel.encode();
      if (fileBytes == null) throw Exception("Failed to encode Excel file.");
      await _downloadFile(fileBytes, fileName);
    } catch (e) {
      throw Exception('Error exporting multiple sheets to Excel: $e');
    }
  }

  /// Downloads the Excel file on web platform
  static Future<void> _downloadFile(
      List<int> fileBytes, String fileName) async {
    try {
      // Create a Blob from the bytes
      final blob = html.Blob(
        [fileBytes],
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      );

      // Generate a download URL
      final url = html.Url.createObjectUrlFromBlob(blob);

      // Create an anchor element and trigger the download
      final anchor = html.document.createElement('a') as html.AnchorElement;
      anchor.href = url;
      anchor.style.display = 'none';
      anchor.download = fileName;

      html.document.body?.children.add(anchor);

      // Trigger the download
      anchor.click();

      // Clean up by removing the anchor and revoking the URL
      anchor.remove();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      throw Exception('Error downloading file: $e');
    }
  }
}
