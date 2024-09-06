import 'package:get/get.dart';

import '../controllers/tambah_user_controller.dart';

class TambahUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahUserController>(
      () => TambahUserController(),
    );
  }
}
