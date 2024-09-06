import 'package:get/get.dart';

import '../controllers/detail_kelas_controller.dart';

class DetailKelasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DetailKelasController>(
      () => DetailKelasController(),
    );
  }
}
