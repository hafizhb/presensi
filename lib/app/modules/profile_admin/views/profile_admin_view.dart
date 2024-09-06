import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi/app/modules/profile_admin/controllers/profile_admin_controller.dart';
import 'package:presensi/app/routes/app_pages.dart';
import 'package:presensi/app/style/app_color.dart';
import '../../../widgets/menu_tile.dart';

class ProfileAdminView extends GetView<ProfileAdminController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: AppColor.blackprimary),
          onPressed: () => Get.back(),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
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
                              ? "https://ui-avatars.com/api/?name=${user['nama']}/"
                              : user['avatar'],
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Text(
                        "${user['nama']}",
                        style: GoogleFonts.poppins(color: AppColor.blackprimary, fontWeight: FontWeight.w600, fontSize: 20)
                    ),
                    Text(
                        "${user['email']}",
                        style: GoogleFonts.poppins(color: AppColor.blackprimary)
                    )
                  ],
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 42),
                  child: Column(
                    children: [
                      MenuTile(
                        title: "Ubah Profile",
                        icon: Icon(Icons.person_off, color: Colors.white),
                        onTap: () => Get.toNamed(Routes.UBAHPROFILE_ADMIN, arguments: user),
                      ),
                      MenuTile(
                          title: "Ubah Password",
                          icon: Icon(Icons.password, color: Colors.white),
                          onTap: () => Get.toNamed(Routes.UBAH_PASSWORD)
                      ),
                      MenuTile(
                          title: "Log Out",
                          icon: Icon(Icons.logout, color: Colors.white),
                          onTap: () => controller.logout()
                      ),
                      Container(
                        height: 1,
                        color: AppColor.primarySoft,
                      )
                    ],
                  ),
                )
              ],
            );
          } else {
            return Center(
              child: Text("Tidak dapat memuat data user."),
            );
          }
        },
      ),
    );
  }
}
