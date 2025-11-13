import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../../../shared/models/product_model.dart';
import '../../../shared/utils/responsive_utils.dart';

class CategoryView extends GetView<CategoryController> {
  const CategoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Obx(() => Text(controller.currentCategory.value?.name ?? 'Category')),
        backgroundColor: Colors.orange,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // TODO: Implement search
            },
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            if (ResponsiveUtils.isMobile(context)) {
              return Column(
                children: [
                  _buildMobileTopBar(),
                  Expanded(
                    child: Container(
                      width: double.infinity,
                      child: _buildProductGrid(),
                    ),
                  ),
                ],
              );
            } else {
              return Row(
                children: [
                  // Sidebar Filters
                  Container(
                    width: ResponsiveUtils.isTablet(context) ? 280 : 320,
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      border: Border(
                        right: BorderSide(color: Colors.grey[300]!),
                      ),
                    ),
                    child: _buildFilterSidebar(),
                  ),
                  // Main Content
                  Expanded(
                    child: Column(
                      children: [
                        _buildTopBar(),
                        Expanded(
                          child: _buildProductGrid(),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            }
          },
        );
      }),
    );
  }

  Widget _buildFilterSidebar() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(Get.context!)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Info
          Obx(() {
            final category = controller.currentCategory.value;
            if (category == null) return const SizedBox();
            
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (category.imageUrl.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      category.imageUrl,
                      height: 120,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          height: 120,
                          color: Colors.grey[300],
                          child: const Icon(Icons.image, size: 40),
                        );
                      },
                    ),
                  ),
                const SizedBox(height: 10),
                Text(
                  category.name,
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(Get.context!,
                      mobile: 16, tablet: 18, desktop: 20),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                if (category.description.isNotEmpty) ...[
                  const SizedBox(height: 5),
                  Text(
                    category.description,
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
                const SizedBox(height: 10),
                Obx(() => Text(
                  '${controller.categoryProducts.length} products',
                  style: TextStyle(color: Colors.grey[700], fontWeight: FontWeight.w500),
                )),
                const Divider(height: 30),
              ],
            );
          }),

          // Sort Options
          Text(
            'Sort By',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(Get.context!,
                mobile: 14, tablet: 16, desktop: 16),
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Obx(() => Column(
            children: controller.sortOptions.map((option) {
              String label = option;
              switch (option) {
                case 'price_low':
                  label = 'Price: Low to High';
                  break;
                case 'price_high':
                  label = 'Price: High to Low';
                  break;
                case 'newest':
                  label = 'Newest First';
                  break;
                case 'name':
                  label = 'Name A-Z';
                  break;
              }
              
              return RadioListTile<String>(
                title: Text(label),
                value: option,
                groupValue: controller.selectedSortOption.value,
                onChanged: (value) {
                  if (value != null) controller.updateSortOption(value);
                },
                dense: true,
              );
            }).toList(),
          )),
          const Divider(height: 30),

          // Style Filter
          Obx(() {
            if (controller.availableStyles.isEmpty) return const SizedBox();
            return _buildFilterSection('Style', controller.availableStyles);
          }),

          // Brand Filter
          Obx(() {
            if (controller.availableBrands.isEmpty) return const SizedBox();
            return _buildFilterSection('Brand', controller.availableBrands);
          }),

          // Occasions Filter
          Obx(() {
            if (controller.availableOccasions.isEmpty) return const SizedBox();
            return _buildFilterSection('Occasions', controller.availableOccasions);
          }),

          // Features Filter
          Obx(() {
            if (controller.availableFeatures.isEmpty) return const SizedBox();
            return _buildFilterSection('Features', controller.availableFeatures);
          }),

          // Clear Filters
          Obx(() {
            if (controller.selectedFilters.isEmpty) return const SizedBox();
            return Column(
              children: [
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: controller.clearFilters,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                    ),
                    child: const Text('Clear All Filters', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFilterSection(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: ResponsiveUtils.getResponsiveFontSize(Get.context!,
              mobile: 14, tablet: 16, desktop: 16),
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((option) {
            return Obx(() => FilterChip(
              label: Text(option),
              selected: controller.selectedFilters.contains(option),
              onSelected: (_) => controller.toggleFilter(option),
              selectedColor: Colors.orange.withOpacity(0.3),
            ));
          }).toList(),
        ),
        const Divider(height: 30),
      ],
    );
  }

  Widget _buildTopBar() {
    return Container(
      padding: EdgeInsets.all(ResponsiveUtils.getResponsivePadding(Get.context!)),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Row(
        children: [
          Obx(() => Text(
            '${controller.categoryProducts.length} Products',
            style: TextStyle(
              fontSize: ResponsiveUtils.getResponsiveFontSize(Get.context!,
                mobile: 14, tablet: 16, desktop: 16),
              fontWeight: FontWeight.w500,
            ),
          )),
          const Spacer(),
          Obx(() {
            if (controller.selectedFilters.isEmpty) return const SizedBox();
            return Wrap(
              spacing: 8,
              children: controller.selectedFilters.map((filter) {
                return Chip(
                  label: Text(filter, style: const TextStyle(fontSize: 12)),
                  onDeleted: () => controller.toggleFilter(filter),
                  deleteIcon: const Icon(Icons.close, size: 16),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildMobileTopBar() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(color: Colors.grey[300]!),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Obx(() => Text(
                '${controller.categoryProducts.length} Products',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              )),
              const Spacer(),
              IconButton(
                onPressed: _showMobileFilters,
                icon: const Icon(Icons.filter_list),
                tooltip: 'Filters',
              ),
              PopupMenuButton<String>(
                onSelected: (value) => controller.updateSortOption(value),
                itemBuilder: (context) {
                  return controller.sortOptions.map((option) {
                    String label = option;
                    switch (option) {
                      case 'price_low':
                        label = 'Price: Low to High';
                        break;
                      case 'price_high':
                        label = 'Price: High to Low';
                        break;
                      case 'newest':
                        label = 'Newest First';
                        break;
                      case 'name':
                        label = 'Name A-Z';
                        break;
                    }
                    return PopupMenuItem(
                      value: option,
                      child: Row(
                        children: [
                          Text(label),
                          const Spacer(),
                          if (controller.selectedSortOption.value == option)
                            const Icon(Icons.check, color: Colors.orange),
                        ],
                      ),
                    );
                  }).toList();
                },
                child: const Icon(Icons.sort),
              ),
            ],
          ),
          Obx(() {
            if (controller.selectedFilters.isEmpty) return const SizedBox();
            return Column(
              children: [
                const SizedBox(height: 12),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: controller.selectedFilters.map((filter) {
                      return Chip(
                        label: Text(filter, style: const TextStyle(fontSize: 11)),
                        onDeleted: () => controller.toggleFilter(filter),
                        deleteIcon: const Icon(Icons.close, size: 14),
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      );
                    }).toList(),
                  ),
                ),
              ],
            );
          }),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return Obx(() {
      if (controller.categoryProducts.isEmpty) {
        return const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2_outlined, size: 80, color: Colors.grey),
              SizedBox(height: 16),
              Text(
                'No products found',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
              SizedBox(height: 8),
              Text(
                'Try adjusting your filters',
                style: TextStyle(color: Colors.grey),
              ),
            ],
          ),
        );
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = ResponsiveUtils.getResponsiveGridCount(context,
            mobile: 2, tablet: 3, desktop: 4);
          final spacing = ResponsiveUtils.isMobile(context) ? 12.0 : 20.0;
          final padding = ResponsiveUtils.getResponsivePadding(context);

          return Padding(
            padding: EdgeInsets.all(padding),
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                crossAxisSpacing: spacing,
                mainAxisSpacing: spacing,
                childAspectRatio: ResponsiveUtils.isMobile(context) ? 0.7 : 0.8,
              ),
              itemCount: controller.categoryProducts.length,
              itemBuilder: (context, index) {
                final product = controller.categoryProducts[index];
                return _buildProductCard(product);
              },
            ),
          );
        },
      );
    });
  }

  void _showMobileFilters() {
    showModalBottomSheet(
      context: Get.context!,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.85,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          color: Colors.white,
        ),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(color: Colors.grey[300]!),
                ),
              ),
              child: Row(
                children: [
                  const Text(
                    'Filters',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            Expanded(
              child: _buildFilterSidebar(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductCard(ProductModel product) {
    return Card(
      elevation: 2,
      child: InkWell(
        onTap: () => controller.goToProductDetail(product),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image
            Expanded(
              flex: 3,
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                child: product.imageUrl.isNotEmpty
                    ? Image.network(
                        product.imageUrl,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.orange,
                              strokeWidth: 2,
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: double.infinity,
                            color: Colors.grey[300],
                            child: const Icon(Icons.kitchen, size: 50, color: Colors.grey),
                          );
                        },
                      )
                    : Container(
                        width: double.infinity,
                        color: Colors.grey[300],
                        child: const Icon(Icons.kitchen, size: 50, color: Colors.grey),
                      ),
              ),
            ),
            // Product Info
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: Text(
                        product.name,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: ResponsiveUtils.isMobile(Get.context!) ? 11 : 12,
                          height: 1.1,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.brand,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: ResponsiveUtils.isMobile(Get.context!) ? 9 : 10,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        if (product.originalPrice != null) ...[
                          Flexible(
                            child: Text(
                              '₹${product.originalPrice!.toStringAsFixed(0)}',
                              style: const TextStyle(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 3),
                        ],
                        Flexible(
                          child: Text(
                            '₹${product.price.toStringAsFixed(0)}',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                              fontSize: ResponsiveUtils.isMobile(Get.context!) ? 11 : 12,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        if (product.discountPercentage > 0) ...[
                          const SizedBox(width: 3),
                          Text(
                            '${product.discountPercentage}% OFF',
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 8,
                              fontWeight: FontWeight.bold,
                            ),
                            maxLines: 1,
                          ),
                        ],
                      ],
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
}
