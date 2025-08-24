import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../shared/models/product_model.dart';
import '../../../shared/models/category_model.dart';
import '../../../shared/models/product_variant_model.dart';

class ProductController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Observable variables
  final Rx<ProductModel?> currentProduct = Rx<ProductModel?>(null);
  final Rx<CategoryModel?> productCategory = Rx<CategoryModel?>(null);
  final RxBool isLoading = false.obs;
  final RxInt selectedImageIndex = 0.obs;
  
  // Variant-related variables
  final Rx<ProductVariantModel?> selectedVariant = Rx<ProductVariantModel?>(null);
  final RxList<ProductVariantModel> productVariants = <ProductVariantModel>[].obs;
  final RxBool variantsLoading = false.obs;

  String? productId;

  @override
  void onInit() {
    super.onInit();
    productId = Get.arguments?['productId'];
    if (productId != null) {
      loadProductData();
    }
  }

  Future<void> loadProductData() async {
    isLoading.value = true;
    try {
      await loadProductInfo();
      if (currentProduct.value != null) {
        await loadProductCategory();
        // Load variants if product has them
        if (currentProduct.value!.hasVariants) {
          await loadProductVariants();
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Failed to load product data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadProductInfo() async {
    if (productId == null) return;
    
    try {
      final doc = await _firestore.collection('products').doc(productId!).get();
      if (doc.exists) {
        currentProduct.value = ProductModel.fromMap(doc.data()!, doc.id);
      }
    } catch (e) {
      print('Error loading product info: $e');
    }
  }

  Future<void> loadProductCategory() async {
    final product = currentProduct.value;
    if (product == null) return;
    
    try {
      final doc = await _firestore.collection('categories').doc(product.categoryId).get();
      if (doc.exists) {
        productCategory.value = CategoryModel.fromMap(doc.data()!, doc.id);
      }
    } catch (e) {
      print('Error loading product category: $e');
    }
  }

  void changeSelectedImage(int index) {
    selectedImageIndex.value = index;
  }

  void goToCategory() {
    final product = currentProduct.value;
    if (product != null) {
      Get.toNamed('/category', arguments: {'categoryId': product.categoryId});
    }
  }

  Future<void> loadProductVariants() async {
    final product = currentProduct.value;
    if (product == null) return;
    
    variantsLoading.value = true;
    try {
      final querySnapshot = await _firestore
          .collection('products')
          .doc(product.id)
          .collection('variants')
          .orderBy('displayOrder')
          .get();
      
      final variants = querySnapshot.docs
          .map((doc) => ProductVariantModel.fromMap(doc.data(), doc.id))
          .toList();
      
      productVariants.assignAll(variants);
      
      // Update the product with variants
      currentProduct.value!.variants = variants;
      
      // Set the first available variant as default
      if (variants.isNotEmpty) {
        selectVariant(variants.first);
      }
    } catch (e) {
      print('Error loading product variants: $e');
    } finally {
      variantsLoading.value = false;
    }
  }
  
  void selectVariant(ProductVariantModel variant) {
    selectedVariant.value = variant;
    // Reset image index when variant changes
    selectedImageIndex.value = 0;
  }
  
  void selectVariantByColor(String color) {
    final variant = productVariants.firstWhereOrNull(
      (v) => v.color.toLowerCase() == color.toLowerCase(),
    );
    if (variant != null) {
      selectVariant(variant);
    }
  }
  
  // Get current price based on selected variant
  double getCurrentPrice() {
    final product = currentProduct.value;
    if (product == null) return 0.0;
    
    if (selectedVariant.value != null) {
      return product.getVariantPrice(selectedVariant.value);
    }
    
    return product.price;
  }
  
  // Get current images based on selected variant
  List<String> getCurrentImages() {
    final product = currentProduct.value;
    if (product == null) return [];
    
    return product.getCurrentImages(selectedVariant.value);
  }
  
  // Check if current variant is available
  bool isCurrentVariantAvailable() {
    final product = currentProduct.value;
    if (product == null) return false;
    
    return product.isVariantAvailable(selectedVariant.value);
  }
  
  // Get stock for current variant
  int getCurrentStock() {
    if (selectedVariant.value != null) {
      return selectedVariant.value!.stockQuantity;
    }
    
    return currentProduct.value?.stockQuantity ?? 0;
  }
  
  void addToCart() {
    final product = currentProduct.value;
    if (product == null) return;
    
    String message = 'Product added to cart successfully!';
    
    // Include variant info in the message if applicable
    if (selectedVariant.value != null) {
      message = '${product.name} (${selectedVariant.value!.color}) added to cart!';
    }
    
    // TODO: Implement actual add to cart functionality with variant support
    Get.snackbar('Added to Cart', message);
  }
}
