import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi/app/routes/app_pages.dart';
import '../../../style/app_color.dart';
import '../controllers/home_admin_controller.dart';

class HomeAdminView extends GetView<HomeAdminController> {
  const HomeAdminView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Home Admin',
          style: GoogleFonts.poppins(
            color: AppColor.blackprimary,
              fontSize: 22,
              fontWeight: FontWeight.w400
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => Get.toNamed(Routes.PROFILE_ADMIN),
            icon: Icon(Icons.person),
          ),
        ],
      ),
      body: Obx(() {
        DocumentSnapshot<Map<String, dynamic>>? userDoc = controller.userSnapshot.value;

        if (userDoc == null) {
          return Center(child: CircularProgressIndicator());
        }

        Map<String, dynamic>? user = userDoc.data();

        if (user == null) {
          return Center(child: Text("Data user tidak tersedia."));
        }

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
                      "${user['nama'].toString().split(' ').take(4).join(' ')}",
                      style: TextStyle(fontSize: 23, fontWeight: FontWeight.w600),
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
                        onPressed: () => Get.toNamed(Routes.TAMBAH_USER),
                        icon: Icon(Icons.person_add, color: Colors.white),
                      ),
                      Text(
                          "Tambah User",
                          style: GoogleFonts.poppins(color: Colors.white)
                      )
                    ],
                  ),
                  Column(
                    children: [
                      IconButton(
                        onPressed: () => Get.toNamed(Routes.LIS_USER),
                        icon: Icon(Icons.person_pin, color: Colors.white),
                      ),
                      Text(
                          "Lis User",
                          style: GoogleFonts.poppins(color: Colors.white)
                      )
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }
}
