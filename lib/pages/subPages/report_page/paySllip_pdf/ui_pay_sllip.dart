import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:tiger_erp_hrm/Coustom_widget/Textfield.dart';
import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:tiger_erp_hrm/LoginApiController/loginController.dart';
import 'pdf_page.dart';

class CustomDropdown extends StatefulWidget {
  final String userName;
  final String empCode;
  final String companyID;
  final String companyName;

  CustomDropdown({
    super.key,
    required this.userName,
    required this.empCode,
    required this.companyID,
    required this.companyName,
  });

  @override
  _CustomDropdownState createState() => _CustomDropdownState();
}

class _CustomDropdownState extends State<CustomDropdown> {
  TextEditingController empCodeController = TextEditingController();
  SingleValueDropDownController itemController = SingleValueDropDownController();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  String? selectedCategoryId;
  List<DropDownValueModel> periodList = [];

  @override
  void initState() {
    super.initState();
    empCodeController.text = widget.empCode;
    fetchPeriodList();
  }

  Future<void> fetchPeriodList() async {
    var headers = {
      'Authorization': '${BaseUrl.authorization}',
    };

    var request = http.Request(
      'GET',
      Uri.parse('${BaseUrl.baseUrl}/api/v1/salary/get-period-list/1'),
    );
    request.headers.addAll(headers);

    try {
      http.Response response = await http.Response.fromStream(
        await http.Client().send(request),
      );
      if (response.statusCode == 200) {
        List<dynamic> data = jsonDecode(response.body);
        List<DropDownValueModel> fetchedList = data
            .map((item) => DropDownValueModel(
          name: item['periodName'],
          value: item['id'].toString(),
        ))
            .toList();
        setState(() {
          periodList = fetchedList;
        });
      } else {
        print('Failed to fetch data. Status code: ${response.statusCode}');
        print(response.reasonPhrase);
      }
    } catch (error) {
      print('Error during API request: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(height: 20),
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
          child: DropDownTextField(
            textFieldDecoration: InputDecoration(
              contentPadding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Color(0xFFBCC2C2)),
              ),
              disabledBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Color(0xFFBCC2C2)),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2, color: Colors.blueAccent),
              ),
              hintText: 'Select Month',
              labelText: 'Select Month',
              border: InputBorder.none,
            ),
            controller: itemController,
            clearOption: false,
            textFieldFocusNode: textFieldFocusNode,
            searchFocusNode: searchFocusNode,
            dropDownItemCount: 4,
            searchShowCursor: false,
            enableSearch: true,
            dropDownList: periodList,
            onChanged: (val) {
              selectedCategoryId = val.value;
              print('Selected value: $val');
            },
          ),
        ),
        SizedBox(height: 10),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: ElevatedButton(
            onPressed: () async {
              if (selectedCategoryId == null || selectedCategoryId!.isEmpty) {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      title: Text('Error'),
                      content: Text('Please select a month'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => PSPdfPage(
                      selectedCategoryId: int.parse(selectedCategoryId!),
                      userName: widget.userName,
                      empCode: widget.empCode,
                      companyID: widget.companyID,
                      companyName: widget.companyName,
                    ),
                  ),
                );
              }
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
        ),
      ],
    );
  }
}
