import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart' as pw;
import 'package:tiger_erp_hrm/pages/subPages/report_page/loan_pdf/util.dart' as loan_util;

class LPdfPage extends StatefulWidget {
  final String userName;
  final String empCode;
  final String companyID;
  final String companyName;
  const LPdfPage({
    Key? key,
    required this.userName,
    required this.empCode,
    required this.companyID,
    required this.companyName,
  }) : super(key: key);

  @override
  State<LPdfPage> createState() => _LPdfPageState();
}

class _LPdfPageState extends State<LPdfPage> {
  PrintingInfo? printingInfo;

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

  @override
  Widget build(BuildContext context) {
    final action = <PdfPreviewAction>[
      if (!kIsWeb) PdfPreviewAction(icon: Icon(Icons.save), onPressed: loan_util.saveAsFile)
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff162b4a),
        title: Text(
          'Loan Pdf',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.white),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: PdfPreview(
        maxPageWidth: 700,
        actions: action,
        onPrinted: loan_util.showPrintedToast,
        onShared: loan_util.showShearedToast,
        build: (format) => loan_util.generateLoanPdf(
          format,
          widget.empCode,
          widget.companyID,
          widget.userName,
          widget.companyName,
        ),
      ),
    );
  }
}
