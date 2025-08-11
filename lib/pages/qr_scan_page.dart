import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../services/db_service.dart';
import '../models/attendance.dart';

class QRScanPage extends StatefulWidget {
  const QRScanPage({super.key});
  @override
  State<QRScanPage> createState() => _QRScanPageState();
}

class _QRScanPageState extends State<QRScanPage> {
  final MobileScannerController controller = MobileScannerController(
    formats: [BarcodeFormat.qrCode],
    detectionSpeed: DetectionSpeed.normal,
    facing: CameraFacing.back,
  );
  bool _busy = false;

  Future<void> _handleScan(String code) async {
    final list = await DBService().getAttendanceByEmployee(code);
    final nextType = list.isNotEmpty && list.first.type == 'IN' ? 'OUT' : 'IN';
    await DBService().addAttendance(Attendance(employeeCode: code, checkTime: DateTime.now(), type: nextType));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Tercatat: $nextType ($code)')));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR'),
        actions: [
          IconButton(onPressed: () => controller.toggleTorch(), icon: const Icon(Icons.flash_on)),
          IconButton(onPressed: () => controller.switchCamera(), icon: const Icon(Icons.cameraswitch)),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            flex: 4,
            child: MobileScanner(
              controller: controller,
              onDetect: (capture) async {
                if (_busy) return;
                final barcodes = capture.barcodes;
                if (barcodes.isEmpty) return;
                final value = barcodes.first.rawValue;
                if (value == null || value.isEmpty) return;
                _busy = true;
                try { await _handleScan(value); } finally { _busy = false; }
              },
            ),
          ),
          const Expanded(child: Center(child: Text('Arahkan kamera ke QR karyawan'))),
        ],
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
