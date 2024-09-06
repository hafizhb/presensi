import 'package:get/get.dart';

import '../controllers/ubahprofile_controller.dart';

class UbahprofileBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<UbahprofileController>(
      () => UbahprofileController(),
    );
  }
}
