import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi/app/routes/app_pages.dart';

import '../../../style/app_color.dart';
import '../../../widgets/lisv3_tile.dart';
import '../controllers/lis_kelas_controller.dart';

class LisKelasView extends StatelessWidget {
  final LisKelasController controller = Get.put(LisKelasController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lis Kelas',
          style: GoogleFonts.patrickHand(
              color: AppColor.blackprimary,
              fontSize: 22
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
              icon: Icon(Icons.bookmark, color: Colors.white),
              onTap: () {
                Get.toNamed(
                  Routes.DETAIL_KELAS,
                  arguments: {'kelasId': kelas['k_id']},
                );
              },
            );
          },
        );
      }),
    );
  }
}

