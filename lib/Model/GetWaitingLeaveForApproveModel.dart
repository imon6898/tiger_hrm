
import 'dart:convert';

List<GetWaitingLeaveForApproveModel> getWaitingLeaveForApproveModelFromJson(String str) => List<GetWaitingLeaveForApproveModel>.from(json.decode(str).map((x) => GetWaitingLeaveForApproveModel.fromJson(x)));

String getWaitingLeaveForApproveModelToJson(List<GetWaitingLeaveForApproveModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class GetWaitingLeaveForApproveModel {
  String empName;
  String designation;
  String department;
  String typeName;
  int id;
  String empCode;
  DateTime startDate;
  DateTime endDate;
  DateTime applicationDate;
  int accepteDuration;
  int leaveTypedId;
  dynamic unAccepteDuration;
  dynamic referanceEmpcode;
  String grandtype;
  dynamic yyyymmdd;
  String withpay;
  dynamic appType;
  int companyId;
  dynamic applyTo;
  dynamic reason;
  dynamic emgContructNo;
  dynamic emgAddress;
  dynamic userName;
  dynamic authorityEmpcode;

  GetWaitingLeaveForApproveModel({
    required this.empName,
    required this.designation,
    required this.department,
    required this.typeName,
    required this.id,
    required this.empCode,
    required this.startDate,
    required this.endDate,
    required this.applicationDate,
    required this.accepteDuration,
    required this.leaveTypedId,
    required this.unAccepteDuration,
    required this.referanceEmpcode,
    required this.grandtype,
    required this.yyyymmdd,
    required this.withpay,
    required this.appType,
    required this.companyId,
    required this.applyTo,
    required this.reason,
    required this.emgContructNo,
    required this.emgAddress,
    required this.userName,
    required this.authorityEmpcode,
  });

  factory GetWaitingLeaveForApproveModel.fromJson(Map<String, dynamic> json) => GetWaitingLeaveForApproveModel(
    empName: json["empName"],
    designation: json["designation"],
    department: json["department"],
    typeName: json["typeName"],
    id: json["id"],
    empCode: json["empCode"],
    startDate: DateTime.parse(json["startDate"]),
    endDate: DateTime.parse(json["endDate"]),
    applicationDate: DateTime.parse(json["applicationDate"]),
    accepteDuration: json["accepteDuration"],
    leaveTypedId: json["leaveTypedID"],
    unAccepteDuration: json["unAccepteDuration"],
    referanceEmpcode: json["referanceEmpcode"],
    grandtype: json["grandtype"],
    yyyymmdd: json["yyyymmdd"],
    withpay: json["withpay"],
    appType: json["appType"],
    companyId: json["companyID"],
    applyTo: json["applyTo"],
    reason: json["reason"],
    emgContructNo: json["emgContructNo"],
    emgAddress: json["emgAddress"],
    userName: json["userName"],
    authorityEmpcode: json["authorityEmpcode"],
  );

  Map<String, dynamic> toJson() => {
    "empName": empName,
    "designation": designation,
    "department": department,
    "typeName": typeName,
    "id": id,
    "empCode": empCode,
    "startDate": startDate.toIso8601String(),
    "endDate": endDate.toIso8601String(),
    "applicationDate": applicationDate.toIso8601String(),
    "accepteDuration": accepteDuration,
    "leaveTypedID": leaveTypedId,
    "unAccepteDuration": unAccepteDuration,
    "referanceEmpcode": referanceEmpcode,
    "grandtype": grandtype,
    "yyyymmdd": yyyymmdd,
    "withpay": withpay,
    "appType": appType,
    "companyID": companyId,
    "applyTo": applyTo,
    "reason": reason,
    "emgContructNo": emgContructNo,
    "emgAddress": emgAddress,
    "userName": userName,
    "authorityEmpcode": authorityEmpcode,
  };
}
