import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'category.dart';

class CategoriesDatabaseHelper {
  static const String _databaseName = 'categories.db';
  static const int _databaseVersion = 1;

  static Database? _database;

  static Future<void> initializeDatabase() async {
    try {
      final databasePath = await getDatabasesPath();
      final path = join(databasePath, _databaseName);

      if (await databaseFactory.databaseExists(path)) {
        _database = await openDatabase(path, version: _databaseVersion);
      } else {
        _database = await openDatabase(path, version: _databaseVersion,
            onCreate: (db, version) {
              db.execute('''
          CREATE TABLE categories(
            id INTEGER PRIMARY KEY,
            name TEXT,
            checked INTEGER
          )
        ''');

              // Insert the initial categories into the database
          _insertInitialCategories(db);

            });
      }
    } catch (e) {
      print('Error initializing categories database: $e');
      rethrow;
    }
  }

  static Future<Database> get database async {
    if (_database != null) return _database!;

    await initializeDatabase();
    return _database!;
  }

  // Inserts an initial set of categories into the database.
  static Future<void> _insertInitialCategories(Database db) async {
    try {
      final initialCategories = [
        Category(id: 0, name: 'Garlic', checked: false),
        Category(id: 1, name: 'Lactose', checked: false),
        Category(id: 2, name: 'Nuts', checked: false),
        Category(id: 3, name: 'Allergen', checked: false),
        Category(id: 4, name: 'Peanuts', checked: false),
        Category(id: 5, name: 'Onion', checked: false),
      ];
      final batch = db.batch();
      for (final category in initialCategories) {
        batch.insert('categories', category.toMap());
      }

      await batch.commit();
    } catch (e) {
      print('Error inserting initial categories: $e');
      rethrow;
    }
  }

  static Future<int> createCategory(String name, int checked) async {
    try {
      final db = await database;
      return await db.insert('categories', {
        'name': name,
        'checked': checked,
      });
    } catch (e) {
      print('Error creating category: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>?> readCategories() async {
    try {
      final db = await database;
      return await db.query('categories');
    } catch (e) {
      print('Error reading categories: $e');
      rethrow;
    }
  }

  static Future<List<Map<String, dynamic>>> readCheckedCategories() async {
    try {
      final db = await database;
      return await db.query('categories', where: 'checked = ?', whereArgs: [1]);
    } catch (e) {
      print('Error reading checked categories: $e');
      rethrow;
    }
  }

  static Future<int> updateCategory(int id, String name, int checked) async {
    try {
      final db = await database;
      return await db.update(
          'categories',
          {
            'name': name,
            'checked': checked,
          },
          where: 'id = ?',
          whereArgs: [id]);
    } catch (e) {
      print('Error updating category: $e');
      rethrow;
    }
  }

  static Future<int> deleteCategory(int id) async {
    try {
      final db = await database;
      return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
    } catch (e) {
      print('Error deleting category: $e');
      rethrow;
    }
  }
}
