import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart' as pw;
import 'package:http/http.dart' as http;
import 'package:tiger_erp_hrm/pages/subPages/report_page/attendence_pdf/util.dart';
import '../../../../LoginApiController/loginController.dart';




class PdfPage extends StatefulWidget {

  final String userName;
  final String empCode;
  final String companyID;
  final String companyName;
  final DateTime fromDate;
  final DateTime endDate;

  const PdfPage({
    Key? key,
    required this.userName,
    required this.empCode,
    required this.companyID,
    required this.companyName,
    required this.fromDate,
    required this.endDate,
  }) : super(key: key);

  @override
  State<PdfPage> createState() => _PdfPageState();
}

class _PdfPageState extends State<PdfPage> {
  PrintingInfo? printingInfo;
  //late List<GetIndividualInOutReportModel> reportData;

  @override
  void initState() {
    super.initState();
    _init();

  }

  Future<void> _init() async {
    final info = await Printing.info();
    setState(() {
      printingInfo = info;
    });
  }

  String formatDate(DateTime date) {
    return "${date.year}-${_twoDigits(date.month)}-${_twoDigits(date.day)}";
  }

  String _twoDigits(int n) {
    if (n >= 10) return "$n";
    return "0$n";
  }


  @override
  Widget build(BuildContext context) {
    final action = <PdfPreviewAction>[
      if (!kIsWeb) const PdfPreviewAction(icon: Icon(Icons.save), onPressed: saveAsFile)
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff162b4a),
        title: Text('Attendance Pdf',
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.white),
          onPressed: () { Navigator.pop(context); },

        ),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        actions: action,
        onPrinted: showPrintedToast,
        onShared: showShearedToast,
        build: (format) => generatePdf(format,
          widget.empCode,
          widget.companyID,
          formatDate(widget.fromDate),
          formatDate(widget.endDate),
        ),
      ),
    );
  }
}