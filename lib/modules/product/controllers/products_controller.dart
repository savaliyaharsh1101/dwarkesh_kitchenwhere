import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../shared/models/product_model.dart';
import '../../../shared/models/category_model.dart';

class ProductsController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Observable variables
  final RxList<ProductModel> products = <ProductModel>[].obs;
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxBool hasMoreProducts = true.obs;
  final RxString selectedCategoryId = ''.obs;
  final RxString selectedSortBy = 'name'.obs;
  final RxString searchQuery = ''.obs;
  
  // Pagination
  final int productsPerPage = 10;
  final RxInt currentPage = 1.obs;
  final RxInt totalProducts = 0.obs;
  DocumentSnapshot? lastDocument;
  
  // Sort options
  final List<Map<String, String>> sortOptions = [
    {'value': 'name', 'label': 'Name (A-Z)'},
    {'value': 'name_desc', 'label': 'Name (Z-A)'},
    {'value': 'price_asc', 'label': 'Price: Low to High'},
    {'value': 'price_desc', 'label': 'Price: High to Low'},
    {'value': 'newest', 'label': 'Newest First'},
    {'value': 'rating', 'label': 'Highest Rated'},
  ];

  @override
  void onInit() {
    super.onInit();
    
    // Get arguments if any (category filter)
    final args = Get.arguments as Map<String, dynamic>?;
    if (args != null && args['categoryId'] != null) {
      selectedCategoryId.value = args['categoryId'];
    }
    
    loadInitialData();
  }

  Future<void> loadInitialData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadCategories(),
        loadProducts(refresh: true),
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCategories() async {
    try {
      print('Loading categories...');
      final snapshot = await _firestore
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .get();

      print('Found ${snapshot.docs.length} categories');
      categories.value = snapshot.docs
          .map((doc) {
            final category = CategoryModel.fromMap(doc.data(), doc.id);
            print('Category: ${category.name} (ID: ${category.id})');
            return category;
          })
          .toList();
      
      // Sort by name locally
      categories.sort((a, b) => a.name.compareTo(b.name));
      print('Categories loaded and sorted');
    } catch (e) {
      print('Error loading categories: $e');
      Get.snackbar('Error', 'Failed to load categories: $e');
    }
  }

  Future<void> loadProducts({bool refresh = false}) async {
    if (refresh) {
      currentPage.value = 1;
      lastDocument = null;
      products.clear();
      hasMoreProducts.value = true;
    }

    if (!hasMoreProducts.value && !refresh) return;

    try {
      // Start with basic products query
      Query query = _firestore.collection('products');

      // Apply category filter first if selected
      if (selectedCategoryId.value.isNotEmpty) {
        print('Filtering by category: ${selectedCategoryId.value}');
        query = query.where('categoryId', isEqualTo: selectedCategoryId.value);
      }

      // Apply search filter only if no category (to avoid composite index issues)
      if (searchQuery.value.isNotEmpty && selectedCategoryId.value.isEmpty) {
        query = query
            .where('name', isGreaterThanOrEqualTo: searchQuery.value)
            .where('name', isLessThanOrEqualTo: '${searchQuery.value}\uf8ff');
      }

      // Simple ordering by name to avoid index issues
      query = query.orderBy('name');

      // Apply pagination
      if (lastDocument != null) {
        query = query.startAfterDocument(lastDocument!);
      }
      
      query = query.limit(productsPerPage);

      print('Executing Firestore query...');
      final snapshot = await query.get();
      print('Query returned ${snapshot.docs.length} documents');
      
      if (snapshot.docs.isEmpty) {
        print('No documents found');
        hasMoreProducts.value = false;
        return;
      }

      // Map documents to products
      final allProducts = snapshot.docs
          .map((doc) {
            try {
              final data = doc.data() as Map<String, dynamic>;
              print('Product data: ${data['name']} - categoryId: ${data['categoryId']} - isActive: ${data['isActive']} - isAvailable: ${data['isAvailable']}');
              return ProductModel.fromMap(data, doc.id);
            } catch (e) {
              print('Error mapping product ${doc.id}: $e');
              return null;
            }
          })
          .where((product) => product != null)
          .cast<ProductModel>()
          .toList();
      
      print('Mapped ${allProducts.length} products');
      
      // Filter for active and available products
      var filteredProducts = allProducts
          .where((product) => product.isAvailable && product.isActive)
          .toList();
      
      print('After availability filter: ${filteredProducts.length} products');
      
      // Apply client-side search if category filter is active
      if (searchQuery.value.isNotEmpty && selectedCategoryId.value.isNotEmpty) {
        filteredProducts = filteredProducts
            .where((product) => product.name.toLowerCase().contains(searchQuery.value.toLowerCase()))
            .toList();
        print('After search filter: ${filteredProducts.length} products');
      }
      
      // Apply client-side sorting if not sorting by name
      if (selectedSortBy.value != 'name') {
        switch (selectedSortBy.value) {
          case 'name_desc':
            filteredProducts.sort((a, b) => b.name.compareTo(a.name));
            break;
          case 'price_asc':
            filteredProducts.sort((a, b) => a.price.compareTo(b.price));
            break;
          case 'price_desc':
            filteredProducts.sort((a, b) => b.price.compareTo(a.price));
            break;
          case 'newest':
            filteredProducts.sort((a, b) => b.createdAt.compareTo(a.createdAt));
            break;
          case 'rating':
            filteredProducts.sort((a, b) => b.rating.compareTo(a.rating));
            break;
        }
      }
      
      final newProducts = filteredProducts;
      print('Final product count: ${newProducts.length}');

      if (refresh) {
        products.value = newProducts;
      } else {
        products.addAll(newProducts);
      }

      // Update pagination state
      if (snapshot.docs.length < productsPerPage) {
        hasMoreProducts.value = false;
      } else {
        lastDocument = snapshot.docs.last;
        currentPage.value++;
      }

      // Update total count
      totalProducts.value = products.length; // Simple count for now
      
    } catch (e) {
      print('Error loading products: $e');
      Get.snackbar('Error', 'Failed to load products. Please try again.');
    }
  }

  Future<void> _updateTotalCount() async {
    try {
      Query countQuery = _firestore.collection('products');
      
      if (selectedCategoryId.value.isNotEmpty) {
        countQuery = countQuery.where('categoryId', isEqualTo: selectedCategoryId.value);
      }
      
      if (searchQuery.value.isNotEmpty) {
        countQuery = countQuery
            .where('name', isGreaterThanOrEqualTo: searchQuery.value)
            .where('name', isLessThanOrEqualTo: '${searchQuery.value}\uf8ff');
      }
      
      final snapshot = await countQuery.get();
      totalProducts.value = snapshot.docs
          .where((doc) => (doc.data() as Map<String, dynamic>)['isAvailable'] == true && 
                         (doc.data() as Map<String, dynamic>)['isActive'] == true)
          .length;
    } catch (e) {
      print('Error getting total count: $e');
    }
  }

  void onSortChanged(String sortValue) {
    selectedSortBy.value = sortValue;
    loadProducts(refresh: true);
  }

  void onCategoryChanged(String categoryId) {
    print('onCategoryChanged called with categoryId: "$categoryId"');
    selectedCategoryId.value = categoryId;
    print('selectedCategoryId.value set to: "${selectedCategoryId.value}"');
    
    if (categoryId.isEmpty) {
      print('Clearing category filter - showing all products');
    } else {
      final category = categories.firstWhere((cat) => cat.id == categoryId, orElse: () => throw Exception('Category not found'));
      print('Filtering by category: ${category.name} (${categoryId})');
    }
    
    loadProducts(refresh: true);
  }

  void onSearchChanged(String query) {
    searchQuery.value = query;
    loadProducts(refresh: true);
  }

  void clearFilters() {
    selectedCategoryId.value = '';
    searchQuery.value = '';
    selectedSortBy.value = 'name';
    loadProducts(refresh: true);
  }

  void loadMoreProducts() {
    if (!hasMoreProducts.value || isLoading.value) return;
    loadProducts();
  }

  void refreshProducts() {
    loadProducts(refresh: true);
  }

  int get totalPages => (totalProducts.value / productsPerPage).ceil();
  
  String get resultsText {
    if (products.isEmpty) return 'No products found';
    
    final start = ((currentPage.value - 1) * productsPerPage) + 1;
    final end = (start + products.length - 1).clamp(start, totalProducts.value);
    
    return 'Showing $start-$end of ${totalProducts.value} products';
  }

  CategoryModel? get selectedCategory {
    if (selectedCategoryId.value.isEmpty) return null;
    try {
      return categories.firstWhere((cat) => cat.id == selectedCategoryId.value);
    } catch (e) {
      return null;
    }
  }
}
