import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class RecommendationWidget extends StatefulWidget {
  final String token;
  final String empCode;
  final String companyID;
  final TextEditingController forwardToIDController;
  final TextEditingController forwardToNameController;
  final TextEditingController forwardToDesignationController;
  final TextEditingController remarkController;

  RecommendationWidget({
    required this.forwardToIDController,
    required this.forwardToNameController,
    required this.forwardToDesignationController,
    required this.remarkController,
    required this.token,
    required this.empCode,
    required this.companyID,
  });

  @override
  _RecommendationWidgetState createState() => _RecommendationWidgetState();
}

class _RecommendationWidgetState extends State<RecommendationWidget> {
  void fetchDutiesEmployeeData(String empCode) async {
    empCode = empCode ?? 'defaultEmpCode';
    var headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer ${widget.token}',
    };

    var response = await http.get(
      Uri.parse('http://175.29.186.86:7021/api/v1/GetEmployment/$empCode/${widget.companyID}'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      if (data.isNotEmpty) {
        // Assuming you want the first item from the list
        Map<String, dynamic> firstItem = data[0];
        setState(() {
          widget.forwardToNameController.text = firstItem['empName'];
          widget.forwardToDesignationController.text = firstItem['designation'];
        });
      }
    } else {
      print('Failed to fetch employee data: ${response.reasonPhrase}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text('Are you sure you want to recommend?'),
        SizedBox(height: 10),
        TextField(
          controller: widget.forwardToIDController,
          onChanged: (value) {
            fetchDutiesEmployeeData(value);
          },
          decoration: InputDecoration(
            labelText: 'Forward to ID',
            border: OutlineInputBorder(), // Add a border to the TextField
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: widget.forwardToNameController,
          enabled: false,
          decoration: InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(), // Add a border to the TextField
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: widget.forwardToDesignationController,
          enabled: false,
          decoration: InputDecoration(
            labelText: 'Designation',
            border: OutlineInputBorder(), // Add a border to the TextField
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: widget.remarkController,
          decoration: InputDecoration(
            labelText: 'Remark',
            border: OutlineInputBorder(), // Add a border to the TextField
          ),
        ),
      ],
    );
  }
}
