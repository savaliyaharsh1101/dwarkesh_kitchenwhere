import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // floatingActionButton: FloatingActionButton(
      //   onPressed: () => Get.toNamed('/admin/inquiries'),
      //   backgroundColor: Colors.orange[700],
      //   child: const Icon(Icons.admin_panel_settings, color: Colors.white),
      //   tooltip: 'Admin Panel',
      // ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(
            child: CircularProgressIndicator(
              color: Colors.orange,
            ),
          );
        }

        return RefreshIndicator(
          onRefresh: () async {
            await controller.loadHomeData();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              children: [
                // Top Contact Bar
                _buildTopContactBar(),

                // Header Section
                _buildHeader(),

                // Hero Banner
                _buildHeroBanner(),

                // Choose Category Section
                _buildChooseCategorySection(),

                // Featured Products Section
                _buildFeaturedProductsSection(),

                // Video Gallery Section
                // _buildVideoGallerySection(),

                // Contact Form Section
                _buildContactFormSection(),

                // Footer
                _buildFooter(),
              ],
            ),
          ),
        );
      }),
    );
  }

  Widget _buildTopContactBar() {
    return Container(
      color: Colors.orange[700],
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.phone, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            '+91 9909788802',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(width: 30),
          Icon(Icons.email, color: Colors.white, size: 16),
          const SizedBox(width: 8),
          Text(
            'yogiproduct@yahoo.in',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 40),
      child: Column(
        children: [
          // Logo and Cart Row
          Row(
            children: [
              // Logo
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.orange[100],
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      Icons.kitchen,
                      color: Colors.orange[700],
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Dwarkesh Enterprise',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[700],
                    ),
                  ),
                ],
              ),

              const Spacer(),

              // Find Location Button
              ElevatedButton.icon(
                onPressed: () {},
                icon: Icon(Icons.location_on, size: 16),
                label: Text('Find a Location'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange[700],
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Navigation Menu
          // Row(
          //   children: [
          //     _buildNavLink('Home', true),
          //     _buildNavLink('About Us', false),
          //     _buildNavLink('Products', false),
          //     _buildNavLink('Contact', false),

          //     const Spacer(),

          //     // Search Bar
          //     // Container(
          //     //   width: 300,
          //     //   height: 40,
          //     //   decoration: BoxDecoration(
          //     //     border: Border.all(color: Colors.grey[300]!),
          //     //     borderRadius: BorderRadius.circular(20),
          //     //   ),
          //     //   child: Row(
          //     //     children: [
          //     //       Expanded(
          //     //         child: TextField(
          //     //           decoration: InputDecoration(
          //     //             hintText: 'Search products...',
          //     //             border: InputBorder.none,
          //     //             contentPadding: EdgeInsets.symmetric(horizontal: 16),
          //     //           ),
          //     //         ),
          //     //       ),
          //     //       Container(
          //     //         width: 40,
          //     //         height: 40,
          //     //         decoration: BoxDecoration(
          //     //           color: Colors.orange[700],
          //     //           borderRadius: BorderRadius.circular(20),
          //     //         ),
          //     //         child: Icon(
          //     //           Icons.search,
          //     //           color: Colors.white,
          //     //           size: 20,
          //     //         ),
          //     //       ),
          //     //     ],
          //     //   ),
          //     // ),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget _buildNavLink(String title, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: TextButton(
        onPressed: () {},
        child: Text(
          title,
          style: TextStyle(
            fontSize: 16,
            color: isActive ? Colors.orange[700] : Colors.grey[700],
            fontWeight: isActive ? FontWeight.bold : FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(String title, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
          color: isActive ? Colors.orange[700] : Colors.grey[700],
        ),
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      height: 500,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.orange[400]!,
            Colors.deepOrange[600]!,
          ],
        ),
      ),
      child: Stack(
        children: [
          // Background pattern
          Positioned.fill(
            child: Opacity(
              opacity: 0.1,
              child: Image.network(
                'https://images.unsplash.com/photo-1556909114-f6e7ad7d3136?ixlib=rb-4.0.3',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(),
              ),
            ),
          ),

          // Content
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Welcome to Dwarkesh Enterprise',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  'Premium kitchen tools and accessories for every chef',
                  style: TextStyle(
                    fontSize: 20,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 32),
                ElevatedButton(
                  onPressed: () => Get.toNamed('/menu'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.orange[700],
                    padding: const EdgeInsets.symmetric(
                        horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                  ),
                  child: const Text(
                    'Shop Products',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoriesSection() {
    return Container(
      padding: const EdgeInsets.all(60),
      child: Column(
        children: [
          Text(
            'Product Categories',
            style: TextStyle(
              fontSize: 36,
              fontWeight: FontWeight.bold,
              color: Colors.grey[800],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Explore our diverse range of kitchen tools and accessories',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 40),

          // Categories Grid
          Obx(() {
            if (controller.categories.isEmpty) {
              return _buildEmptyCategories();
            }

            return GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                crossAxisSpacing: 20,
                mainAxisSpacing: 20,
                childAspectRatio: 1.2,
              ),
              itemCount: controller.categories.length,
              itemBuilder: (context, index) {
                final category = controller.categories[index];
                return _buildCategoryCard(category);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(dynamic category) {
    return GestureDetector(
      onTap: () => controller.selectCategory(category.id),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(15),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 8,
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Category Image
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: BorderRadius.circular(40),
                border: Border.all(
                  color: Colors.orange[200]!,
                  width: 2,
                ),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(38),
                child: category.imageUrl.isNotEmpty
                    ? Image.network(
                        category.imageUrl,
                        fit: BoxFit.cover,
                        loadingBuilder: (context, child, loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                              strokeWidth: 2,
                              color: Colors.orange[700],
                            ),
                          );
                        },
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(
                            Icons.kitchen,
                            size: 40,
                            color: Colors.orange[700],
                          );
                        },
                      )
                    : Icon(
                        Icons.kitchen,
                        size: 40,
                        color: Colors.orange[700],
                      ),
              ),
            ),
            const SizedBox(height: 16),
            Text(
              category.name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              category.description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCategories() {
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.kitchen,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No categories available',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Categories will appear here once added by admin',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromoBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 12),
      color: const Color(0xFF2D5A3D),
      child: Center(
        child: Text(
          'Get 5% off | Use code: makehomespecial',
          style: TextStyle(
            color: Colors.white,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildBreadcrumb() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 20),
      child: Row(
        children: [
          Text(
            'Home',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            ' ❯ ',
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
          Text(
            'Kitchen',
            style: TextStyle(
              color: Color(0xFF2D5A3D),
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Sidebar Filters
          _buildSidebar(),

          const SizedBox(width: 40),

          // Main Product Area
          Expanded(
            child: _buildProductGrid(),
          ),
        ],
      ),
    );
  }

  Widget _buildSidebar() {
    return Container(
      width: 250,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Category Filters
          _buildCategoryQuickLinks(),

          const SizedBox(height: 30),

          // Filter Section
          _buildFiltersSection(),
        ],
      ),
    );
  }

  Widget _buildCategoryQuickLinks() {
    final categories = [
      'KITCHEN RACKS',
      'BAKING DISHES',
      'JARS + CANISTERS',
      'KITCHEN TOOLS',
      'LUNCH BOXES',
      'LUNCH BAGS',
      'COOKWARE',
      'KIDS LUNCH BOXES',
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Kitchenware Utensils',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D5A3D),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Spruce up your kitchen decor for a clutter-free cooking space with our wide range of kitchen essentials.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
        const SizedBox(height: 20),

        // Category Grid
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
            childAspectRatio: 2.5,
          ),
          itemCount: categories.length,
          itemBuilder: (context, index) {
            return Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey[300]!),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  categories[index],
                  style: TextStyle(
                    fontSize: 11,
                    color: Color(0xFF2D5A3D),
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFiltersSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Filters',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Color(0xFF2D5A3D),
          ),
        ),
        const SizedBox(height: 15),

        // Type Filter
        _buildFilterGroup('Type', [
          'Airtight Jar (30)',
          'Cooking Pot (61)',
          'Lunch Box (46)',
          'Kitchen Tool (7)',
        ]),

        const SizedBox(height: 20),

        // Color Filter
        _buildFilterGroup('Colour', [
          'Black (72)',
          'White (84)',
          'Transparent (146)',
          'Silver (53)',
        ]),

        const SizedBox(height: 20),

        // Material Filter
        _buildFilterGroup('Materials', [
          'Glass (150)',
          'Metal (73)',
          'Ceramic (62)',
          'Wood (53)',
        ]),
      ],
    );
  }

  Widget _buildFilterGroup(String title, List<String> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Colors.grey[800],
          ),
        ),
        const SizedBox(height: 8),
        ...options
            .map<Widget>((option) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Row(
                    children: [
                      Checkbox(
                        value: false,
                        onChanged: (value) {},
                        activeColor: Color(0xFF2D5A3D),
                      ),
                      Expanded(
                        child: Text(
                          option,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey[700],
                          ),
                        ),
                      ),
                    ],
                  ),
                ))
            .toList(),
      ],
    );
  }

  Widget _buildProductGrid() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Results Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '291 Kitchen Results found',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey[800],
              ),
            ),

            // Sort Dropdown
            DropdownButton<String>(
              value: 'Featured',
              items: [
                'Featured',
                'Price: Low to High',
                'Price: High to Low',
                'Newest'
              ].map((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
              onChanged: (String? newValue) {},
            ),
          ],
        ),

        const SizedBox(height: 30),

        // Product Grid
        Obx(() {
          if (controller.featuredProducts.isEmpty) {
            return _buildSampleProducts();
          }

          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 4,
              crossAxisSpacing: 20,
              mainAxisSpacing: 30,
              childAspectRatio: 0.8,
            ),
            itemCount: controller.featuredProducts.length > 12
                ? 12
                : controller
                    .featuredProducts.length, // Show 4x3 = 12 products max
            itemBuilder: (context, index) {
              final product = controller.featuredProducts[index];
              return _buildProductCard(product);
            },
          );
        }),
      ],
    );
  }

  Widget _buildSampleProducts() {
    // Sample products inspired by Nestasia
    final sampleProducts = [
      {
        'name': 'Groovo Stackable Food Storage Containers Set Of 7',
        'price': 2495,
        'originalPrice': 2995,
        'discount': '17% Off',
        'image':
            'https://images.unsplash.com/photo-1584990347332-f6fa08c4e41e?w=300',
      },
      {
        'name': 'Embossed Glass Jar With Airtight Lid Set Of 4 750ml',
        'price': 790,
        'originalPrice': 1260,
        'discount': '37% Off',
        'image':
            'https://images.unsplash.com/photo-1556909114-4fb70e6f8e95?w=300',
      },
      {
        'name':
            'Winnie Blue Kitchen Jars With See Through Window Set Of 4 800ml',
        'price': 1150,
        'originalPrice': 1800,
        'discount': '36% Off',
        'image':
            'https://images.unsplash.com/photo-1584464491033-06628f3a6b7b?w=300',
      },
      {
        'name': 'Stainless Steel Mixing Bowls Set of 5',
        'price': 1299,
        'originalPrice': 1599,
        'discount': '19% Off',
        'image':
            'https://images.unsplash.com/photo-1556909114-bef3c4738c2e?w=300',
      },
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 20,
        mainAxisSpacing: 30,
        childAspectRatio: 0.75,
      ),
      itemCount: sampleProducts.length,
      itemBuilder: (context, index) {
        final product = sampleProducts[index];
        return _buildSampleProductCard(product);
      },
    );
  }

  Widget _buildSampleProductCard(Map<String, dynamic> product) {
    return Container(
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
            flex: 4,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey[50],
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
                child: CachedNetworkImage(
                  imageUrl: product['image'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF2D5A3D),
                    ),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Icon(
                      Icons.kitchen,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Product Details
          Container(
            height: 85,
            padding: const EdgeInsets.all(8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product['name'],
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[800],
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),

                // Price Section
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          '₹${product['price']}',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF2D5A3D),
                          ),
                        ),
                        const SizedBox(width: 6),
                        if (product['originalPrice'] != null)
                          Expanded(
                            child: Text(
                              '₹${product['originalPrice']}',
                              style: TextStyle(
                                fontSize: 10,
                                color: Colors.grey[500],
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ),
                      ],
                    ),
                    if (product['discount'] != null)
                      Text(
                        '${product['discount']}',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.red[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductCard(dynamic product) {
    return Container(
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
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(12),
                  topRight: Radius.circular(12),
                ),
              ),
              child: Center(
                child: Icon(
                  Icons.kitchen,
                  size: 50,
                  color: Colors.grey[400],
                ),
              ),
            ),
          ),

          // Product Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey[800],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    '₹ ${product.price.toStringAsFixed(0)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2D5A3D),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Banner Categories Section
  Widget _buildHeroBanner() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          // Section Title
          Text(
            'Featured Categories',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.orange[700],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'Explore our premium kitchen categories',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 40),

          // Banner Categories Row
          Obx(() {
            if (controller.categories.isEmpty) {
              return _buildBannerCategoriesPlaceholder();
            }

            // Get 3 random categories
            final randomCategories = controller.categories.take(3).toList();

            return Container(
              height: 300, // Fixed height for the row
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: randomCategories.map((category) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: _buildBannerCategoryCard(category),
                    );
                  }).toList(),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBannerCategoryCard(dynamic category) {
    return Container(
      width: 280,
      height: 300, // Fixed height to prevent sizing issues
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 3,
            blurRadius: 10,
          ),
        ],
      ),
      child: InkWell(
        onTap: () => controller.selectCategory(category.id),
        child: Column(
          children: [
            // Category Image
            Container(
              width: double.infinity,
              height: 180,
              decoration: BoxDecoration(
                color: Colors.orange[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                child: category.imageUrl.isNotEmpty
                    ? CachedNetworkImage(
                        imageUrl: category.imageUrl,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Center(
                          child: CircularProgressIndicator(
                              color: Colors.orange[700]),
                        ),
                        errorWidget: (context, url, error) => Center(
                          child: Icon(
                            Icons.kitchen,
                            size: 60,
                            color: Colors.grey[400],
                          ),
                        ),
                      )
                    : Center(
                        child: Icon(
                          Icons.kitchen,
                          size: 60,
                          color: Colors.orange[700],
                        ),
                      ),
              ),
            ),

            // Category Details
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      category.name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[800],
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Expanded(
                      child: Text(
                        category.description,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[600],
                        ),
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          'Explore',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: Colors.orange[700],
                          ),
                        ),
                        const SizedBox(width: 4),
                        Icon(
                          Icons.arrow_forward,
                          size: 16,
                          color: Colors.orange[700],
                        ),
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

  Widget _buildBannerCategoriesPlaceholder() {
    return Container(
      height: 300,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.category,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No categories available',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Categories will appear here once added by admin',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChooseCategorySection() {
    return Container(
      padding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Category',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.orange[700],
            ),
          ),
          const SizedBox(height: 30),

          // Categories from Firebase
          Obx(() {
            if (controller.categories.isEmpty) {
              return _buildEmptyCategories();
            }

            return Wrap(
              spacing: 15,
              runSpacing: 15,
              children: controller.categories.map((category) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.orange[50],
                    border: Border.all(color: Colors.orange[200]!),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: InkWell(
                    onTap: () => controller.selectCategory(category.id),
                    child: Text(
                      category.name.toUpperCase(),
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                        color: Colors.orange[700],
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildFeaturedProductsSection() {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Latest Products',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              ),
              // Row(
              //   children: [
              //     _buildProductFilter('All', true),
              //     _buildProductFilter('Bestseller', false),
              //     _buildProductFilter('New Product', false),
              //   ],
              // ),
            ],
          ),
          const SizedBox(height: 40),

          // Products Grid
          _buildLatestProductsGrid(),

          const SizedBox(height: 30),

          ElevatedButton(
            onPressed: () => Get.toNamed('/products'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange[700],
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: const Text('View All', style: TextStyle(fontSize: 16)),
          ),
        ],
      ),
    );
  }

  Widget _buildProductFilter(String title, bool isActive) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: TextButton(
        onPressed: () {},
        style: TextButton.styleFrom(
          backgroundColor: isActive ? Colors.orange[700] : Colors.transparent,
          foregroundColor: isActive ? Colors.white : Colors.grey[700],
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
            side: BorderSide(
              color: isActive ? Colors.orange[700]! : Colors.grey[300]!,
            ),
          ),
        ),
        child: Text(title),
      ),
    );
  }

  Widget _buildLatestProductsGrid() {
    return Obx(() {
      final products = controller.featuredProducts;

      if (products.isEmpty) {
        return _buildEmptyProducts();
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 4,
          crossAxisSpacing: 20,
          mainAxisSpacing: 20,
          childAspectRatio: 0.8,
        ),
        itemCount: products.length > 12
            ? 12
            : products.length, // Show 4x3 = 12 products max
        itemBuilder: (context, index) {
          final product = products[index];
          return _buildFirebaseProductCard(product);
        },
      );
    });
  }

  Widget _buildLatestProductCard(Map<String, dynamic> product) {
    return Container(
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
                child: CachedNetworkImage(
                  imageUrl: product['image'],
                  fit: BoxFit.cover,
                  width: double.infinity,
                  placeholder: (context, url) => Center(
                    child: CircularProgressIndicator(color: Colors.orange[700]),
                  ),
                  errorWidget: (context, url, error) => Center(
                    child: Icon(
                      Icons.kitchen,
                      size: 40,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Product Details
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product['name'],
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.grey[800],
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Text(
                    '₹ ${product['price']}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange[700],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildVideoGallerySection() {
  //   return Container(
  //     padding: const EdgeInsets.all(40),
  //     child: Column(
  //       children: [
  //         Text(
  //           'Video Gallery',
  //           style: TextStyle(
  //             fontSize: 32,
  //             fontWeight: FontWeight.bold,
  //             color: Colors.orange[700],
  //           ),
  //         ),
  //         const SizedBox(height: 30),
  //         Container(
  //           height: 300,
  //           decoration: BoxDecoration(
  //             color: Colors.grey[200],
  //             borderRadius: BorderRadius.circular(15),
  //           ),
  //           child: Center(
  //             child: Column(
  //               mainAxisAlignment: MainAxisAlignment.center,
  //               children: [
  //                 Icon(
  //                   Icons.play_circle_outline,
  //                   size: 80,
  //                   color: Colors.orange[700],
  //                 ),
  //                 const SizedBox(height: 16),
  //                 Text(
  //                   'Product Demonstration Videos',
  //                   style: TextStyle(
  //                     fontSize: 18,
  //                     fontWeight: FontWeight.w500,
  //                     color: Colors.grey[700],
  //                   ),
  //                 ),
  //               ],
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  Widget _buildContactFormSection() {
    return Container(
      color: Colors.grey[50],
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Text(
            'Contact with Us',
            style: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.orange[700],
            ),
          ),
          const SizedBox(height: 30),
          Row(
            children: [
              // Contact Form
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Inquiry',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: controller.inquiryNameController,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: controller.inquiryEmailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: controller.inquiryMobileController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: controller.inquiryMessageController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Message',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(() => ElevatedButton(
                            onPressed: controller.isSubmittingInquiry.value
                                ? null
                                : controller.submitInquiry,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Send Now'),
                          )),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 40),

              // Suggestion Form
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.1),
                        spreadRadius: 2,
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Suggestion',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey[800],
                        ),
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: controller.suggestionNameController,
                        decoration: InputDecoration(
                          labelText: 'Your Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: controller.suggestionEmailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: controller.suggestionMobileController,
                        keyboardType: TextInputType.phone,
                        decoration: InputDecoration(
                          labelText: 'Mobile Number',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: controller.suggestionProductNameController,
                        decoration: InputDecoration(
                          labelText: 'Product Name',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      TextField(
                        controller: controller.suggestionMessageController,
                        maxLines: 4,
                        decoration: InputDecoration(
                          labelText: 'Your Suggestion',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Obx(() => ElevatedButton(
                            onPressed: controller.isSubmittingSuggestion.value
                                ? null
                                : controller.submitSuggestion,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange[700],
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 30, vertical: 15),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Send Now'),
                          )),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: Colors.grey[800],
      padding: const EdgeInsets.all(40),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Company Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.kitchen,
                          color: Colors.orange[700],
                          size: 32,
                        ),
                        const SizedBox(width: 12),
                        Flexible(
                          child: Text(
                            'Dwarkesh Enterprise',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'CONTACT US',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      '+91 9909788802',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'yogiproduct@yahoo.in',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      'YOGI PRODUCTS,KHAMBHA\nSR NO.230, (OLD SR NO.97/1),PLOT NO.02,\nRAVKI MAKHAVAD ROAD,JAY SARDAR CHOWK,\nVILLAGE: KHAMBHA,TAL.LODHIKA,\nDIST : RAJKOT,PINCODE:360035',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Categories from Firebase
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Categories',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    // Dynamic categories from Firebase
                    Obx(() {
                      if (controller.categories.isEmpty) {
                        return Column(
                          children: [
                            _buildFooterLink('BASKET'),
                            _buildFooterLink('BOARD'),
                            _buildFooterLink('BOTTLE'),
                            _buildFooterLink('CHIPSER'),
                            _buildFooterLink('CHOPPER'),
                          ],
                        );
                      }

                      // Show first 5 categories from Firebase
                      final displayCategories =
                          controller.categories.take(5).toList();
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: displayCategories.map((category) {
                          return _buildFooterCategoryLink(
                            category.name.toUpperCase(),
                            category.id,
                          );
                        }).toList(),
                      );
                    }),
                  ],
                ),
              ),

              // Useful Links
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Useful Links',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    _buildFooterLink('About Us'),
                    _buildFooterLink('Contact Us'),
                    _buildFooterLink('Privacy & Policy'),
                    _buildFooterLink('Terms & Condition'),
                  ],
                ),
              ),

              // Contact Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Contact Info',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      '+91 9909788802',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 15),
                    Text(
                      'Mon - Sat 09 am - 08 pm',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 30),
          Divider(color: Colors.grey[600]),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '© All Rights Reserved by Dwarkesh Enterprise',
                style: TextStyle(
                  color: Colors.grey[400],
                ),
              ),
              Row(
                children: [
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Privacy & Policy',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                  Text(' | ', style: TextStyle(color: Colors.grey[400])),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      'Terms & Condition',
                      style: TextStyle(color: Colors.grey[400]),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFooterLink(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () {},
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
          ),
        ),
      ),
    );
  }

  Widget _buildFooterCategoryLink(String title, String categoryId) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: () => controller.selectCategory(categoryId),
        child: Text(
          title,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[400],
            decoration: TextDecoration.underline,
          ),
        ),
      ),
    );
  }

  Widget _buildFirebaseProductCard(dynamic product) {
    // Null safety checks
    final originalPrice = product.originalPrice;
    final currentPrice = product.price ?? 0.0;
    final hasDiscount = originalPrice != null && originalPrice > currentPrice;
    final discountPercent = hasDiscount
        ? ((originalPrice - currentPrice) / originalPrice * 100).round()
        : 0;
    final stockQuantity = product.stockQuantity ?? 0;
    final brand = product.brand ?? '';
    final material = product.material ?? '';
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
                  if (product.brand != null && product.brand.isNotEmpty)
                    Text(
                      product.brand.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: Colors.grey[500],
                        letterSpacing: 0.5,
                      ),
                    ),

                  if (product.brand != null && product.brand.isNotEmpty)
                    const SizedBox(height: 4),

                  // Product name
                  Text(
                    product.name,
                    style: TextStyle(
                      fontSize: 13,
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
                        '(4.0)',
                        style: TextStyle(
                          fontSize: 10,
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
                        '₹${product.price.toStringAsFixed(0)}',
                        style: TextStyle(
                          fontSize: 16,
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

                  const SizedBox(height: 6),

                  // Material/Category info
                  if (product.material != null && product.material.isNotEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: Colors.blue.withOpacity(0.2)),
                      ),
                      child: Text(
                        product.material.toUpperCase(),
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

  Widget _buildEmptyProducts() {
    return Container(
      height: 200,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.shopping_bag_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'No products available',
            style: TextStyle(
              fontSize: 18,
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Products will appear here once added by admin',
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }
}
