import 'package:get/get.dart';
import 'package:presensi/app/routes/app_pages.dart';

class PageIndexController extends GetxController {

  RxInt pageIndex = 1.obs;

  void changePage(int i) async {
    switch (i) {
      case 0:
        pageIndex.value = i;
        Get.offAllNamed(Routes.RIWAYAT_PRESENSI);
        break;
      case 2:
        pageIndex.value = i;
        Get.offAllNamed(Routes.PROFILE);
        break;
      default:
        pageIndex.value = i;
        Get.offAllNamed(Routes.HOME);
    }
  }
}
