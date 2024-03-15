class LeaveDataForHR {
  final String empCode;
  final String empName;
  final String empEmail;
  final String applyDate;
  final String startDate;
  final String endDate;
  final String days;
  final String payType;
  final int id;
  final String reason;
  final String emgContructNo;
  final String typeName;
  final int leaveTypedID;
  final String unAccepteDuration;
  final String referanceEmpcode;
  final String grandtype;
  final String appType;
  final int companyID;
  final String applyTo;
  final String emgAddress;
  final String userName;
  final String authorityEmpcode;
  final String recommandToEmail;
  final String recommandedName;
  final String reportToEmail;
  final String reportToEmpName;

  LeaveDataForHR({
    required this.empCode,
    required this.empName,
    required this.empEmail,
    required this.applyDate,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.payType,
    required this.id,
    required this.reason,
    required this.emgContructNo,
    required this.typeName,
    required this.leaveTypedID,
    required this.unAccepteDuration,
    required this.referanceEmpcode,
    required this.grandtype,
    required this.appType,
    required this.companyID,
    required this.applyTo,
    required this.emgAddress,
    required this.userName,
    required this.authorityEmpcode,
    required this.recommandToEmail,
    required this.recommandedName,
    required this.reportToEmail,
    required this.reportToEmpName,
  });
  @override
  String toString() {
    return 'LeaveData{id: $id, empCode: $empCode, empName: $empName, empEmail: $empEmail, applyDate: $applyDate, startDate: $startDate, endDate: $endDate, days: $days, payType: $payType, reason: $reason, emgContructNo: $emgContructNo, typeName: $typeName, leaveTypedID: $leaveTypedID, unAccepteDuration: $unAccepteDuration, referanceEmpcode: $referanceEmpcode, grandtype: $grandtype, appType: $appType, companyID: $companyID, applyTo: $applyTo, emgAddress: $emgAddress, userName: $userName, authorityEmpcode: $authorityEmpcode, recommandToEmail: $recommandToEmail, recommandedName: $recommandedName, reportToEmail: $reportToEmail, reportToEmpName: $reportToEmpName,}';
  }

}
