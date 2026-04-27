import 'package:flutter_test/flutter_test.dart';
import 'package:safe_receipt/data/models/receipt_model.dart';

void main() {
  group('ReceiptModel Tests', () {
    test('Should correctly convert from and to Map', () {
      final now = DateTime.now();
      final receipt = ReceiptModel(
        id: '123',
        userId: 'user_1',
        title: 'MacBook Pro',
        shop: 'Apple Store',
        price: 1999.99,
        purchaseDate: now,
        expiryDate: now.add(const Duration(days: 365)),
        category: 'Electronics',
        imagePath: '/path/to/image.jpg',
      );

      final map = receipt.toMap();
      final fromMap = ReceiptModel.fromMap(map);

      expect(fromMap.title, 'MacBook Pro');
      expect(fromMap.price, 1999.99);
      expect(fromMap.isSynced, false);
      expect(fromMap.purchaseDate.toIso8601String(), now.toIso8601String());
    });

    test('copyWith should return a new object with updated values', () {
      final receipt = ReceiptModel(
        id: '1',
        userId: 'u1',
        title: 'Old Title',
        shop: 'Shop',
        price: 10.0,
        purchaseDate: DateTime.now(),
        expiryDate: DateTime.now(),
        category: 'Cat',
        imagePath: 'path',
      );

      final updated = receipt.copyWith(title: 'New Title', isSynced: true);

      expect(updated.title, 'New Title');
      expect(updated.isSynced, true);
      expect(updated.id, '1'); // Tetap sama
    });
  });
}
