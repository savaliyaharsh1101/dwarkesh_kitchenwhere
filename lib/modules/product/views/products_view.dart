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
          _buildHeader(context),
          Expanded(
            child: Obx(() {
              if (controller.isLoading.value && controller.products.isEmpty) {
                return const Center(
                  child: CircularProgressIndicator(color: Colors.orange),
                );
              }
              return Column(
                children: [
                  _buildResultsHeader(context),
                  Expanded(child: _buildProductsGrid()),
                  _buildPagination(),
                ],
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final isMobile = ResponsiveUtils.isMobile(context);
    return LayoutBuilder(
      builder: (context, constraints) {
        return Container(
          color: Colors.orange[700],
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 12 : 20,
            horizontal: ResponsiveUtils.getResponsivePadding(context),
          ),
          child: isMobile
              ? _buildMobileHeader(context)
              : _buildDesktopHeader(context),
        );
      },
    );
  }

  Widget _buildMobileHeader(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            IconButton(
              onPressed: () => Get.back(),
              icon: const Icon(Icons.arrow_back, color: Colors.white, size: 20),
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.2),
                borderRadius: BorderRadius.circular(6),
              ),
              child: const Icon(Icons.kitchen, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 8),
            const Expanded(
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
        const SizedBox(height: 12),
        _buildSearchButton(context, isMobile: true),
        const SizedBox(height: 8),
        Obx(() {
          final cat = controller.selectedCategory;
          if (cat == null) return const SizedBox.shrink();
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Category: ${cat.name}',
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDesktopHeader(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: () => Get.back(),
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
        const SizedBox(width: 16),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.2),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.kitchen, color: Colors.white, size: 24),
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
        const SizedBox(width: 32),
        Expanded(child: _buildSearchButton(context, isMobile: false)),
        const SizedBox(width: 20),
        Obx(() {
          final cat = controller.selectedCategory;
          if (cat == null) return const SizedBox.shrink();
          return Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Category: ${cat.name}',
              style: const TextStyle(color: Colors.white, fontSize: 14),
            ),
          );
        }),
      ],
    );
  }

  Widget _buildSearchButton(BuildContext context, {required bool isMobile}) {
    return isMobile
        ? SizedBox(
            width: double.infinity,
            height: 40,
            child: ElevatedButton.icon(
              onPressed: () => _openSearchDialog(context),
              icon: const Icon(Icons.search, size: 18),
              label: const Text('Search'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.orange[700],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          )
        : ElevatedButton.icon(
            onPressed: () => _openSearchDialog(context),
            icon: const Icon(Icons.search),
            label: const Text('Search Products'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Colors.orange[700],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          );
  }

  void _openSearchDialog(BuildContext context) {
    final TextEditingController searchController = TextEditingController();
    showDialog(
      context: context,
      builder: (dialogContext) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  'Search Products',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: searchController,
                  autofocus: true,
                  onSubmitted: (value) {
                    Navigator.of(dialogContext).pop();
                    if (value.trim().isNotEmpty) {
                      Get.toNamed('/product-search',
                          arguments: {'query': value.trim()});
                    }
                  },
                  decoration: InputDecoration(
                    hintText: 'Enter product name, brand, color, etc.',
                    filled: true,
                    fillColor: Colors.grey[100],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Colors.grey[300]!, width: 1),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide:
                          BorderSide(color: Colors.orange[700]!, width: 2),
                    ),
                    prefixIcon:
                        Icon(Icons.search, color: Colors.grey[600]),
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(dialogContext).pop(),
                      child: const Text('Cancel'),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.of(dialogContext).pop();
                        final query = searchController.text.trim();
                        if (query.isNotEmpty) {
                          Get.toNamed('/product-search',
                              arguments: {'query': query});
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700],
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Search'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildResultsHeader(BuildContext context) {
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
  }

  Widget _buildProductsGrid() {
    return Obx(() {
      if (controller.products.isEmpty) {
        return _buildEmptyState();
      }
      return NotificationListener<ScrollNotification>(
        onNotification: (ScrollNotification scrollInfo) {
          if (scrollInfo.metrics.pixels ==
                  scrollInfo.metrics.maxScrollExtent &&
              controller.hasMoreProducts.value &&
              !controller.isLoading.value) {
            controller.loadMoreProducts();
          }
          return false;
        },
        child: LayoutBuilder(
          builder: (context, constraints) {
            final crossAxisCount =
                ResponsiveUtils.getResponsiveGridCount(
              context,
              mobile: 2,
              tablet: 3,
              desktop: 5,
            );
            final spacing =
                ResponsiveUtils.isMobile(context) ? 12.0 : 20.0;
            final aspectRatio =
                ResponsiveUtils.isMobile(context) ? 0.7 : 0.8;
            return GridView.builder(
              padding: EdgeInsets.symmetric(
                horizontal: ResponsiveUtils.getResponsivePadding(context),
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
                return _buildProductCard(controller.products[index], context);
              },
            );
          },
        ),
      );
    });
  }

  Widget _buildProductCard(ProductModel product, BuildContext context) {
    final hasDiscount = product.originalPrice != null &&
        product.originalPrice! > product.price;
    final discountPercent = hasDiscount
        ? (((product.originalPrice! - product.price) /
                product.originalPrice!) *
            100)
            .round()
        : 0;
    return InkWell(
      onTap: () => Get.toNamed('/product-detail',
          arguments: {'productId': product.id}),
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
                      child: product.imageUrl.isNotEmpty
                          ? CachedNetworkImage(
                              imageUrl: product.imageUrl,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                child: CircularProgressIndicator(
                                  color: Colors.orange[700],
                                  strokeWidth: 2,
                                ),
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
                  if (product.stockQuantity <= 5 && product.stockQuantity > 0)
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
                          'Only ${product.stockQuantity}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 9,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    )
                  else if (product.stockQuantity <= 0)
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
                  Positioned(
                    bottom: 8,
                    right: 8,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        shape: BoxShape.circle,
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
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    if (product.brand.isNotEmpty)
                      Flexible(
                        child: Text(
                        product.brand.toUpperCase(),
                        style: TextStyle(
                          fontSize:
                                ResponsiveUtils.isMobile(context) ? 9 : 10,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[500],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      ),
                    if (product.brand.isNotEmpty) const SizedBox(height: 4),
                    Flexible(
                      child: Text(
                        product.name,
                        style: TextStyle(
                          fontSize:
                              ResponsiveUtils.isMobile(context) ? 12 : 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[800],
                          height: 1.2,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Flexible(
                      child: Row(
                      children: [
                          Flexible(
                            child: Row(
                          children: List.generate(5, (i) {
                            return Icon(
                              i < 4 ? Icons.star : Icons.star_border,
                                  size: 12,
                              color: Colors.amber[600],
                            );
                          }),
                        ),
                          ),
                          const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            '(${product.rating.toStringAsFixed(1)})',
                            style: TextStyle(
                              fontSize:
                                  ResponsiveUtils.isMobile(context)
                                        ? 9
                                        : 10,
                              color: Colors.grey[500],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    ),
                    const SizedBox(height: 8),
                    Flexible(
                      child: Row(
                      children: [
                        Flexible(
                          child: Text(
                            '₹${product.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontSize:
                                  ResponsiveUtils.isMobile(context)
                                        ? 14
                                        : 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[700],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (hasDiscount) ...[
                            const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              '₹${product.originalPrice!.toStringAsFixed(0)}',
                              style: TextStyle(
                                  fontSize: 10,
                                color: Colors.grey[500],
                                decoration: TextDecoration.lineThrough,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ],
                    ),
                    ),
                    const SizedBox(height: 6),
                    if (product.material.isNotEmpty)
                      Flexible(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.blue.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                        product.material.toUpperCase(),
                        style: const TextStyle(
                              fontSize: 9,
                          fontWeight: FontWeight.w600,
                          color: Colors.blue,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                        ),
                      ),
                  ],
                ),
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
          Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
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
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
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
            padding: EdgeInsets.all(
                ResponsiveUtils.getResponsivePadding(context)),
            child: isMobile
                ? Column(
                    children: [
                      Text(
                        'Page ${controller.currentPage.value}',
                        style:
                            TextStyle(fontSize: 12, color: Colors.grey[600]),
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
                        style:
                            TextStyle(fontSize: 14, color: Colors.grey[600]),
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
