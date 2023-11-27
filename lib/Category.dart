class Category {
  final int id;
  final String name;
  bool checked;

  Category({
    required this.id,
    required this.name,
    required this.checked,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'checked': checked ? 1 : 0,
    };
  }

  factory Category.fromMap(Map<String, dynamic> map) {
    return Category(
      id: map['id'],
      name: map['name'],
      checked: map['checked'] == 1,
    );
  }
}
