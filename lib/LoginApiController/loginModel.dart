import 'package:tiger_erp_hrm/LoginApiController/loginController.dart';

class LoginModel {
  String? token;
  int? loginID;
  String? userName;
  String? loginPassword;
  String? empCode;
  String? isActive;
  int? companyID;
  String? companyName;

  LoginModel({
    this.token,
    this.loginID,
    this.userName,
    this.loginPassword,
    this.empCode,
    this.isActive,
    this.companyID,
    this.companyName,
    required LoginController loginController,
  });

  LoginModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    loginID = json['loginID'];
    userName = json['userName'];
    loginPassword = json['loginPassword'];
    empCode = json['empCode'];
    isActive = json['isActive'];
    companyID = json['companyID'];
    companyName = json['companyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['token'] = this.token;
    data['loginID'] = this.loginID;
    data['userName'] = this.userName;
    data['loginPassword'] = this.loginPassword;
    data['empCode'] = this.empCode;
    data['isActive'] = this.isActive;
    data['companyID'] = this.companyID;
    data['companyName'] = this.companyName;
    return data;
  }
}

