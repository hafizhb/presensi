import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi/app/routes/app_pages.dart';
import '../../../style/app_color.dart';
import '../../../widgets/lisv3_tile.dart';
import '../controllers/lis_presensi_controller.dart';

class LisPresensiView extends StatelessWidget {
  final LisPresensiController controller = Get.put(LisPresensiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lis Presensi Kelas',
          style: GoogleFonts.patrickHand(
            color: AppColor.blackprimary,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Get.back(),
        ),
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            width: MediaQuery.of(context).size.width,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.kelasList.isEmpty) {
          return Center(child: Text('Tambahkan kelas terlebih dahulu!'));
        }

        return ListView.builder(
          itemCount: controller.kelasList.length,
          itemBuilder: (context, index) {
            var kelas = controller.kelasList[index];
            return Lisv3Tile(
              title: kelas['s_nama'],
              icon: Icon(Icons.bookmark_added, color: Colors.white),
              onTap: () {
                // Navigasi ke halaman Detail Presensi dengan kelasId sebagai argumen
                Get.toNamed(
                  Routes.DETAIL_PRESENSI,
                  arguments: {'kelasId': kelas['k_id']}, // Mengirim kelasId sebagai argumen
                );
              },
            );
          },
        );
      }),
    );
  }
}