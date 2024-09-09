import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../controllers/page_index_controller.dart';
import '../../../style/app_color.dart';
import '../controllers/riwayat_presensi_controller.dart';

class RiwayatPresensiView extends StatelessWidget {
  final pageC = Get.find<PageIndexController>();
  final RiwayatPresensiController controller = Get.put(RiwayatPresensiController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Riwayat Presensi',
          style: GoogleFonts.patrickHand(
              color: AppColor.blackprimary,
              fontSize: 22
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }

        if (controller.riwayatPresensiList.isEmpty) {
          return Center(child: Text('Tidak ada riwayat presensi.'));
        }

        return ListView.builder(
          itemCount: controller.riwayatPresensiList.length,
          itemBuilder: (context, index) {
            RiwayatPresensi riwayat = controller.riwayatPresensiList[index];

            return RiwayatTile(
                matkul: 'Mata Kuliah: ${riwayat.sNama}',
                kehadiran: 'Status: ${riwayat.kehadiran}',
                waktu: 'Hadir pada: ${riwayat.waktu}');
          },
        );
      }),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle, backgroundColor: AppColor.primary,
        items: [
          TabItem(icon: Icons.history, title: 'Riwayat'),
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}

class RiwayatTile extends StatelessWidget {
  final String matkul;
  final String kehadiran;
  final String waktu;

  RiwayatTile({
    required this.matkul,
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
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    matkul,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      color: AppColor.blacksecondary,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    kehadiran,
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
          ],
        ),
      ),
    );
  }
}