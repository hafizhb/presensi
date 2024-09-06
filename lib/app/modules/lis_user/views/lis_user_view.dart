import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi/app/modules/lis_user/controllers/lis_user_controller.dart';
import '../../../style/app_color.dart';

class LisUserView extends StatelessWidget {
  final LisUserController controller = Get.put(LisUserController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Lis User',
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.userList.isEmpty) {
            return Center(child: Text('Tidak ada user.'));
          } else {
            return ListView.builder(
              itemCount: controller.userList.length,
              itemBuilder: (context, index) {
                var user = controller.userList[index];
                String m_nama = user['m_nama'] ?? 'No Name';
                String m_email = user['m_email'] ?? 'No Email';

                return LisTile(
                  title: m_nama,
                  subtitle: m_email,
                  icon: Icon(Icons.person),
                );
              },
            );
          }
        }),
      ),
    );
  }
}

class LisTile extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget icon;

  LisTile({
    required this.title,
    required this.subtitle,
    required this.icon,
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
            Container(
              width: 42,
              height: 42,
              margin: EdgeInsets.only(right: 24),
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
                  SizedBox(height: 4), // Spasi antara title dan subtitle
                  Text(
                    subtitle,
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

