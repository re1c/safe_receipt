# SafeReceipt
### *Digital E-Warranty Vault & Receipt Manager*

SafeReceipt is a mobile utility designed to bridge the gap between physical receipts and digital asset management. Built for the **Mobile Programming Mini Project**, this application serves as a secure vault for digitizing thermal receipts and tracking warranty periods to prevent loss of claims due to faded or lost physical documents.

---

## 📋 Project Requirements Fulfillment

This project is built to strictly adhere to the academic requirements while maintaining industry-standard practices:

*   **Relational Database (CRUD)**: Utilizes **SQLite** (`sqflite`) for robust local persistence, handling the complete lifecycle of receipt data including complex date relations for warranty tracking.
*   **Firebase Authentication**: Implements a secure user gateway with email/password authentication, ensuring that each user's vault is private and protected.
*   **Firebase Cloud Integration**: 
    *   **Cloud Firestore**: Real-time synchronization of receipt metadata across devices.
    *   **Firebase Storage**: Secure cloud backup for high-resolution receipt images.
*   **Local Notifications**: Implements an automated reminder system using `flutter_local_notifications` to alert users 30 days before a warranty expires.
*   **Hardware Resource (Camera)**: Direct integration with the device camera to capture and digitize physical receipts on the spot.
*   **Security & Best Practices**:
    *   **Firebase Security Rules**: Implements strict data isolation to ensure users can only access their own files.
    *   **Automated Testing**: Includes unit tests for core data models to ensure data integrity and stability.


---

## ✨ Features & User Experience

*   **Smart Dashboard**: A clean overview of all stored assets with visual indicators for items nearing warranty expiration.
*   **Digitization Engine**: Capture receipts instantly. The app handles local storage first to ensure functionality in low-signal areas, with background cloud sync.
*   **Categorization**: Organize assets by category (Electronics, Appliances, Fashion, etc.) for easier management.
*   **Automated Reminders**: Never miss a warranty claim. The app proactively calculates and schedules reminders based on your purchase and expiry dates.
*   **Premium Dark Mode**: Full support for system-wide themes with a modern Material 3 aesthetic.

---

## 🛠️ Technical Implementation

The application architecture is designed for scalability and maintainability:

*   **State Management**: Powered by **Provider**, ensuring a reactive UI and clean separation between business logic and the view layer.
*   **Service Pattern**: Dedicated services for Database, Firebase, and Notifications to follow the Single Responsibility Principle.
*   **Data Consistency**: Implements a "Local-First" strategy where data is committed to the SQLite database before attempting cloud synchronization, ensuring no data loss.

---

## ⚙️ Quick Setup

To run this project locally, ensure you have the Flutter SDK installed and follow these steps:

1.  **Clone & Install**:
    ```bash
    git clone https://github.com/re1c/safe_receipt.git
    cd safe_receipt
    flutter pub get
    ```

2.  **Firebase Configuration**:
    Since Firebase configuration is environment-specific, you will need to link your own Firebase project:
    ```bash
    flutterfire configure
    ```
    *Note: Ensure Authentication (Email), Firestore, and Storage are enabled in your Firebase console.*

3.  **Run**:
    ```bash
    flutter run
    ```

---

**Developed by:**  
**Naswan Nashir Ramadhan**  
NRP: 5025231246  
*Department of Informatics, Institut Teknologi Sepuluh Nopember*
