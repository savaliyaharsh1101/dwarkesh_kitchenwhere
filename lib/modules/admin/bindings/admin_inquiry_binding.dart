import 'package:get/get.dart';
import '../controllers/admin_inquiry_controller.dart';

class AdminInquiryBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AdminInquiryController>(() => AdminInquiryController());
  }
}
