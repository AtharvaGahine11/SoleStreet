class ProductCategory {
  final String id;
  final String name;
  final String icon;
  final String? imageUrl;
  final String gender; // 'women', 'men', 'unisex', 'all'
  final String description;

  const ProductCategory({
    required this.id,
    required this.name,
    required this.icon,
    this.imageUrl,
    this.gender = 'all',
    this.description = '',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'icon': icon,
      'imageUrl': imageUrl,
      'gender': gender,
      'description': description,
    };
  }

  factory ProductCategory.fromMap(Map<String, dynamic> map) {
    return ProductCategory(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      icon: map['icon'] ?? '',
      imageUrl: map['imageUrl'],
      gender: map['gender'] ?? 'all',
      description: map['description'] ?? '',
    );
  }
}
