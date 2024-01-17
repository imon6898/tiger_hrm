
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tiger_erp_hrm/Coustom_widget/customTextFieldbyimam.dart';
import 'paySllip_pdf/ui_pay_sllip.dart';
import '../../../Coustom_widget/CustomDropdownField.dart';
import '../../../Coustom_widget/Textfield.dart';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tiger_erp_hrm/Coustom_widget/CustomDatePickerField.dart';
import 'package:http/http.dart' as http;
import 'package:pdf/widgets.dart' as pw;
import 'attendence_pdf/pdf_page.dart';
import 'loan_pdf/pdf_page.dart';
import 'paySllip_pdf/pdf_page.dart';




class ReportPage extends StatefulWidget {
  final String userName;
  final String empCode;
  final String companyID;
  final String companyName;

  const ReportPage({super.key,
    required this.userName,
    required this.empCode,
    required this.companyID,
    required this.companyName,
  });

  @override
  State<ReportPage> createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> {

  TextEditingController empCodeController = TextEditingController();
  TextEditingController fromDateController = TextEditingController();
  TextEditingController endDateController = TextEditingController();


  String? selectedSalaryPeriod;
  List<String>? salaryPeriods;
  bool isDropdownVisible = false;


  static final String title = 'Invoice';

  DateTime? fromDate;
  DateTime? endDate;

  Future<void> fromSelectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        fromDate = picked;
        fromDateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  Future<void> endSelectDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        endDate = picked;
        endDateController.text = picked.toString().split(" ")[0];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    empCodeController.text = widget.empCode;
  }



  Future<File> generatePdf(String fromDate, String endDate) async {
    final pdf = pw.Document();

    // Add content to the PDF (customize this based on your requirements)
    pdf.addPage(
      pw.Page(
        build: (context) {
          return pw.Center(
            child: pw.Text('Hello World!'),
          );
        },
      ),
    );

    // Save the PDF to a file
    final output = await getTemporaryDirectory();
    final file = File("${output.path}/example.pdf");
    await file.writeAsBytes(await pdf.save());

    return file; // Return the generated File object
  }






  bool isExpandedSalaryPeriodId = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe9f0fd),
      appBar: AppBar(
        backgroundColor: const Color(0xff162b4a),
        title: Text(
          "Select Report",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios,color: Colors.white),
          onPressed: () { Navigator.pop(context); },

        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [

            Card(
                child: ListTile(
                  title: const Text('Attendence Report'),
                  subtitle: const Text('Check Your Attendence Report'),
                  onTap: () {
                    Get.bottomSheet(
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffefebef),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              CustomTextFields(
                                labelText: 'Employee Code',
                                hintText: 'Employee Code',
                                borderColor: 0xFFBCC2C2,
                                filled: true,
                                disableOrEnable: false,
                                controller: empCodeController,
                              ),
                              CustomDatePickerField(
                                controller: fromDateController,
                                hintText: 'Select a date',
                                labelText: 'From Date',
                                disableOrEnable: true,
                                borderColor: 0xFFBCC2C2,
                                filled: true,
                                onTap: () => fromSelectDate(),
                              ),
                              CustomDatePickerField(
                                controller: endDateController,
                                hintText: 'Select a date',
                                labelText: 'End Date',
                                disableOrEnable: true,
                                borderColor: 0xFFBCC2C2,
                                filled: true,
                                onTap: () => endSelectDate(),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // Call the function to generate the PDF and get the File object
                                    //File pdfFile = await generatePdf();

                                    String formattedFromDate = fromDate!.toString().split(" ")[0];
                                    String formattedEndDate = endDate!.toString().split(" ")[0];

                                    // Call the function to generate the PDF and get the File object
                                    File pdfFile = await generatePdf(formattedFromDate, formattedEndDate);

                                    print('From Date: $formattedFromDate');
                                    print('End Date: $formattedEndDate');

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PdfPage(
                                          userName: widget.userName,
                                          empCode: widget.empCode,
                                          companyID: widget.companyID,
                                          companyName: widget.companyName,
                                          fromDate: fromDate!,
                                          endDate: endDate!,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: StadiumBorder(),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                        child: Icon(Icons.save_as_outlined, color: Colors.white),
                                      ),
                                      Text(
                                        'Generate Pdf',
                                        style: TextStyle(fontSize: 20, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                    );
                  },
                )
            ),

            SizedBox(height: 10,),

            Card(
                child: ListTile(
                  title: const Text('Pay Sllip'),
                  subtitle: const Text('Check Your Pay Sllip'),
                  onTap: () {

                    Get.bottomSheet(
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffefebef),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                          ),
                          child: CustomDropdown(
                            userName: widget.userName,
                            empCode: widget.empCode,
                            companyID: widget.companyID,
                            companyName: widget.companyName,
                          )
                        )
                    );
                  },
                )
            ),

            SizedBox(height: 10,),

            Card(
                child: ListTile(
                  title: const Text('Loan Report'),
                  subtitle: const Text('Check Your Loan Report'),
                  onTap: () {
                    Get.bottomSheet(
                        Container(
                          decoration: BoxDecoration(
                            color: Color(0xffefebef),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              SizedBox(height: 10),
                              CustomTextFields(
                                labelText: 'Employee Code',
                                hintText: 'Employee Code',
                                borderColor: 0xFFBCC2C2,
                                filled: true,
                                disableOrEnable: false,
                                controller: empCodeController,
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                                child: ElevatedButton(
                                  onPressed: () async {
                                    // Call the function to generate the PDF and get the File object
                                    //File pdfFile = await generatePdf();

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => LPdfPage(
                                          userName: widget.userName,
                                          empCode: widget.empCode,
                                          companyID: widget.companyID,
                                          companyName: widget.companyName,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: StadiumBorder(),
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
                                        child: Icon(Icons.save_as_outlined, color: Colors.white),
                                      ),
                                      Text(
                                        'Generate Pdf',
                                        style: TextStyle(fontSize: 20, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          ),
                        )
                    );
                  },
                )
            ),

          ],
        ),
      ),
    );
  }
}
