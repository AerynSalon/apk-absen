class Attendance {
  final int? id;
  final String employeeCode;
  final DateTime checkTime;
  final String type; // 'IN' or 'OUT'

  Attendance({this.id, required this.employeeCode, required this.checkTime, required this.type});

  Map<String, dynamic> toMap() => {
    'id': id,
    'employeeCode': employeeCode,
    'checkTime': checkTime.toIso8601String(),
    'type': type,
  };

  factory Attendance.fromMap(Map<String, dynamic> m) => Attendance(
    id: m['id'] as int?,
    employeeCode: m['employeeCode'] as String,
    checkTime: DateTime.parse(m['checkTime'] as String),
    type: m['type'] as String,
  );
}
