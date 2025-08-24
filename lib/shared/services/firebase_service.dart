import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

/// Shared Firebase Service for both Admin and User apps
/// This service manages all Firebase operations for the kitchen ware business
class FirebaseService extends GetxService {
  static FirebaseService get instance => Get.find<FirebaseService>();
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Collections - Shared between admin and user apps
  static const String CATEGORIES_COLLECTION = 'categories';
  static const String PRODUCTS_COLLECTION = 'products';
  static const String ORDERS_COLLECTION = 'orders';
  static const String USERS_COLLECTION = 'users';
  static const String ADMIN_USERS_COLLECTION = 'admin_users';

  // Getters for collections
  CollectionReference get categoriesCollection => 
      _firestore.collection(CATEGORIES_COLLECTION);
  
  CollectionReference get productsCollection => 
      _firestore.collection(PRODUCTS_COLLECTION);
  
  CollectionReference get ordersCollection => 
      _firestore.collection(ORDERS_COLLECTION);
  
  CollectionReference get usersCollection => 
      _firestore.collection(USERS_COLLECTION);
  
  CollectionReference get adminUsersCollection => 
      _firestore.collection(ADMIN_USERS_COLLECTION);

  // Auth getters
  FirebaseAuth get auth => _auth;
  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;
  
  // Firestore getter
  FirebaseFirestore get firestore => _firestore;

  @override
  void onInit() {
    super.onInit();
    print('🔥 Firebase Service initialized');
  }

  // ========== CATEGORY OPERATIONS ==========
  
  /// Get all categories (used by both admin and user apps)
  Stream<QuerySnapshot> getCategoriesStream() {
    return categoriesCollection
        .where('isActive', isEqualTo: true)
        .orderBy('order', descending: false)
        .snapshots();
  }

  /// Add new category (admin only)
  Future<DocumentReference> addCategory({
    required String name,
    required String description,
    String? imageUrl,
    int order = 0,
  }) async {
    return await categoriesCollection.add({
      'name': name,
      'description': description,
      'imageUrl': imageUrl ?? '',
      'order': order,
      'isActive': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update category (admin only)
  Future<void> updateCategory(String categoryId, Map<String, dynamic> data) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await categoriesCollection.doc(categoryId).update(data);
  }

  /// Delete category (admin only)
  Future<void> deleteCategory(String categoryId) async {
    await categoriesCollection.doc(categoryId).update({
      'isActive': false,
      'deletedAt': FieldValue.serverTimestamp(),
    });
  }

  // ========== PRODUCT OPERATIONS ==========
  
  /// Get all products (used by both admin and user apps)
  Stream<QuerySnapshot> getProductsStream() {
    return productsCollection
        .where('isActive', isEqualTo: true)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Get products by category (user app)
  Stream<QuerySnapshot> getProductsByCategoryStream(String categoryId) {
    return productsCollection
        .where('categoryId', isEqualTo: categoryId)
        .where('isActive', isEqualTo: true)
        .where('isAvailable', isEqualTo: true)
        .orderBy('order', descending: false)
        .snapshots();
  }

  /// Add new kitchen ware product (admin only)
  Future<DocumentReference> addProduct({
    required String name,
    required String description,
    required double price,
    required String categoryId,
    String? imageUrl,
    String? brand,
    String? material,
    String? dimensions,
    List<String>? features,
    int stockQuantity = 0,
    int order = 0,
  }) async {
    return await productsCollection.add({
      'name': name,
      'description': description,
      'price': price,
      'categoryId': categoryId,
      'imageUrl': imageUrl ?? '',
      'brand': brand ?? '',
      'material': material ?? '',
      'dimensions': dimensions ?? '',
      'features': features ?? [],
      'stockQuantity': stockQuantity,
      'order': order,
      'isActive': true,
      'isAvailable': true,
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Update product (admin only)
  Future<void> updateProduct(String productId, Map<String, dynamic> data) async {
    data['updatedAt'] = FieldValue.serverTimestamp();
    await productsCollection.doc(productId).update(data);
  }

  /// Delete product (admin only)
  Future<void> deleteProduct(String productId) async {
    await productsCollection.doc(productId).update({
      'isActive': false,
      'deletedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Toggle product availability (admin only)
  Future<void> toggleProductAvailability(String productId, bool isAvailable) async {
    await productsCollection.doc(productId).update({
      'isAvailable': isAvailable,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ========== ORDER OPERATIONS ==========

  /// Add new order (user app)
  Future<DocumentReference> addOrder({
    required String userId,
    required List<Map<String, dynamic>> items,
    required double totalAmount,
    String? specialInstructions,
  }) async {
    return await ordersCollection.add({
      'userId': userId,
      'items': items,
      'totalAmount': totalAmount,
      'specialInstructions': specialInstructions ?? '',
      'status': 'pending', // pending, confirmed, preparing, ready, delivered, cancelled
      'orderNumber': _generateOrderNumber(),
      'createdAt': FieldValue.serverTimestamp(),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  /// Get orders stream (admin app)
  Stream<QuerySnapshot> getOrdersStream() {
    return ordersCollection
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Get user orders stream (user app)
  Stream<QuerySnapshot> getUserOrdersStream(String userId) {
    return ordersCollection
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }

  /// Update order status (admin only)
  Future<void> updateOrderStatus(String orderId, String status) async {
    await ordersCollection.doc(orderId).update({
      'status': status,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ========== AUTHENTICATION ==========

  /// Sign in with email and password
  Future<UserCredential?> signInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('Sign in error: $e');
      rethrow;
    }
  }

  /// Create user with email and password
  Future<UserCredential?> createUserWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(email: email, password: password);
    } catch (e) {
      print('Create user error: $e');
      rethrow;
    }
  }

  /// Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  /// Check if user is admin
  Future<bool> isAdmin(String userId) async {
    try {
      final doc = await adminUsersCollection.doc(userId).get();
      return doc.exists;
    } catch (e) {
      print('Error checking admin status: $e');
      return false;
    }
  }

  // ========== HELPER METHODS ==========

  /// Generate unique order number
  String _generateOrderNumber() {
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    return 'ORD${timestamp.toString().substring(8)}';
  }

  /// Get server timestamp
  FieldValue get serverTimestamp => FieldValue.serverTimestamp();
}
