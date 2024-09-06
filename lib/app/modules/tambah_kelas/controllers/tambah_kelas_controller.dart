import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class TambahKelasController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  var kelasList = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAvailableClasses();
  }

  // Mendapatkan daftar kelas yang belum dimasuki oleh mahasiswa
  void fetchAvailableClasses() async {
    try {
      isLoading(true);
      String userNim = await getCurrentUserNim();

      var kelasSnapshot = await firestore.collection('Kelas').get();
      var availableClasses = kelasSnapshot.docs.where((kelas) {
        List nimList = kelas.data()['nim_list'] ?? [];
        return !nimList.contains(userNim);
      }).map((doc) => {
        'k_id': doc.id,
        ...doc.data()
      }).toList();

      // Mendapatkan s_nama dari koleksi Matkul berdasarkan k_matkul
      for (var kelas in availableClasses) {
        String kMatkul = kelas['k_matkul'];

        // Query koleksi Matkul untuk mendapatkan s_nama
        var matkulSnapshot = await firestore.collection('Matkul').doc(kMatkul).get();
        if (matkulSnapshot.exists) {
          kelas['s_nama'] = matkulSnapshot.data()?['s_nama'] ?? 'Nama Tidak Ditemukan';
        } else {
          kelas['s_nama'] = 'Nama Tidak Ditemukan';
        }
      }

      kelasList.assignAll(availableClasses);
    } finally {
      isLoading(false);
    }
  }

  // Mendapatkan NIM mahasiswa saat ini
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

  // Menambahkan kelas dan menyimpan id kelas di koleksi Mahasiswa
  Future<void> addClass(String kelasId) async {
    String userNim = await getCurrentUserNim();

    // Update nim_list pada dokumen kelas
    await firestore.collection('Kelas').doc(kelasId).update({
      'nim_list': FieldValue.arrayUnion([userNim])
    });

    // Mengambil semua sesi yang ada di dalam kelas
    var sesiSnapshot = await firestore.collection('Kelas').doc(kelasId).collection('Sesi').get();

    // Tambah  mahasiswa di setiap sesi yang ada
    for (var sesiDoc in sesiSnapshot.docs) {
      String mingguId = sesiDoc.id;

      await firestore
          .collection('Kelas')
          .doc(kelasId)
          .collection('Sesi')
          .doc(mingguId)
          .collection('Mahasiswa_Peserta')
          .doc(userNim)
          .set({
        'id': userNim,
        'kehadiran': '',
        'waktu': null
      });
    }

    // Simpan id kelas di koleksi Mahasiswa
    await firestore
        .collection('Mahasiswa')
        .doc(userNim)
        .update({
      'm_kelas': FieldValue.arrayUnion([kelasId])
    });

    fetchAvailableClasses(); // Refresh list setelah menambahkan kelas
  }
}
