import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';
import 'firebase_options.dart';
import 'shared/services/firebase_service.dart';
import 'modules/home/views/home_view.dart';
import 'modules/home/bindings/home_binding.dart';

import 'modules/category/views/category_view.dart';
import 'modules/category/bindings/category_binding.dart';
import 'modules/product/views/product_detail_view.dart';
import 'modules/product/views/products_view.dart';
import 'modules/product/views/product_search_view.dart';
import 'modules/product/bindings/product_binding.dart';
import 'modules/product/bindings/products_binding.dart';
import 'modules/product/bindings/product_search_binding.dart';
import 'modules/admin/views/admin_inquiry_view.dart';
import 'modules/admin/bindings/admin_inquiry_binding.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize shared Firebase service
  Get.put(FirebaseService(), permanent: true);

  runApp(DwarkeshEnterpriseApp());
}

class DwarkeshEnterpriseApp extends StatelessWidget {
  const DwarkeshEnterpriseApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Dwarkesh Enterprise - Kitchen Ware Store',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/home',
      getPages: [
        GetPage(
          name: '/home',
          page: () => HomeView(),
          binding: HomeBinding(),
        ),
        GetPage(
          name: '/category',
          page: () => CategoryView(),
          binding: CategoryBinding(),
        ),
        GetPage(
          name: '/product-detail',
          page: () => ProductDetailView(),
          binding: ProductBinding(),
        ),
        GetPage(
          name: '/menu',
          page: () => CategoryView(), // Updated to use CategoryView
          binding: CategoryBinding(),
        ),
        GetPage(
          name: '/products',
          page: () => ProductsView(),
          binding: ProductsBinding(),
        ),
        GetPage(
          name: '/product-search',
          page: () => ProductSearchView(),
          binding: ProductSearchBinding(),
        ),
        GetPage(
          name: '/admin/inquiries',
          page: () => AdminInquiryView(),
          binding: AdminInquiryBinding(),
        ),
      ],
    );
  }
}
