import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../Coustom_widget/Textfield.dart';
import '../report_page/assets_pdf/assets_pdf_page.dart';
import '../report_page/loan_pdf/pdf_page.dart';
import '../report_page/paySllip_pdf/ui_pay_sllip.dart';

class SalaryAndPaySlip extends StatefulWidget {
  final String userName;
  final String empCode;
  final String companyID;
  final String companyName;
  final String gradeValue;

  const SalaryAndPaySlip({
    super.key,
    required this.userName,
    required this.empCode,
    required this.companyID,
    required this.companyName,
    required this.gradeValue,
  });

  @override
  State<SalaryAndPaySlip> createState() => _SalaryAndPaySlipState();
}

class _SalaryAndPaySlipState extends State<SalaryAndPaySlip> {

  TextEditingController empCodeController = TextEditingController();

  @override
  void initState() {
    super.initState();
    empCodeController.text = widget.empCode;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffe9f0fd),
      appBar: AppBar(
        backgroundColor: const Color(0xff162b4a),
        title: Text(
          "Salary And PaySlip",
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
        padding: EdgeInsets.all(8),
        child: Column(
          children: [
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

            SizedBox(height: 10,),

            Card(
                child: ListTile(
                  title: const Text('Assets Report'),
                  subtitle: const Text('Check Your Assets Report'),
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
                                        builder: (context) => APdfPage(
                                          userName: widget.userName,
                                          empCode: widget.empCode,
                                          companyID: widget.companyID,
                                          companyName: widget.companyName,
                                          gradeValue: widget.gradeValue,
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
