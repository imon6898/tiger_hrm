import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart' as pw;

import 'util.dart';

class PSPdfPage extends StatefulWidget {
  final int selectedCategoryId;
  final String userName;
  final String empCode;
  final String companyID;
  final String companyName;

  const PSPdfPage({Key? key,
    required this.selectedCategoryId,
    required this.userName,
    required this.empCode,
    required this.companyID,
    required this.companyName,
  }) : super(key: key);

  @override
  State<PSPdfPage> createState() => _PSPdfPageState();
}

class _PSPdfPageState extends State<PSPdfPage> {
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
          'Pdf',
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
        build: (format) => generatePdfPS(format,
          widget.empCode,
          widget.companyID,
          widget.selectedCategoryId,
        ),
      ),
    );
  }
}
