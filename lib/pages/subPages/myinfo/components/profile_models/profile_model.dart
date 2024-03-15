// To parse this JSON data, do
//
//     final profileModel = profileModelFromJson(jsonString);

import 'dart:convert';

List<ProfileModel> profileModelFromJson(String str) => List<ProfileModel>.from(json.decode(str).map((x) => ProfileModel.fromJson(x)));

String profileModelToJson(List<ProfileModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ProfileModel {
  String? empCode;
  String? empName;
  String? department;
  String? designation;
  String? dateOfJoining;
  String? grade;
  String? photo;

  ProfileModel({
    this.empCode,
    this.empName,
    this.department,
    this.designation,
    this.dateOfJoining,
    this.grade,
    this.photo,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) => ProfileModel(
    empCode: json["empCode"],
    empName: json["empName"],
    department: json["department"],
    designation: json["designation"],
    dateOfJoining: json["dateOfJoining"],
    grade: json["grade"],
    photo: json["photo"],
  );

  Map<String, dynamic> toJson() => {
    "empCode": empCode,
    "empName": empName,
    "department": department,
    "designation": designation,
    "dateOfJoining": dateOfJoining,
    "grade": grade,
    "photo": photo,
  };
}
