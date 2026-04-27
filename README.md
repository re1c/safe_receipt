# SafeReceipt: Digital E-Warranty Vault 🛡️

[![Project Demo](https://img.shields.io/badge/Demo-Video-blueviolet?style=for-the-badge&logo=youtube)](demo_video_246.mp4)
[![Flutter](https://img.shields.io/badge/Flutter-3.41.6-blue?logo=flutter)](https://flutter.dev)
[![Firebase](https://img.shields.io/badge/Firebase-Integrated-orange?logo=firebase)](https://firebase.google.com)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

**SafeReceipt** adalah aplikasi manajemen aset digital yang dirancang untuk mendigitalisasi struk fisik dan mengelola masa garansi secara cerdas. Proyek ini dikembangkan guna memenuhi persyaratan **Mini Project mata kuliah Pemrograman Perangkat Bergerak**.

---

## 📺 Project Demo
Demo lengkap fitur aplikasi dapat dilihat pada file berikut:
👉 **[Tonton Video Demo (demo_video_246.mp4)](demo_video_246.mp4)**

---

## Ringkasan Implementasi Teknis
Aplikasi ini dikembangkan dengan mengintegrasikan beberapa komponen utama sesuai dengan kebutuhan fungsional sistem:

- **Persistensi Data Lokal (Relational)**: Menggunakan **SQLite** (`sqflite`) untuk menyimpan riwayat aset secara permanen di perangkat, mencakup operasi pembuatan, pembacaan, pembaruan, hingga penghapusan data (CRUD).
- **Sistem Autentikasi**: Mengintegrasikan **Firebase Authentication** untuk mengelola akses pengguna secara aman melalui metode Email dan Password.
- **Penyimpanan Cloud**: Memanfaatkan **Cloud Firestore** untuk sinkronisasi metadata aset dan **Firebase Storage** untuk pencadangan foto struk secara daring.
- **Layanan Pengingat**: Menggunakan **Local Notifications** untuk memberikan peringatan kepada pengguna sebelum masa garansi aset berakhir (penjadwalan otomatis).
- **Integrasi Hardware**: Memanfaatkan **Resource Kamera** melalui paket `image_picker` untuk proses digitalisasi dokumen fisik secara langsung.
- **Dokumentasi Proyek**: Seluruh kode sumber dikelola secara terstruktur di GitHub dan dilengkapi dengan video demonstrasi untuk menunjukkan alur kerja aplikasi secara menyeluruh.

---

## ✨ Fitur Unggulan
Selain kriteria dasar, aplikasi ini dilengkapi dengan fitur tambahan untuk meningkatkan UX:
- **Local-First with Auto-Sync**: Data tetap dapat diakses secara offline dan otomatis tersinkronisasi ke cloud saat koneksi internet kembali tersedia.
- **Bulk Deletion**: Memungkinkan pengguna untuk menghapus banyak struk sekaligus dengan mode seleksi.
- **Smart Search**: Pencarian cepat berdasarkan nama barang atau nama toko.
- **Premium UI/UX**: Desain modern menggunakan Material 3 dengan animasi transisi *Hero* dan skema warna gelap yang elegan.

---

## 🛠️ Tech Stack
- **Framework**: Flutter (Stable Channel)
- **State Management**: Provider (Clean Architecture)
- **Local DB**: SQLite
- **Cloud Backend**: Firebase (Auth, Firestore, Storage)
- **Local Service**: Local Notifications, Camera, Connectivity Plus

---

## 🚀 Cara Menjalankan Proyek
1. **Clone repositori**:
   ```bash
   git clone git@github.com:re1c/safe_receipt.git
   ```
2. **Setup FVM** (jika menggunakan):
   ```bash
   fvm install && fvm use stable
   ```
3. **Install Dependencies**:
   ```bash
   flutter pub get
   ```
4. **Jalankan Aplikasi**:
   ```bash
   flutter run
   ```

---

## 🛡️ Keamanan & Privasi
Proyek ini mengimplementasikan **Firebase Security Rules** untuk memastikan setiap pengguna hanya dapat mengakses, mengubah, atau menghapus data milik mereka sendiri.

---

**Naswan Nashir Ramadhan**  
NRP: 5025231246  
*Departemen Teknik Informatika, Institut Teknologi Sepuluh Nopember*
