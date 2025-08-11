import 'package:flutter/material.dart';
import '../models/employee.dart';

class EmployeeTile extends StatelessWidget {
  final Employee e;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  const EmployeeTile({super.key, required this.e, this.onTap, this.onDelete});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: const CircleAvatar(child: Icon(Icons.person)),
      title: Text(e.name),
      subtitle: Text(e.role),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(icon: const Icon(Icons.qr_code), onPressed: onTap),
          IconButton(icon: const Icon(Icons.delete_outline), onPressed: onDelete),
        ],
      ),
    );
  }
}
