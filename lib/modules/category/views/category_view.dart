import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/category_controller.dart';
import '../../../shared/models/product_model.dart';

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

        return Row(
          children: [
            // Sidebar Filters
            Container(
              width: 300,
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
      }),
    );
  }

  Widget _buildFilterSidebar() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
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
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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
          const Text(
            'Sort By',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
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
      padding: const EdgeInsets.all(20),
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
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
          )),
          const Spacer(),
          Obx(() {
            if (controller.selectedFilters.isEmpty) return const SizedBox();
            return Wrap(
              spacing: 8,
              children: controller.selectedFilters.map((filter) {
                return Chip(
                  label: Text(filter),
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

      return GridView.builder(
        padding: const EdgeInsets.all(20),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.8,
        ),
        itemCount: controller.categoryProducts.length,
        itemBuilder: (context, index) {
          final product = controller.categoryProducts[index];
          return _buildProductCard(product);
        },
      );
    });
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
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.name,
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      product.brand,
                      style: TextStyle(color: Colors.grey[600], fontSize: 12),
                    ),
                    const Spacer(),
                    Row(
                      children: [
                        if (product.originalPrice != null) ...[
                          Text(
                            '₹${product.originalPrice!.toStringAsFixed(0)}',
                            style: const TextStyle(
                              decoration: TextDecoration.lineThrough,
                              color: Colors.grey,
                              fontSize: 12,
                            ),
                          ),
                          const SizedBox(width: 5),
                        ],
                        Text(
                          '₹${product.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.orange,
                          ),
                        ),
                        if (product.discountPercentage > 0) ...[
                          const SizedBox(width: 5),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '${product.discountPercentage}% OFF',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
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
