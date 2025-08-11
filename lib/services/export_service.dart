import 'dart:io';
import 'package:csv/csv.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';
import '../models/attendance.dart';

class ExportService {
  static Future<File> exportAttendanceCsv(List<Attendance> data, {String filenamePrefix = 'attendance'}) async {
    final rows = <List<dynamic>>[
      ['employee_code', 'check_time', 'type']
    ];
    final fmt = DateFormat('yyyy-MM-dd HH:mm:ss');
    for (final a in data) {
      rows.add([a.employeeCode, fmt.format(a.checkTime), a.type]);
    }
    final csv = const ListToCsvConverter().convert(rows);
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/$filenamePrefix-${DateTime.now().millisecondsSinceEpoch}.csv');
    return file.writeAsString(csv);
  }
}
