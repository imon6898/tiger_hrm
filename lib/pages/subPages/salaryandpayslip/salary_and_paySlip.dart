import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../Coustom_widget/Textfield.dart';
import '../../../controller/dashboard_controller.dart';
import '../report_page/assets_pdf/assets_pdf_page.dart';
import '../report_page/loan_pdf/pdf_page.dart';
import '../report_page/paySllip_pdf/ui_pay_sllip.dart';

class SalaryAndPaySlip extends StatefulWidget {

  const SalaryAndPaySlip({super.key});

  @override
  State<SalaryAndPaySlip> createState() => _SalaryAndPaySlipState();
}

class _SalaryAndPaySlipState extends State<SalaryAndPaySlip> {

  TextEditingController empCodeController = TextEditingController();
  var dashboardControl = Get.put(DashboardController());

  @override
  void initState() {
    super.initState();
    empCodeController.text = dashboardControl.loginModel?.empCode ?? '';
  }

  @override
  Widget build(BuildContext context) {

    var userName = dashboardControl.loginModel?.userName ?? '';
    var empCode = dashboardControl.loginModel?.empCode ?? '';
    var companyID = dashboardControl.loginModel?.companyId?.toString() ?? '';
    var companyName = dashboardControl.loginModel?.companyName ?? '';
    var gradeValue = dashboardControl.loginModel?.gradeValue?.toString() ?? '';

    return Scaffold(
      backgroundColor: const Color(0xffe9f0fd),
      appBar: AppBar(
        backgroundColor: const Color(0xff162b4a),
        title: const Text(
          "Salary And PaySlip",
          style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Colors.white
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios,color: Colors.white),
          onPressed: () { Navigator.pop(context); },

        ),
      ),

      body: Padding(
        padding: const EdgeInsets.all(8),
        child: Column(
          children: [
            Card(
                child: ListTile(
                  title: const Text('Pay Slip'),
                  subtitle: const Text('Check Your Pay Sllip'),
                  onTap: () {

                    Get.bottomSheet(
                        Container(
                            decoration: const BoxDecoration(
                              color: Color(0xffefebef),
                              borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                            ),
                            child: CustomDropdown(
                              userName: userName,
                              empCode: empCode,
                              companyID: companyID,
                              companyName: companyName,
                            )
                        )
                    );
                  },
                )
            ),

            const SizedBox(height: 10,),

            Card(
                child: ListTile(
                  title: const Text('Loan Report'),
                  subtitle: const Text('Check Your Loan Report'),
                  onTap: () {
                    Get.bottomSheet(
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xffefebef),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
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
                                          userName: userName,
                                          empCode: empCode,
                                          companyID: companyID,
                                          companyName: companyName,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: const StadiumBorder(),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
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

            const SizedBox(height: 10,),

            Card(
                child: ListTile(
                  title: const Text('Assets Report'),
                  subtitle: const Text('Check Your Assets Report'),
                  onTap: () {
                    Get.bottomSheet(
                        Container(
                          decoration: const BoxDecoration(
                            color: Color(0xffefebef),
                            borderRadius: BorderRadius.only(topLeft: Radius.circular(20),topRight: Radius.circular(20)),
                          ),
                          child: Column(
                            children: [
                              const SizedBox(height: 10),
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
                                          userName: userName,
                                          empCode: empCode,
                                          companyID: companyID,
                                          companyName: companyName,
                                          gradeValue: gradeValue,
                                        ),
                                      ),
                                    );
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green,
                                    shape: const StadiumBorder(),
                                  ),
                                  child: const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: EdgeInsetsDirectional.fromSTEB(0, 0, 10, 0),
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
