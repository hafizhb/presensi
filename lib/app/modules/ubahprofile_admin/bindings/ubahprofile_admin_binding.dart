import 'package:get/get.dart';

import '../controllers/ubahprofile_admin_controller.dart';

class UbahprofileAdminBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UbahprofileAdminController>(
      () => UbahprofileAdminController(),
    );
  }
}
