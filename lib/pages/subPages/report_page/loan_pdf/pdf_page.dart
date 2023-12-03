import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:pdf/pdf.dart' as pw;

import 'util.dart';


class LPdfPage extends StatefulWidget {
  const LPdfPage({Key? key}) : super(key: key);

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
      if (!kIsWeb) const PdfPreviewAction(icon: Icon(Icons.save), onPressed: saveAsFile)
    ];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff162b4a),
        title: Text('Pdf',
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
        build: generatePdf,
      ),
    );
  }
}
