import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart' as printing;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

Future<Uint8List> generatePdfPS(final PdfPageFormat format) async {
  final doc = pw.Document(
    title: 'Flutter School',
  );
  final logoImage = pw.MemoryImage((await rootBundle.load('lib/images/Star-Tech.png')).buffer.asUint8List());

  final FooterImage = pw.MemoryImage((await rootBundle.load('lib/images/Star-Tech.png')).buffer.asUint8List());

  final font = await rootBundle.load('lib/images/OpenSans-Regular.ttf');
  final ttf = pw.Font.ttf(font);

  final pageTheme = await _myPageTheme(format);

  doc.addPage(
    pw.MultiPage(
      pageTheme: pageTheme,
      header: (final context) => pw.Center(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text('Start Tech & Engineering LTD.', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20)),
            pw.Text('6th floor, 28 Kazi Nazrul Islam Ave, Navana Zohura Square, Dhaka 1000',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.Text('Pay Slip', style: pw.TextStyle(color: PdfColors.blue, fontWeight: pw.FontWeight.bold, fontSize: 15)),
          ],
        ),
      ),
      build: (final context) {
        final List<pw.Widget> content = [];

        content.add(
          pw.Container(
            padding: const pw.EdgeInsets.only(left: 20, bottom: 20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                pw.Padding(padding: const pw.EdgeInsets.only(top: 20)),
                // Adding a Table with 2 columns and 1 row
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.black),
                  children: [
                    // TableRow
                    pw.TableRow(
                      children: [
                        // Cell 1
                        pw.Container(
                          width: 50,
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('MONTH :', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text('EMP CODE :', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text('EMP NAME :', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text('DESIGNATION :', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text('DEPARTMENT :', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text('MODE :', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                        ),
                        // Cell 2
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('November-2022', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text('20', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text('Aminul Karim Khan', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text('Manager', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text('HR & Admin', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text('Bank', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                pw.SizedBox(height: 10),

                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.black),
                  children: [
                    // TableRow
                    pw.TableRow(
                      children: [
                        // Cell 1
                        pw.Container(
                          width: format.availableWidth / 2 - 8.0,  // Adjust padding
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Text('ADDITION', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                        ),
                        // Cell 2
                        pw.Container(
                          width: format.availableWidth / 2 - 8.0,  // Adjust padding
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Text('DEDUCTION', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.black),
                  children: [


                    pw.TableRow(
                      children: [
                        // Cell 1
                        pw.Container(
                          width: format.availableWidth / 2 - 8.0,  // Adjust padding
                          child: pw.Column(
                            children: [
                              pw.Table(
                                border: pw.TableBorder.all(color: PdfColors.black),
                                children: [
                                  pwTableRow(['BASIC :', '31,900']),
                                  pwTableRow(['HOUSE RENT:', '15,950']),
                                  pwTableRow(['ENTERTAINMENT:', '0']),
                                  pwTableRow(['MEDICAL:', '3,190']),
                                  pwTableRow(['TRANSPORT:', '2,500']),
                                  pwTableRow(['SPECIAL ALLOWNCE:', '0']),
                                  pwTableRow(['MOBILE ALLOWNCE:', '0']),
                                  pwTableRow(['ARREAR:', '0']),
                                  pwTableRowWithBold(['TOTAL ADDITION:', '53,540']),
                                ],
                              ),
                            ],
                          ),
                        ),
                        // Cell 2
                        pw.Container(
                          width: format.availableWidth / 2 - 8.0,  // Adjust padding
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.center,
                            children: [
                              pw.Table(
                                border: pw.TableBorder.all(color: PdfColors.black),
                                children: [
                                  // Row 1
                                  pwTableRow(['INCOME TAX:', '417']),
                                  pwTableRow(['PROVIDENT FUND:', '0']),
                                  pwTableRow(['ADVANCE SALARY/LOAN:', '0']),
                                  pwTableRow(['FOODING:', '0']),
                                  pwTableRow(['LEAVE WITHOUT PAY:', '0']),
                                  pwTableRow(['OTHERS:', '0']),
                                  pwTableRow(['HOUSING POLICY:', '0']),
                                  pwTableRow(['None', '0']),
                                  pwTableRowWithBold(['TOTAL DEDUCTION:', '417']),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    // Header row

                  ],
                ),

                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.black),
                  children: [
                    // TableRow
                    pw.TableRow(
                      children: [
                        // Cell 1
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Row(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                            children: [
                              pw.Text('NET PAYABLE:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.Text('50,000', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                pw.SizedBox(height: 10),

                pw.Text('NET PAYMENT HAS BEEN TRANSFERD TO THE FOLLOWING ACCOUNT:',
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

                pw.SizedBox(height: 10),

                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.black),
                  children: [
                    // TableRow
                    pw.TableRow(
                      children: [
                        // Cell 1
                        pw.Container(
                          width: 50,
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('BANK NAME:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text('BRANCH NAME:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text('ACCOUNT NUMBER:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

                            ],
                          ),
                        ),
                        // Cell 2
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Column(
                            crossAxisAlignment: pw.CrossAxisAlignment.start,
                            children: [
                              pw.Text('The Bank', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text('Banani', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text('1912100014331', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),


                pw.SizedBox(height: 10),


                pw.Text('N.B. Please confirm any descrepancy in this statement in written within 07(seven) days',
                    style: pw.TextStyle(fontSize: 11)),

                pw.SizedBox(height: 10),

              ],
            ),
          ),
        );

        return content;
      },
    ),
  );
  return doc.save();
}





pw.TableRow pwTableRow(List<String> texts) {
  return pw.TableRow(
    children: texts.map((text) => pw.Container(
      padding: const pw.EdgeInsets.all(8.0),
      child: pw.Text(text, style: pw.TextStyle(fontSize: 10,)),
    )).toList(),
  );
}pw.TableRow pwTableRowWithBold(List<String> texts) {
  return pw.TableRow(
    children: texts.map((text) => pw.Container(
      padding: const pw.EdgeInsets.all(8.0),
      child: pw.Text(text, style: pw.TextStyle(fontSize: 10,fontWeight: pw.FontWeight.bold)),
    )).toList(),
  );
}









Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  final logoImage = pw.MemoryImage((await rootBundle.load('lib/images/Star-Tech.png')).buffer.asUint8List());

  return pw.PageTheme(
      margin: const pw.EdgeInsets.symmetric(horizontal: 1 * PdfPageFormat.cm, vertical: 0.5 * PdfPageFormat.cm),
      textDirection: pw.TextDirection.ltr,
      orientation: pw.PageOrientation.portrait,
      buildBackground: (final context) => pw.FullPage(
          ignoreMargins: true,
          child: pw.Watermark(
              angle: 7,
              child: pw.Opacity(
                  opacity: 0.3,
                  child: pw.Image(
                    alignment: pw.Alignment.center,
                    logoImage,
                    fit: pw.BoxFit.cover,
                  )))));
}

Future<void> saveAsFile(BuildContext context, printing.LayoutCallback build, PdfPageFormat pageFormat) async {
  final bytes = await build(pageFormat);

  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  final file = File('$appDocPath/document.pdf');
  print('Save as file ${file.path}...');
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}

void showPrintedToast(final BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Document Printed successfully"))
  );
}

void showShearedToast(final BuildContext context){
  ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Document Sheared successfully"))
  );
}