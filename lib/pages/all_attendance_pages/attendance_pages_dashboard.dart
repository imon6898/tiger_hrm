import 'dart:io';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tiger_erp_hrm/LoginApiController/loginController.dart';
import 'package:tiger_erp_hrm/LoginApiController/loginModel.dart';
import 'package:tiger_erp_hrm/pages/authPages/get_employee_data/get_employeement_data.dart';
import 'package:tiger_erp_hrm/pages/subPages/apply_attendence/apply_attendance.dart';
import 'package:tiger_erp_hrm/pages/subPages/approve_attend.dart';
import '../../../Coustom_widget/neumorphic_button.dart';
import '../../Coustom_widget/CustomDatePickerField.dart';
import '../../Coustom_widget/Textfield.dart';
import '../subPages/report_page/attendence_pdf/pdf_page.dart';
import '../subPages/report_page/selecting_report.dart';
// import 'package:google_fonts/google_fonts.dart';
import 'package:pdf/widgets.dart' as pw;



class AttendancePagesDashBoard extends StatefulWidget {
  final LoginModel? loginModel;
  final Position? location;
  const AttendancePagesDashBoard({
    Key? key,
    this.loginModel,
    this.location,

  }) : super(key: key);

  @override
  State<AttendancePagesDashBoard> createState() => _AttendancePagesDashBoardState();
}

class _AttendancePagesDashBoardState extends State<AttendancePagesDashBoard> {
  List _photos = [
    Data(image: 'lib/images/A1.png', text: 'Apply\nAttendance'),
    Data(image: 'lib/images/A2.png', text: 'Approve\nAttend. by HR'),
    Data(image: 'lib/images/A2.png', text: 'Attendance\nReport'),

  ];



  @override
  Widget build(BuildContext context) {

    String userName = widget.loginModel?.userName ?? 'N/A';
    String empCode = widget.loginModel?.empCode ?? 'N/A';
    int? companyId = widget.loginModel?.companyId;
    String companyName = widget.loginModel?.companyName ?? 'N/A';
    String empName = widget.loginModel?.empName ?? 'N/A';
    String reportTo = widget.loginModel?.reportTo ?? 'N/A';
    int? gradeValue = widget.loginModel?.gradeValue;
    int? gender = widget.loginModel?.gender;
    int? userTypeId = widget.loginModel?.userTypeId;
    Position? location = widget.location;


    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff162b4a),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_rounded, color: Colors.white,),
        ),
        title: Text(
          "Attendance Page",
          style: TextStyle(color: Colors.white, fontSize: 30, fontFamily: 'Kanit'),
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        color: Color(0xffe9f0fd),
        child: GridView.builder(
            itemCount: _photos.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2, ),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(10.0),
                child: NeumorphicButton(
                  imagePathAsset: _photos[index].image,
                  buttonText: _photos[index].text,
                  onTap: () {
                    // Handle item tap here
                    switch (_photos[index].text) {
                      case 'Apply\nAttendance':
                        Future.delayed(Duration(milliseconds: 60), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => AttendancePage(
                              userName: userName,
                              empCode: empCode,
                              companyID: companyId?.toString() ?? '',
                              companyName: companyName,
                              location: widget.location ?? Position(
                                latitude: 0.0,
                                longitude: 0.0,
                                accuracy: 0.0,
                                altitude: 0.0,
                                altitudeAccuracy: 0.0,
                                heading: 0.0,
                                headingAccuracy: 0.0,
                                speed: 0.0,
                                speedAccuracy: 0.0,
                                timestamp: DateTime.now(),
                              ),
                            )),
                          );
                        });
                        break;
                      case 'Approve\nAttend. by HR':
                        Future.delayed(Duration(milliseconds: 60), () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => ApproveAttendPage()),
                          );
                        });

                        break;
                      case 'Attendance\nReport':
                        Future.delayed(Duration(milliseconds: 60), () {

                          // Navigator.push(
                          //   context,
                          //   MaterialPageRoute(builder: (context) => ReportPage(
                          //     userName: userName,
                          //     empCode: empCode,
                          //     companyID: companyId?.toString() ?? '',
                          //     companyName: companyName,
                          //       gradeValue: gradeValue?.toString() ?? '',
                          //   )),
                          // );

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
                                                userName: userName,
                                                empCode: empCode,
                                                companyID: companyId?.toString() ?? '',
                                                companyName: companyName,
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
                        });
                        break;

                    // Add cases for other pages as needed
                    };
                  },
                ),
              );
            }),
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    empCodeController.text = widget.loginModel?.empCode ?? 'N/A';
  }

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


}

class Data {
  String image;
  String text;

  Data({required this.image,required this.text});

}