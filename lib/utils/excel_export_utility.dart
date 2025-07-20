import 'package:excel/excel.dart';
import 'package:flutter/foundation.dart';
import 'package:universal_html/html.dart' as html;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

/// Guarda el archivo en la carpeta Descargas y lo abre (no web)
Future<void> saveFileToDownloads(List<int> fileBytes, String fileName) async {
  try {
    Directory? downloadsDir;
    if (Platform.isAndroid) {
      downloadsDir = Directory('/storage/emulated/0/Download');
    } else if (Platform.isIOS) {
      downloadsDir = await getApplicationDocumentsDirectory();
    } else {
      downloadsDir = await getDownloadsDirectory();
    }
    if (downloadsDir == null) {
      throw Exception('No se pudo obtener la carpeta de descargas.');
    }
    final file = File('${downloadsDir.path}/$fileName');
    await file.writeAsBytes(fileBytes, flush: true);
    print('Archivo guardado en: ${file.path}');
    await OpenFile.open(file.path);
  } catch (e) {
    print('Error guardando archivo Excel: $e');
    throw Exception('Error guardando archivo Excel: $e');
  }
}

class ExcelSheetData {
  final String sheetName;
  final List<String> headers;
  final List<List<dynamic>> rows;
  ExcelSheetData({
    required this.sheetName,
    required this.headers,
    required this.rows,
  });
}

class ExcelExportUtility {
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
      if (kIsWeb) {
        await _downloadFile(fileBytes, fileName);
      } else {
        await saveFileToDownloads(fileBytes, fileName);
      }
    } catch (e) {
      throw Exception('Error exporting multiple sheets to Excel: $e');
    }
  }

  static Future<void> _downloadFile(
      List<int> fileBytes, String fileName) async {
    try {
      final blob = html.Blob(
        [fileBytes],
        'application/vnd.openxmlformats-officedocument.spreadsheetml.sheet',
      );
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement;
      anchor.href = url;
      anchor.style.display = 'none';
      anchor.download = fileName;
      html.document.body?.children.add(anchor);
      anchor.click();
      anchor.remove();
      html.Url.revokeObjectUrl(url);
    } catch (e) {
      throw Exception('Error downloading file: $e');
    }
  }
}
