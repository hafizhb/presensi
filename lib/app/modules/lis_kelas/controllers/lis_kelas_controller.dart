import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LisKelasController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  var kelasList = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchEnrolledClasses();
  }

  // Fungsi untuk mendapatkan daftar kelas yang sudah dimasuki oleh mahasiswa
  void fetchEnrolledClasses() async {
    try {
      isLoading(true);
      String userNim = await getCurrentUserNim();

      // Mengambil dokumen mahasiswa berdasarkan userNim
      var mahasiswaDoc = await firestore
          .collection('Mahasiswa')
          .doc(userNim)
          .get();
      List<dynamic> enrolledClasses = mahasiswaDoc.data()?['m_kelas'] ?? [];

      if (enrolledClasses.isNotEmpty) {
        // Mengambil detail kelas berdasarkan k_id di m_kelas
        var kelasSnapshot = await firestore
            .collection('Kelas')
            .where(FieldPath.documentId, whereIn: enrolledClasses)
            .get();

        var enrolledKelas = kelasSnapshot.docs.map((doc) => {
          'k_id': doc.id,
          ...doc.data()
        }).toList();

        // Mendapatkan s_nama dari koleksi Matkul berdasarkan k_matkul
        for (var kelas in enrolledKelas) {
          String kMatkul = kelas['k_matkul'];

          // Query koleksi Matkul untuk mendapatkan s_nama
          var matkulSnapshot = await firestore.collection('Matkul').doc(kMatkul).get();
          if (matkulSnapshot.exists) {
            kelas['s_nama'] = matkulSnapshot.data()?['s_nama'] ?? 'Nama Tidak Ditemukan';
          } else {
            kelas['s_nama'] = 'Nama Tidak Ditemukan';
          }
        }

        kelasList.assignAll(enrolledKelas);
      } else {
        kelasList.clear();
      }
    } finally {
      isLoading(false);
    }
  }

  // Fungsi untuk mendapatkan NIM mahasiswa saat ini
  Future<String> getCurrentUserNim() async {
    String uid = auth.currentUser!.uid;
    var mahasiswaSnapshot = await firestore
        .collection('Mahasiswa')
        .where('uid', isEqualTo: uid)
        .get();
    if (mahasiswaSnapshot.docs.isNotEmpty) {
      return mahasiswaSnapshot.docs.first.data()['m_nim'];
    }
    return '';
  }

  // Fungsi untuk menghapus kelas
  Future<void> removeClass(String kelasId) async {
    String userNim = await getCurrentUserNim();

    // Hapus nim dari nim_list di dokumen kelas
    await firestore
        .collection('Kelas')
        .doc(kelasId)
        .update({
      'nim_list': FieldValue.arrayRemove([userNim])
    });

    // Hapus entry mahasiswa dari setiap minggu di dalam subkoleksi 'Sesi'
    var sesiSnapshot = await firestore
        .collection('Kelas')
        .doc(kelasId)
        .collection('Sesi')
        .get();

    for (var sesiDoc in sesiSnapshot.docs) {
      String mingguId = sesiDoc.id;

      await firestore
          .collection('Kelas')
          .doc(kelasId)
          .collection('Sesi')
          .doc(mingguId)
          .collection('Mahasiswa_Peserta')
          .doc(userNim)
          .delete();
    }

    // Hapus kelas dari daftar kelas di dokumen mahasiswa
    await firestore
        .collection('Mahasiswa')
        .doc(userNim)
        .update({
      'm_kelas': FieldValue.arrayRemove([kelasId])
    });

    fetchEnrolledClasses(); // Refresh list setelah menghapus kelas
  }
}
