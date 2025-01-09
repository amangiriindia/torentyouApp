import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, 'notifications.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE notifications (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            title TEXT,
            text TEXT,
            image TEXT,
            name TEXT
          )
        ''');
      },
    );
  }

  Future<List<Map<String, dynamic>>> getNotifications() async {
    final db = await database;
    return await db.query('notifications', orderBy: 'id DESC');
  }

  Future<int> addNotification({
    required String title,
    String? text,
    String? image,
    String? name,
  }) async {
    final db = await database;
    return await db.insert('notifications', {
      'title': title,
      'text': text ?? 'NA',
      'image': image ?? 'NA',
      'name': name ?? 'NA',
    });
  }

  Future<int> deleteAllNotifications() async {
    final db = await database;
    return await db.delete('notifications');
  }
}