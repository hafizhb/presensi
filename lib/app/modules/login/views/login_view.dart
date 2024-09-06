import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi/app/routes/app_pages.dart';
import 'package:presensi/app/style/app_color.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColor.primary,
      body: ListView(
        shrinkWrap: true,
        children: [
          Container(
            height: MediaQuery.of(context).size.height * 35 / 100,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.only(left: 32),
            decoration: BoxDecoration(
              gradient: AppColor.primaryGradient,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Aplikasi Monitoring \nPresensi",
                  style: GoogleFonts.patrickHand(
                    fontSize: 35,
                    color: Colors.white,
                    height: 150 / 100,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 65 / 100,
            width: MediaQuery.of(context).size.width,
            color: Colors.white,
            padding: EdgeInsets.only(left: 20, right: 20, top: 36, bottom: 84),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  margin: EdgeInsets.only(bottom: 24),
                  child: Text(
                    'Log In',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: EdgeInsets.only(left: 14, right: 14, top: 4),
                  margin: EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1, color: AppColor.secondary),
                  ),
                  child: TextField(
                    style: GoogleFonts.poppins(fontSize: 14),
                    maxLines: 1,
                    controller: controller.emailC,
                    decoration: InputDecoration(
                      label: Text(
                        "Email",
                        style: TextStyle(
                          color: AppColor.blacksecondary,
                          fontSize: 14,
                        ),
                      ),
                      floatingLabelBehavior: FloatingLabelBehavior.always,
                      border: InputBorder.none,
                      hintText: "youremail@email.com",
                      hintStyle: GoogleFonts.poppins(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColor.blacksecondary,
                      ),
                    ),
                  ),
                ),
                Material(
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: EdgeInsets.only(left: 14, right: 14, top: 4),
                    margin: EdgeInsets.only(bottom: 24),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(width: 1, color: AppColor.secondary),
                    ),
                    child: Obx(
                          () => TextField(
                        style: GoogleFonts.poppins(fontSize: 14),
                        maxLines: 1,
                        controller: controller.passC,
                        obscureText: controller.obsecureText.value,
                        decoration: InputDecoration(
                          label: Text(
                            "Password",
                            style: TextStyle(
                              color: AppColor.blacksecondary,
                              fontSize: 14,
                            ),
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          border: InputBorder.none,
                          hintText: "********",
                          suffixIcon: IconButton(
                            icon: Icon(
                              controller.obsecureText.value
                                  ? Icons.visibility_rounded
                                  : Icons.visibility_off_rounded,
                              color: AppColor.blacksecondary
                            ),
                            onPressed: () {
                              controller.obsecureText.value = !controller.obsecureText.value;
                            },
                          ),
                          hintStyle: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColor.blacksecondary,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Obx(
                      () => Container(
                    width: MediaQuery.of(context).size.width,
                    child: ElevatedButton(
                      onPressed: () async {
                        if (controller.isLoading.isFalse) {
                          await controller.login();
                        }
                      },
                      child: Text(
                        (controller.isLoading.isFalse) ? 'Log in' : 'Loading...',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.symmetric(vertical: 18), backgroundColor: AppColor.primary,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.only(top: 4),
                  alignment: Alignment.centerLeft,
                  child: TextButton(
                    onPressed: () => Get.toNamed(Routes.RESET_PASSWORD),
                    child: Text(
                        "Lupa Password?",
                      style: GoogleFonts.poppins(),
                    ),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColor.blacksecondary,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
