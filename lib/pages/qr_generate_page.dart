import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../models/employee.dart';

class QRGeneratePage extends StatelessWidget {
  final Employee employee;
  const QRGeneratePage({super.key, required this.employee});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('QR: ${employee.name}')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            QrImageView(
              data: employee.code,
              version: QrVersions.auto,
              size: 240,
            ),
            const SizedBox(height: 16),
            Text(employee.code, style: const TextStyle(color: Colors.grey)),
            const SizedBox(height: 16),
            Text(employee.name, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}
