import 'package:employee_insight/constants/image_constants.dart';
import 'package:employee_insight/constants/string_constants.dart';
import 'package:employee_insight/presentation/home/salary/pdf_view_screen.dart';
import 'package:employee_insight/presentation/widgets/app_scaffold.dart';
import 'package:flutter/material.dart';
import 'package:employee_insight/presentation/theme/app_color.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:share_plus/share_plus.dart';

class SalaryDetailsScreen extends StatelessWidget {
  const SalaryDetailsScreen({super.key});

  final double housingAllowance = 5000.0;
  final double transportAllowance = 2000.0;
  final double otherAllowance = 1000.0;
  final double basicSalary = 15000.0;

  @override
  Widget build(BuildContext context) {
    final totalSalary =
        housingAllowance + transportAllowance + otherAllowance + basicSalary;

    final salaryTextStyle = Theme.of(context).textTheme.titleLarge;

    return AppScaffold(
      titleText: StringConstants.salaryDetails,
      showBackArrow: true,
      scaffoldBody: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            SizedBox(
              height: 0.3.sh,
              width: 0.6.sw,
              child: Image.asset(
                ImageConstants.salaryGif,
                fit: BoxFit.contain,
              ),
            ),
            Card(
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      StringConstants.salaryBreakDown,
                      style:
                      Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: AppColor.primaryColor,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text(StringConstants.basicSalary),
                      trailing: Text('\$${basicSalary.toStringAsFixed(2)}',
                        style: salaryTextStyle,),
                    ),
                    ListTile(
                      title: const Text(StringConstants.houseAllowance),
                      trailing: Text(
                        '\$${housingAllowance.toStringAsFixed(2)}',
                        style: salaryTextStyle,
                      ),
                    ),
                    ListTile(
                      title: const Text(StringConstants.transportAllowance),
                      trailing: Text(
                        '\$${transportAllowance.toStringAsFixed(2)}',
                        style:  salaryTextStyle,
                      ),
                    ),
                    ListTile(
                      title: const Text(StringConstants.otherAllowance),
                      trailing: Text('\$${otherAllowance.toStringAsFixed(2)}',
                        style: salaryTextStyle,),
                    ),
                    const Divider(),
                    ListTile(
                      title: const Text(
                        StringConstants.totalSalary,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      trailing: Text(
                        '\$${totalSalary.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.bold
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    Padding(
                      padding: const EdgeInsets.only(left: 210),
                      child: GestureDetector(
                          onTap: () async {
                            final pdfFile = await generatePDF(
                              housingAllowance: housingAllowance,
                              transportAllowance: transportAllowance,
                              otherAllowance: otherAllowance,
                              basicSalary: basicSalary,
                            );
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PDFViewScreen(
                                  path: pdfFile.path,
                                  onDownloadPressed: () async {
                                    await _downloadPDF(pdfFile.path);
                                  },
                                ),
                              ),
                            );
                          },
                          child: Text(
                            StringConstants.viewDetails,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: AppColor.darkPurple),
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<File> generatePDF({
    required double housingAllowance,
    required double transportAllowance,
    required double otherAllowance,
    required double basicSalary,
  }) async {
    final pdf = pw.Document();
    final totalSalary =
        housingAllowance + transportAllowance + otherAllowance + basicSalary;

    pdf.addPage(
      pw.Page(
        build: (pw.Context context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(StringConstants.salaryBreakDown,
                style:
                pw.TextStyle(fontSize: 24, fontWeight: pw.FontWeight.bold)),
            pw.Divider(),
            pw.Text(
                '${StringConstants.basicSalary}: \$${basicSalary.toStringAsFixed(2)}'),
            pw.Text(
                '${StringConstants.houseAllowance}: \$${housingAllowance.toStringAsFixed(2)}'),
            pw.Text(
                '${StringConstants.transportAllowance}: \$${transportAllowance.toStringAsFixed(2)}'),
            pw.Text(
                '${StringConstants.otherAllowance}: \$${otherAllowance.toStringAsFixed(2)}'),
            pw.Divider(),
            pw.Text(
                '${StringConstants.totalSalary}: \$${totalSalary.toStringAsFixed(2)}',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
          ],
        ),
      ),
    );

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/salary_slip.pdf');
    await file.writeAsBytes(await pdf.save());
    return file;
  }

  Future<void> _downloadPDF(String filePath) async {
    final pdfFile = File(filePath);
    final xFile = XFile(pdfFile.path);
    await Share.shareXFiles([xFile], text: StringConstants.salarySlip);
  }
}