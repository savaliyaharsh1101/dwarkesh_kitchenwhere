import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../shared/models/category_model.dart';
import '../../../shared/models/product_model.dart';

class CategoryController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Observable variables
  final RxList<ProductModel> categoryProducts = <ProductModel>[].obs;
  final Rx<CategoryModel?> currentCategory = Rx<CategoryModel?>(null);
  final RxBool isLoading = false.obs;
  final RxString selectedSortOption = 'name'.obs;
  final RxList<String> selectedFilters = <String>[].obs;
  
  // Filter options
  final List<String> sortOptions = ['name', 'price_low', 'price_high', 'newest'];
  final RxList<String> availableStyles = <String>[].obs;
  final RxList<String> availableOccasions = <String>[].obs;
  final RxList<String> availableFeatures = <String>[].obs;
  final RxList<String> availableBrands = <String>[].obs;

  String? categoryId;

  @override
  void onInit() {
    super.onInit();
    categoryId = Get.arguments?['categoryId'];
    if (categoryId != null) {
      loadCategoryData();
    }
  }

  Future<void> loadCategoryData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadCategoryInfo(),
        loadCategoryProducts(),
      ]);
      extractFilterOptions();
    } catch (e) {
      Get.snackbar('Error', 'Failed to load category data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCategoryInfo() async {
    if (categoryId == null) return;
    
    try {
      final doc = await _firestore.collection('categories').doc(categoryId!).get();
      if (doc.exists) {
        currentCategory.value = CategoryModel.fromMap(doc.data()!, doc.id);
      }
    } catch (e) {
      print('Error loading category info: $e');
    }
  }

  Future<void> loadCategoryProducts() async {
    if (categoryId == null) return;
    
    try {
      // Simple query to avoid composite index requirements
      final snapshot = await _firestore
          .collection('products')
          .where('categoryId', isEqualTo: categoryId!)
          .get();
          
      List<ProductModel> products = snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data() as Map<String, dynamic>, doc.id))
          .where((product) => product.isAvailable && product.isActive)
          .toList();

      // Apply sorting locally
      switch (selectedSortOption.value) {
        case 'price_low':
          products.sort((a, b) => a.price.compareTo(b.price));
          break;
        case 'price_high':
          products.sort((a, b) => b.price.compareTo(a.price));
          break;
        case 'newest':
          products.sort((a, b) => b.createdAt.compareTo(a.createdAt));
          break;
        default:
          products.sort((a, b) => a.name.compareTo(b.name));
      }

      // Apply filters
      if (selectedFilters.isNotEmpty) {
        products = products.where((product) {
          return selectedFilters.any((filter) {
            return product.style == filter ||
                   product.occasions.contains(filter) ||
                   product.additionalFeatures.contains(filter) ||
                   product.brand == filter;
          });
        }).toList();
      }

      categoryProducts.value = products;
    } catch (e) {
      print('Error loading category products: $e');
    }
  }

  void extractFilterOptions() {
    final Set<String> styles = {};
    final Set<String> occasions = {};
    final Set<String> features = {};
    final Set<String> brands = {};

    for (final product in categoryProducts) {
      if (product.style != null) styles.add(product.style!);
      occasions.addAll(product.occasions);
      features.addAll(product.additionalFeatures);
      brands.add(product.brand);
    }

    availableStyles.value = styles.toList()..sort();
    availableOccasions.value = occasions.toList()..sort();
    availableFeatures.value = features.toList()..sort();
    availableBrands.value = brands.toList()..sort();
  }

  void updateSortOption(String sortOption) {
    selectedSortOption.value = sortOption;
    loadCategoryProducts();
  }

  void toggleFilter(String filter) {
    if (selectedFilters.contains(filter)) {
      selectedFilters.remove(filter);
    } else {
      selectedFilters.add(filter);
    }
    loadCategoryProducts();
  }

  void clearFilters() {
    selectedFilters.clear();
    loadCategoryProducts();
  }

  void goToProductDetail(ProductModel product) {
    Get.toNamed('/product-detail', arguments: {'productId': product.id});
  }
}
