class LeaveDataforSup{
  final String empCode;
  final String empName;
  final String empEmail;
  final String designation;
  final String department;
  final String typeName;
  final String laDate;
  final String lsDate;
  final String leDate;
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

  LeaveDataforSup({
    required this.empCode,
    required this.empName,
    required this.empEmail,
    required this.designation,
    required this.department,
    required this.typeName,
    required this.laDate,
    required this.lsDate,
    required this.leDate,
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

  factory LeaveDataforSup.fromJson(Map<String, dynamic> json) {
    return LeaveDataforSup(
      empCode: json['empCode'] ?? '',
      empName: json['empName'] ?? '',
      empEmail: json['empEmail'] ?? '',
      designation: json['designation'] ?? '',
      department: json['department'] ?? '',
      typeName: json['typeName'] ?? '',
      laDate: json['laDate'] ?? '',
      lsDate: json['lsDate'] ?? '',
      leDate: json['leDate'] ?? '',
      days: json['accepteDuration'].toString(),
      payType: json['withpay'] ?? '',
      id: json['id'] ?? 0,
      reason: json['reason'] ?? '',
      emgContructNo: json['emgContructNo'] ?? '',
      leaveTypedID: json['leaveTypedID'] ?? 0,
      unAccepteDuration: json['unAccepteDuration'] ?? '',
      referanceEmpcode: json['referanceEmpcode'] ?? '',
      grandtype: json['grandtype'] ?? 0,
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
        'empEmail: $empEmail, '
        'designation: $designation, '
        'department: $department, '
        'typeName: $typeName, '
        'laDate: $laDate, '
        'lsDate: $lsDate, '
        'leDate: $leDate, '
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
        'yyyymmdd: $yyyymmdd}'
        'recommandToEmail: $recommandToEmail, '
        'recommandedName: $recommandedName, '
        'reportToEmail: $reportToEmail, '
        'reportToEmpName: $reportToEmpName, ';
  }
}
