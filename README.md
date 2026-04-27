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

## 🎯 Pemenuhan Kriteria Tugas
Aplikasi ini telah mengimplementasikan seluruh kriteria penilaian dengan rincian teknis sebagai berikut:

| Kriteria | Bobot | Implementasi Teknis | Status |
| :--- | :---: | :--- | :---: |
| **Relational Database (CRUD)** | 10% | Local persistence menggunakan **SQLite (sqflite)** dengan operasi Create, Read, Update, dan Delete yang lengkap. | ✅ |
| **Firebase Authentication** | 5% | Sistem Login dan Register menggunakan **Firebase Auth** (Email & Password). | ✅ |
| **Firebase Storing** | 5% | Sinkronisasi metadata ke **Cloud Firestore** dan penyimpanan foto struk ke **Firebase Storage**. | ✅ |
| **Notifications** | 5% | Pengingat otomatis masa garansi (H-30) menggunakan **flutter_local_notifications**. | ✅ |
| **Smartphone Resource** | 5% | Integrasi **Camera & Gallery** menggunakan paket `image_picker`. | ✅ |
| **Demo & GitHub** | 10% | Repositori terstruktur rapi, kode bersih, dan video demo tersedia. | ✅ |

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
