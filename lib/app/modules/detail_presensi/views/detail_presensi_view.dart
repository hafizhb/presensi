import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../style/app_color.dart';
import '../controllers/detail_presensi_controller.dart';

class DetailPresensiView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final DetailPresensiController controller = Get.put(DetailPresensiController());

    // Set kelasId setelah controller diinisialisasi
    final String kelasId = Get.arguments['kelasId'];
    controller.setKelasId = kelasId; // Set kelasId menggunakan setter

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Presensi',
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
            height: 1,
            color: AppColor.primary,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.presensiList.isEmpty) {
          return Center(child: Text('Tidak ada data presensi.'));
        }
        return ListView.builder(
          itemCount: controller.presensiList.length,
          itemBuilder: (context, index) {
            var presensi = controller.presensiList[index];
            return DetailPresensiTile(
              title: '${presensi['hari']}, ${presensi['k_tanggal']}',
              subtitle: 'Jam Mulai: ${presensi['k_jam']}',
              waktu: 'Jam Hadir: ${presensi['waktu']}',
              kehadiran: '${presensi['kehadiran']}',
            );
          },
        );
      }),
    );
  }
}

class DetailPresensiTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final String kehadiran;
  final String waktu;

  DetailPresensiTile({
    required this.title,
    required this.subtitle,
    required this.kehadiran,
    required this.waktu,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColor.primary,
              width: 1,
            ),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: AppColor.blacksecondary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300,
                      color: AppColor.blacksecondary,
                    ),
                  ),
                  Text(
                    waktu,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300,
                      color: AppColor.blacksecondary,
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColor.primary,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: AppColor.secondary,
                    width: 1,
                  ),
                ),
                child: Text(
                  kehadiran,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}