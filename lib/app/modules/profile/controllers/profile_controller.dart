import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:presensi/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // Stream untuk mengambil data user berdasarkan uid dan m_nim
  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String uid = auth.currentUser!.uid;

    // Cari dokumen yang memiliki uid yang sesuai
    DocumentSnapshot<Map<String, dynamic>> mahasiswaDoc = await firestore
        .collection('Mahasiswa')
        .where('uid', isEqualTo: uid)
        .limit(1)
        .get()
        .then((querySnapshot) {
      if (querySnapshot.docs.isNotEmpty) {
        return querySnapshot.docs.first;
      }
      throw FirebaseAuthException(
          code: 'user-not-found', message: 'User tidak ditemukan');
    });

    // Stream data mahasiswa berdasarkan NIM
    yield* firestore
        .collection("Mahasiswa")
        .doc(mahasiswaDoc.get('m_nim'))
        .snapshots();
  }

  void logout() async {
    await auth.signOut();
    Get.offAllNamed(Routes.LOGIN);
  }
}
