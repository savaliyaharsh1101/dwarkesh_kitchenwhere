class ProductVariantModel {
  final String id;
  final String color;
  final String colorHex;
  final String imageUrl;
  final List<String> images;
  final int stockQuantity;
  final double? priceAdjustment; // Additional cost for this variant (can be negative for discount)
  final bool isAvailable;
  final String? sku;
  final int displayOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductVariantModel({
    required this.id,
    required this.color,
    required this.colorHex,
    required this.imageUrl,
    this.images = const [],
    this.stockQuantity = 0,
    this.priceAdjustment = 0.0,
    this.isAvailable = true,
    this.sku,
    this.displayOrder = 0,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductVariantModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ProductVariantModel(
      id: documentId,
      color: map['color'] ?? '',
      colorHex: map['colorHex'] ?? '#000000',
      imageUrl: map['imageUrl'] ?? '',
      images: List<String>.from(map['images'] ?? []),
      stockQuantity: map['stockQuantity'] ?? 0,
      priceAdjustment: (map['priceAdjustment'] ?? 0.0).toDouble(),
      isAvailable: map['isAvailable'] ?? true,
      sku: map['sku'],
      displayOrder: map['displayOrder'] ?? 0,
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
      'color': color,
      'colorHex': colorHex,
      'imageUrl': imageUrl,
      'images': images,
      'stockQuantity': stockQuantity,
      'priceAdjustment': priceAdjustment,
      'isAvailable': isAvailable,
      'sku': sku,
      'displayOrder': displayOrder,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  // Helper methods
  double getAdjustedPrice(double basePrice) {
    return basePrice + (priceAdjustment ?? 0.0);
  }

  bool get hasImages => images.isNotEmpty || imageUrl.isNotEmpty;

  List<String> get allImages {
    if (images.isNotEmpty) return images;
    if (imageUrl.isNotEmpty) return [imageUrl];
    return [];
  }

  ProductVariantModel copyWith({
    String? id,
    String? color,
    String? colorHex,
    String? imageUrl,
    List<String>? images,
    int? stockQuantity,
    double? priceAdjustment,
    bool? isAvailable,
    String? sku,
    int? displayOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return ProductVariantModel(
      id: id ?? this.id,
      color: color ?? this.color,
      colorHex: colorHex ?? this.colorHex,
      imageUrl: imageUrl ?? this.imageUrl,
      images: images ?? this.images,
      stockQuantity: stockQuantity ?? this.stockQuantity,
      priceAdjustment: priceAdjustment ?? this.priceAdjustment,
      isAvailable: isAvailable ?? this.isAvailable,
      sku: sku ?? this.sku,
      displayOrder: displayOrder ?? this.displayOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
