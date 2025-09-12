# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

## Project Overview

**KichanWare User App** - A Flutter e-commerce application for Dwarkesh Enterprise's kitchen ware store. This is the customer-facing mobile app that allows users to browse products, view categories, submit inquiries, and interact with the kitchen ware catalog.

**Architecture**: Modular Flutter app using GetX for state management, Firebase for backend, and a component-based UI structure.

## Essential Commands

### Development
```bash
# Get dependencies
flutter pub get

# Run app in debug mode
flutter run

# Run on specific device
flutter run -d chrome    # Web
flutter run -d windows   # Windows desktop

# Build for production
flutter build apk --release                    # Android APK
flutter build web --release                    # Web build
flutter build windows --release                # Windows desktop

# Run tests
flutter test

# Analyze code quality
flutter analyze

# Format code
dart format .

# Clean project (when facing build issues)
flutter clean && flutter pub get
```

### Firebase Setup
```bash
# Install Firebase CLI tools
npm install -g firebase-tools

# Deploy web build to Firebase Hosting
flutter build web --release
firebase deploy --only hosting
```

## Project Architecture

### Core Structure
- **Modular Architecture**: Each feature is organized in separate modules with dedicated controllers, views, and bindings
- **GetX Pattern**: Used for state management, routing, and dependency injection
- **Firebase Backend**: Firestore for data, Firebase Auth for authentication, Firebase Hosting for web deployment
- **Shared Services**: Centralized Firebase operations and business logic

### Key Modules
1. **Home Module** (`lib/modules/home/`) - Main landing page with categories and featured products
2. **Category Module** (`lib/modules/category/`) - Product categories and navigation
3. **Product Module** (`lib/modules/product/`) - Product details, listings, and variants
4. **Admin Module** (`lib/modules/admin/`) - Admin inquiry management

### State Management (GetX)
- **Controllers**: Business logic and state management for each module
- **Bindings**: Dependency injection setup for each route
- **Observables**: Reactive state variables using `.obs`
- **Navigation**: Declarative routing with GetPages

### Firebase Integration
- **FirebaseService**: Centralized service in `lib/shared/services/firebase_service.dart`
- **Collections**: Categories, Products, Orders, Users, Admin Users, Inquiries, Suggestions
- **Real-time Updates**: Stream-based data loading for live updates
- **Authentication**: Email/password auth with admin role checking

## Data Models

### Enhanced Product System
- **Product Variants**: Modular color/size system (like RAM modules in computer analogy)
- **CategoryModel**: Hierarchical categories with sorting and icons
- **ProductModel**: Comprehensive product data with variants, pricing, inventory
- **InquiryModel** & **SuggestionModel**: Customer communication models

### Key Model Features
- **Product Variants**: Dynamic color options with separate pricing and inventory
- **Comprehensive Fields**: Pricing, dimensions, materials, features, occasions, care instructions
- **Backward Compatibility**: Existing products work without variants

## Development Patterns

### Adding New Features
1. Create module folder structure: `controllers/`, `views/`, `bindings/`
2. Implement GetX controller with reactive variables
3. Create binding class for dependency injection
4. Add route to `main.dart` GetPages
5. Update shared services if Firebase operations needed

### GetX Controller Pattern
```dart
class FeatureController extends GetxController {
  final RxBool isLoading = false.obs;
  final RxList<Model> items = <Model>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadData();
  }
  
  Future<void> loadData() async {
    isLoading.value = true;
    try {
      // Load data logic
    } catch (e) {
      Get.snackbar('Error', 'Failed to load: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
```

### Firebase Operations
- Use `FirebaseService.instance` for all Firebase operations
- Follow existing patterns for CRUD operations
- Handle errors with try-catch and user feedback via GetX snackbars
- Use streams for real-time data updates

## Product Variant System

### Modular Design Philosophy
Following the "RAM in computer" analogy from your rules:
- **Base Product**: Like the computer (core functionality)
- **Variants**: Like RAM modules (can be added/removed independently)
- **Hot-swappable**: Variants can be managed without affecting base product
- **Reusable**: Variant system can be applied to any product type

### Key Features
- **Color Variants**: Different colors with separate images, pricing, stock
- **Price Adjustments**: Per-variant pricing modifications
- **Stock Management**: Individual inventory tracking per variant
- **Admin Management**: Easy addition/removal through AdminVariantService

