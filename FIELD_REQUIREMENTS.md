# FIELD REQUIREMENTS FOR KICHANWARE APP

Based on analysis of Nestasia kitchen collection (https://nestasia.in/collections/kitchen), here are the comprehensive field requirements for both Category and Product models.

## CATEGORY MODEL FIELDS

### Current Fields:
- `id` (String) - Unique identifier
- `name` (String) - Category name
- `description` (String) - Category description  
- `imageUrl` (String) - Main category image
- `isActive` (bool) - Whether category is active
- `createdAt` (DateTime) - Creation timestamp
- `updatedAt` (DateTime) - Last update timestamp

### New Fields Added:
- `iconUrl` (String?) - Small icon for category (optional)
- `sortOrder` (int) - Order for displaying categories (default: 0)
- `parentCategoryId` (String?) - For subcategories (optional)
- `productCount` (int) - Number of products in category (default: 0)

### Usage in UI:
- **User App**: Display categories with icons, sort by sortOrder, show product counts
- **Admin App**: Form fields for all category details, subcategory selection

---

## PRODUCT MODEL FIELDS

### Current Fields:
- `id` (String) - Unique identifier
- `name` (String) - Product name
- `description` (String) - Product description
- `price` (double) - Current selling price
- `imageUrl` (String) - Main product image
- `categoryId` (String) - Associated category
- `isAvailable` (bool) - Product availability
- `isInStock` (bool) - Stock status
- `isOnSale` (bool) - Sale status
- `features` (List<String>) - Product features
- `brand` (String) - Brand name
- `material` (String) - Product material
- `createdAt` (DateTime) - Creation timestamp
- `updatedAt` (DateTime) - Last update timestamp

### New Fields Added:

#### Pricing & Discounts:
- `originalPrice` (double?) - Original price before discount (optional)
- `discountPercentage` (int) - Discount percentage (default: 0)

#### Images:
- `images` (List<String>) - Multiple product images (default: [])

#### Product Details:
- `dimensions` (String?) - Product size/dimensions (optional)
- `weight` (String?) - Product weight (optional)
- `color` (String?) - Product color (optional)
- `sku` (String?) - Stock Keeping Unit/Product code (optional)

#### Categorization & Filtering:
- `style` (String?) - Style type (Contemporary, Modern, Minimalist, etc.) (optional)
- `occasions` (List<String>) - Suitable occasions (Anniversary, Birthday, Wedding, etc.) (default: [])
- `additionalFeatures` (List<String>) - Extra features (Airtight, With Handle, With Lid, etc.) (default: [])
- `tags` (List<String>) - Search tags (default: [])

#### Inventory:
- `stockQuantity` (int) - Available stock count (default: 0)

#### Reviews & Ratings:
- `rating` (double) - Average rating (default: 0.0)
- `reviewCount` (int) - Number of reviews (default: 0)

#### Care Instructions:
- `careInstructions` (String?) - Product care guidelines (optional)

### Usage in UI:
- **User App**: Display products with images, pricing, ratings, filters by style/occasions/features
- **Admin App**: Comprehensive form with all product details, image upload, inventory management

---

## FIELD MAPPING FROM NESTASIA

### Categories from Nestasia:
- **Type**: Airtight Jar, Apron, Baking Dish, Butter Dish, Cooking Pot, etc.
- **Material**: Ceramic, Glass, Stainless Steel, Wood, Marble, etc.
- **Style**: Contemporary, Modern, Minimalist, Rustic, Scandinavian, Traditional, Vintage
- **Feature**: Airtight, Pattern, Plain Colour, Set, Texture, With Handle, With Lid, With Spoon, With Stand

### Product Attributes from Nestasia:
- **Occasions**: Anniversary, Baby Shower, Birthday, Christmas, Diwali, FathersDay, Festive, Housewarming, MothersDay, Trousseau, Valentine, Wedding
- **Features**: Airtight, Pattern, Plain Colour, Set, Texture, With Chopsticks, With Handle, With Lid, With Spoon, With Stand
- **Availability**: In stock, Out of stock

---

## IMPLEMENTATION STATUS

✅ **COMPLETED**:
- Enhanced CategoryModel with all new fields
- Enhanced ProductModel with all new fields  
- Updated HomeController with add functions
- All models have proper fromMap() and toMap() methods

🔄 **NEXT STEPS**:
1. Create admin forms for adding categories and products
2. Update user UI to display new fields
3. Add sample data with new field structure
4. Implement filtering and search functionality
5. Add image upload capabilities

---

## ADMIN FORM REQUIREMENTS

### Category Add Form:
- Name (Text Field)
- Description (Text Area)
- Image Upload
- Icon Upload (Optional)
- Parent Category (Dropdown)
- Sort Order (Number)
- Is Active (Checkbox)

### Product Add Form:
- Basic Info: Name, Description, Brand, SKU
- Pricing: Price, Original Price, Discount %
- Images: Multiple image upload
- Category: Category selection dropdown
- Physical: Dimensions, Weight, Color, Material
- Classification: Style dropdown, Occasions multi-select, Features multi-select
- Inventory: Stock quantity, availability toggles
- Additional: Care instructions, tags
- Status: Available, In Stock, On Sale toggles

This comprehensive structure will provide a robust foundation for your KichanWare e-commerce application similar to Nestasia's functionality.
