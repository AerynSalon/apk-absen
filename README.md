# AERYN SALON - Flutter Attendance App

A minimal, production-ready starter for a salon employee attendance system (absensi) built with Flutter.

## Fitur Utama
- Scan QR untuk **Check-in / Check-out**
- Generate QR untuk setiap karyawan
- Riwayat absensi per karyawan dan per hari
- Export CSV (lokal) dan share
- Database lokal **SQLite (sqflite)** — siap disambungkan ke backend (REST/Firebase/Supabase)
- Mode offline (sinkronisasi bisa ditambahkan nanti)

## Struktur
```
lib/
  main.dart
  models/{
    employee.dart,
    attendance.dart
  }
  services/{
    db_service.dart,
    export_service.dart
  }
  pages/{
    home_page.dart,
    employees_page.dart,
    qr_scan_page.dart,
    qr_generate_page.dart,
    attendance_page.dart,
    settings_page.dart
  }
  widgets/{attendance_tile.dart, employee_tile.dart}
assets/logo.png
```

## Persiapan Cepat
1. Buat proyek Flutter kosong:
   ```bash
   flutter create aeryn_salon_absen
   ```
2. Hapus folder `lib` dan `assets` di proyek baru, lalu **salin** folder `lib`, `assets`, dan `pubspec.yaml` dari paket ini.
3. Jalankan:
   ```bash
   flutter pub get
   flutter run
   ```

### Izin Android (wajib utk kamera)
Tambahkan pada `android/app/src/main/AndroidManifest.xml` di dalam `<manifest>`:
```xml
<uses-permission android:name="android.permission.CAMERA" />
```

### Min SDK (untuk sqflite)
Di `android/app/build.gradle` set `minSdkVersion 21` atau lebih.

## Kustomisasi
- Tambah lokasi/geo-fence: tambahkan kolom lat/long & radius lalu validasi pada scan.
- Sinkronisasi cloud: buat service baru (`cloud_service.dart`) dan panggil saat insert/updates.
- Role admin vs staf: tambah auth sederhana berbasis PIN.
