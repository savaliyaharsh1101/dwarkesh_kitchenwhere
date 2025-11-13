import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../shared/models/product_model.dart';

class ProductSearchController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  final RxList<ProductModel> searchResults = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    // Get search query from arguments
    final args = Get.arguments;
    if (args != null && args['query'] != null) {
      searchQuery.value = args['query'];
      performSearch(searchQuery.value);
    }
  }

  Future<void> performSearch(String query) async {
    if (query.trim().isEmpty) {
      searchResults.clear();
      return;
    }

    isLoading.value = true;
    searchQuery.value = query;
    
    try {
      // Fetch all products
      final snapshot = await _firestore
          .collection('products')
          .where('isActive', isEqualTo: true)
          .get();

      // Convert to ProductModel
      List<ProductModel> allProducts = snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .toList();

      // Filter products based on search query (case-insensitive)
      final lowercaseQuery = query.toLowerCase();
      
      searchResults.value = allProducts.where((product) {
        // Search in product name
        if (product.name.toLowerCase().contains(lowercaseQuery)) {
          return true;
        }
        
        // Search in description
        if (product.description.toLowerCase().contains(lowercaseQuery)) {
          return true;
        }
        
        // Search in brand
        if (product.brand.toLowerCase().contains(lowercaseQuery)) {
          return true;
        }
        
        // Search in material
        if (product.material.toLowerCase().contains(lowercaseQuery)) {
          return true;
        }
        
        // Search in features
        if (product.features.any((feature) => 
            feature.toLowerCase().contains(lowercaseQuery))) {
          return true;
        }
        
        // Search in tags
        if (product.tags.any((tag) => 
            tag.toLowerCase().contains(lowercaseQuery))) {
          return true;
        }
        
        // Search in color (if exists)
        if (product.color != null && 
            product.color!.toLowerCase().contains(lowercaseQuery)) {
          return true;
        }
        
        // Search in style (if exists)
        if (product.style != null && 
            product.style!.toLowerCase().contains(lowercaseQuery)) {
          return true;
        }
        
        // Search in occasions
        if (product.occasions.any((occasion) => 
            occasion.toLowerCase().contains(lowercaseQuery))) {
          return true;
        }
        
        // Search in additional features
        if (product.additionalFeatures.any((feature) => 
            feature.toLowerCase().contains(lowercaseQuery))) {
          return true;
        }
        
        return false;
      }).toList();
      
      // Sort results: exact matches first, then partial matches
      searchResults.sort((a, b) {
        final aNameMatch = a.name.toLowerCase() == lowercaseQuery;
        final bNameMatch = b.name.toLowerCase() == lowercaseQuery;
        
        if (aNameMatch && !bNameMatch) return -1;
        if (!aNameMatch && bNameMatch) return 1;
        
        return a.name.compareTo(b.name);
      });
      
    } catch (e) {
      Get.snackbar('Error', 'Failed to search products: $e');
      searchResults.clear();
    } finally {
      isLoading.value = false;
    }
  }

  void clearSearch() {
    searchQuery.value = '';
    searchResults.clear();
  }
}
