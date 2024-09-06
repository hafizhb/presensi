import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi/app/modules/profile/controllers/profile_controller.dart';
import 'package:presensi/app/routes/app_pages.dart';
import 'package:presensi/app/style/app_color.dart';

import '../../../controllers/page_index_controller.dart';
import '../../../widgets/menu_tile.dart';

class ProfileView extends GetView<ProfileController> {
  final pageC = Get.find<PageIndexController>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      extendBody: true,
      body: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
        stream: controller.streamUser(),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snap.hasData) {
            Map<String, dynamic> user = snap.data!.data()!;
            return ListView(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ClipOval(
                      child: Container(
                        width: 124,
                        height: 124,
                        color: AppColor.primary,
                        child: Image.network(
                          (user["avatar"] == null || user['avatar'] == "")
                              ? "https://ui-avatars.com/api/?name=${user['m_nama']}/"
                              : user['avatar'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                      "${user['m_nama']}",
                      style: GoogleFonts.poppins(color: AppColor.blackprimary, fontWeight: FontWeight.w600, fontSize: 20),
                    ),
                    Text(
                      "${user['m_email']}",
                      style: GoogleFonts.poppins(color: AppColor.blackprimary),
                    ),
                    Text(
                      "${user['m_nim']}",
                      style: GoogleFonts.poppins(color: AppColor.blackprimary),
                    ),
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 42),
                  child: Column(
                    children: [
                      MenuTile(
                        title: "Ubah Profile",
                        icon: Icon(Icons.person, color: Colors.white),
                        onTap: () => Get.toNamed(Routes.UBAHPROFILE, arguments: user),
                      ),
                      MenuTile(
                        title: "Ubah Password",
                        icon: Icon(Icons.password, color: Colors.white),
                        onTap: () => Get.toNamed(Routes.UBAH_PASSWORD),
                      ),
                      MenuTile(
                        title: "Log Out",
                        icon: Icon(Icons.logout, color: Colors.white),
                        onTap: () => controller.logout(),
                      ),
                      Container(
                        height: 1,
                        color: AppColor.primarySoft,
                      ),
                    ],
                  ),
                ),
              ],
            );
          } else {
            return Center(
              child: Text("Tidak dapat memuat data user."),
            );
          }
        },
      ),
      bottomNavigationBar: ConvexAppBar(
        style: TabStyle.fixedCircle, backgroundColor: AppColor.primary,
        items: [
          TabItem(icon: Icons.calendar_today, title: 'Riwayat'),
          TabItem(icon: Icons.home, title: 'Home'),
          TabItem(icon: Icons.people, title: 'Profile'),
        ],
        initialActiveIndex: pageC.pageIndex.value,
        onTap: (int i) => pageC.changePage(i),
      ),
    );
  }
}