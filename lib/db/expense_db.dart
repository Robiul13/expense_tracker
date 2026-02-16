import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/expense_model.dart';

class ExpenseDB {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final path = join(await getDatabasesPath(), 'expense.db');

    return openDatabase(
      path,
      version: 2,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE expenses(
            id TEXT PRIMARY KEY,
            user_id TEXT,
            title TEXT,
            amount REAL,
            category TEXT,
            created_at TEXT,
            updated_at TEXT,
            is_synced INTEGER DEFAULT 0
          )
        ''');
      },
    );
  }

  // ✅ INSERT
  static Future<void> insertExpense(Expense expense) async {
    final db = await database;
    await db.insert(
      'expenses',
      expense.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // ✅ GET ALL
  static Future<List<Expense>> getExpenses() async {
    final db = await database;
    final maps = await db.query(
      'expenses',
      orderBy: 'created_at DESC',
    );

    return maps.map((e) => Expense.fromMap(e)).toList();
  }

  // ✅ GET UNSYNCED
  static Future<List<Expense>> getUnsyncedExpenses() async {
    final db = await database;

    final maps = await db.query(
      'expenses',
      where: 'is_synced = ?',
      whereArgs: [0],
    );

    return maps.map((e) => Expense.fromMap(e)).toList();
  }

  // ✅ MARK AS SYNCED
  static Future<void> markAsSynced(String id) async {
    final db = await database;

    await db.update(
      'expenses',
      {'is_synced': 1},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ✅ DELETE
  static Future<void> deleteExpense(String id) async {
    final db = await database;

    await db.delete(
      'expenses',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ✅ UPDATE
  static Future<void> updateExpense(Expense expense) async {
    final db = await database;

    await db.update(
      'expenses',
      expense.toMap(),
      where: 'id = ?',
      whereArgs: [expense.id],
    );
  }

  // ✅ CLEAR DB (optional utility)
  static Future<void> clearAll() async {
    final db = await database;
    await db.delete('expenses');
  }
}
