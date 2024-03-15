// loginModel.dart

import 'dart:convert';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';

part 'loginModel.g.dart';

@HiveType(typeId: 0)
class LoginModel {
  String? token;
  String? loginId;
  String? userName;
  String? empName;
  String? empMail;
  String? loginPassword;
  int? userTypeId;
  String? empCode;
  String? isActive;
  int? companyId;
  String? companyName;
  int? gender;
  int? gradeValue;
  String? department;
  String? reportTo;
  String? recommendToEmail;
  dynamic recommendTo;

  @HiveField(8)
  Position? location;

  LoginModel({
    this.token,
    this.loginId,
    this.userName,
    this.empName,
    this.empMail,
    this.loginPassword,
    this.userTypeId,
    this.empCode,
    this.isActive,
    this.companyId,
    this.companyName,
    this.gender,
    this.gradeValue,
    this.department,
    this.reportTo,
    this.recommendTo,
    this.recommendToEmail,
  });


  factory LoginModel.fromJson(Map<String, dynamic> json) => LoginModel(
    token: json["token"],
    loginId: json["loginID"],
    userName: json["userName"],
    empName: json["empName"],
    empMail: json["empMail"],
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
    recommendToEmail: json["recommendToEmail"],
  );

  Map<String, dynamic> toJson() => {
    "token": token,
    "loginID": loginId,
    "userName": userName,
    "empName": empName,
    "empMail": empMail,
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
    "recommendToEmail": recommendToEmail,
  };
}
