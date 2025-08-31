import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../controllers/home_controller.dart';
import '../../../shared/utils/responsive_utils.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
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
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = ResponsiveUtils.isMobile(context);
        
        return Container(
          color: Colors.orange[700],
          padding: EdgeInsets.symmetric(
            vertical: 8, 
            horizontal: ResponsiveUtils.getResponsivePadding(context)
          ),
          child: isMobile
              ? Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.phone, color: Colors.white, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          '+91 7202911169 / +91 9106856266',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.email, color: Colors.white, size: 14),
                        const SizedBox(width: 6),
                        Text(
                          'dwarkeshenterprise2408@gmail.com',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.phone, color: Colors.white, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      '+91 7202911169 / +91 9106856266',
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
                      'dwarkeshenterprise2408@gmail.com',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = ResponsiveUtils.isMobile(context);
        final isTablet = ResponsiveUtils.isTablet(context);
        
        return Container(
          color: Colors.white,
          padding: EdgeInsets.symmetric(
            vertical: isMobile ? 12 : 20, 
            horizontal: ResponsiveUtils.getResponsivePadding(context)
          ),
          child: Column(
            children: [
              // Logo and Cart Row
              isMobile ? 
                // Mobile: Stack logo and button vertically
                Column(
                  children: [
                    // Logo Row
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          padding: EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Icon(
                            Icons.kitchen,
                            color: Colors.orange[700],
                            size: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Dwarkesh Enterprise',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[700],
                            ),
                            textAlign: TextAlign.center,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    // Find Location Button
                    ElevatedButton.icon(
                      onPressed: () {},
                      icon: Icon(Icons.location_on, size: 14),
                      label: Text('Find Location', style: TextStyle(fontSize: 12)),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.orange[700],
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      ),
                    ),
                  ],
                ) 
                : 
                // Desktop/Tablet: Logo and button in row
                Row(
                  children: [
                    // Logo
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.all(isTablet ? 6 : 8),
                          decoration: BoxDecoration(
                            color: Colors.orange[100],
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Icon(
                            Icons.kitchen,
                            color: Colors.orange[700],
                            size: isTablet ? 24 : 28,
                          ),
                        ),
                        SizedBox(width: isTablet ? 8 : 12),
                        Flexible(
                          child: Text(
                            'Dwarkesh Enterprise',
                            style: TextStyle(
                              fontSize: isTablet ? 22 : 28,
                              fontWeight: FontWeight.bold,
                              color: Colors.orange[700],
                            ),
                            overflow: TextOverflow.ellipsis,
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
    
              SizedBox(height: isMobile ? 12 : 20),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeroBanner() {
    return ResponsiveUtils.responsiveContainer(
      mobilePadding: const EdgeInsets.all(16),
      tabletPadding: const EdgeInsets.all(30),
      desktopPadding: const EdgeInsets.all(40),
      child: Column(
        children: [
          // Section Title
          LayoutBuilder(
            builder: (context, constraints) {
              return Text(
                'Featured Categories',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                    mobile: 24, tablet: 28, desktop: 32),
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              );
            },
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
              height: 300,
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
      height: 300,
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
    return ResponsiveUtils.responsiveContainer(
      mobilePadding: const EdgeInsets.all(16),
      tabletPadding: const EdgeInsets.all(30),
      desktopPadding: const EdgeInsets.all(40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              return Text(
                'Choose Category',
                style: TextStyle(
                  fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                    mobile: 24, tablet: 28, desktop: 32),
                  fontWeight: FontWeight.bold,
                  color: Colors.orange[700],
                ),
              );
            },
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
      child: ResponsiveUtils.responsiveContainer(
        mobilePadding: const EdgeInsets.all(16),
        tabletPadding: const EdgeInsets.all(30),
        desktopPadding: const EdgeInsets.all(40),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                LayoutBuilder(
                  builder: (context, constraints) {
                    return Text(
                      'Latest Products',
                      style: TextStyle(
                        fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                          mobile: 24, tablet: 28, desktop: 32),
                        fontWeight: FontWeight.bold,
                        color: Colors.orange[700],
                      ),
                    );
                  },
                ),
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
      ),
    );
  }

  Widget _buildLatestProductsGrid() {
    return Obx(() {
      final products = controller.featuredProducts;

      if (products.isEmpty) {
        return _buildEmptyProducts();
      }

      return LayoutBuilder(
        builder: (context, constraints) {
          final crossAxisCount = ResponsiveUtils.getResponsiveGridCount(context,
            mobile: 2, tablet: 3, desktop: 4);
          final spacing = ResponsiveUtils.isMobile(context) ? 12.0 : 20.0;
          final maxItems = ResponsiveUtils.isMobile(context) ? 6 : 12;
          
          return GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: spacing,
              mainAxisSpacing: spacing,
              childAspectRatio: ResponsiveUtils.isMobile(context) ? 0.7 : 0.8,
            ),
            itemCount: products.length > maxItems ? maxItems : products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return _buildFirebaseProductCard(product);
            },
          );
        },
      );
    });
  }

  Widget _buildContactFormSection() {
    return Container(
      color: Colors.grey[50],
      child: ResponsiveUtils.responsiveContainer(
        mobilePadding: const EdgeInsets.all(16),
        tabletPadding: const EdgeInsets.all(30),
        desktopPadding: const EdgeInsets.all(40),
        child: Column(
          children: [
            LayoutBuilder(
              builder: (context, constraints) {
                return Text(
                  'Contact with Us',
                  style: TextStyle(
                    fontSize: ResponsiveUtils.getResponsiveFontSize(context,
                      mobile: 24, tablet: 28, desktop: 32),
                    fontWeight: FontWeight.bold,
                    color: Colors.orange[700],
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
            LayoutBuilder(
              builder: (context, constraints) {
                if (ResponsiveUtils.isMobile(context)) {
                  return Column(
                    children: [
                      // Mobile Inquiry Form
                      _buildInquiryForm(),
                      
                      const SizedBox(height: 20),

                      // Mobile Suggestion Form
                      _buildSuggestionForm(),
                    ],
                  );
                } else {
                  return Row(
                    children: [
                      // Desktop Inquiry Form
                      Expanded(child: _buildInquiryForm()),
                      const SizedBox(width: 40),
                      // Desktop Suggestion Form
                      Expanded(child: _buildSuggestionForm()),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInquiryForm() {
    return Container(
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
    );
  }

  Widget _buildSuggestionForm() {
    return Container(
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
                      '+91 7202911169',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '+91 9106856266',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Corporate Inquiry: +91 9409329714',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'dwarkeshenterprise2408@gmail.com',
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
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
                      '+91 7202911169',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      '+91 9106856266',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      'Corporate: +91 9409329714',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[400],
                        fontWeight: FontWeight.w600,
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
          Text(
            '© All Rights Reserved by Dwarkesh Enterprise',
            style: TextStyle(
              color: Colors.grey[400],
            ),
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
                      fontSize: ResponsiveUtils.isMobile(Get.context!) ? 12 : 14,
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
                          fontSize: ResponsiveUtils.isMobile(Get.context!) ? 14 : 16,
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
