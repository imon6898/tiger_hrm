import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart' as printing;
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';

import '../../../../LoginApiController/loginController.dart';


Future<Map<String, dynamic>?> featchGetPaySlip(String empCode, selectedCategoryId, String companyID) async {
  var headers = {
    'Authorization': BaseUrl.authorization,
  };

  var request = http.Request(
    'GET',
    Uri.parse('${BaseUrl.baseUrl}/api/v1/salary/get-pay-slip/$empCode/$selectedCategoryId/$companyID/-1'),
  );

  request.headers.addAll(headers);

  http.StreamedResponse response = await request.send();

  if (response.statusCode == 200) {
    // Decode the response body using json.decode
    List<dynamic> dataList = json.decode(await response.stream.bytesToString());

    Map<String, dynamic> data = dataList.isNotEmpty ? dataList.first : {};

    // Extracting relevant fields from the API response
    var empCode = data['empCode'];
    var empName = data['empName'];
    var designation = data['designation'];
    var department = data['department'];
    var periodName = data['periodName'];
    var basic = data['basic'];
    var remuneration = data['remuneration'];
    var houseRent = data['houseRent'];
    var convAllo = data['convAllo'];
    var mediAllo = data['mediAllo'];
    var grossPay = data['grossPay'];
    var carAllo = data['carAllo'];
    var spacilAllo = data['spacilAllo'];
    var lfa = data['lfa'];
    var elEncase = data['elEncase'];
    var salesComm = data['salesComm'];
    var salaryAdj = data['salaryAdj'];
    var advance = data['advance'];
    var fstBonus = data['fstBonus'];
    var perBonus = data['perBonus'];
    var otherAddi = data['otherAddi'];
    var totalAddi = data['totalAddi'];
    var exCelBill = data['exCelBill'];
    var exFulBill = data['exFulBill'];
    var fmlyPackge = data['fmlyPackge'];
    var instalDeduct = data['instalDeduct'];
    var absDeduct = data['absDeduct'];
    var salaryDeduct = data['salaryDeduct'];
    var otherDeduct = data['otherDeduct'];
    var advanceDeduct = data['advanceDeduct'];
    var pfOwn = data['pfOwn'];
    var incomeTax = data['incomeTax'];
    var totalDeduct = data['totalDeduct'];
    var netPay = data['netPay'];
    var extraAddition = data['extraAddition'];
    var bank = data['bank'];
    var bankBranch = data['bankBranch'];
    var accountNo = data['accountNo'];
    var payby = data['payby'];

    return {
      'empCode' : empCode,
      'empName' : empName,
      'designation' : designation,
      'department' : department,
      'periodName' : periodName,
      'basic' : basic,
      'remuneration' : remuneration,
      'houseRent' : houseRent,
      'convAllo' : convAllo,
      'mediAllo' : mediAllo,
      'grossPay' : grossPay,
      'carAllo' : carAllo,
      'spacilAllo' : spacilAllo,
      'lfa' : lfa,
      'elEncase' : elEncase,
      'salesComm' : salesComm,
      'salaryAdj' : salaryAdj,
      'advance' : advance,
      'fstBonus' : fstBonus,
      'perBonus' : perBonus,
      'otherAddi' : otherAddi,
      'totalAddi' : totalAddi,
      'exCelBill' : exCelBill,
      'exFulBill' : exFulBill,
      'fmlyPackge' : fmlyPackge,
      'instalDeduct' : instalDeduct,
      'absDeduct' : absDeduct,
      'salaryDeduct' : salaryDeduct,
      'otherDeduct' : otherDeduct,
      'advanceDeduct' : advanceDeduct,
      'pfOwn' : pfOwn,
      'incomeTax' : incomeTax,
      'totalDeduct' : totalDeduct,
      'netPay' : netPay,
      'extraAddition' : extraAddition,
      'bank' : bank,
      'bankBranch' : bankBranch,
      'accountNo' : accountNo,
      'payby' : payby,

    };

  } else {
    print(response.reasonPhrase);
  }
}

