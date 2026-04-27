import 'package:flutter/material.dart';
import '../data/models/receipt_model.dart';
import '../data/services/database_helper.dart';
import '../data/services/firebase_service.dart';
import '../data/services/notification_service.dart';

class ReceiptProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  final FirebaseService _firebaseService = FirebaseService();
  final NotificationService _notificationService = NotificationService();

  List<ReceiptModel> _receipts = [];
  bool _isLoading = false;

  List<ReceiptModel> get receipts => _receipts;
  bool get isLoading => _isLoading;

  Future<void> loadReceipts() async {
    _isLoading = true;
    notifyListeners();
    _receipts = await _dbHelper.getAllReceipts();
    _isLoading = false;
    notifyListeners();
  }

  Future<void> addReceipt(ReceiptModel receipt) async {
    await _dbHelper.insertReceipt(receipt);
    await loadReceipts();
    
    // Schedule Notification
    await _notificationService.scheduleWarrantyReminder(
      receipt.id.hashCode,
      receipt.title,
      receipt.expiryDate,
    );

    // Sync to Cloud (Background)
    try {
      await _firebaseService.syncReceiptToCloud(receipt);
      await _dbHelper.markAsSynced(receipt.id);
      await loadReceipts();
    } catch (e) {
      print("Background Sync Failed: $e");
    }
  }

  Future<void> updateReceipt(ReceiptModel receipt) async {
    await _dbHelper.updateReceipt(receipt);
    await loadReceipts();
    
    // Update Notification
    await _notificationService.cancelNotification(receipt.id.hashCode);
    await _notificationService.scheduleWarrantyReminder(
      receipt.id.hashCode,
      receipt.title,
      receipt.expiryDate,
    );

    // Sync to Cloud
    try {
      await _firebaseService.syncReceiptToCloud(receipt);
      await _dbHelper.markAsSynced(receipt.id);
      await loadReceipts();
    } catch (e) {
      print("Sync Update Failed: $e");
    }
  }

  Future<void> deleteReceipt(String id) async {
    await _dbHelper.deleteReceipt(id);
    await loadReceipts();
    
    // Cancel Notification
    await _notificationService.cancelNotification(id.hashCode);

    // Delete from Cloud
    try {
      await _firebaseService.deleteReceiptFromCloud(id);
    } catch (e) {
      print("Delete Cloud Failed: $e");
    }
  }
}
