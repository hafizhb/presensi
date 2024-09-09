import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi/app/modules/ubahprofile/controllers/ubahprofile_controller.dart';
import '../../../style/app_color.dart';
import '../../../widgets/custom_input.dart';

class UbahprofileView extends GetView<UbahprofileController> {
  final Map<String, dynamic> user = Get.arguments;

  @override
  Widget build(BuildContext context) {
    controller.m_namaC.text = user["m_nama"];
    controller.m_nimC.text = user["m_nim"];
    controller.m_emailC.text = user["m_email"];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ubah Profile',
          style: GoogleFonts.patrickHand(
            color: AppColor.blackprimary,
            fontSize: 22,
          ),
        ),
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(Icons.arrow_back),
        ),
        actions: [
          Obx(
                () => TextButton(
              onPressed: () {
                if (controller.isLoading.isFalse) {
                  controller.updateProfile();
                }
              },
              child: Text((controller.isLoading.isFalse) ? 'Selesai' : 'Loading...'),
              style: TextButton.styleFrom(
                foregroundColor: AppColor.primary,
              ),
            ),
          ),
        ],
        elevation: 0,
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Container(
            width: MediaQuery.of(context).size.width,
            height: 1,
            color: AppColor.secondary,
          ),
        ),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        padding: EdgeInsets.all(20),
        children: [
          Center(
            child: Stack(
              children: [
                GetBuilder<UbahprofileController>(
                  builder: (controller) {
                    if (controller.image != null) {
                      return ClipOval(
                        child: Container(
                          width: 98,
                          height: 98,
                          color: AppColor.primarySoft,
                          child: Image.file(
                            File(controller.image!.path),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    } else {
                      return ClipOval(
                          child: Container(
                            width: 98,
                            height: 98,
                            color: AppColor.primarySoft,
                            child: Image.network(
                              user["avatar"] ?? "https://ui-avatars.com/api/?name=${user['m_nama']}/",
                              fit: BoxFit.cover,
                            ),
                          )
                      );
                    }
                  },
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: SizedBox(
                    width: 36,
                    height: 36,
                    child: ElevatedButton(
                      onPressed: () {
                        controller.pickImage();
                      },
                      child: Icon(Icons.camera),
                      style: ElevatedButton.styleFrom(
                        padding: EdgeInsets.zero,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 30),
          CustomInput(
            controller: controller.m_namaC,
            label: "Full Name",
            hint: "Your Full Name",
            disabled: true,
          ),
          CustomInput(
            controller: controller.m_nimC,
            label: "Email",
            hint: "youremail@email.com",
            disabled: true,
          ),
          CustomInput(
            controller: controller.m_emailC,
            label: "Email",
            hint: "youremail@email.com",
            disabled: true,
          ),
        ],
      ),
    );
  }
}
