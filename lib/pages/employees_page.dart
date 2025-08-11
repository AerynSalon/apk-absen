import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/employee.dart';
import '../services/db_service.dart';
import '../widgets/employee_tile.dart';
import 'qr_generate_page.dart';

class EmployeesPage extends StatefulWidget {
  const EmployeesPage({super.key});

  @override
  State<EmployeesPage> createState() => _EmployeesPageState();
}

class _EmployeesPageState extends State<EmployeesPage> {
  List<Employee> employees = [];
  final nameC = TextEditingController();
  final roleC = TextEditingController();

  Future<void> _load() async {
    employees = await DBService().getEmployees();
    setState((){});
  }

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data Karyawan')),
      body: RefreshIndicator(
        onRefresh: _load,
        child: ListView(
          children: [
            for (final e in employees)
              EmployeeTile(
                e: e,
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(
                    builder: (_) => QRGeneratePage(employee: e),
                  ));
                },
                onDelete: () async {
                  await DBService().deleteEmployee(e.id!);
                  _load();
                },
              ),
            const SizedBox(height: 80),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _showAddDialog(context),
        label: const Text('Tambah'),
        icon: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      showDragHandle: true,
      isScrollControlled: true,
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 16, right: 16,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 16, top: 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Tambah Karyawan', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            TextField(controller: nameC, decoration: const InputDecoration(labelText: 'Nama')), 
            const SizedBox(height: 8),
            TextField(controller: roleC, decoration: const InputDecoration(labelText: 'Jabatan / Role')),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: OutlinedButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Batal'),
                )),
                const SizedBox(width: 12),
                Expanded(child: FilledButton(
                  onPressed: () async {
                    final code = DateTime.now().millisecondsSinceEpoch.toString();
                    await DBService().addEmployee(Employee(code: code, name: nameC.text.trim(), role: roleC.text.trim().isEmpty ? 'Staff' : roleC.text.trim()));
                    nameC.clear(); roleC.clear();
                    if (mounted) Navigator.pop(ctx);
                    _load();
                  },
                  child: const Text('Simpan'),
                )),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
