import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart' as printing; // Use an alias for the printing package
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../LoginApiController/loginController.dart';

Future<dynamic> fetchGetRptAsset(String empCode, String companyID, String gradeValue) async {
  var headers = {
    'accept': '*/*',
    'Authorization': '${BaseUrl.authorization}',
  };

  var url = Uri.parse('${BaseUrl.baseUrl}/api/v1/salary/EmpCurrentAsset/$empCode/$companyID/$gradeValue');

  var response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var jsonResponseList = json.decode(response.body);
    if (jsonResponseList is List && jsonResponseList.isNotEmpty) {

      // Save data to shared preferences
      saveDataToSharedPreferences(jsonResponseList[0]);

      return jsonResponseList;
    } else {
      print('Empty response or invalid data structure');
    }
  } else {
    print('Request failed with status: ${response.statusCode}');
  }

  return [];
}

void saveDataToSharedPreferences(data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('empCode', data['empCode'] ?? '');
  prefs.setString('empName', data['empName'] ?? '');
  prefs.setString('designation', data['designation'] ?? '');
  prefs.setString('department', data['department'] ?? '');
  prefs.setString('categoryname', data['categoryname'] ?? '');
  prefs.setString('assetName', data['assetName'] ?? '');
  prefs.setInt('model', data['model'] ?? '');
  prefs.setInt('assainDate', data['assainDate'] ?? '');
  prefs.setInt('serial', data['serial'] ?? '');
  prefs.setInt('confiruration', data['confiruration'] ?? '');

  prefs.setInt('companyID', data['companyID'] ?? 0);
}

Future<Uint8List> generateAssetPdf(final PdfPageFormat format, String empCode,
    String companyID, String userName, String companyName, String gradeValue) async {
  List individualAssetReport = await fetchGetRptAsset(empCode, companyID, gradeValue,);

  if (individualAssetReport.isNotEmpty) { // Check if the list is not empty
    final doc = pw.Document(
      title: 'Flutter School',
    );
    final logoImage = pw.MemoryImage((await rootBundle.load('lib/images/DailyStar.png')).buffer.asUint8List());
    final FooterImage = pw.MemoryImage((await rootBundle.load('lib/images/DailyStar.png')).buffer.asUint8List());
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
              pw.Text('The Daily Star.', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20)),
              pw.Text('64-65, Kazi Nazrul Islam Avenue, Dhaka-1215', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
              pw.Text('Head Wise Asset Summary Report', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
              pw.Text('Asset Summary By Type', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            ],
          ),
        ),
        build: (final context) {
          final List<pw.Widget> content = [];
          if (individualAssetReport.isEmpty) {
            content.add(
                pw.Column(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Center(
                      child: pw.Text('Data not found', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 30)),
                    ),
                    // Other widgets can be added below if needed
                  ],
                )
            ); // Add a message when data is null
          } else {
            content.add(
              pw.Container(
                padding: const pw.EdgeInsets.only(left: 0, bottom: 20),
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
                                  pw.Text('EMP CODE :', style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                                  pw.SizedBox(height: 5),
                                  pw.Text('EMP NAME :', style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                                  pw.SizedBox(height: 5),
                                  pw.Text('DESIGNATION :', style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                                  pw.SizedBox(height: 5),
                                  pw.Text('DEPARTMENT :', style: pw.TextStyle(
                                      fontWeight: pw.FontWeight.bold)),
                                ],
                              ),
                            ),
                            // Cell 2
                            pw.Container(
                              padding: const pw.EdgeInsets.all(8.0),
                              child: pw.Column(
                                crossAxisAlignment: pw.CrossAxisAlignment.start,
                                children: [
                                  pw.Text(individualAssetReport[0]['empCode'],
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold)),
                                  pw.SizedBox(height: 5),
                                  pw.Text(individualAssetReport[0]['empName'],
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold)),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      individualAssetReport[0]['designation'],
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold)),
                                  pw.SizedBox(height: 5),
                                  pw.Text(
                                      individualAssetReport[0]['department'],
                                      style: pw.TextStyle(
                                          fontWeight: pw.FontWeight.bold)),
                                ],
                              ),
                            ),
                          ],
                        ),


                      ],
                    ),

                  ],
                ),
              ),
            );

            List<pw.TableRow> tableRows = [];
            tableRows.add(

              pw.TableRow(
                children: [
                  _buildTableCell(text: 'Asset Catagory.',
                      width: 100,
                      textAlign: pw.TextAlign.center),
                  _buildTableCell(text: 'Asset Name',
                      width: 100,
                      textAlign: pw.TextAlign.center),
                  _buildTableCell(text: 'Model',
                      width: 100,
                      textAlign: pw.TextAlign.center),
                  _buildTableCell(text: 'Serial',
                      width: 100,
                      textAlign: pw.TextAlign.center),
                  _buildTableCell(text: 'Configuration',
                      width: 100,
                      textAlign: pw.TextAlign.center),
                  _buildTableCell(text: 'Issue Date',
                      width: 100,
                      textAlign: pw.TextAlign.center),
                ],

                decoration: pw.BoxDecoration(
                  color: PdfColor.fromHex("#DDDDDD"),
                ),
              ),
            );


            if (individualAssetReport.isNotEmpty) {
              for (int i = 0; i < individualAssetReport.length; i++) {
                Map rowData = individualAssetReport[i];

                tableRows.add(
                  pw.TableRow(
                    children: [
                      _buildTableDataCell(rowData['categoryname'] ?? ''),
                      _buildTableDataCell(rowData['assetName'] ?? ''),
                      _buildTableDataCell(rowData['model'] ?? ''),
                      _buildTableDataCell(rowData['serial'] ?? ''),
                      _buildTableDataCell(rowData['confiruration'] ?? ''),
                      _buildTableDataCell(rowData['assainDate'] ?? ''),

                    ],
                  ),
                );


                content.add(
                  pw.Table(
                    border: pw.TableBorder.all(),
                    columnWidths: {
                      0: const pw.FixedColumnWidth(100), // SL.
                      1: const pw.FixedColumnWidth(100),     // Date
                      2: const pw.FixedColumnWidth(100),     // Day
                      3: const pw.FixedColumnWidth(100),     // In Time
                      4: const pw.FixedColumnWidth(100),     // Out Time
                      5: const pw.FixedColumnWidth(100),     // W/Hour
                          // Comment
                    },
                    children: tableRows,
                  ),
                );
                tableRows = [];

              }

              if (tableRows.isNotEmpty) {
                content.add(pw.Table(border: pw.TableBorder.all(), children: tableRows));
              }
            }

            if (tableRows.isNotEmpty) {
              content.add(pw.Table(border: pw.TableBorder.all(), children: tableRows));
            }
          }

          return content;
        },
      ),
    );
    return doc.save();
  } else {
    // Handle the case when the API response is empty
    print('Empty API response');
    // You can either show an error message or return a PDF document with an appropriate message
    return _generateEmptyDocument(format);
  }
}

