import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:presensi/app/modules/tambah_user/controllers/tambah_user_controller.dart';

import '../../../style/app_color.dart';
import '../../../widgets/custom_input.dart';


class TambahUserView extends GetView<TambahUserController> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Tambah User',
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
          CustomInput(
            controller: controller.m_nimC,
            label: 'NIM Mahasiswa',
            hint: 'NIM',
          ),
          CustomInput(
            controller: controller.m_namaC,
            label: 'Nama Lengkap',
            hint: 'Nama',
          ),
          CustomInput(
            controller: controller.m_emailC,
            label: 'Email',
            hint: 'youremail@email.com',
          ),
          SizedBox(height: 30),
          Container(
            width: MediaQuery.of(context).size.width,
            child: Obx(
                  () => ElevatedButton(
                onPressed: () {
                  if (controller.isLoading.isFalse) {
                    controller.addUser();
                  }
                },
                child: Text(
                  (controller.isLoading.isFalse) ? 'Tambah User' : 'Loading...',
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