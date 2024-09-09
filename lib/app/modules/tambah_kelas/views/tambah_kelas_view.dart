import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi/app/style/app_color.dart';
import '../../../widgets/custom_toast.dart';
import '../../../widgets/lisv2_tile.dart';
import '../controllers/tambah_kelas_controller.dart';

class TambahKelasView extends StatelessWidget {
  final TambahKelasController controller = Get.put(TambahKelasController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah Kelas',
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
          return Center(child: Text('Tidak ada kelas yang tersedia.'));
        }

        return ListView.builder(
          itemCount: controller.kelasList.length,
          itemBuilder: (context, index) {
            var kelas = controller.kelasList[index];

            return Lisv2Tile(
              title: kelas['s_nama'],
              icon: Icon(Icons.book, color: Colors.white),
              trailing: IconButton(
                icon: Icon(Icons.add, color: AppColor.primary),
                onPressed: () async {
                  await controller.addClass(kelas['k_id']);
                  CustomToast.successToast('Berhasil', 'Kelas berhasil ditambahkan');
                },
              ),
            );
          },
        );
      }),
    );
  }
}
