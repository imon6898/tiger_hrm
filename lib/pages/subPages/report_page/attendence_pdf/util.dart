import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart' as printing;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../../../../LoginApiController/loginController.dart';


///api integration




Future<List<dynamic>> getIndividualInOutReport(String empCode, String companyID, String fromDate, String endDate) async {
  var headers = {
    'Authorization': '${BaseUrl.authorization}',
  };

  var url = Uri.parse('${BaseUrl.baseUrl}/api/v1/atten/get-individual-inout-report/$empCode/$companyID/$fromDate/$endDate');

  var response = await http.get(url, headers: headers);

  if (response.statusCode == 200) {
    var jsonResponseList = json.decode(response.body);

    if (jsonResponseList is List && jsonResponseList.isNotEmpty) {
      // Save data to shared preferences
      saveDataToSharedPreferences(jsonResponseList[0]);
      return jsonResponseList;
    } else {
      // No data found, return an empty list
      return [];
    }
  } else {
    print('Request failed with status: ${response.statusCode}');
  }

  return []; // or throw an exception
}

void saveDataToSharedPreferences( data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('date', data['date'] ?? '');
  prefs.setString('day', data['day'] ?? '');
  prefs.setString('login', data['login']?? '');
  prefs.setString('logout', data['logout'] ?? '');
  prefs.setString('workingHour', data['workingHour'] ?? '');
  prefs.setString('lates', data['lates'] ?? '');
  prefs.setString('earlier', data['earlier'] ?? '');
  prefs.setString('status', data['status'] ?? '');
}

Future<Uint8List> generatePdf(final PdfPageFormat format, String empCode,
    String companyID, String fromDate, String endDate) async {


  List individualInOutReport = await getIndividualInOutReport(empCode, companyID, fromDate, endDate);



  print("individualInOutReport: $individualInOutReport");
  final doc = pw.Document(
    title: 'Star Tech',
  );

  final logoImage = pw.MemoryImage((await rootBundle.load('lib/images/DailyStar.png')).buffer.asUint8List());
  final pageTheme = await _myPageTheme(format);

  doc.addPage(
    pw.MultiPage(
      pageTheme: await _myPageTheme(format),
      header: (final context) => pw.Center(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text('The Daily Star.', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 20)),
            pw.Text('64-65, Kazi Nazrul Islam Avenue, Dhaka-1215', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
            pw.Text('Employee Monthly In & Out Report', style: pw.TextStyle(fontWeight: pw.FontWeight.bold, fontSize: 11)),
          ],
        ),
      ),
      build: (final context) {
        final List<pw.Widget> content = [];

        if (individualInOutReport.isEmpty) {
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
              padding: const pw.EdgeInsets.only(left: 30, bottom: 20),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.center,
                mainAxisAlignment: pw.MainAxisAlignment.start,
                children: [
                  pw.Padding(padding: const pw.EdgeInsets.only(top: 20)),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Text('Emp.Code: ', textAlign: pw.TextAlign.right),
                                pw.Text(individualInOutReport[0]['empCodS'].toString(), textAlign: pw.TextAlign.right),
                              ],
                            ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Row(
                              children: [
                                pw.Text('Department: ', textAlign: pw.TextAlign.right),
                                pw.Text(individualInOutReport[0]['department'].toString(), textAlign: pw.TextAlign.right),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 5),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.start,
                          children: [
                            pw.Row(
                              children: [
                                pw.Text('Emp Name: ', textAlign: pw.TextAlign.right),
                                pw.Text(individualInOutReport[0]['empName'].toString(), textAlign: pw.TextAlign.right),
                              ],
                            ),
                          ],
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Column(
                          crossAxisAlignment: pw.CrossAxisAlignment.end,
                          children: [
                            pw.Row(
                              children: [
                                pw.Text('Designation: ', textAlign: pw.TextAlign.right),
                                pw.Text(individualInOutReport[0]['designation'].toString(), textAlign: pw.TextAlign.right),
                              ],
                            ),
                          ],
                        ),
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
                _buildTableCell('SL.'),
                _buildTableCell('Date'),
                _buildTableCell('Day'),
                _buildTableCell('In Time'),
                _buildTableCell('Out Time'),
                _buildTableCell('W/Hour'),
                //_buildTableCell('Late'),
                _buildTableCell('Earlier'),
                _buildTableCell('Status'),
                _buildTableCell('Comment'),
              ],

              decoration: pw.BoxDecoration(
                color: PdfColor.fromHex("#DDDDDD"),
              ),
            ),
          );


          if (individualInOutReport.isNotEmpty) {
            for (int i = 0; i < individualInOutReport.length; i++) {
              Map rowData = individualInOutReport[i];

              tableRows.add(
                pw.TableRow(
                  children: [
                    _buildTableDataCell((i + 1).toString()),
                    _buildTableDataCell(rowData['date'] ?? ''),
                    _buildTableDataCell(rowData['day'] ?? ''),
                    _buildTableDataCell(rowData['login'] ?? ''),
                    _buildTableDataCell(rowData['logout'] ?? ''),
                    _buildTableDataCell(rowData['workingHour'] ?? ''),
                    //_buildTableDataCell(rowData['lates'] ?? ''),
                    _buildTableDataCell(rowData['earlier'] ?? ''),
                    _buildTableDataCell(rowData['status'] ?? ''),
                    _buildTableDataCell(rowData['comment'] ?? ''),
                  ],
                ),
              );


              content.add(
                pw.Table(
                  border: pw.TableBorder.all(),
                  columnWidths: {
                    0: const pw.FixedColumnWidth(20), // SL.
                    1: const pw.FlexColumnWidth(1.2),     // Date
                    2: const pw.FlexColumnWidth(),     // Day
                    3: const pw.FlexColumnWidth(),     // In Time
                    4: const pw.FlexColumnWidth(),     // Out Time
                    5: const pw.FlexColumnWidth(),     // W/Hour
                    6: const pw.FlexColumnWidth(),     // Late
                    7: const pw.FlexColumnWidth(),     // Earlier
                    8: const pw.FlexColumnWidth(),     // Status
                    9: const pw.FlexColumnWidth(),     // Comment
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


        // Table create

        return content;
      },
    ),
  );
  return doc.save();
}

pw.Widget _buildTableCell(String text) {
  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 1, vertical: 1),
    child: pw.Text(
      text,
      textAlign: pw.TextAlign.center,
      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
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
      horizontal: 1 * PdfPageFormat.cm, vertical: 0.5 * PdfPageFormat.cm,
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
    printing.LayoutCallback build,
    PdfPageFormat pageFormat,
    ) async {
  final bytes = await build(pageFormat);

  final appDocDir = await getApplicationDocumentsDirectory();
  final appDocPath = appDocDir.path;
  final file = File('$appDocPath/Attendance.pdf');
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
