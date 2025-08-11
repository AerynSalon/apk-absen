import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/db_service.dart';
import '../widgets/attendance_tile.dart';
import '../services/export_service.dart';

class AttendancePage extends StatefulWidget {
  const AttendancePage({super.key});

  @override
  State<AttendancePage> createState() => _AttendancePageState();
}

class _AttendancePageState extends State<AttendancePage> {
  DateTime _selected = DateTime.now();
  var _items = <dynamic>[];

  Future<void> _load() async {
    final list = await DBService().getAttendanceByDate(_selected);
    setState(() => _items = list);
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    final fmt = DateFormat('EEEE, dd MMM yyyy', 'id_ID');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Riwayat Absensi'),
        actions: [
          IconButton(
            onPressed: () async {
              final f = await ExportService.exportAttendanceCsv(List.from(_items));
              if (!mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('CSV tersimpan: ${f.path}')));
            },
            icon: const Icon(Icons.upload_file),
            tooltip: 'Export CSV',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          children: [
            ListTile(
              leading: const Icon(Icons.today),
              title: Text(fmt.format(_selected)),
              trailing: IconButton(
                icon: const Icon(Icons.date_range),
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2100),
                    initialDate: _selected,
                  );
                  if (picked != null) {
                    setState(() => _selected = picked);
                    _load();
                  }
                },
              ),
            ),
            const Divider(height: 0),
            for (final a in _items) AttendanceTile(item: a),
            const SizedBox(height: 80),
          ],
        ),
      ),
    );
  }
}
