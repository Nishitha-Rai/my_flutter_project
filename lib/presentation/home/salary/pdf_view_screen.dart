import 'dart:io';
import 'package:employee_insight/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;

class PDFViewScreen extends StatelessWidget {
  final String path;
  final VoidCallback? onDownloadPressed;

  const PDFViewScreen({Key? key, required this.path, this.onDownloadPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(StringConstants.salarySlip),
        actions: [
          IconButton(
            icon: Icon(Icons.file_download),
            onPressed: onDownloadPressed,
          ),
        ],
      ),
      body: PDFView(
        filePath: path,
      ),
    );
  }
}



Future<File> generatePDF({
  required double housingAllowance,
  required double transportAllowance,
  required double otherAllowance,
  required double basicSalary,
}) async {
  final pdf = pw.Document();
  final totalSalary = housingAllowance + transportAllowance + otherAllowance + basicSalary;

  pdf.addPage(
    pw.Page(
      build: (pw.Context context) => pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(StringConstants.salaryBreakDown, style: pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
          pw.Divider(),
          pw.Text('${StringConstants.basicSalary}: \$${basicSalary.toStringAsFixed(2)}'),
          pw.Text('${StringConstants.houseAllowance}: \$${housingAllowance.toStringAsFixed(2)}'),
          pw.Text('${StringConstants.transportAllowance}: \$${transportAllowance.toStringAsFixed(2)}'),
          pw.Text('${StringConstants.otherAllowance}: \$${otherAllowance.toStringAsFixed(2)}'),
          pw.Divider(),
          pw.Text('${StringConstants.totalSalary}: \$${totalSalary.toStringAsFixed(2)}', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
        ],
      ),
    ),
  );

  final output = await getTemporaryDirectory();
  final file = File('${output.path}/salary_slip.pdf');
  await file.writeAsBytes(await pdf.save());
  return file;
}