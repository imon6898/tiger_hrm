class LeaveDataForHR {
  final String empCode;
  final String empName;
  final String applyDate;
  final String startDate;
  final String endDate;
  final String days;
  final String payType;
  final int id;
  final String reason;
  final String emgContructNo;
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

  LeaveDataForHR({
    required this.empCode,
    required this.empName,
    required this.applyDate,
    required this.startDate,
    required this.endDate,
    required this.days,
    required this.payType,
    required this.id,
    required this.reason,
    required this.emgContructNo,
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
  });
  @override
  String toString() {
    return 'LeaveData{id: $id, empCode: $empCode, empName: $empName, applyDate: $applyDate, startDate: $startDate, endDate: $endDate, days: $days, payType: $payType, reason: $reason, emgContructNo: $emgContructNo, leaveTypedID: $leaveTypedID, unAccepteDuration: $unAccepteDuration, referanceEmpcode: $referanceEmpcode, grandtype: $grandtype, appType: $appType, companyID: $companyID, applyTo: $applyTo, emgAddress: $emgAddress, userName: $userName, authorityEmpcode: $authorityEmpcode}';
  }

}
