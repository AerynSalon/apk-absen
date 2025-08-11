import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import '../services/db_service.dart';
import '../models/attendance.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});

  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  bool _busy = false;

  @override
  void reassemble() {
    super.reassemble();
    controller?.pauseCamera();
    controller?.resumeCamera();
  }

  void _onQR(QRViewController c) {
    controller = c;
    c.scannedDataStream.listen((scanData) async {
      if (_busy) return;
      _busy = true;
      final code = scanData.code;
      if (code == null) { _busy = false; return; }
      await _handleScan(code);
      _busy = false;
    });
  }

  Future<void> _handleScan(String code) async {
    // Alternate IN/OUT based on last record
    final list = await DBService().getAttendanceByEmployee(code);
    final nextType = list.isNotEmpty && list.first.type == 'IN' ? 'OUT' : 'IN';
    await DBService().addAttendance(Attendance(employeeCode: code, checkTime: DateTime.now(), type: nextType));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tercatat: $nextType ($code)')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR')),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQR,
            ),
          ),
          const Expanded(
            child: Center(child: Text('Arahkan kamera ke QR karyawan')),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}
