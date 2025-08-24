class CategoryModel {
  final String id;
  final String name;
  final String description;
  final String imageUrl;
  final String? iconUrl;
  final bool isActive;
  final int sortOrder;
  final String? parentCategoryId;
  final int productCount;
  final DateTime createdAt;
  final DateTime updatedAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.description,
    required this.imageUrl,
    this.iconUrl,
    required this.isActive,
    this.sortOrder = 0,
    this.parentCategoryId,
    this.productCount = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory CategoryModel.fromMap(Map<String, dynamic> map, String documentId) {
    return CategoryModel(
      id: documentId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      iconUrl: map['iconUrl'],
      isActive: map['isActive'] ?? true,
      sortOrder: map['sortOrder'] ?? 0,
      parentCategoryId: map['parentCategoryId'],
      productCount: map['productCount'] ?? 0,
      createdAt: _parseDateTime(map['createdAt']),
      updatedAt: _parseDateTime(map['updatedAt']),
    );
  }

  static DateTime _parseDateTime(dynamic value) {
    if (value == null) {
      return DateTime.now();
    }
    
    // Handle int (milliseconds since epoch)
    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }
    
    // Handle DateTime
    if (value is DateTime) {
      return value;
    }
    
    // Handle String (ISO 8601)
    if (value is String) {
      try {
        return DateTime.parse(value);
      } catch (e) {
        print('Error parsing date string: $value');
        return DateTime.now();
      }
    }
    
    // Handle Firestore Timestamp
    if (value.runtimeType.toString() == 'Timestamp') {
      return (value as dynamic).toDate();
    }
    
    print('Unknown date type: ${value.runtimeType} - $value');
    return DateTime.now();
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'iconUrl': iconUrl,
      'isActive': isActive,
      'sortOrder': sortOrder,
      'parentCategoryId': parentCategoryId,
      'productCount': productCount,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }
}
