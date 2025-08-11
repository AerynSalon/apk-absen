import 'package:flutter/material.dart';
import 'pages/home_page.dart';

void main() {
  runApp(const AerynSalonApp());
}

class AerynSalonApp extends StatelessWidget {
  const AerynSalonApp({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF6750A4)),
      useMaterial3: true,
    );
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AERYN SALON - Absensi',
      theme: theme,
      home: const HomePage(),
    );
  }
}
