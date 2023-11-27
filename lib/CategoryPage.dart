import 'package:flutter/material.dart';
import 'CategoriesDatabaseHelper.dart';
import 'category.dart';

class CategoryPage extends StatefulWidget {
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late List<Category> _categories = [];

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await CategoriesDatabaseHelper.readCategories();
      if (categories != null) {
        setState(() {
          _categories = categories.map((category) => Category.fromMap(category)).toList();
        });
      }
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<void> _createCategory(String name, int checked) async {
    try {
      await CategoriesDatabaseHelper.createCategory(name, checked);
      _loadCategories(); // Reload categories after creating a new one
    } catch (e) {
      print('Error creating category: $e');
    }
  }

  Future<void> _deleteCategory(int id) async {
    try {
      await CategoriesDatabaseHelper.deleteCategory(id);
      _loadCategories(); // Reload categories after deleting one
    } catch (e) {
      print('Error deleting category: $e');
    }
  }

  Future<void> _updateCategory(int id, String name, int checked) async {
    try {
      await CategoriesDatabaseHelper.updateCategory(id, name, checked);
      _loadCategories(); // Reload categories after updating one
    } catch (e) {
      print('Error updating category: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: ListView.builder(
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return CategoryTile(
            category: _categories[index],
            onUpdate: _updateCategory,
            onDelete: _deleteCategory,
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final String? categoryName = await showDialog<String>(
            context: context,
            builder: (context) {
              String? newName;
              return AlertDialog(
                title: Text('New Category'),
                content: TextField(
                  onChanged: (value) {
                    newName = value;
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter category name',
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: Text('Cancel'),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pop(newName);
                    },
                    child: Text('Create'),
                  ),
                ],
              );
            },
          );

          if (categoryName != null && categoryName.isNotEmpty) {
            _createCategory(categoryName, 5);
          }
        },
        child: Icon(Icons.add),
      ),
    );
  }
}

class CategoryTile extends StatelessWidget {
  final Category category;
  final Function(int, String, int) onUpdate;
  final Function(int) onDelete;

  const CategoryTile({
    required this.category,
    required this.onUpdate,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Checkbox(
            value: category.checked == true,
            onChanged: (bool? value) {
              onUpdate(
                category.id,
                category.name,
                value == true ? 1 : 0,
              );
            },
          ),
          GestureDetector(
            onTap: () {
              onUpdate(
                category.id,
                category.name,
                category.checked == true ? 0 : 1,
              );
            },
            child: Text(
              category.name,
              style: TextStyle(
                color: category.checked == true ? Colors.green : Colors.red,
              ),
            ),
          ),
        ],
      ),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          onDelete(category.id);
        },
      ),
    );
  }
}
