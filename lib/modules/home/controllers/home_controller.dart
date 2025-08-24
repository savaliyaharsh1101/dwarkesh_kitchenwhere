import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../shared/models/category_model.dart';
import '../../../shared/models/product_model.dart';
import '../../../shared/models/inquiry_model.dart';
import '../../../shared/models/suggestion_model.dart';

class HomeController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  
  // Observable variables
  final RxList<CategoryModel> categories = <CategoryModel>[].obs;
  final RxList<ProductModel> featuredProducts = <ProductModel>[].obs;
  final RxBool isLoading = false.obs;
  final RxString selectedCategoryId = ''.obs;

  // Form controllers for inquiry
  final TextEditingController inquiryNameController = TextEditingController();
  final TextEditingController inquiryEmailController = TextEditingController();
  final TextEditingController inquiryMobileController = TextEditingController();
  final TextEditingController inquiryMessageController = TextEditingController();

  // Form controllers for suggestion
  final TextEditingController suggestionNameController = TextEditingController();
  final TextEditingController suggestionEmailController = TextEditingController();
  final TextEditingController suggestionMobileController = TextEditingController();
  final TextEditingController suggestionProductNameController = TextEditingController();
  final TextEditingController suggestionMessageController = TextEditingController();

  // Loading states for forms
  final RxBool isSubmittingInquiry = false.obs;
  final RxBool isSubmittingSuggestion = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadHomeData();
  }

  Future<void> loadHomeData() async {
    isLoading.value = true;
    try {
      await Future.wait([
        loadCategories(),
        loadFeaturedProducts(),
      ]);
    } catch (e) {
      Get.snackbar('Error', 'Failed to load data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> loadCategories() async {
    try {
      final snapshot = await _firestore
          .collection('categories')
          .where('isActive', isEqualTo: true)
          .get();

      categories.value = snapshot.docs
          .map((doc) => CategoryModel.fromMap(doc.data(), doc.id))
          .toList();
      
      // Sort by name locally to avoid needing composite index
      categories.sort((a, b) => a.name.compareTo(b.name));
    } catch (e) {
      print('Error loading categories: $e');
    }
  }

  Future<void> loadFeaturedProducts() async {
    try {
      final snapshot = await _firestore
          .collection('products')
          .limit(20)
          .get();

      featuredProducts.value = snapshot.docs
          .map((doc) => ProductModel.fromMap(doc.data(), doc.id))
          .where((product) => product.isAvailable && product.isActive)
          .take(6)
          .toList();
    } catch (e) {
      print('Error loading featured products: $e');
    }
  }

  void selectCategory(String categoryId) {
    selectedCategoryId.value = categoryId;
    Get.toNamed('/menu', arguments: {'categoryId': categoryId});
  }

void refreshData() {
    loadHomeData();
  }

  Future<void> addCategory(CategoryModel category) async {
    try {
      await _firestore.collection('categories').add(category.toMap());
      print('Category added successfully');
      refreshData();
    } catch (e) {
      print('Error adding category: $e');
    }
  }

  Future<void> addProduct(ProductModel product) async {
    try {
      await _firestore.collection('products').add(product.toMap());
      print('Product added successfully');
      refreshData();
    } catch (e) {
      print('Error adding product: $e');
    }
  }

  Future<void> updateCategory(String categoryId, CategoryModel category) async {
    try {
      await _firestore.collection('categories').doc(categoryId).update(category.toMap());
      print('Category updated successfully');
      refreshData();
    } catch (e) {
      print('Error updating category: $e');
    }
  }

  Future<void> updateProduct(String productId, ProductModel product) async {
    try {
      await _firestore.collection('products').doc(productId).update(product.toMap());
      print('Product updated successfully');
      refreshData();
    } catch (e) {
      print('Error updating product: $e');
    }
  }

  Future<void> deleteCategory(String categoryId) async {
    try {
      await _firestore.collection('categories').doc(categoryId).delete();
      print('Category deleted successfully');
      refreshData();
    } catch (e) {
      print('Error deleting category: $e');
    }
  }

  Future<void> deleteProduct(String productId) async {
    try {
      await _firestore.collection('products').doc(productId).delete();
      print('Product deleted successfully');
      refreshData();
    } catch (e) {
      print('Error deleting product: $e');
    }
  }

  Future<CategoryModel?> getCategoryById(String categoryId) async {
    try {
      final doc = await _firestore.collection('categories').doc(categoryId).get();
      if (doc.exists) {
        return CategoryModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting category: $e');
      return null;
    }
  }

  Future<ProductModel?> getProductById(String productId) async {
    try {
      final doc = await _firestore.collection('products').doc(productId).get();
      if (doc.exists) {
        return ProductModel.fromMap(doc.data()!, doc.id);
      }
      return null;
    } catch (e) {
      print('Error getting product: $e');
      return null;
    }
  }

  // Submit inquiry form
  Future<void> submitInquiry() async {
    // Validate form fields
    if (inquiryNameController.text.trim().isEmpty ||
        inquiryEmailController.text.trim().isEmpty ||
        inquiryMobileController.text.trim().isEmpty ||
        inquiryMessageController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Basic email validation
    if (!GetUtils.isEmail(inquiryEmailController.text.trim())) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isSubmittingInquiry.value = true;
    try {
      final now = DateTime.now();
      final inquiry = InquiryModel(
        id: '', // Will be set by Firestore
        name: inquiryNameController.text.trim(),
        email: inquiryEmailController.text.trim(),
        mobile: inquiryMobileController.text.trim(),
        message: inquiryMessageController.text.trim(),
        createdAt: now,
        updatedAt: now,
        isRead: false,
      );

      await _firestore.collection('inquiries').add(inquiry.toMap());
      
      // Clear form
      _clearInquiryForm();
      
      Get.snackbar(
        'Success',
        'Your inquiry has been submitted successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit inquiry: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmittingInquiry.value = false;
    }
  }

  // Submit suggestion form
  Future<void> submitSuggestion() async {
    // Validate form fields
    if (suggestionNameController.text.trim().isEmpty ||
        suggestionEmailController.text.trim().isEmpty ||
        suggestionMobileController.text.trim().isEmpty ||
        suggestionProductNameController.text.trim().isEmpty ||
        suggestionMessageController.text.trim().isEmpty) {
      Get.snackbar(
        'Error',
        'Please fill in all fields',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    // Basic email validation
    if (!GetUtils.isEmail(suggestionEmailController.text.trim())) {
      Get.snackbar(
        'Error',
        'Please enter a valid email address',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isSubmittingSuggestion.value = true;
    try {
      final now = DateTime.now();
      final suggestion = SuggestionModel(
        id: '', // Will be set by Firestore
        productName: suggestionProductNameController.text.trim(),
        suggestion: suggestionMessageController.text.trim(),
        customerName: suggestionNameController.text.trim(),
        customerEmail: suggestionEmailController.text.trim(),
        customerMobile: suggestionMobileController.text.trim(),
        createdAt: now,
        updatedAt: now,
        isRead: false,
        priority: 'medium',
        status: 'pending',
      );

      await _firestore.collection('suggestions').add(suggestion.toMap());
      
      // Clear form
      _clearSuggestionForm();
      
      Get.snackbar(
        'Success',
        'Your suggestion has been submitted successfully!',
        backgroundColor: Colors.green,
        colorText: Colors.white,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to submit suggestion: $e',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isSubmittingSuggestion.value = false;
    }
  }

  // Clear inquiry form
  void _clearInquiryForm() {
    inquiryNameController.clear();
    inquiryEmailController.clear();
    inquiryMobileController.clear();
    inquiryMessageController.clear();
  }

  // Clear suggestion form
  void _clearSuggestionForm() {
    suggestionNameController.clear();
    suggestionEmailController.clear();
    suggestionMobileController.clear();
    suggestionProductNameController.clear();
    suggestionMessageController.clear();
  }

  @override
  void onClose() {
    // Dispose controllers
    inquiryNameController.dispose();
    inquiryEmailController.dispose();
    inquiryMobileController.dispose();
    inquiryMessageController.dispose();
    suggestionNameController.dispose();
    suggestionEmailController.dispose();
    suggestionMobileController.dispose();
    suggestionProductNameController.dispose();
    suggestionMessageController.dispose();
    super.onClose();
  }
}
