import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import '../models/receipt_model.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  // Auth Methods
  Stream<User?> get user => _auth.authStateChanges();

  Future<UserCredential?> signUp(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("SignUp Error: $e");
      rethrow;
    }
  }

  Future<UserCredential?> signIn(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print("SignIn Error: $e");
      rethrow;
    }
  }

  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Firestore & Storage Sync
  Future<void> syncReceiptToCloud(ReceiptModel receipt) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      // 1. Upload Image to Firebase Storage
      String cloudImageUrl = receipt.imagePath;
      if (File(receipt.imagePath).existsSync()) {
        final storageRef = _storage.ref().child('receipts/${user.uid}/${receipt.id}.jpg');
        await storageRef.putFile(File(receipt.imagePath));
        cloudImageUrl = await storageRef.getDownloadURL();
      }

      // 2. Save Metadata to Firestore
      final receiptData = receipt.copyWith(userId: user.uid, imagePath: cloudImageUrl).toFirestore();
      await _firestore.collection('receipts').doc(receipt.id).set(receiptData);
    } catch (e) {
      print("Sync Error: $e");
      rethrow;
    }
  }

  Future<void> deleteReceiptFromCloud(String receiptId) async {
    try {
      final user = _auth.currentUser;
      if (user == null) return;

      await _firestore.collection('receipts').doc(receiptId).delete();
      await _storage.ref().child('receipts/${user.uid}/$receiptId.jpg').delete();
    } catch (e) {
      print("Delete Cloud Error: $e");
    }
  }
}
