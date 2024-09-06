import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../style/app_color.dart';
import '../controllers/detail_kelas_controller.dart';

class DetailKelasView extends StatelessWidget {
  final DetailKelasController controller = Get.put(DetailKelasController());

  @override
  Widget build(BuildContext context) {
    // Mengambil kelasId dari argument yang dikirimkan saat navigasi
    final String kelasId = Get.arguments['kelasId'];
    controller.setKelasId = kelasId;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Kelas',
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
            height: 1,
            color: AppColor.primary,
          ),
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        if (controller.kelasDetail.isEmpty) {
          return Center(child: Text('Detail kelas tidak tersedia.'));
        }
        return DetailKelasTile(
          title: controller.kelasDetail['matkul_nama'],
          hari: controller.kelasDetail['hari'],
          jam: controller.kelasDetail['jam'],
          dosen: controller.kelasDetail['dosen_nama'],
          icon: Icon(Icons.book, color: Colors.white),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.red),
            onPressed: () async {
              bool confirm = await _showConfirmationDialog(context);
              if (confirm) {
                await controller.removeClass(controller.kelasDetail['k_id']);
                Get.snackbar('Berhasil', 'Kelas berhasil dihapus');
              }
            },
          ),
        );
      }),
    );
  }
  // Fungsi untuk menampilkan dialog konfirmasi sebelum menghapus kelas
  Future<bool> _showConfirmationDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Hapus Kelas'),
        content: Text('Apakah Anda yakin ingin menghapus kelas ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('Tidak'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Ya'),
          ),
        ],
      ),
    ) ?? false;
  }

}

class DetailKelasTile extends StatelessWidget {
  final String title;
  final String hari;
  final String jam;
  final String dosen;
  final Widget icon;
  final Widget trailing;

  DetailKelasTile({
    required this.title,
    required this.hari,
    required this.jam,
    required this.dosen,
    required this.icon,
    required this.trailing,
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
          crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to the top
          children: [
            Container(
              width: 42,
              height: 42,
              margin: EdgeInsets.only(right: 16),
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColor.primarySoft,
                borderRadius: BorderRadius.circular(100),
              ),
              child: icon,
            ),
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
                  SizedBox(height: 4),
                  Text(
                    'Hari: $hari',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300,
                      color: AppColor.blacksecondary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Jam: $jam',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300,
                      color: AppColor.blacksecondary,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Dosen: $dosen',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w300,
                      color: AppColor.blacksecondary,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                trailing,
              ],
            ),
          ],
        ),
      ),
    );
  }
}



