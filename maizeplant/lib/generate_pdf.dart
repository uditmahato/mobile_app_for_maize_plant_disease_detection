import 'package:pdf/widgets.dart' as pw;
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:open_file/open_file.dart';

class GeneratePdfPage {
  static Future<void> generatePdf({
    required Uint8List imageData,
    required String prediction,
    required double confidenceLevel,
    required String symptoms,
    required String treatments,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) {
          return pw.Center(
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Text(
                  'Report of Disease Detected',
                  style: pw.TextStyle(
                      fontSize: 24, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 20),
                if (imageData.isNotEmpty)
                  pw.Center(
                    child: pw.Image(pw.MemoryImage(imageData)),
                  ),
                pw.SizedBox(height: 20),
                pw.Text(
                  'Prediction: $prediction',
                  style: pw.TextStyle(
                      fontSize: 18, fontWeight: pw.FontWeight.bold),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 10),
                pw.Text(
                  'Confidence Level: ${confidenceLevel.toStringAsFixed(2)}%',
                  style: pw.TextStyle(fontSize: 16),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 30),
                pw.Text(
                  'Symptoms: \n$symptoms',
                  style: pw.TextStyle(fontSize: 16),
                  textAlign: pw.TextAlign.center,
                ),
                pw.SizedBox(height: 30),
                pw.Text(
                  'Treatments: \n$treatments',
                  style: pw.TextStyle(fontSize: 16),
                  textAlign: pw.TextAlign.center,
                ),
              ],
            ),
          );
        },
      ),
    );

    // Mobile platform-specific code to save and open the PDF
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/example.pdf");
    await file.writeAsBytes(await pdf.save());

    // Open the PDF file using the 'open_file' package
    OpenFile.open(file.path);
  }
}
