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




Future<dynamic> fetchGetRptLoan(String empCode, String companyID) async {
  var headers = {
    'accept': '*/*',
    'Authorization': '${BaseUrl.authorization}',
  };

  var url = Uri.parse('${BaseUrl.baseUrl}/api/v1/salary/get-rpt-loaninfoledgerreport/$empCode/$companyID');

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




void saveDataToSharedPreferences( data) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  prefs.setString('empCode', data['empCode'] ?? '');
  prefs.setString('empName', data['empName'] ?? '');
  prefs.setString('designation', data['designation'] ?? '');
  prefs.setString('accountName', data['accountName'] ?? '');
  prefs.setString('loanDate', data['loanDate'] ?? '');
  prefs.setInt('salaryHeadID', data['salaryHeadID'] ?? 0);
  prefs.setInt('installmentStart', data['installmentStart'] ?? 0);
  prefs.setInt('loanAmount', data['loanAmount'] ?? 0);
  prefs.setInt('paid', data['paid'] ?? 0);
  prefs.setInt('downPayment', data['downPayment'] ?? 0);
  prefs.setInt('netLoan', data['netLoan'] ?? 0);
  prefs.setInt('noofInstallment', data['noofInstallment'] ?? 0);
  prefs.setInt('installmentType', data['installmentType'] ?? 0);
  prefs.setInt('installmentamount', data['installmentamount'] ?? 0);
  prefs.setInt('interest', data['interest'] ?? 0);
  prefs.setInt('companyID', data['companyID'] ?? 0);
  prefs.setString('remarks', data['remarks'] ?? '');
  prefs.setString('ddmmyy', data['ddmmyy'] ?? '');

}


int totalNetLoan = 0;
int totalPaid = 0;
int totalInstallmentAmount = 0;
int totalLoanAmount = 0;

