import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart' as printing; // Use an alias for the printing package
import 'package:path_provider/path_provider.dart';
import 'package:open_file/open_file.dart';


Future<Uint8List>generatePdf(final PdfPageFormat format) async
{
  final doc = pw.Document(
    title:  'Star Tech',
  );
  final logoImage=pw.MemoryImage((await rootBundle.load('lib/images/Star-Tech.png')).buffer.asUint8List());

  final FooterImage=pw.MemoryImage((await rootBundle.load('lib/images/Star-Tech.png')).buffer.asUint8List());

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
            pw.Text('Start Tech & Engineering LTD.', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 20)),
            pw.Text('6th floor, 28 Kazi Nazrul Islam Ave, Navana Zohura Square, Dhaka 1000', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 11)),
            pw.Text('Employee Monthly In & Out Report', style: pw.TextStyle(fontWeight: pw.FontWeight.bold,fontSize: 11)),
          ],
        ),
      ),
      build: (final context) {
        final List<pw.Widget> content = [];

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
                  //mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                              children: [
                                pw.Text('Emp.Code: ', textAlign: pw.TextAlign.right),
                                pw.Text('20', textAlign: pw.TextAlign.right),
                              ]
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
                                pw.Text('HR & Admin', textAlign: pw.TextAlign.right),
                              ]
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                pw.SizedBox(height: 5),

                pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  //mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                  children: [
                    pw.Expanded(
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Row(
                              children: [
                                pw.Text('Emp Name: ', textAlign: pw.TextAlign.right),
                                pw.Text('Imam Hossain', textAlign: pw.TextAlign.right),
                              ]
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
                                pw.Text('Manager', textAlign: pw.TextAlign.right),
                              ]
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                pw.SizedBox(height: 5),

                pw.Row(
                    children: [
                      pw.Text('Branch Name: ', textAlign: pw.TextAlign.right),
                      pw.Text('Head Office', textAlign: pw.TextAlign.right),
                    ]
                ),
              ],
            ),
          ),
        );

        // Table create
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
              _buildTableCell('Late'),
              _buildTableCell('Earlier'),
              _buildTableCell('Status'),
              _buildTableCell('Comment'),
            ],
            decoration: pw.BoxDecoration(
              color: PdfColor.fromHex("#DDDDDD"),
            ),
          ),
        );

        for (int i = 1; i <= 100; i++) {
          tableRows.add(
            pw.TableRow(
              children: [
                _buildTableDataCell(i.toString()),
                _buildTableDataCell('1-Nov-23'),
                _buildTableDataCell('Wednesday'),
                _buildTableDataCell('09:11'),
                _buildTableDataCell('21:21'),
                _buildTableDataCell('12:09:28'),
                _buildTableDataCell('satarday'),
                _buildTableDataCell('satarday'),
                _buildTableDataCell('satarday'),
                _buildTableDataCell('satarday'),
              ],
            ),
          );

          // Check if the number of rows is a multiple of 20

          if (i % 100 == 0) {
            // Add the table rows to the content
            content.add(

                pw.Table(
                    border: pw.TableBorder.all(),
                    children: tableRows
                ),
            );
            // Clear the table rows for the next page
            tableRows = [];
          }
        }
        // Add the remaining rows if any
        if (tableRows.isNotEmpty) {
          content.add(pw.Table(border: pw.TableBorder.all(), children: tableRows));
        }
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



Future<pw.PageTheme>_myPageTheme(PdfPageFormat format)async
{

  final logoImage=pw.MemoryImage((await rootBundle.load('lib/images/Star-Tech.png')).buffer.asUint8List());


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
          opacity: 0.4,
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
