import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../widgets/custom_alert_dialog.dart';
import '../../../widgets/custom_toast.dart';

class TambahUserController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool isLoadingAddUser = false.obs;

  TextEditingController m_namaC = TextEditingController();
  TextEditingController m_nimC = TextEditingController();
  TextEditingController m_emailC = TextEditingController();
  TextEditingController passAdminC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  String getDefaultPassword() {
    return DefaultUser.defaultPassword;
  }

  Future<void> addUser() async {
    if (m_namaC.text.isNotEmpty && m_nimC.text.isNotEmpty && m_emailC.text.isNotEmpty) {
      isLoading.value = true;
      CustomAlertDialog.confirmAdmin(
        title: 'Konfirmasi Admin',
        message: 'Masukkan Password Admin',
        onCancel: () {
          isLoading.value = false;
          Get.back();
        },
        onConfirm: () async {
          if (isLoadingAddUser.isFalse) {
            await prosesAddUser();
            isLoading.value = false;
          }
        },
        controller: passAdminC,
      );
    } else {
      isLoading.value = false;
      CustomToast.errorToast('Error', 'Semua data harus diisi terlebih dahulu');
    }
  }

  prosesAddUser() async {
    if (passAdminC.text.isNotEmpty) {
      isLoadingAddUser.value = true;
      String emailAdmin = auth.currentUser!.email!;
      try {
        await auth.signInWithEmailAndPassword(email: emailAdmin, password: passAdminC.text);

        String defaultPassword = getDefaultPassword();

        UserCredential mahasiswaCredential = await auth.createUserWithEmailAndPassword(
          email: m_emailC.text,
          password: defaultPassword,
        );

        if (mahasiswaCredential.user != null) {
          String uid = mahasiswaCredential.user!.uid;
          String userNIM = m_nimC.text;

          await firestore.collection("Mahasiswa").doc(userNIM).set({
            "m_nim": m_nimC.text,
            "m_nama": m_namaC.text,
            "m_email": m_emailC.text,
            "uid": uid,
            "role": "user",
            "m_fakultas": "Fakultas Teknik",
            "m_prodi": "Teknik Elektro",
            "m_strata": "S1"
          });

          auth.signOut();

          await auth.signInWithEmailAndPassword(email: emailAdmin, password: passAdminC.text);

          Get.back();
          Get.back();
          CustomToast.successToast('Success', 'Berhasil menambahkan user');

          isLoadingAddUser.value = false;
        }
      } on FirebaseAuthException catch (e) {
        isLoadingAddUser.value = false;
        if (e.code == 'weak-password') {
          Get.snackbar("Terjadi Kesalahan", "Password yang digunakan terlalu singkat");
        } else if (e.code == 'email-already-in-use') {
          Get.snackbar("Terjadi Kesalahan", "User sudah ada. Kamu tidak dapat menambahkan user dengan email ini.");
        } else if (e.code == 'wrong-password') {
          Get.snackbar("Terjadi Kesalahan", "Admin tidak dapat login. Password salah !");
        } else {
          Get.snackbar("Terjadi Kesalahan", "${e.code}");
        }
      } catch (e) {
        isLoadingAddUser.value = false;
        Get.snackbar("Terjadi Kesalahan", "Tidak dapat menambahkan user.");
      }
    } else {
      isLoading.value = false;
      Get.snackbar("Terjadi Kesalahan", "Password wajib diisi untuk keperluan validasi");
    }
  }

}

class DefaultUser  {
  static String defaultPassword = 'password';
}