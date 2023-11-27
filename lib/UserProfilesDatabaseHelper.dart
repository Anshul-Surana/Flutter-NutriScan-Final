import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class UserProfilesDatabaseHelper {
  static const String _databaseName = 'user_profiles.db';
  static const int _databaseVersion = 1;

  static Database? _database;

  static Future<Database> initializeDatabase() async {
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, _databaseName);

      if (_database != null) return _database!;

      _database = await openDatabase(path, version: _databaseVersion,
          onCreate: (db, version) {
            db.execute('''
          CREATE TABLE IF NOT EXISTS user_profiles(
            id INTEGER PRIMARY KEY,
            name TEXT,
            age INTEGER,
            height REAL,
            weight REAL,
            avatarImagePath TEXT
          )
        ''');
          });

      return _database!;
    } catch (e) {
      print('Error initializing user_profiles database: $e');
      rethrow;
    }
  }

  static Future<Map<String, dynamic>?> readUserProfile() async {
    final db = await initializeDatabase();
    final result = await db.query('user_profiles');
    return result.isNotEmpty ? result.first : null;
  }

  static Future<int> createUserProfile(String name, int age, double height,
      double weight, String? avatarImagePath) async {
    final db = await initializeDatabase();

    // Replace existing user profile if it exists
    await db.transaction((txn) async {
      await txn.rawInsert(
        'INSERT OR REPLACE INTO user_profiles '
            '(id, name, age, height, weight, avatarImagePath) VALUES (?, ?, ?, ?, ?, ?)',
        [1, name, age, height, weight, avatarImagePath],
      );
    });

    return 1; // You can return the user ID or any other meaningful value
  }

// Additional CRUD operations can be added here, similar to categories
}
