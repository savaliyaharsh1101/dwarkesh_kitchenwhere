import 'product_variant_model.dart';

class ProductModel {
  final String id;
  final String name;
  final String description;
  final double price;
  final double? originalPrice;
  final int discountPercentage;
  final String imageUrl;
  final List<String> images;
  final String categoryId;
  final bool isAvailable;
  final bool isActive;
  final bool isOnSale;
  final List<String> features;
  final String brand;
  final String material;
  final String dimensions;
  final String? weight;
  final String? color; // Keep for backward compatibility, represents default color
  final String? style;
  final List<String> occasions;
  final List<String> additionalFeatures;
  final int stockQuantity; // Default stock quantity
  final int order;
  final String? sku;
  final List<String> tags;
  final double rating;
  final int reviewCount;
  final String? careInstructions;
  final bool hasVariants; // New field
  List<ProductVariantModel> variants; // To be loaded separately
  final DateTime createdAt;
  final DateTime updatedAt;

  ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    this.originalPrice,
    this.discountPercentage = 0,
    required this.imageUrl,
    this.images = const [],
    required this.categoryId,
    required this.isAvailable,
    required this.isActive,
    required this.isOnSale,
    required this.features,
    required this.brand,
    required this.material,
    required this.dimensions,
    this.weight,
    this.color,
    this.style,
    this.occasions = const [],
    this.additionalFeatures = const [],
    this.stockQuantity = 0,
    required this.order,
    this.sku,
    this.tags = const [],
    this.rating = 0.0,
    this.reviewCount = 0,
    this.careInstructions,
    this.hasVariants = false,
    this.variants = const [],
    required this.createdAt,
    required this.updatedAt,
  });

  factory ProductModel.fromMap(Map<String, dynamic> map, String documentId) {
    return ProductModel(
      id: documentId,
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      price: (map['price'] ?? 0.0).toDouble(),
      originalPrice: map['originalPrice']?.toDouble(),
      discountPercentage: map['discountPercentage'] ?? 0,
      imageUrl: map['imageUrl'] ?? '',
      images: map['imageUrl'] != null ? [map['imageUrl']] : [],
      categoryId: map['categoryId'] ?? '',
      isAvailable: map['isAvailable'] ?? true,
      isActive: map['isActive'] ?? true,
      isOnSale: map['isOnSale'] ?? false,
      features: List<String>.from(map['features'] ?? []),
      brand: map['brand'] ?? '',
      material: map['material'] ?? '',
      dimensions: map['dimensions'] ?? '',
      weight: map['weight'],
      color: map['color'],
      style: map['style'],
      occasions: List<String>.from(map['occasions'] ?? []),
      additionalFeatures: List<String>.from(map['additionalFeatures'] ?? []),
      stockQuantity: map['stockQuantity'] ?? 0,
      order: map['order'] ?? 0,
      sku: map['sku'],
      tags: List<String>.from(map['tags'] ?? []),
      rating: (map['rating'] ?? 0.0).toDouble(),
      reviewCount: map['reviewCount'] ?? 0,
      careInstructions: map['careInstructions'],
      hasVariants: map['hasVariants'] ?? false,
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
      'price': price,
      'originalPrice': originalPrice,
      'discountPercentage': discountPercentage,
      'imageUrl': imageUrl,
      'images': images,
      'categoryId': categoryId,
      'isAvailable': isAvailable,
      'isActive': isActive,
      'isOnSale': isOnSale,
      'features': features,
      'brand': brand,
      'material': material,
      'dimensions': dimensions,
      'weight': weight,
      'color': color,
      'style': style,
      'occasions': occasions,
      'additionalFeatures': additionalFeatures,
      'stockQuantity': stockQuantity,
      'sku': sku,
      'tags': tags,
      'rating': rating,
      'reviewCount': reviewCount,
      'careInstructions': careInstructions,
      'hasVariants': hasVariants,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'updatedAt': updatedAt.millisecondsSinceEpoch,
    };
  }

  // Helper methods for variants
  bool get hasColorVariants => hasVariants && variants.isNotEmpty;
  
  ProductVariantModel? getVariantById(String variantId) {
    try {
      return variants.firstWhere(
        (variant) => variant.id == variantId,
      );
    } catch (e) {
      return variants.isNotEmpty ? variants.first : null;
    }
  }
  
  ProductVariantModel? getVariantByColor(String color) {
    try {
      return variants.firstWhere(
        (variant) => variant.color.toLowerCase() == color.toLowerCase(),
      );
    } catch (e) {
      return variants.isNotEmpty ? variants.first : null;
    }
  }
  
  List<String> get availableColors {
    return variants
        .where((variant) => variant.isAvailable)
        .map((variant) => variant.color)
        .toList();
  }
  
  int getTotalStock() {
    if (!hasVariants) return stockQuantity;
    return variants.fold(0, (sum, variant) => sum + variant.stockQuantity);
  }
  
  double getVariantPrice(ProductVariantModel? variant) {
    if (variant == null) return price;
    return variant.getAdjustedPrice(price);
  }
  
  List<String> getCurrentImages(ProductVariantModel? selectedVariant) {
    if (selectedVariant != null && selectedVariant.hasImages) {
      return selectedVariant.allImages;
    }
    return images.isNotEmpty ? images : [imageUrl];
  }
  
  bool isVariantAvailable(ProductVariantModel? variant) {
    if (variant == null) return isAvailable;
    return variant.isAvailable && variant.stockQuantity > 0;
  }
}
