import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_variant_model.dart';

/// Admin service for managing product variants
/// This service provides methods that would be used in your admin panel
/// to add, update, and delete color variants for products
class AdminVariantService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Add a new color variant to a product
  /// This is like adding a new RAM module to a computer
  Future<String> addVariantToProduct(
    String productId,
    ProductVariantModel variant,
  ) async {
    try {
      // First, mark the product as having variants
      await _firestore.collection('products').doc(productId).update({
        'hasVariants': true,
      });

      // Add the variant to the product's variants subcollection
      final docRef = await _firestore
          .collection('products')
          .doc(productId)
          .collection('variants')
          .add(variant.toMap());

      return docRef.id;
    } catch (e) {
      throw Exception('Failed to add variant: $e');
    }
  }

  /// Update an existing variant
  /// Like upgrading RAM specs while keeping the same slot
  Future<void> updateVariant(
    String productId,
    String variantId,
    ProductVariantModel updatedVariant,
  ) async {
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .collection('variants')
          .doc(variantId)
          .update(updatedVariant.toMap());
    } catch (e) {
      throw Exception('Failed to update variant: $e');
    }
  }

  /// Remove a variant from a product
  /// Like removing a RAM module from a computer
  Future<void> removeVariant(String productId, String variantId) async {
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .collection('variants')
          .doc(variantId)
          .delete();

      // Check if this was the last variant
      final remainingVariants = await _firestore
          .collection('products')
          .doc(productId)
          .collection('variants')
          .get();

      // If no variants left, mark product as not having variants
      if (remainingVariants.docs.isEmpty) {
        await _firestore.collection('products').doc(productId).update({
          'hasVariants': false,
        });
      }
    } catch (e) {
      throw Exception('Failed to remove variant: $e');
    }
  }

  /// Get all variants for a product
  Future<List<ProductVariantModel>> getProductVariants(String productId) async {
    try {
      final querySnapshot = await _firestore
          .collection('products')
          .doc(productId)
          .collection('variants')
          .orderBy('displayOrder')
          .get();

      return querySnapshot.docs
          .map((doc) => ProductVariantModel.fromMap(doc.data(), doc.id))
          .toList();
    } catch (e) {
      throw Exception('Failed to get variants: $e');
    }
  }

  /// Bulk add multiple variants to a product
  /// Like installing multiple RAM modules at once
  Future<List<String>> addMultipleVariants(
    String productId,
    List<ProductVariantModel> variants,
  ) async {
    try {
      final batch = _firestore.batch();
      final variantIds = <String>[];

      // Mark product as having variants
      final productRef = _firestore.collection('products').doc(productId);
      batch.update(productRef, {'hasVariants': true});

      // Add each variant
      for (final variant in variants) {
        final variantRef = _firestore
            .collection('products')
            .doc(productId)
            .collection('variants')
            .doc(); // Auto-generate ID

        batch.set(variantRef, variant.toMap());
        variantIds.add(variantRef.id);
      }

      await batch.commit();
      return variantIds;
    } catch (e) {
      throw Exception('Failed to add multiple variants: $e');
    }
  }

  /// Update variant stock quantity
  /// Useful for inventory management
  Future<void> updateVariantStock(
    String productId,
    String variantId,
    int newStock,
  ) async {
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .collection('variants')
          .doc(variantId)
          .update({
        'stockQuantity': newStock,
        'isAvailable': newStock > 0,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      throw Exception('Failed to update variant stock: $e');
    }
  }

  /// Toggle variant availability
  Future<void> toggleVariantAvailability(
    String productId,
    String variantId,
    bool isAvailable,
  ) async {
    try {
      await _firestore
          .collection('products')
          .doc(productId)
          .collection('variants')
          .doc(variantId)
          .update({
        'isAvailable': isAvailable,
        'updatedAt': DateTime.now(),
      });
    } catch (e) {
      throw Exception('Failed to toggle variant availability: $e');
    }
  }

  /// Reorder variants (change display order)
  Future<void> reorderVariants(
    String productId,
    List<String> variantIds,
  ) async {
    try {
      final batch = _firestore.batch();

      for (int i = 0; i < variantIds.length; i++) {
        final variantRef = _firestore
            .collection('products')
            .doc(productId)
            .collection('variants')
            .doc(variantIds[i]);

        batch.update(variantRef, {
          'displayOrder': i,
          'updatedAt': DateTime.now(),
        });
      }

      await batch.commit();
    } catch (e) {
      throw Exception('Failed to reorder variants: $e');
    }
  }
}

/// Example usage in your admin panel:
class AdminVariantExamples {
  final AdminVariantService _service = AdminVariantService();

  /// Example: Adding color variants to a kitchen appliance
  Future<void> addKitchenAppliancolorVariants(String productId) async {
    final variants = [
      ProductVariantModel(
        id: '', // Will be auto-generated
        color: 'Stainless Steel',
        colorHex: '#C0C0C0',
        imageUrl: 'https://example.com/stainless_steel.jpg',
        images: [
          'https://example.com/stainless_steel_1.jpg',
          'https://example.com/stainless_steel_2.jpg',
        ],
        stockQuantity: 15,
        priceAdjustment: 0.0, // Base price
        isAvailable: true,
        sku: 'KW-SS-001',
        displayOrder: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductVariantModel(
        id: '',
        color: 'Black',
        colorHex: '#000000',
        imageUrl: 'https://example.com/black.jpg',
        images: [
          'https://example.com/black_1.jpg',
          'https://example.com/black_2.jpg',
        ],
        stockQuantity: 12,
        priceAdjustment: 500.0, // ₹500 extra for black finish
        isAvailable: true,
        sku: 'KW-BK-001',
        displayOrder: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
      ProductVariantModel(
        id: '',
        color: 'White',
        colorHex: '#FFFFFF',
        imageUrl: 'https://example.com/white.jpg',
        images: [
          'https://example.com/white_1.jpg',
          'https://example.com/white_2.jpg',
        ],
        stockQuantity: 8,
        priceAdjustment: -200.0, // ₹200 discount for white
        isAvailable: true,
        sku: 'KW-WH-001',
        displayOrder: 2,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    ];

    try {
      final variantIds = await _service.addMultipleVariants(productId, variants);
      print('Successfully added ${variantIds.length} variants');
    } catch (e) {
      print('Error adding variants: $e');
    }
  }

  /// Example: Update stock for a specific variant
  Future<void> updateStockExample(String productId, String variantId) async {
    try {
      await _service.updateVariantStock(productId, variantId, 20);
      print('Stock updated successfully');
    } catch (e) {
      print('Error updating stock: $e');
    }
  }
}
