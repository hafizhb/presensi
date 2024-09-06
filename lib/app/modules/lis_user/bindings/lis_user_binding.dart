import 'package:get/get.dart';

import '../controllers/lis_user_controller.dart';

class LisUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LisUserController>(
      () => LisUserController(),
    );
  }
}
