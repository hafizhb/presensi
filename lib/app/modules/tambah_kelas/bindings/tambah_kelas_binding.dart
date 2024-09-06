import 'package:get/get.dart';

import '../controllers/tambah_kelas_controller.dart';

class TambahKelasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<TambahKelasController>(
      () => TambahKelasController(),
    );
  }
}
