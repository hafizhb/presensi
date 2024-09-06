import 'package:get/get.dart';

import '../controllers/lis_kelas_controller.dart';

class LisKelasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LisKelasController>(
      () => LisKelasController(),
    );
  }
}
