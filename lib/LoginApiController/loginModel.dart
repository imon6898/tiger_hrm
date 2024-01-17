

import 'dart:convert';

LoginModel loginModelFromJson(String str) => LoginModel.fromJson(json.decode(str));

String loginModelToJson(LoginModel data) => json.encode(data.toJson());

class LoginModel {
  String token;
  int loginId;
  String userName;
  String empName;
  String loginPassword;
  int userTypeId;
  String empCode;
  String isActive;
  int companyId;
  String companyName;
  int gender;
  int gradeValue;
  String department;
  String reportTo;
  dynamic recommendTo;

  LoginModel({
    required this.token,
    required this.loginId,
    required this.userName,
    required this.empName,
    required this.loginPassword,
    required this.userTypeId,
    required this.empCode,
    required this.isActive,
    required this.companyId,
    required this.companyName,
    required this.gender,
    required this.gradeValue,
    required this.department,
    required this.reportTo,
    required this.recommendTo,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    token: json["token"],
    loginId: json["loginID"],
    userName: json["userName"],
    empName: json["empName"],
    loginPassword: json["loginPassword"],
    userTypeId: json["userTypeId"],
    empCode: json["empCode"],
    isActive: json["isActive"],
    companyId: json["companyID"],
    companyName: json["companyName"],
    gender: json["gender"],
    gradeValue: json["gradeValue"],
    department: json["department"],
    reportTo: json["reportTo"],
    recommendTo: json["recommendTo"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "loginID": loginId,
    "userName": userName,
    "empName": empName,
    "loginPassword": loginPassword,
    "userTypeId": userTypeId,
    "empCode": empCode,
    "isActive": isActive,
    "companyID": companyId,
    "companyName": companyName,
    "gender": gender,
    "gradeValue": gradeValue,
    "department": department,
    "reportTo": reportTo,
    "recommendTo": recommendTo,
  };
}
