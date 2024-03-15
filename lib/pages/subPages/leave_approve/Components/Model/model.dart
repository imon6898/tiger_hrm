class LeaveDatafor{
  final String empCode;
  final String empName;
  final String empEmail;
  final String designation;
  final String department;
  final String typeName;
  final String applyDate;
  final String startDate;
  final String endDate;
  final String days;
  final String payType;
  final int id;
  final String reason;
  final String emgContructNo;
  final int leaveTypedID; // Corrected naming here
  final String unAccepteDuration;
  final String referanceEmpcode;
  final int grandtype;
  final String appType;
  final int companyID;
  final String applyTo;
  final String emgAddress;
  final String userName;
  final String authorityEmpcode;
  final String yyyymmdd;
  final String recommandToEmail;
  final String recommandedName;
  final String reportToEmail;
  final String reportToEmpName;

  LeaveDatafor({
    required this.empCode,
    required this.empName,
    required this.empEmail,
    required this.designation,
    required this.department,
    required this.typeName,
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
    required this.yyyymmdd,
    required this.recommandToEmail,
    required this.recommandedName,
    required this.reportToEmail,
    required this.reportToEmpName,
  });

  factory LeaveDatafor.fromJson(Map<String, dynamic> json) {
    return LeaveDatafor(
      empCode: json['empCode'] ?? '',
      empName: json['empName'] ?? '',
      empEmail: json['empEmail'] ?? '',
      designation: json['designation'] ?? '',
      department: json['department'] ?? '',
      typeName: json['typeName'] ?? '',
      applyDate: json['applicationDate'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      days: json['accepteDuration'].toString(),
      payType: json['withpay'] ?? '',
      id: json['id'] ?? 0,
      reason: json['reason'] ?? '',
      emgContructNo: json['emgContructNo'] ?? '',
      leaveTypedID: json['leaveTypedID'] ?? 0,
      unAccepteDuration: json['unAccepteDuration'] ?? '',
      referanceEmpcode: json['referanceEmpcode'] ?? '',
      grandtype: json['grandtype'] ?? '',
      appType: json['appType'] ?? '',
      companyID: json['companyID'] ?? 0,
      applyTo: json['applyTo'] ?? '',
      emgAddress: json['emgAddress'] ?? '',
      userName: json['userName'] ?? '',
      authorityEmpcode: json['authorityEmpcode'] ?? '',
      yyyymmdd: json['yyyymmdd'] ?? '',
      recommandToEmail: json['recommandToEmail'] ?? '',
      recommandedName: json['recommandedName'] ?? '',
      reportToEmail: json['reportToEmail'] ?? '',
      reportToEmpName: json['reportToEmpName'] ?? '',
    );
  }

  @override
  String toString() {
    return 'LeaveDatafor{'
        'id: $id, '
        'empCode: $empCode, '
        'empName: $empName, '
        'designation: $designation, '
        'department: $department, '
        'typeName: $typeName, '
        'applyDate: $applyDate, '
        'startDate: $startDate, '
        'endDate: $endDate, '
        'days: $days, '
        'payType: $payType, '
        'reason: $reason, '
        'emgContructNo: $emgContructNo, '
        'leaveTypedID: $leaveTypedID, '
        'unAccepteDuration: $unAccepteDuration, '
        'referanceEmpcode: $referanceEmpcode, '
        'grandtype: $grandtype, '
        'appType: $appType, '
        'companyID: $companyID, '
        'applyTo: $applyTo, '
        'emgAddress: $emgAddress, '
        'userName: $userName, '
        'authorityEmpcode: $authorityEmpcode, '
        'yyyymmdd: $yyyymmdd, '
        'recommandToEmail: $recommandToEmail, '
        'recommandedName: $recommandedName, '
        'reportToEmail: $reportToEmail, '
        'reportToEmpName: $reportToEmpName, ';
  }
}
