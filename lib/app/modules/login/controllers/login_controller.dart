import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:presensi/app/routes/app_pages.dart';

import '../../../widgets/custom_toast.dart';

class LoginController extends GetxController {
  RxBool isLoading = false.obs;
  RxBool obsecureText = true.obs;
  TextEditingController emailC = TextEditingController();
  TextEditingController passC = TextEditingController();

  FirebaseAuth auth = FirebaseAuth.instance;
  final storage = GetStorage();

  Future<void> login() async {
    if (emailC.text.isNotEmpty && passC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        final credential = await auth.signInWithEmailAndPassword(
          email: emailC.text,
          password: passC.text,
        );

        // Mendapatkan UID dari Firebase Auth
        String uid = credential.user!.uid;

        // Cek di collection 'Mahasiswa'
        DocumentSnapshot<Map<String, dynamic>>? userDoc = await FirebaseFirestore.instance
            .collection('Mahasiswa')
            .where('uid', isEqualTo: uid)
            .limit(1)
            .get()
            .then((querySnapshot) => querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first : null);

        // Jika tidak ditemukan di 'Mahasiswa', cek di collection 'Admin'
        if (userDoc == null) {
          userDoc = await FirebaseFirestore.instance
              .collection('Admin')
              .where('uid', isEqualTo: uid)
              .limit(1)
              .get()
              .then((querySnapshot) => querySnapshot.docs.isNotEmpty ? querySnapshot.docs.first : null);
        }

        // Jika masih tidak ditemukan, lempar kesalahan
        if (userDoc == null) {
          throw FirebaseAuthException(
              code: 'user-not-found', message: 'User tidak ditemukan');
        }

        // Mendapatkan data nim dan role
        String userNIM = userDoc.id;
        String userRole = userDoc.data()?['role'] ?? 'user';

        // Simpan nim dan role ke dalam storage
        storage.write('m_nim', userNIM);
        storage.write('role', userRole);

        // Redirect ke halaman sesuai role
        if (userRole == 'Administrator') {
          Get.offAllNamed(Routes.HOME_ADMIN);
        } else {
          Get.offAllNamed(Routes.HOME);
        }

        isLoading.value = false;
      } on FirebaseAuthException catch (e) {
        isLoading.value = false;
        if (e.code == 'user-not-found') {
          CustomToast.errorToast("Terjadi Kesalahan", "User tidak ditemukan untuk email tersebut.");
        } else if (e.code == 'wrong-password') {
          CustomToast.errorToast("Terjadi Kesalahan", "Password salah. Silakan coba lagi.");
        } else {
          CustomToast.errorToast("Terjadi Kesalahan", "Password salah. Silakan coba lagi.");
        }
      } catch (e) {
        isLoading.value = false;
        CustomToast.errorToast("Terjadi Kesalahan", "Tidak dapat login. Kesalahan: $e");
      }
    } else {
      CustomToast.errorToast("Terjadi Kesalahan", "Email dan password wajib diisi.");
    }
  }
}
