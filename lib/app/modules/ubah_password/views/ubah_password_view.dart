import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi/app/modules/ubah_password/controllers/ubah_password_controller.dart';
import 'package:presensi/app/style/app_color.dart';

import '../../../widgets/custom_input.dart';


class UbahPasswordView extends GetView<UbahPasswordController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
            'Ubah Password',
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
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(20),
        children: [
          Obx(
              () => CustomInput(
                  controller: controller.currC,
                  label: "Password Lama",
                  hint: "********",
                obsecureText: controller.currObs.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    (controller.currObs.value != false)
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                  ),
                  onPressed: () {
                    controller.currObs.value = !(controller.currObs.value);
                  },
                ),
              )
          ),
          Obx(
                  () => CustomInput(
                controller: controller.newC,
                label: "Password Baru",
                hint: "********",
                obsecureText: controller.newObs.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    (controller.newObs.value != false)
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                  ),
                  onPressed: () {
                    controller.newObs.value = !(controller.newObs.value);
                  },
                ),
              )
          ),
          Obx(
                  () => CustomInput(
                controller: controller.confirmC,
                label: "Konfirmasi Password",
                hint: "********",
                obsecureText: controller.confirmObs.value,
                suffixIcon: IconButton(
                  icon: Icon(
                    (controller.confirmObs.value != false)
                        ? Icons.visibility_rounded
                        : Icons.visibility_off_rounded,
                  ),
                  onPressed: () {
                    controller.confirmObs.value = !(controller.confirmObs.value);
                  },
                ),
              )
          ),
          SizedBox(height: 10),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Obx(
                  () => ElevatedButton(
                    onPressed: () {
                      if (controller.isLoading.isFalse) {
                        controller.updatePass();
                      }
                      },
                    child: Text(
                      (controller.isLoading.isFalse) ? "Ubah Password" : "Loading...",
                      style: GoogleFonts.poppins(
                        fontSize: 16,
                        color: Colors.white
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColor.primary,
                      padding: EdgeInsets.symmetric(vertical: 18),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
            ),
          )
        ],
      ),
    );
  }
}