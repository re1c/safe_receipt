# SafeReceipt - Digital E-Warranty Vault

SafeReceipt is a professional Flutter application designed for managing digital receipts and warranty information. This project was developed as a Mini Project for the Mobile Programming course.

## 🚀 Features & Requirements

- **CRUD with Relational Database (10%)**: Implemented using **SQLite** (`sqflite`) for high-performance local storage of receipt data.
- **Firebase Authentication (5%)**: Secure login and registration system using **Firebase Auth**.
- **Storing Data in Firebase (5%)**: 
  - **Firestore**: Syncs receipt metadata (title, price, dates) to the cloud.
  - **Firebase Storage**: Automatically backs up receipt photos to secure cloud storage.
- **Notifications (5%)**: Integrated **Local Notifications** to remind users 30 days before a warranty expires.
- **Smartphone Resource (5%)**: Leverages the **Camera** to digitize physical thermal receipts.
- **Premium UI**: Modern Material 3 design with Dark Mode support and smooth transitions.

## 🛠️ Tech Stack

- **Framework**: Flutter
- **State Management**: Provider
- **Local DB**: SQLite (sqflite)
- **Backend**: Firebase (Auth, Firestore, Storage)
- **Utilities**: camera, image_picker, flutter_local_notifications, intl, uuid

## ⚙️ Configuration Instructions (MANDATORY)

To make the app 100% functional, please follow these steps:

1.  **Initialize Firebase**:
    -   Go to [Firebase Console](https://console.firebase.google.com/).
    -   Create a new project named `SafeReceipt`.
    -   In your terminal, inside the `safe_receipt` directory, run:
        ```bash
        flutterfire configure
        ```
    -   Follow the prompts to link the app.

2.  **Enable Services in Firebase Console**:
    -   **Authentication**: Enable Email/Password provider.
    -   **Firestore Database**: Create a database in Test Mode or production.
    -   **Storage**: Enable Firebase Storage.

3.  **Run the App**:
    ```bash
    flutter run
    ```

## 📂 Project Structure

- `lib/data/models`: Data structures.
- `lib/data/services`: Database, Firebase, and Notification logic.
- `lib/providers`: State management using Provider pattern.
- `lib/ui`: All screens (Auth, Home, Receipt Form).

---
Developed with ❤️ by Naswan Nashir Ramadhan (5025231246)
