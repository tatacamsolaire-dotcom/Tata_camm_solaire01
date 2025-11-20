import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/product.dart';
import '../models/sale.dart';

class AppDB {
  static final AppDB _instance = AppDB._();
  static Database? _db;
  AppDB._();
  factory AppDB() => _instance;

  Future<Database> get db async {
    if (_db != null) return _db!;
    _db = await init();
    return _db!;
  }

  Future<Database> init() async {
    final path = join(await getDatabasesPath(), 'gestion_vente.db');
    return await openDatabase(path, version: 1, onCreate: (db, v) async {
      await db.execute('''
        CREATE TABLE products(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          description TEXT,
          purchasePrice INTEGER,
          salePrice INTEGER,
          initialStock INTEGER,
          stock INTEGER
        );
      ''');
      await db.execute('''
        CREATE TABLE sales(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          productId INTEGER,
          productName TEXT,
          quantity INTEGER,
          amount INTEGER,
          clientName TEXT,
          clientPhone TEXT,
          city TEXT,
          date TEXT
        );
      ''');
    });
  }

  Future<int> insertProduct(Product p) async {
    final dbClient = await db;
    return await dbClient.insert('products', p.toMap());
  }

  Future<List<Product>> allProducts() async {
    final dbClient = await db;
    final res = await dbClient.query('products');
    return res.map((e) => Product.fromMap(e)).toList();
  }

  Future<int> updateProduct(Product p) async {
    final dbClient = await db;
    return await dbClient.update('products', p.toMap(), where: 'id=?', whereArgs: [p.id]);
  }

  Future<int> deleteAllProducts() async {
    final dbClient = await db;
    return await dbClient.delete('products');
  }

  Future<int> insertSale(Sale s) async {
    final dbClient = await db;
    return await dbClient.insert('sales', s.toMap());
  }

  Future<List<Map<String, dynamic>>> allSales() async {
    final dbClient = await db;
    return await dbClient.query('sales', orderBy: 'date DESC');
  }

  Future<int> deleteAllSales() async {
    final dbClient = await db;
    return await dbClient.delete('sales');
  }
}
