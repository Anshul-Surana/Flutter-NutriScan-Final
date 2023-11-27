// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';
// import 'category.dart';
//
// class DatabaseProvider {
//   static const String _databaseName = 'categories.db';
//   static const int _databaseVersion = 1;
//
//   static Database? _database;
//
//   static Future<void> initializeDatabase() async {
//     try {
//       print('Initializing database...');
//       final databasePath = await getDatabasesPath();
//       final path = join(databasePath, _databaseName);
//
//       if (await databaseFactory.databaseExists(path)) {
//         _database = await openDatabase(path, version: _databaseVersion);
//       } else {
//         _database = await openDatabase(path, version: _databaseVersion,
//             onCreate: (db, version) {
//           db.execute('''
//           CREATE TABLE categories(
//             id INTEGER PRIMARY KEY,
//             name TEXT,
//             checked INTEGER
//           )
//         ''');
//
//           db.execute('''
//           CREATE TABLE user_profiles(
//             id INTEGER PRIMARY KEY,
//             name TEXT,
//             age INTEGER,
//             height REAL,
//             weight REAL
//             avatarImagePath TEXT
//           )
//         ''');
//
//           // Insert the initial categories into the database
//           _insertInitialCategories(db);
//         });
//       }
//       print('Database initialization successful.');
//     } catch (e) {
//       print('Error initializing database: $e');
//       rethrow;
//     }
//   }
//
//   static Future<Database> get database async {
//     if (_database != null) return _database!;
//
//     await initializeDatabase();
//     return _database!;
//   }
//
//   /// Inserts an initial set of categories into the database.
//   static Future<void> _insertInitialCategories(Database db) async {
//     try {
//       final initialCategories = [
//         Category(id: 0, name: 'Garlic', checked: false),
//         Category(id: 1, name: 'Lactose', checked: false),
//         Category(id: 2, name: 'Nuts', checked: false),
//         Category(id: 3, name: 'Allergen', checked: false),
//         Category(id: 4, name: 'Peanuts', checked: false),
//       ];
//
//       final batch = db.batch();
//       for (final category in initialCategories) {
//         batch.insert('categories', category.toMap());
//       }
//
//       await batch.commit();
//     } catch (e) {
//       print('Error inserting initial categories: $e');
//       rethrow;
//     }
//   }
//
//   static Future<Map<String, dynamic>?> readUserProfile() async {
//     try {
//       final db = await database;
//       final List<Map<String, dynamic>> result = await db.query('user_profiles');
//
//       return result.isNotEmpty ? result.first : null;
//     } catch (e) {
//       print('Error reading user profile: $e');
//       rethrow;
//     }
//   }
//
//   static Future<int> createUserProfile(String name, int age, double height,
//       double weight, String? avatarImagePath) async {
//     try {
//       final db = await database;
//       final Map<String, dynamic> userProfile = {
//         'name': name,
//         'age': age,
//         'height': height,
//         'weight': weight,
//         'avatarImagePath': avatarImagePath,
//       };
//
//       return await db.insert('user_profiles', userProfile,
//           conflictAlgorithm: ConflictAlgorithm.replace);
//     } catch (e) {
//       print('Error creating/updating user profile: $e');
//       rethrow;
//     }
//   }
//
//   /// Creates a new category in the database.
//   static Future<int> createCategory(String name, int checked) async {
//     try {
//       final db = await database;
//       return await db.insert('categories', {
//         'name': name,
//         'checked': checked,
//       });
//     } catch (e) {
//       print('Error creating category: $e');
//       rethrow;
//     }
//   }
//
//   /// Reads all categories from the database.
//   static Future<List<Map<String, dynamic>>?> readCategories() async {
//     try {
//       final db = await database;
//       return await db.query('categories');
//     } catch (e) {
//       print('Error reading categories: $e');
//       rethrow;
//     }
//   }
//
//   /// Updates an existing category in the database.
//   static Future<int> updateCategory(int id, String name, int checked) async {
//     try {
//       final db = await database;
//       return await db.update(
//           'categories',
//           {
//             'name': name,
//             'checked': checked,
//           },
//           where: 'id = ?',
//           whereArgs: [id]);
//     } catch (e) {
//       print('Error updating category: $e');
//       rethrow;
//     }
//   }
//
//   /// Deletes a category from the database.
//   static Future<int> deleteCategory(int id) async {
//     try {
//       final db = await database;
//       return await db.delete('categories', where: 'id = ?', whereArgs: [id]);
//     } catch (e) {
//       print('Error deleting category: $e');
//       rethrow;
//     }
//   }
// }
