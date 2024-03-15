import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart' as pw;

import 'util.dart';

class APdfPage extends StatefulWidget {
  final String userName;
  final String empCode;
  final String companyID;
  final String companyName;
  final String gradeValue;

  const APdfPage({Key? key,
    required this.userName,
    required this.empCode,
    required this.companyID,
    required this.companyName,
    required this.gradeValue,
  }) : super(key: key);

  @override
  State<APdfPage> createState() => _PSPdfPageState();
}

class _PSPdfPageState extends State<APdfPage> {
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
      if (!kIsWeb) const PdfPreviewAction(icon: Icon(Icons.save), onPressed: saveAsFile),
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff162b4a),
        title: Text(
          'Assets Pdf',
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
        onPrinted: showPrintedToast,
        onShared: showShearedToast,
        build: (format) => generateAssetPdf(format,
          widget.empCode,
          widget.companyID,
          widget.userName,
          widget.companyName,
          widget.gradeValue
        ),
      ),
    );
  }
}
