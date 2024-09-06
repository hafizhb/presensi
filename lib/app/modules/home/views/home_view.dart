import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi/app/routes/app_pages.dart';
import 'package:presensi/app/style/app_color.dart';

import '../controllers/home_controller.dart';
import '../../../controllers/page_index_controller.dart';

class HomeView extends GetView<HomeController> {
  final pageC = Get.find<PageIndexController>();

  @override
  Widget build(BuildContext context) {
    final String m_nim = Get.find<GetStorage>().read('m_nim') ?? '';

    return Scaffold(
      appBar: AppBar(),
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snap.hasData) {
            Map<String, dynamic> user = snap.data!.data()!;

            return ListView(
              padding: EdgeInsets.only(top: 0, left: 20, right: 20),
              children: [
                Row(
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                            "Selamat Datang,",
                            style: GoogleFonts.patrickHand(fontSize: 20)),
                        Text(
                          "${user['m_nama'].toString().split(' ').take(4).join(' ')}",
                          style: GoogleFonts.poppins(fontSize: 25, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: AppColor.primary,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Column(
                        children: [
                          IconButton(
                            onPressed: () => Get.toNamed(Routes.LIS_PRESENSI),
                            icon: Icon(Icons.bookmark_added, color: Colors.white),
                          ),
                          Text(
                              "Lis Presensi",
                            style: GoogleFonts.poppins(color: Colors.white)
                          )
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () => Get.toNamed(Routes.LIS_KELAS),
                            icon: Icon(Icons.bookmark, color: Colors.white),
                          ),
                          Text(
                              "Lis Kelas",
                              style: GoogleFonts.poppins(color: Colors.white)
                          )
                        ],
                      ),
                      Column(
                        children: [
                          IconButton(
                            onPressed: () => Get.toNamed(Routes.TAMBAH_KELAS),
                            icon: Icon(Icons.bookmark_add, color: Colors.white),
                          ),
                          Text(
                              "Tambah Kelas",
                              style: GoogleFonts.poppins(color: Colors.white)
                          )
                        ],
                      )
                    ],
                  ),
                ),
                SizedBox(height: 20),
                Divider(
                  color: Colors.grey[300],
                  thickness: 2,
                ),
              ],
            );
          } else {
            return Center(child: Text("Tidak dapat memuat data user."));
          }
        },
      ),
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
