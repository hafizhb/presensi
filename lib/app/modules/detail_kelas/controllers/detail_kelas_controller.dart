import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DetailKelasController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  var kelasDetail = <String, dynamic>{}.obs;
  var isLoading = true.obs;
  late String kelasId;
  late String userNim;

  set setKelasId(String id) {
    kelasId = id;
    fetchClassDetails();
  }

  @override
  void onInit() {
    super.onInit();
    userNim = '';
    initializeDateFormatting('id_ID', null).then((_) {
      fetchClassDetails();
    });
  }

  // Mengambil detail kelas
  void fetchClassDetails() async {
    try {
      isLoading(true);
      userNim = await getCurrentUserNim();

      // Mengambil detail kelas berdasarkan kelasId
      var kelasSnapshot = await firestore
          .collection('Kelas')
          .doc(kelasId)
          .get();

      if (kelasSnapshot.exists) {
        var kelasData = kelasSnapshot.data()!;
        var matkulId = kelasData['k_matkul'];
        var dosenId = kelasData['k_dosen'];

        // Mengambil nama matkul dari Collection Matkul
        var matkulSnapshot = await firestore
            .collection('Matkul')
            .doc(matkulId)
            .get();

        var matkulNama = matkulSnapshot.exists ? matkulSnapshot.data()!['s_nama'] : 'Unknown';

        // Mengambil hari dan jam dari subkoleksi 'Sesi' -> dokumen 'Minggu1'
        var sesiSnapshot = await firestore
            .collection('Kelas')
            .doc(kelasId)
            .collection('Sesi')
            .doc('Minggu1')
            .get();

        String? hari;
        String? jam;

        if (sesiSnapshot.exists) {
          var kTanggal = sesiSnapshot.data()!['k_tanggal'];
          var kJam = sesiSnapshot.data()!['k_jam'];

          // Mengubah k_tanggal menjadi format hari (contoh: Senin)
          if (kTanggal != null) {
            try {
              DateTime tanggal = DateTime.parse(kTanggal); // Konversi string ke DateTime
              hari = DateFormat('EEEE', 'id_ID').format(tanggal); // Ambil nama hari dari tanggal
            } catch (e) {
              print('Error parsing kTanggal: $kTanggal, Error: $e');  // Log jika terjadi error parsing
              hari = 'Invalid date';
            }
          }

          jam = kJam;
        }

        // Mengambil nama dosen dari Collection Dosen
        var dosenSnapshot = await firestore
            .collection('Dosen')
            .doc(dosenId)
            .get();

        var dosenNama = dosenSnapshot.exists ? dosenSnapshot.data()!['d_nama'] : 'Unknown';

        kelasDetail.assignAll({
          'k_id': kelasId,
          'matkul_nama': matkulNama,
          'hari': hari ?? '',
          'jam': jam ?? '',
          'dosen_nama': dosenNama,
        });
      }
    } finally {
      isLoading(false);
    }
  }

  // Mndapatkan NIM mahasiswa saat ini
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

  // Menghapus kelas
  Future<void> removeClass(String kelasId) async {
    String userNim = await getCurrentUserNim();

    // Hapus nim dari nim_list di dokumen kelas
    await firestore
        .collection('Kelas')
        .doc(kelasId)
        .update({
      'nim_list': FieldValue.arrayRemove([userNim])
    });

    // Hapus mahasiswa dari setiap document di dalam subkoleksi 'Sesi'
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

    Get.back();
    Get.back();

    fetchClassDetails(); // Refresh list setelah menghapus kelas
  }
}