// Function to generate a PDF document with an empty message
Future<Uint8List> _generateEmptyDocument(final PdfPageFormat format) async {
  final doc = pw.Document(
    title: 'Empty Document',
  );

  // Add a page with a message indicating empty data
  doc.addPage(pw.Page(
    build: (context) {
      return pw.Center(
        child: pw.Text(
          'No data available',
          style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
        ),
      );
    },
  ));

  // Save the document to a byte array
  return doc.save();
}

pw.Widget _buildTableCell({
  required String text,
  required double width,
  pw.TextAlign textAlign = pw.TextAlign.start,
}) {
  return pw.Container(
    width: width,
    padding: const pw.EdgeInsets.symmetric(horizontal: 5, vertical: 10),
    child: pw.Text(
      text,
      textAlign: textAlign,
      style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 10),
    ),
  );
}


pw.Widget _buildTableDataCell(String text) {
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 1, vertical: 1),
    child: pw.Text(
      text,
      textAlign: pw.TextAlign.center,
      style: pw.TextStyle(fontSize: 10),
    ),
  );
}


Future<pw.PageTheme> _myPageTheme(PdfPageFormat format) async {
  final logoImage = pw.MemoryImage((await rootBundle.load('lib/images/DailyStar.png')).buffer.asUint8List());

  return pw.PageTheme(
    margin: const pw.EdgeInsets.symmetric(
      horizontal: 1 * PdfPageFormat.cm,
      vertical: 0.5 * PdfPageFormat.cm,
    ),
    textDirection: pw.TextDirection.ltr,
    orientation: pw.PageOrientation.portrait,
    buildBackground: (final context) => pw.FullPage(
      ignoreMargins: true,
      child: pw.Watermark(
        angle: 7,
        child: pw.Opacity(
          opacity: 0.1,
          child: pw.Image(
            alignment: pw.Alignment.center,
            logoImage,
            fit: pw.BoxFit.cover,
          ),
        ),
      ),
    ),
  );
}

Future<void> saveAsFile(
    BuildContext context,
    printing.LayoutCallback build, // Use printing.LayoutCallback
    PdfPageFormat pageFormat,
    ) async {
  final bytes = await build(pageFormat);

  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  final file = File('$appDocPath/document.pdf');
  print('Save as file ${file.path}...');
  await file.writeAsBytes(bytes);
  await OpenFile.open(file.path);
}

void showPrintedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Document Printed successfully")),
  );
}

void showShearedToast(final BuildContext context) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(content: Text("Document Sheared successfully")),
  );
}

String _formatDate(String dateString) {
  // Parse the original date string with the specific format
  DateTime originalDate = DateFormat('MM/dd/yyyy').parse(dateString);

  // Format the date using the desired format "dd-MMM-yyyy"
  String formattedDate = DateFormat('dd-MMM-yyyy').format(originalDate);

  return formattedDate;
}
