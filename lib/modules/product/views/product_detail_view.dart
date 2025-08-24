import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/product_controller.dart';

class ProductDetailView extends GetView<ProductController> {
  const ProductDetailView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Product Details',
            style:
                TextStyle(color: Colors.black87, fontWeight: FontWeight.w600)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black87),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite_border),
            onPressed: () {},
          ),
          IconButton(
            icon: const Icon(Icons.share),
            onPressed: () {},
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
              child: CircularProgressIndicator(color: Colors.orange));
        }

        final product = controller.currentProduct.value;
        if (product == null) {
          return const Center(child: Text('Product not found!'));
        }

        return LayoutBuilder(
          builder: (context, constraints) {
            // Check if we have enough width for side-by-side layout
            if (constraints.maxWidth > 800) {
              // Desktop/Tablet layout - side by side
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left side - Product Images
                  Expanded(
                    flex: 1,
                    child: _buildProductImageSection(product),
                  ),
                  // Right side - Product Info
                  Expanded(
                    flex: 1,
                    child: _buildProductInfoSection(product),
                  ),
                ],
              );
            } else {
              // Mobile layout - stacked vertically
              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Product Images
                    _buildProductImageSection(product),
                    // Product Info
                    _buildProductInfoSection(product),
                  ],
                ),
              );
            }
          },
        );
      }),
    );
  }

  Widget _buildProductImageSection(product) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Main Product Image
          Container(
            width: double.infinity,
            height: 400, // Fixed height for consistent sizing
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.2),
                  spreadRadius: 2,
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
              color: Colors.grey[50], // Background color for loading
            ),
            child: Obx(() {
              final images = controller.getCurrentImages();
              return PageView.builder(
                onPageChanged: controller.changeSelectedImage,
                itemCount: images.isNotEmpty ? images.length : 1,
                itemBuilder: (context, index) {
                  final images = controller.getCurrentImages();
                  final imageUrl = images.isNotEmpty ? images[index] : '';
                  return ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: imageUrl.isNotEmpty
                        ? Image.network(
                            imageUrl,
                            fit: BoxFit.contain, // Changed to contain for proper sizing
                            width: double.infinity,
                            height: double.infinity,
                            loadingBuilder: (context, child, loadingProgress) {
                              if (loadingProgress == null) return child;
                              return Container(
                                color: Colors.grey[50],
                                child: Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes != null
                                        ? loadingProgress.cumulativeBytesLoaded /
                                            (loadingProgress.expectedTotalBytes ?? 1)
                                        : null,
                                    color: Colors.orange,
                                  ),
                                ),
                              );
                            },
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: Colors.grey[100],
                                child: const Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.broken_image, size: 60, color: Colors.grey),
                                      SizedBox(height: 8),
                                      Text(
                                        'Image not available',
                                        style: TextStyle(color: Colors.grey, fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        : Container(
                            color: Colors.grey[100],
                            child: const Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.image, size: 60, color: Colors.grey),
                                  SizedBox(height: 8),
                                  Text(
                                    'No image available',
                                    style: TextStyle(color: Colors.grey, fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                          ),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 16),
          
          // Image Page Indicators
          Obx(() {
            final images = controller.getCurrentImages();
            if (images.length <= 1) return const SizedBox();
            
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(images.length, (index) {
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 4),
                  width: controller.selectedImageIndex.value == index ? 12 : 8,
                  height: controller.selectedImageIndex.value == index ? 12 : 8,
                  decoration: BoxDecoration(
                    color: controller.selectedImageIndex.value == index 
                        ? Colors.orange 
                        : Colors.grey[400],
                    shape: BoxShape.circle,
                  ),
                );
              }),
            );
          }),
          
          const SizedBox(height: 16),
          
          // Color Selection Below Image
          Obx(() => _buildImageColorSelection(product)),
        ],
      ),
    );
  }

  Widget _buildProductInfoSection(product) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            // Breadcrumb
            _buildBreadcrumb(),
            const SizedBox(height: 16),

            // Product Title
            Text(
              product.name,
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),

            // Brand
            Text(
              'by ${product.brand}',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey[600],
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 16),

            // Price Section
            Obx(() => _buildPriceSection(product)),
            const SizedBox(height: 24),
            
            // Color Variants Section
            Obx(() => _buildColorVariantsSection(product)),

            // Stock Status
            Obx(() => _buildStockStatus(product)),
            const SizedBox(height: 24),

            // Description
            Text(
              'Description',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              product.description,
              style: const TextStyle(
                fontSize: 16,
                height: 1.6,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 24),

            // Key Features
            if (product.features.isNotEmpty) _buildKeyFeatures(product),
            const SizedBox(height: 24),

            // Product Details
            _buildProductDetails(product),
            const SizedBox(height: 32),

            // Action Buttons
            _buildActionButtons(),
          ],
        ),
      ),
    );
  }

  Widget _buildBreadcrumb() {
    return Obx(() {
      final category = controller.productCategory.value;
      return Wrap(
        children: [
          InkWell(
            onTap: () => Get.toNamed('/home'),
            child: Text(
              'Home',
              style: TextStyle(color: Colors.grey[600], fontSize: 14),
            ),
          ),
          Text(' / ', style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          if (category != null) ...[
            InkWell(
              onTap: controller.goToCategory,
              child: Text(
                category.name,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ),
            Text(' / ',
                style: TextStyle(color: Colors.grey[600], fontSize: 14)),
          ],
          Text(
            'Product Details',
            style: const TextStyle(
                color: Colors.orange,
                fontSize: 14,
                fontWeight: FontWeight.w500),
          ),
        ],
      );
    });
  }

  Widget _buildColorVariantsSection(product) {
    // Check if product has variants and controller has loaded variants
    if (!product.hasVariants || controller.productVariants.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // Check if variants are still loading
    if (controller.variantsLoading.value) {
      return Container(
        padding: const EdgeInsets.all(16),
        child: const Center(
          child: CircularProgressIndicator(color: Colors.orange),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Available Colors',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(width: 8),
            if (controller.selectedVariant.value != null)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.orange.withOpacity(0.3)),
                ),
                child: Text(
                  controller.selectedVariant.value!.color,
                  style: const TextStyle(
                    color: Colors.orange,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 12),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: controller.productVariants.map((variant) {
              final isSelected = controller.selectedVariant.value?.id == variant.id;
              final isAvailable = variant.isAvailable && variant.stockQuantity > 0;
              
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: GestureDetector(
                  onTap: isAvailable ? () => controller.selectVariant(variant) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected 
                            ? Colors.orange 
                            : (isAvailable ? Colors.grey[300]! : Colors.grey[200]!),
                        width: isSelected ? 3 : 2,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ] : null,
                    ),
                    child: Column(
                      children: [
                        // Color circle/preview image
                        Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: Colors.grey[200],
                          ),
                          child: variant.imageUrl.isNotEmpty
                              ? ClipRRect(
                                  borderRadius: BorderRadius.circular(8),
                                  child: Image.network(
                                    variant.imageUrl,
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(8),
                                          color: _parseColor(variant.colorHex),
                                        ),
                                        child: const Icon(
                                          Icons.palette,
                                          color: Colors.white,
                                          size: 24,
                                        ),
                                      );
                                    },
                                  ),
                                )
                              : Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(8),
                                    color: _parseColor(variant.colorHex),
                                  ),
                                  child: const Icon(
                                    Icons.palette,
                                    color: Colors.white,
                                    size: 24,
                                  ),
                                ),
                        ),
                        const SizedBox(height: 6),
                        // Color name
                        SizedBox(
                          width: 60,
                          child: Text(
                            variant.color,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: isAvailable 
                                  ? (isSelected ? Colors.orange : Colors.black87)
                                  : Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        // Stock indicator
                        if (!isAvailable)
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Out',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          )
                        else if (variant.stockQuantity <= 5)
                          Container(
                            margin: const EdgeInsets.only(top: 2),
                            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${variant.stockQuantity}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 8,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }
  
  Widget _buildImageColorSelection(product) {
    // Check if product has variants and controller has loaded variants
    if (!product.hasVariants || controller.productVariants.isEmpty) {
      return const SizedBox.shrink();
    }
    
    // Check if variants are still loading
    if (controller.variantsLoading.value) {
      return const SizedBox(
        height: 60,
        child: Center(
          child: CircularProgressIndicator(color: Colors.orange, strokeWidth: 2),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Colors Available',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        const SizedBox(height: 12),
        
        // Color options row
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: controller.productVariants.map((variant) {
              final isSelected = controller.selectedVariant.value?.id == variant.id;
              final isAvailable = variant.isAvailable && variant.stockQuantity > 0;
              
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: GestureDetector(
                  onTap: isAvailable ? () => controller.selectVariant(variant) : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: isSelected 
                            ? Colors.orange 
                            : (isAvailable ? Colors.grey[300]! : Colors.grey[200]!),
                        width: isSelected ? 3 : 2,
                      ),
                      boxShadow: isSelected ? [
                        BoxShadow(
                          color: Colors.orange.withOpacity(0.3),
                          spreadRadius: 1,
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ] : null,
                    ),
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _parseColor(variant.colorHex),
                      ),
                      child: !isAvailable
                          ? Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: Colors.black.withOpacity(0.3),
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            )
                          : null,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
        
        const SizedBox(height: 8),
        
        // Show selected color name
        if (controller.selectedVariant.value != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Text(
              controller.selectedVariant.value!.color,
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
      ],
    );
  }
  
  Color _parseColor(String colorHex) {
    try {
      return Color(int.parse(colorHex.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }

  Widget _buildPriceSection(product) {
    // Use current price from controller which considers selected variant
    final currentPrice = controller.getCurrentPrice();
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.orange.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.orange.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          // Current Price
          Text(
            '₹${currentPrice.toStringAsFixed(0)}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.orange,
            ),
          ),
          const SizedBox(width: 12),
          // Original Price & Discount
          if (product.originalPrice != null) ...[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₹${product.originalPrice!.toStringAsFixed(0)}',
                  style: const TextStyle(
                    fontSize: 18,
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                  ),
                ),
                if (product.discountPercentage > 0)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '${product.discountPercentage}% OFF',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildStockStatus(product) {
    final isAvailable = controller.isCurrentVariantAvailable();
    final currentStock = controller.getCurrentStock();
    
    return Row(
      children: [
        Icon(
          isAvailable ? Icons.check_circle : Icons.cancel,
          color: isAvailable ? Colors.green : Colors.red,
          size: 20,
        ),
        const SizedBox(width: 8),
        Text(
          isAvailable ? 'In Stock' : 'Out of Stock',
          style: TextStyle(
            color: isAvailable ? Colors.green : Colors.red,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        if (currentStock > 0) ...[
          const SizedBox(width: 16),
          Text(
            '$currentStock units available',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
        ],
        // Show variant-specific stock info if applicable
        if (controller.selectedVariant.value != null && currentStock <= 5 && currentStock > 0) ...[
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Text(
              'Limited Stock',
              style: const TextStyle(
                color: Colors.orange,
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildKeyFeatures(product) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Key Features',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.black87,
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: product.features.map<Widget>((feature) {
            return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Colors.blue.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.blue.withOpacity(0.3)),
              ),
              child: Text(
                feature,
                style: const TextStyle(
                  color: Colors.black87,
                  fontSize: 14,
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildProductDetails(product) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Product Details',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Brand', product.brand),
          _buildDetailRow('Material', product.material),
          if (product.dimensions != null)
            _buildDetailRow('Dimensions', product.dimensions!),
          if (product.weight != null)
            _buildDetailRow('Weight', product.weight!),
          if (product.color != null) _buildDetailRow('Color', product.color!),
          if (product.sku != null) _buildDetailRow('SKU', product.sku!),
          if (product.style != null) _buildDetailRow('Style', product.style!),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: TextStyle(
                color: Colors.grey[700],
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        // // Add to Cart Button
        // SizedBox(
        //   width: double.infinity,
        //   height: 50,
        //   child: ElevatedButton(
        //     onPressed: controller.addToCart,
        //     style: ElevatedButton.styleFrom(
        //       backgroundColor: Colors.orange,
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //     ),
        //     child: const Text(
        //       'Add to Cart',
        //       style: TextStyle(
        //         fontSize: 18,
        //         fontWeight: FontWeight.w600,
        //         color: Colors.white,
        //       ),
        //     ),
        //   ),
        // ),
        // const SizedBox(height: 12),
        // // Buy Now Button
        // SizedBox(
        //   width: double.infinity,
        //   height: 50,
        //   child: OutlinedButton(
        //     onPressed: () {
        //       // TODO: Implement buy now
        //     },
        //     style: OutlinedButton.styleFrom(
        //       side: const BorderSide(color: Colors.orange, width: 2),
        //       shape: RoundedRectangleBorder(
        //         borderRadius: BorderRadius.circular(8),
        //       ),
        //     ),
        //     child: const Text(
        //       'Buy Now',
        //       style: TextStyle(
        //         fontSize: 18,
        //         fontWeight: FontWeight.w600,
        //         color: Colors.orange,
        //       ),
        //     ),
        //   ),
        // ),

        const SizedBox(height: 16),
        // View Category Button
        TextButton(
          onPressed: controller.goToCategory,
          child: const Text(
            'View More Products in This Category',
            style: TextStyle(
              color: Colors.orange,
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }
}
