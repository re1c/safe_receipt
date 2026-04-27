import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/receipt_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('receipts.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  Future _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE receipts (
        id TEXT PRIMARY KEY,
        userId TEXT,
        title TEXT NOT NULL,
        shop TEXT NOT NULL,
        price REAL NOT NULL,
        purchaseDate TEXT NOT NULL,
        expiryDate TEXT NOT NULL,
        category TEXT NOT NULL,
        imagePath TEXT NOT NULL,
        isSynced INTEGER NOT NULL
      )
    ''');
  }

  Future<int> insertReceipt(ReceiptModel receipt) async {
    final db = await instance.database;
    return await db.insert('receipts', receipt.toMap());
  }

  Future<List<ReceiptModel>> getAllReceipts() async {
    final db = await instance.database;
    final result = await db.query('receipts', orderBy: 'purchaseDate DESC');
    return result.map((json) => ReceiptModel.fromMap(json)).toList();
  }

  Future<int> updateReceipt(ReceiptModel receipt) async {
    final db = await instance.database;
    return await db.update(
      'receipts',
      receipt.toMap(),
      where: 'id = ?',
      whereArgs: [receipt.id],
    );
  }

  Future<int> deleteReceipt(String id) async {
    final db = await instance.database;
    return await db.delete(
      'receipts',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<int> markAsSynced(String id) async {
    final db = await instance.database;
    return await db.update(
      'receipts',
      {'isSynced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future close() async {
    final db = await instance.database;
    db.close();
  }
}