### Usage Examples
```dart
// Check if product has variants
if (product.hasVariants) {
  // Load variants from subcollection
  final variants = await loadProductVariants(product.id);
  product.variants = variants;
}

// Get variant-specific price
final price = product.getVariantPrice(selectedVariant);

// Check variant availability
final isAvailable = product.isVariantAvailable(selectedVariant);
```

## UI Development

### Responsive Design
- **ResponsiveUtils**: Utility class for screen size adaptations
- **Mobile-first**: Primary target is mobile with desktop support
- **Material 3**: Uses Material Design 3 components

### Theme Configuration
- **Color Scheme**: Orange seed color (`Colors.orange`)
- **Font**: Roboto family
- **Consistency**: Shared color palette and spacing throughout app

### Component Structure
- **Shared Widgets**: Reusable components in `lib/shared/widgets/`
- **LogoWidget**: Consistent branding across screens
- **Location Components**: Geolocation functionality

## Firebase Collections Structure

```
categories/
  {categoryId}/
    - name, description, imageUrl, iconUrl
    - sortOrder, parentCategoryId, productCount
    - isActive, createdAt, updatedAt

products/
  {productId}/
    - Basic info: name, description, price, images
    - Enhanced fields: originalPrice, discountPercentage, dimensions, weight, color
    - Categorization: style, occasions, additionalFeatures, tags
    - Inventory: stockQuantity, isAvailable, isActive
    - hasVariants flag
    
    variants/ (subcollection if hasVariants: true)
      {variantId}/
        - color, colorHex, imageUrl, images
        - stockQuantity, priceAdjustment, isAvailable
        - sku, displayOrder, createdAt, updatedAt

inquiries/
  {inquiryId}/
    - Customer: name, email, mobile
    - message, createdAt, isRead

suggestions/
  {suggestionId}/
    - Customer info and product suggestions
    - priority, status, isRead
```

## Testing Strategy

### Key Areas to Test
1. **Product Variant Selection**: Color changes update price, images, stock
2. **Form Submissions**: Inquiry and suggestion forms validation
3. **Firebase Integration**: Data loading, error handling
4. **Navigation**: GetX routing between modules
5. **Responsive Design**: Different screen sizes

### Test Commands
```bash
# Run all tests
flutter test

# Run specific test file
flutter test test/widget_test.dart

# Test with coverage
flutter test --coverage
```

## Common Issues & Solutions

### Build Issues
```bash
# Clear Flutter cache
flutter clean
flutter pub get

# Update dependencies
flutter pub upgrade

# Fix iOS build issues
cd ios && pod install && cd ..
```

### Firebase Issues
- **Security Rules**: Ensure Firestore rules allow variant subcollection access
- **Indexing**: Create composite indexes for complex queries
- **Network**: Handle offline scenarios gracefully

### GetX Issues
- **Memory Leaks**: Always dispose controllers and text controllers
- **State Updates**: Use `.obs` variables and `Obx()` widgets properly
- **Navigation**: Prefer named routes with GetPage definitions

## Environment Setup

### Prerequisites
- Flutter SDK 3.6.1+
- Dart 3.6.1+
- Firebase CLI
- Android Studio / VS Code with Flutter extensions

### Firebase Configuration
1. Set up Firebase project with Firestore and Authentication
2. Add `firebase_options.dart` with platform configurations
3. Configure Firebase Hosting for web deployment
4. Set up security rules for collections

## Performance Considerations

- **Lazy Loading**: Load product variants only when needed
- **Image Caching**: Use `cached_network_image` for product images
- **State Management**: Minimize unnecessary rebuilds with precise Obx() usage
- **Firebase Queries**: Use pagination for large product collections

## Future Enhancements

Based on existing documentation:
- **Size Variants**: Extend beyond colors to include sizes
- **Bundle Variants**: Combination product offers  
- **AI Recommendations**: Smart product suggestions
- **Advanced Search**: Filter by variant properties
- **Analytics**: Track variant popularity and user behavior

This architecture supports the modular philosophy where features can be "plugged in and out" like hardware modules, maintaining system stability while allowing for easy expansion and modification.