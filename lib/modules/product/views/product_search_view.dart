import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/product_search_controller.dart';
import '../../../shared/utils/responsive_utils.dart';

class ProductSearchView extends GetView<ProductSearchController> {
  const ProductSearchView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.orange[700],
        foregroundColor: Colors.white,
        elevation: 0,
        title: Text('Search Results'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: Column(
        children: [
          // Search bar at top
          _buildSearchBar(),
          
          // Results
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value) {
                return Center(
                  child: CircularProgressIndicator(
                    color: Colors.orange[700],
                  ),
                );
              }

              if (controller.searchQuery.value.isEmpty) {
                return _buildEmptyState(
                  icon: Icons.search,
                  message: 'Enter a search term to find products',
                );
              }

              if (controller.searchResults.isEmpty) {
                return _buildEmptyState(
                  icon: Icons.search_off,
                  message: 'No products found for "${controller.searchQuery.value}"',
                  subtitle: 'Try different keywords',
                );
              }

              return _buildSearchResults(controller.searchResults);
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    return Container(
      color: Colors.orange[700],
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: TextField(
        autofocus: false,
        onSubmitted: (value) => controller.performSearch(value),
        decoration: InputDecoration(
          hintText: 'Search products...',
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: BorderSide.none,
          ),
          prefixIcon: Icon(Icons.search, color: Colors.grey[600]),
          suffixIcon: Obx(() => controller.searchQuery.value.isNotEmpty
              ? IconButton(
                  icon: Icon(Icons.clear, color: Colors.grey[600]),
                  onPressed: () => controller.clearSearch(),
                )
              : SizedBox.shrink()),
          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        ),
      ),
    );
  }

  Widget _buildSearchResults(List<dynamic> results) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results count
        Padding(
          padding: const EdgeInsets.all(16),
          child: Text(
            '${results.length} product${results.length == 1 ? '' : 's'} found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey[700],
            ),
          ),
        ),

        // Products grid
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final crossAxisCount = ResponsiveUtils.getResponsiveGridCount(
                  context,
                  mobile: 2,
                  tablet: 3,
                  desktop: 4,
                );
                final spacing =
                    ResponsiveUtils.isMobile(context) ? 12.0 : 20.0;

                return GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    crossAxisSpacing: spacing,
                    mainAxisSpacing: spacing,
                    childAspectRatio:
                        ResponsiveUtils.isMobile(context) ? 0.7 : 0.8,
                  ),
                  itemCount: results.length,
                  itemBuilder: (context, index) {
                    final product = results[index];
                    return _buildProductCard(product);
                  },
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard(dynamic product) {
    final originalPrice = product.originalPrice;
    final currentPrice = product.price ?? 0.0;
    final hasDiscount = originalPrice != null && originalPrice > currentPrice;
    final discountPercent = hasDiscount
        ? ((originalPrice - currentPrice) / originalPrice * 100).round()
        : 0;
    final imageUrl = product.imageUrl ?? '';

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
            // Product Image
            Expanded(
              flex: 3,
              child: Container(
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
            ),

            // Product Details
            Container(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Product name
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize:
                          ResponsiveUtils.isMobile(Get.context!) ? 12 : 14,
                      fontWeight: FontWeight.w600,
                      color: Colors.grey[800],
                      height: 1.2,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),

                  const SizedBox(height: 8),

                  // Price section
                  Row(
                    children: [
                      Text(
                        '₹${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize:
                              ResponsiveUtils.isMobile(Get.context!) ? 14 : 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.orange[700],
                        ),
                      ),
                      if (hasDiscount) ...[
                        const SizedBox(width: 8),
                        Text(
                          '₹${product.originalPrice!.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[500],
                            decoration: TextDecoration.lineThrough,
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState({
    required IconData icon,
    required String message,
    String? subtitle,
  }) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 80,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 24),
            Text(
              message,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.grey[700],
              ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 8),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey[500],
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
