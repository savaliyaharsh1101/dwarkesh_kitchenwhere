import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/products_controller.dart';
import '../../../shared/models/product_model.dart';
import '../../../shared/utils/responsive_utils.dart';

class ProductsView extends GetView<ProductsController> {
  const ProductsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        children: [
          // Header Section
          _buildHeader(),

          // Filters and Search Section
          // _buildFiltersSection(),

          // Main Content
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                );
              }

              return Column(
                children: [
                  // Results Header
                  _buildResultsHeader(),

                  // Products Grid
                  Expanded(
                    child: _buildProductsGrid(),
                  ),

                  // Pagination
                  _buildPagination(),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = ResponsiveUtils.isMobile(context);
        
        return Container(
          color: Colors.orange[700],
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 12 : 20, 
            horizontal: ResponsiveUtils.getResponsivePadding(context)
          ),
          child: isMobile
              ? Column(
                  children: [
                    Row(
                      children: [
                        // Back Button
                        IconButton(
                          onPressed: () => Get.back(),
                          icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
                        ),
                        const SizedBox(width: 8),
                        
                        // Logo
                        Expanded(
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Icon(
                                  Icons.kitchen,
                                  color: Colors.white,
                                  size: 18,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Flexible(
                                child: Text(
                                  'All Products',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    
                    // Category Info (if filtered) - Mobile
                    const SizedBox(height: 8),
                    Obx(() {
                      final category = controller.selectedCategory;
                      if (category != null) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Category: ${category.name}',
                            style: const TextStyle(color: Colors.white, fontSize: 12),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                )
              : Row(
                  children: [
                    // Back Button
                    IconButton(
                      onPressed: () => Get.back(),
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                    ),
                    const SizedBox(width: 16),

                    // Logo
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.kitchen,
                            color: Colors.white,
                            size: 24,
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'All Products',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),

                    const Spacer(),

                    // Category Info (if filtered) - Desktop
                    Obx(() {
                      final category = controller.selectedCategory;
                      if (category != null) {
                        return Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Category: ${category.name}',
                            style: const TextStyle(color: Colors.white, fontSize: 14),
                          ),
                        );
                      }
                      return const SizedBox.shrink();
                    }),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildFiltersSection() {
    return Container(
      color: Colors.grey[100],
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          // Search Bar
          Expanded(
            flex: 3,
            child: Container(
              height: 45,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: TextField(
                onChanged: (value) => controller.onSearchChanged(value),
                decoration: const InputDecoration(
                  hintText: 'Search products...',
                  prefixIcon: Icon(Icons.search, color: Colors.grey),
                  border: InputBorder.none,
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
            ),
          ),

          const SizedBox(width: 20),

          // Category Filter
          Expanded(
            flex: 2,
            child: Obx(() {
              print(
                  'Building dropdown - selectedCategoryId: "${controller.selectedCategoryId.value}"');
              print('Categories available: ${controller.categories.length}');

              return DropdownButtonFormField<String>(
                value: controller.selectedCategoryId.value.isEmpty
                    ? ''
                    : controller.selectedCategoryId.value,
                decoration: InputDecoration(
                  labelText: 'Category',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: '',
                    child: Text('All Categories'),
                  ),
                  ...controller.categories.map((category) {
                    print(
                        'Adding dropdown item: ${category.name} (${category.id})');
                    return DropdownMenuItem<String>(
                      value: category.id,
                      child: Text(category.name),
                    );
                  }),
                ],
                onChanged: (value) {
                  print('Dropdown selection changed to: "$value"');
                  controller.onCategoryChanged(value ?? '');
                },
              );
            }),
          ),

          const SizedBox(width: 20),

          // Sort Dropdown
          Expanded(
            flex: 2,
            child: Obx(() => DropdownButtonFormField<String>(
                  value: controller.selectedSortBy.value,
                  decoration: InputDecoration(
                    labelText: 'Sort by',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    contentPadding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  ),
                  items: controller.sortOptions
                      .map((option) => DropdownMenuItem<String>(
                            value: option['value']!,
                            child: Text(option['label']!),
                          ))
                      .toList(),
                  onChanged: (value) => controller.onSortChanged(value!),
                )),
          ),

          const SizedBox(width: 20),

          // Clear Filters Button
          ElevatedButton.icon(
            onPressed: controller.clearFilters,
            icon: const Icon(Icons.clear, size: 16),
            label: const Text('Clear'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey[600],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = ResponsiveUtils.isMobile(context);
        
        return Container(
          padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context)),
          child: isMobile
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Obx(() => Text(
                          controller.resultsText,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        )),
                    const SizedBox(height: 8),
                    // Refresh Button - Mobile
                    TextButton.icon(
                      onPressed: controller.refreshProducts,
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Refresh'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.orange[700],
                        padding: EdgeInsets.zero,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Obx(() => Text(
                          controller.resultsText,
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[800],
                          ),
                        )),

                    // Refresh Button - Desktop
                    TextButton.icon(
                      onPressed: controller.refreshProducts,
                      icon: const Icon(Icons.refresh, size: 16),
                      label: const Text('Refresh'),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.orange[700],
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildProductsGrid() {
    return Obx(() {
      if (controller.products.isEmpty) {
        return _buildEmptyState();
      }

      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels == scrollInfo.metrics.maxScrollExtent &&
              controller.hasMoreProducts.value &&
              !controller.isLoading.value) {
            controller.loadMoreProducts();
          }
          return false;
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount = ResponsiveUtils.getResponsiveGridCount(context,
              mobile: 2, tablet: 3, desktop: 5);
            final spacing = ResponsiveUtils.isMobile(context) ? 12.0 : 20.0;
            final aspectRatio = ResponsiveUtils.isMobile(context) ? 0.7 : 0.8;
            
            return GridView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getResponsivePadding(context)
              ),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: aspectRatio,
              ),
              itemCount: controller.products.length +
                  (controller.hasMoreProducts.value ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == controller.products.length) {
                  return _buildLoadingCard();
                }

                final product = controller.products[index];
                return _buildProductCard(product, context);
              },
            );
          },
        ),
      );
    });
  }

  Widget _buildProductCard(ProductModel product, BuildContext context) {
    // Null safety checks
    final originalPrice = product.originalPrice;
    final currentPrice = product.price;
    final hasDiscount = originalPrice != null && originalPrice > currentPrice;
    final discountPercent = hasDiscount
        ? ((originalPrice - currentPrice) / originalPrice * 100).round()
        : 0;
    final stockQuantity = product.stockQuantity;
    final brand = product.brand;
    final material = product.material;
    final imageUrl = product.imageUrl;

    return InkWell(
      onTap: () =>
          Get.toNamed('/product-detail', arguments: {'productId': product.id}),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image with badges
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: Colors.grey[100],
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                    ),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(12),
                        topRight: Radius.circular(12),
                      ),
                      child: imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: imageUrl,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: double.infinity,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                    color: Colors.orange[700], strokeWidth: 2),
                              ),
                              errorWidget: (context, url, error) => Center(
                                child: Icon(
                                  Icons.kitchen,
                                  size: 40,
                                  color: Colors.grey[400],
                                ),
                              ),
                            )
                          : Center(
                              child: Icon(
                                Icons.kitchen,
                                size: 40,
                                color: Colors.grey[400],
                              ),
                            ),
                    ),
                  ),

                  // Discount Badge
                  if (hasDiscount)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$discountPercent% OFF',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Stock Status Badge
                  if (stockQuantity <= 5 && stockQuantity > 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.orange,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          'Only $stockQuantity',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  else if (stockQuantity <= 0)
                    Positioned(
                      top: 8,
                      right: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: Colors.grey[600],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Text(
                          'Out of Stock',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),

                  // Heart/Favorite Icon
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.1),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Icon(
                        Icons.favorite_border,
                        size: 18,
                        color: Colors.grey[600],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Product Details
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Brand name
                  if (brand.isNotEmpty)
                    Text(
                      brand.toUpperCase(),
                      style: TextStyle(
                        fontSize: ResponsiveUtils.isMobile(context) ? 9 : 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[500],
                        letterSpacing: 0.5,
                      ),
                    ),

                  if (brand.isNotEmpty) const SizedBox(height: 4),

                  // Product name
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.isMobile(context) ? 12 : 13,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 6),

                  // Rating (placeholder for now)
                  Row(
                    children: [
                      Row(
                        children: List.generate(5, (index) {
                          return Icon(
                            index < 4 ? Icons.star : Icons.star_border,
                            size: 12,
                            color: Colors.amber[600],
                          );
                        }),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '(${product.rating.toStringAsFixed(1)})',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.isMobile(context) ? 9 : 10,
                          color: Colors.grey[500],
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),

                  // Price section
                  Row(
                    children: [
                      Text(
                        '₹${currentPrice.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: ResponsiveUtils.isMobile(context) ? 14 : 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: 8),
                        Text(
                          '₹${originalPrice!.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),

                  const SizedBox(height: 6),

                  // Material/Category info
                  if (material.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.blue.withOpacity(0.2)),
                      ),
                      child: Text(
                        material.toUpperCase(),
                        style: const TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoadingCard() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[100],
        borderRadius: BorderRadius.circular(12),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.orange),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No products found',
            style: TextStyle(
              fontSize: 20,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Try adjusting your search or filters',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: controller.clearFilters,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[700],
              foregroundColor: Colors.white,
            ),
            child: const Text('Clear Filters'),
          ),
        ],
      ),
    );
  }

  Widget _buildPagination() {
    return Obx(() {
      if (controller.products.isEmpty) return const SizedBox.shrink();

      return LayoutBuilder(
        builder: (context, constraints) {
          final isMobile = ResponsiveUtils.isMobile(context);
          
          return Container(
            padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(context)),
            child: isMobile
                ? Column(
                    children: [
                      Text(
                        'Page ${controller.currentPage.value}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 12),
                      if (controller.hasMoreProducts.value)
                        ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.loadMoreProducts,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Load More'),
                        )
                      else
                        Text(
                          'All products loaded',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Page ${controller.currentPage.value}',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(width: 20),
                      if (controller.hasMoreProducts.value)
                        ElevatedButton(
                          onPressed: controller.isLoading.value
                              ? null
                              : controller.loadMoreProducts,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.orange[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                          ),
                          child: controller.isLoading.value
                              ? const SizedBox(
                                  width: 16,
                                  height: 16,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text('Load More'),
                        )
                      else
                        Text(
                          'All products loaded',
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[500],
                            fontStyle: FontStyle.italic,
                          ),
                        ),
                    ],
                  ),
          );
        },
      );
    });
  }
}