Future<Uint8List>generateLoanPdf(final PdfPageFormat format, String empCode,
    String companyID, String userName, String companyName) async
{

  List individualLoanReport = await fetchGetRptLoan(empCode, companyID);

  final doc = pw.Document(
    title:  'Flutter School',
  );
  final logoImage=pw.MemoryImage((await rootBundle.load('lib/images/DailyStar.png')).buffer.asUint8List());

  final FooterImage=pw.MemoryImage((await rootBundle.load('lib/images/DailyStar.png')).buffer.asUint8List());

  final font=await rootBundle.load('lib/images/OpenSans-Regular.ttf');
  final ttf=pw.Font.ttf(font);

  final pageTheme=await _myPageTheme(format);

  doc.addPage(
    pw.MultiPage(
      pageTheme: pageTheme,
      header: (final context) => pw.Center(
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.center,
          children: [
            pw.Text('The Daily Star.', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
            pw.Text('64-65, Kazi Nazrul Islam Avenue, Dhaka-1215', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 11)),
            pw.Text('Head Wise Loan Summary Report', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 11)),
            pw.Text('Loan Summary By Type', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 11)),
          ],
        ),
      ),
      build: (final context) {
        final List<pw.Widget> content = [];
        if (individualLoanReport.isNotEmpty) {
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
                              pw.Text('PRINT DATE :', style: pw.TextStyle(
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
                              pw.Text(empCode, style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text(userName, style: pw.TextStyle(
                                  fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),

                              pw.Text(individualLoanReport[0]['designation'].toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

                              pw.SizedBox(height: 5),
                              pw.Text(
                                DateFormat('dd-MMM-yyyy').format(
                                    DateTime.now().toLocal()),
                                style: pw.TextStyle(
                                    fontWeight: pw.FontWeight.bold),
                              ),
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
      }

        // Table create
        List<pw.TableRow> tableRows = [];

        tableRows.add(
          pw.TableRow(
            children: [
              _buildTableCell(text: 'Account Name', width: 180, textAlign: pw.TextAlign.start),
              _buildTableCell(text: 'Loan Date', width: 100, textAlign: pw.TextAlign.center),
              _buildTableCell(text: 'Loan', width: 100, textAlign: pw.TextAlign.center),
              _buildTableCell(text: 'Paid', width: 100, textAlign: pw.TextAlign.center),
              _buildTableCell(text: 'EMI', width: 100, textAlign: pw.TextAlign.center),
              _buildTableCell(text: 'Balance', width: 100, textAlign: pw.TextAlign.end),
            ],
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex("#DDDDDD"),
            ),
          ),
        );

        for (int i = 0; i < individualLoanReport.length; i++) {

          int netLoanValue = individualLoanReport[0]['netLoan'] ?? 0;
          int paidValue = individualLoanReport[0]['paid'] ?? 0;
          int installmentAmountValue = individualLoanReport[0]['installmentamount'] ?? 0;
          int loanAmountValue = individualLoanReport[0]['loanAmount'] ?? 0;

          totalNetLoan = netLoanValue;
          totalPaid = paidValue;
          totalInstallmentAmount = installmentAmountValue;
          totalLoanAmount = loanAmountValue;

          tableRows.add(
            pw.TableRow(
              children: [
                pw.Padding(padding: pw.EdgeInsets.symmetric(horizontal: 10,vertical: 5),
                child: pw.Text(individualLoanReport[0]['accountName'].toString(), textAlign: pw.TextAlign.start),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(horizontal: 5, vertical: 5),
                  child: pw.Text(
                    _formatDate(individualLoanReport[0]['loanDate']),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: pw.Text(netLoanValue.toString(), textAlign: pw.TextAlign.center),
                ),
                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: pw.Text(paidValue.toString(), textAlign: pw.TextAlign.center),
                ),

                // Cell for 'installmentamount'
                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: pw.Text(installmentAmountValue.toString(), textAlign: pw.TextAlign.center),
                ),

                // Cell for 'loanAmount'
                pw.Padding(
                  padding: pw.EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  child: pw.Text(loanAmountValue.toString(), textAlign: pw.TextAlign.end),
                ),

              ],
            ),
          );

          // Check if the number of rows is a multiple of 20
          if (i % 100 == 0) {
            // Add the table rows to the content
            content.add(pw.Table(border: pw.TableBorder.all(), children: tableRows));
            // Clear the table rows for the next page
            tableRows = [];
          }
        }
        // Add the remaining rows if any
        if (tableRows.isNotEmpty) {
          content.add(pw.Table(border: pw.TableBorder.all(), children: tableRows));
        }

        content.add(
          pw.Container(
            padding: const pw.EdgeInsets.only(left: 0, bottom: 20),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              mainAxisAlignment: pw.MainAxisAlignment.start,
              children: [
                // Adding a Table with 2 columns and 1 row
                pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.black),
                  children: [
                    // TableRow
                    pw.TableRow(
                      children: [
                        // Cell 1
                        pw.Container(
                          width: 280,
                          padding: const pw.EdgeInsets.all(10.0),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.start,
                            children: [
                              pw.Text('GRAND TOTAL:', style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                            ],
                          ),
                        ),
                        // Cell 2
                        pw.Container(
                          width: 100,
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.center,

                            children: [
                              pw.Text(totalNetLoan.toString(), textAlign: pw.TextAlign.center),
                            ],
                          ),
                        ),
                        pw.Container(
                          width: 100,
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Text(totalPaid.toString(), textAlign: pw.TextAlign.center),
                            ],
                          ),
                        ),
                        // Cell 3
                        pw.Container(
                          width: 100,
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.center,
                            children: [
                              pw.Text(totalInstallmentAmount.toString(), textAlign: pw.TextAlign.center),
                            ],
                          ),
                        ),
                        pw.Container(
                          width: 100,
                          padding: const pw.EdgeInsets.all(8.0),
                          child: pw.Row(
                            mainAxisAlignment: pw.MainAxisAlignment.end,
                            children: [
                              pw.Text(totalLoanAmount.toString(), textAlign: pw.TextAlign.end),
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

        return content;
      },

    ),
  );
  return doc.save();
}


pw.Widget _buildTableCell({
  required String text,
  required double width,
  pw.TextAlign textAlign = pw.TextAlign.start,
}) {
  return pw.Container(
    width: width,
    padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 10),
    child: pw.Text(
      text,
      textAlign: textAlign,
      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
    ),
  );
}





Future<pw.PageTheme>_myPageTheme(PdfPageFormat format)async
{

  final logoImage=pw.MemoryImage((await rootBundle.load('lib/images/DailyStar.png')).buffer.asUint8List());


  return pw.PageTheme(
    margin: const pw.EdgeInsets.symmetric(
      horizontal: 1*PdfPageFormat.cm, vertical: 0.5*PdfPageFormat.cm
    ),
      textDirection: pw.TextDirection.ltr,
      orientation: pw.PageOrientation.portrait,
      buildBackground: (final context)=>pw.FullPage(
      ignoreMargins: true,
      child: pw.Watermark(
        angle: 7,
        child: pw.Opacity(
          opacity: 0.1,
          child: pw.Image(
            alignment: pw.Alignment.center,
            logoImage,
            fit: pw.BoxFit.cover,
          )
        )
      )
    )
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
  final file = File('$appDocPath/Loan.pdf');
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

String _formatDate(String dateString) {
  // Parse the original date string with the specific format
  DateTime originalDate = DateFormat('MM/dd/yyyy').parse(dateString);

  // Format the date using the desired format "dd-MMM-yyyy"
  String formattedDate = DateFormat('dd-MMM-yyyy').format(originalDate);

  return formattedDate;
}


