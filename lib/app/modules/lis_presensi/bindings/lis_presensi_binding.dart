import 'package:get/get.dart';

import '../controllers/lis_presensi_controller.dart';

class LisPresensiBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LisPresensiController>(
      () => LisPresensiController(),
    );
  }
}