Future<Uint8List> generatePdfPS(
    PdfPageFormat format,
    String empCode,
    String companyID,
    int selectedCategoryId) async {

  final Map<String, dynamic>? paySlipData = await featchGetPaySlip(empCode, selectedCategoryId, companyID);

  if (paySlipData == null) {
    // Handle the case where featchGetPaySlip failed
    print('Error fetching pay slip data');
    // You can return an empty Uint8List or handle it as per your requirement
    return Uint8List.fromList([]);
  }

  // Extract data from paySlipData
  //final String empCode = paySlipData['empCode'];
  final String empName = paySlipData['empName'] ?? '';
  final String designation = paySlipData['designation'] ?? '';
  final String department = paySlipData['department'] ?? '';
  final String periodName = paySlipData['periodName'] ?? '';
  final int basic = paySlipData['basic'] as int? ?? 0;
  final int remuneration = paySlipData['remuneration'] as int? ?? 0;
  final int houseRent = paySlipData['houseRent'] as int? ?? 0;
  final int convAllo = paySlipData['convAllo'] as int? ?? 0;
  final int mediAllo = paySlipData['mediAllo'] as int? ?? 0;
  final int grossPay = paySlipData['grossPay'] as int? ?? 0;
  final int carAllo = paySlipData['carAllo'] as int? ?? 0;
  final int spacilAllo = paySlipData['spacilAllo'] as int? ?? 0;
  final int lfa = paySlipData['lfa'] as int? ?? 0;
  final int elEncase = paySlipData['elEncase'] as int? ?? 0;
  final int salesComm = paySlipData['salesComm'] as int? ?? 0;
  final int salaryAdj = paySlipData['salaryAdj'] as int? ?? 0;
  final int advance = paySlipData['advance'] as int? ?? 0;
  final int fstBonus = paySlipData['fstBonus'] as int? ?? 0;
  final int perBonus = paySlipData['perBonus'] as int? ?? 0;
  final int otherAddi = paySlipData['otherAddi'] as int? ?? 0;
  final int totalAddi = paySlipData['totalAddi'] as int? ?? 0;
  final int exCelBill = paySlipData['exCelBill'] as int? ?? 0;
  final int exFulBill = paySlipData['exFulBill'] as int? ?? 0;
  final int fmlyPackge = paySlipData['fmlyPackge'] as int? ?? 0;
  final int instalDeduct = paySlipData['instalDeduct'] as int? ?? 0;
  final int absDeduct = paySlipData['absDeduct'] as int? ?? 0;
  final int salaryDeduct = paySlipData['salaryDeduct'] as int? ?? 0;
  final int otherDeduct = paySlipData['otherDeduct'] as int? ?? 0;
  final int advanceDeduct = paySlipData['advanceDeduct'] as int? ?? 0;
  final int pfOwn = paySlipData['pfOwn'] as int? ?? 0;
  final int incomeTax = paySlipData['incomeTax'] as int? ?? 0;
  final int totalDeduct = paySlipData['totalDeduct'] as int? ?? 0;
  final int netPay = paySlipData['netPay'] as int? ?? 0;
  final int extraAddition = paySlipData['extraAddition'] as int? ?? 0;

  final String bank = paySlipData['bank'] ?? '';
  final String bankBranch = paySlipData['bankBranch'] ?? '';
  final String accountNo = paySlipData['accountNo'] ?? '';
  final String payby = paySlipData['payby'] ?? '';



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
                              pw.Text(periodName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text(empCode, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text(empName, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text(designation, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text(department, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text(payby, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
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
                                  pwTableRow(['BASIC :', basic.toString()]),
                                  pwTableRow(['HOUSE RENT:', houseRent.toString()]),
                                  pwTableRow(['ENTERTAINMENT:', '0']),
                                  pwTableRow(['MEDICAL:', mediAllo.toString()]),
                                  pwTableRow(['TRANSPORT:', convAllo.toString()]),
                                  pwTableRow(['SPECIAL ALLOWNCE:', '0']),
                                  pwTableRow(['MOBILE ALLOWNCE:', '0']),
                                  pwTableRow(['ARREAR:', '0']),
                                  pwTableRowWithBold(['TOTAL ADDITION:', grossPay.toString()]),
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
                                  pwTableRow(['INCOME TAX:', incomeTax.toString()]),
                                  pwTableRow(['PROVIDENT FUND:', '0']),
                                  pwTableRow(['ADVANCE SALARY/LOAN:', '0']),
                                  pwTableRow(['FOODING:', '0']),
                                  pwTableRow(['LEAVE WITHOUT PAY:', '0']),
                                  pwTableRow(['OTHERS:', '0']),
                                  pwTableRow(['HOUSING POLICY:', '0']),
                                  pwTableRow(['None', '0']),
                                  pwTableRowWithBold(['TOTAL DEDUCTION:', totalDeduct.toString()]),
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
                              pw.Text(netPay.toString(), style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
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
                              pw.Text(bank, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text(bankBranch, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                              pw.SizedBox(height: 5),
                              pw.Text(accountNo, style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),

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