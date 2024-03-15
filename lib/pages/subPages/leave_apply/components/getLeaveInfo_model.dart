class GetLeaveInfoModel {
  final int id;
  final String applyDate;
  final String startDate;
  final String endDate;
  final String days;

  GetLeaveInfoModel({
    required this.id,
    required this.applyDate,
    required this.startDate,
    required this.endDate,
    required this.days,
  });

  factory GetLeaveInfoModel.fromJson(Map<String, dynamic> json) {
    return GetLeaveInfoModel(
      id: json['id'] ?? 0,
      applyDate: json['applicationDate'] ?? '',
      startDate: json['startDate'] ?? '',
      endDate: json['endDate'] ?? '',
      days: json['accepteDuration'].toString(),
    );
  }

  @override
  String toString() {
    return 'LeaveDatafor{'
        'id: $id, '
        'applyDate: $applyDate, '
        'startDate: $startDate, '
        'endDate: $endDate, '
        'days: $days, ';
  }
}


class GetLeaveInfoStatusModels3 {
  final String typeName;
  final String applicationDate;
  final String accepteDuration;
  final String remarks;
  final String empName;
  final String status;

  GetLeaveInfoStatusModels3({
    required this.typeName,
    required this.applicationDate,
    required this.accepteDuration,
    required this.remarks,
    required this.empName,
    required this.status,
  });

  factory GetLeaveInfoStatusModels3.fromJson(Map<String, dynamic> json) {
    return GetLeaveInfoStatusModels3(
      typeName: json['typeName'] ?? '',
      applicationDate: json['applicationDate'] ?? '',
      accepteDuration: json['accepteDuration'] ?? '',
      remarks: json['remarks'] ?? '',
      empName: json['empName'] ?? '',
      status: json['status'].toString(),
    );
  }

  @override
  String toString() {
    return 'LeaveDatafor{'
        'typeName: $typeName, '
        'applicationDate: $applicationDate, '
        'accepteDuration: $accepteDuration, '
        'remarks: $remarks, '
        'empName: $empName, '
        'status: $status, ';
  }
}