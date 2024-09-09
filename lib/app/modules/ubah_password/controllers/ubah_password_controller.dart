import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_toast.dart';

class UbahPasswordController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController currC = TextEditingController();
  TextEditingController newC = TextEditingController();
  TextEditingController confirmC = TextEditingController();

  RxBool currObs = true.obs;
  RxBool newObs = true.obs;
  RxBool confirmObs = true.obs;

  FirebaseAuth auth = FirebaseAuth.instance;

  void updatePass() async {
    if (currC.text.isNotEmpty && newC.text.isNotEmpty && confirmC.text.isNotEmpty) {
      if (newC.text == confirmC.text) {
        isLoading.value = true;
        try {
          String emailUser = auth.currentUser!.email!;

          await auth.signInWithEmailAndPassword(email: emailUser, password: currC.text);

          await auth.currentUser!.updatePassword(newC.text);

          Get.back();

          CustomToast.successToast("Berhasil", "Berhasil ubah password");
        } on FirebaseAuthException catch (e) {
          if (e.code == "wrong-password") {
            CustomToast.errorToast("Terjadi Kesalahan", "Password yang dimasukan salah. Tidak dapat update password.");
          } else {
            CustomToast.errorToast("Terjadi Kesalahan", "${e.code.toLowerCase()}");
          }
        } catch (e) {
          CustomToast.errorToast("Terjadi Kesalahan", "Tidak dapat update password");
        } finally {
          isLoading.value = false;
        }
      } else {
        CustomToast.errorToast("Terjadi Kesalahan", "Confirm password tidak cocok.");
      }
    } else {
      CustomToast.errorToast("Terjadi Kesalahan", "Semua input harus diisi");
    }
  }
}
