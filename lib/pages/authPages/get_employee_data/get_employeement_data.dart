import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../../LoginApiController/loginController.dart';



Future<Employee> getEmployeeData(String empCode, String companyID) async {
  try {
    String apiUrl = '${BaseUrl.baseUrl}/api/${v.v1}/GetEmployment/$empCode/$companyID';

    // Add your Authorization header
    Map<String, String> headers = {
      'Authorization': '${BaseUrl.authorization}',
      'accept': '*/*', // Include other headers if needed
    };

    http.Response response = await http.get(Uri.parse(apiUrl), headers: headers);

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);

      if (jsonList.isNotEmpty) {
        // Assuming you want the first employee in the list
        Map<String, dynamic> firstEmployeeData = jsonList.first;
        Employee employee = Employee.fromJson(firstEmployeeData);
        return employee;
      } else {
        print('Empty list of employee data.');
        return Employee(); // Returning a default Employee object with null values
      }
    } else {
      print('Failed to load employee data. Status code: ${response.statusCode}');
      return Employee(); // Returning a default Employee object with null values
    }
  } catch (e) {
    print('Error: $e');
    return Employee(); // Returning a default Employee object with null values
  }
}






class Employee {
  int? gender;
  String? businessNature;
  String? department;
  String? designation;
  String? gradeName;
  String? projectName;
  String? companyName;
  String? companyLocation;
  String? companyAddress;
  int? id;
  String? empName;
  String? empCode;
  int? companyID;
  int? businessNatureID;
  int? designationID;
  DateTime? joinDate;
  int? jobType;
  int? empGradeID;
  String? jobDescription;
  int? jobLocation;
  int? projectID;
  int? departmentID;
  String? confirmationDate;
  String? confirmationDueDate;
  String? cardNo;
  String? experience;
  String? resident;
  String? isComCar;
  String? status;
  int? location;
  String? isBlock;
  int? unit;
  int? machineID;
  String? reportTo;
  String? reportToEmpName;
  String? reportToDepartment;
  String? reportToDesignation;
  String? ot;
  DateTime? assainDate;
  String? type;
  int? active;
  int? gradeValue;
  int? empTypeID;
  int? userTypeId;

  Employee({
    this.gender,
    this.businessNature,
    this.department,
    this.designation,
    this.gradeName,
    this.projectName,
    this.companyName,
    this.companyLocation,
    this.companyAddress,
    this.id,
    this.empName,
    this.empCode,
    this.companyID,
    this.businessNatureID,
    this.designationID,
    this.joinDate,
    this.jobType,
    this.empGradeID,
    this.jobDescription,
    this.jobLocation,
    this.projectID,
    this.departmentID,
    this.confirmationDate,
    this.confirmationDueDate,
    this.cardNo,
    this.experience,
    this.resident,
    this.isComCar,
    this.status,
    this.location,
    this.isBlock,
    this.unit,
    this.machineID,
    this.reportTo,
    this.reportToEmpName,
    this.reportToDepartment,
    this.reportToDesignation,
    this.ot,
    this.assainDate,
    this.type,
    this.active,
    this.gradeValue,
    this.empTypeID,
    this.userTypeId,
  });

  factory Employee.fromJson(Map<String, dynamic> json) {
    return Employee(
      gender: json['gender'],
      businessNature: json['businessNature'],
      department: json['department'],
      designation: json['designation'],
      gradeName: json['gradeName'],
      projectName: json['projectName'],
      companyName: json['companyName'],
      companyLocation: json['companyLocation'],
      companyAddress: json['companyAddress'],
      id: json['id'],
      empName: json['empName'],
      empCode: json['empCode'],
      companyID: json['companyID'],
      businessNatureID: json['businessNatureID'],
      designationID: json['designationID'],
      joinDate: DateTime.parse(json['joinDate']),
      jobType: json['jobType'],
      empGradeID: json['empGradeID'],
      jobDescription: json['jobDescription'],
      jobLocation: json['jobLocation'],
      projectID: json['projectID'],
      departmentID: json['departmentID'],
      confirmationDate: json['confirmationDate'],
      confirmationDueDate: json['confirmationDueDate'],
      cardNo: json['cardNo'],
      experience: json['experience'],
      resident: json['resident'],
      isComCar: json['isComCar'],
      status: json['status'],
      location: json['location'],
      isBlock: json['isBlock'],
      unit: json['unit'],
      machineID: json['machineID'],
      reportTo: json['reportTo'],
      reportToEmpName: json['reportToEmpName'],
      reportToDepartment: json['reportToDepartment'],
      reportToDesignation: json['reportToDesignation'],
      ot: json['ot'],
      assainDate: DateTime.parse(json['assainDate']),
      type: json['type'],
      active: json['active'],
      gradeValue: json['gradeValue'],
      empTypeID: json['empTypeID'],
      userTypeId: json['userTypeId'],
    );
  }
}
