import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:presensi/app/modules/ubahprofile_admin/controllers/ubahprofile_admin_controller.dart';
import '../../../style/app_color.dart';
import '../../../widgets/custom_input.dart';


class UbahprofileAdminView extends GetView<UbahprofileAdminController> {
  final Map<String, dynamic> user = Get.arguments;

  @override
  Widget build(BuildContext context) {
    controller.namaC.text = user["nama"];
    controller.emailC.text = user["email"];

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Ubah Profile',
          style: TextStyle(
            color: AppColor.blackprimary,
            fontSize: 14,
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
              child: Text((controller.isLoading.isFalse) ? 'Done' : 'Loading...'),
              style: TextButton.styleFrom(
                foregroundColor: AppColor.primary,
              ),
            ),
          ),
        ],
        backgroundColor: Colors.white,
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
          // section 1 - Profile Picture
          Center(
            child: Stack(
              children: [
                GetBuilder<UbahprofileAdminController>(
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
                            (user["avatar"] == null || user['avatar'] == "") ? "https://ui-avatars.com/api/?name=${user['nama']}/" : user['avatar'],
                            fit: BoxFit.cover,
                          ),
                        ),
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
          //section 2 - user data
          CustomInput(
            controller: controller.namaC,
            label: "Full Name",
            hint: "Your Full Name",
            margin: EdgeInsets.only(bottom: 16, top: 42),
            disabled: true,
          ),
          CustomInput(
            controller: controller.emailC,
            label: "Email",
            hint: "youremail@email.com",
            disabled: true,
          ),
        ],
      ),
    );
  }
}
