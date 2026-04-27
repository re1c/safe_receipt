class ReceiptModel {
  final String id;
  final String userId;
  final String title;
  final String shop;
  final double price;
  final DateTime purchaseDate;
  final DateTime expiryDate;
  final String category;
  final String imagePath;
  final bool isSynced;

  ReceiptModel({
    required this.id,
    required this.userId,
    required this.title,
    required this.shop,
    required this.price,
    required this.purchaseDate,
    required this.expiryDate,
    required this.category,
    required this.imagePath,
    this.isSynced = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'shop': shop,
      'price': price,
      'purchaseDate': purchaseDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'category': category,
      'imagePath': imagePath,
      'isSynced': isSynced ? 1 : 0,
    };
  }

  factory ReceiptModel.fromMap(Map<String, dynamic> map) {
    return ReceiptModel(
      id: map['id'],
      userId: map['userId'] ?? '',
      title: map['title'],
      shop: map['shop'],
      price: (map['price'] as num).toDouble(),
      purchaseDate: DateTime.parse(map['purchaseDate']),
      expiryDate: DateTime.parse(map['expiryDate']),
      category: map['category'],
      imagePath: map['imagePath'],
      isSynced: map['isSynced'] == 1,
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'id': id,
      'userId': userId,
      'title': title,
      'shop': shop,
      'price': price,
      'purchaseDate': purchaseDate.toIso8601String(),
      'expiryDate': expiryDate.toIso8601String(),
      'category': category,
      'imagePath': imagePath,
    };
  }

  ReceiptModel copyWith({
    String? id,
    String? userId,
    String? title,
    String? shop,
    double? price,
    DateTime? purchaseDate,
    DateTime? expiryDate,
    String? category,
    String? imagePath,
    bool? isSynced,
  }) {
    return ReceiptModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      title: title ?? this.title,
      shop: shop ?? this.shop,
      price: price ?? this.price,
      purchaseDate: purchaseDate ?? this.purchaseDate,
      expiryDate: expiryDate ?? this.expiryDate,
      category: category ?? this.category,
      imagePath: imagePath ?? this.imagePath,
      isSynced: isSynced ?? this.isSynced,
    );
  }
}
