import 'package:flutter/material.dart';
import '../models/attendance.dart';
import 'package:intl/intl.dart';

class AttendanceTile extends StatelessWidget {
  final Attendance item;
  const AttendanceTile({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('dd MMM yyyy, HH:mm');
    return ListTile(
      leading: Icon(item.type == 'IN' ? Icons.login : Icons.logout),
      title: Text('${item.type} • ${item.employeeCode}'),
      subtitle: Text(fmt.format(item.checkTime)),
    );
  }
}
