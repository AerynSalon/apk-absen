# Cara Dapat APK Otomatis via GitHub Actions

Kalau kamu mau file `.apk` **tanpa build manual**, ikuti langkah berikut:

## Opsi cepat (Debug APK — langsung bisa diinstall)
1. Buat repo GitHub baru (public/private).
2. Upload isi proyek ini (folder `lib`, `assets`, `pubspec.yaml`, dan `.github/workflows/flutter-android-apk.yml`).
3. Buka tab **Actions** di repo → pilih workflow **Build Android APK (Debug)** → klik **Run workflow**.
4. Tunggu proses selesai (±5–10 menit pertama kali).  
5. Masuk ke **Actions** → buka run terakhir → bagian **Artifacts** → download **AERYN-SALON-debug-apk**.  
   Di dalamnya ada `app-debug.apk` yang **sudah ditandatangani (debug keystore)** dan **bisa langsung diinstall** di HP Android.

> Workflow otomatis menjalankan `flutter create . --platforms=android` bila folder `android/` belum ada.

## Opsi lanjutan (Release APK — butuh keystore sendiri)
1. Buat keystore:
   ```bash
   keytool -genkey -v -keystore aerynsalon.jks -keyalg RSA -keysize 2048 -validity 10000 -alias aeryn
   ```
2. Encode base64:
   ```bash
   base64 aerynsalon.jks > keystore.b64
   ```
3. Tambah **Repository Secrets**:
   - `KEYSTORE_BASE64` → isi dari `keystore.b64`
   - `KEYSTORE_PASSWORD`
   - `KEY_ALIAS` (misal: `aeryn`)
   - `KEY_PASSWORD`
4. **Uncomment** job `build-android-release` di file workflow.
5. Run workflow, download artifact **AERYN-SALON-release-apk**.

### Tips install di HP
- Aktifkan **Install unknown apps** (Sumber tidak dikenal).
- Transfer APK via kabel/Drive/WA lalu install.

Semoga membantu! — AERYN SALON Absensi
