import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

class RiwayatPresensiController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  // List untuk menyimpan data riwayat presensi
  var riwayatPresensiList = <RiwayatPresensi>[].obs;
  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchRiwayatPresensi();
  }

  Future<void> fetchRiwayatPresensi() async {
    isLoading.value = true;
    try {
      // Dapatkan userNim dari state atau GetStorage
      String userNim = await getCurrentUserNim();

      // Mengambil data presensi dari Firestore
      List<RiwayatPresensi> list = [];

      QuerySnapshot kelasSnapshot = await firestore.collection('Kelas').get();

      for (var kelasDoc in kelasSnapshot.docs) {
        String kelasId = kelasDoc.id;
        String kMatkul = kelasDoc['k_matkul'];
        String sNama = await getNamaMatkul(kMatkul);

        QuerySnapshot sesiSnapshot = await firestore
            .collection('Kelas')
            .doc(kelasDoc.id)
            .collection('Sesi')
            .get();

        for (var sesiDoc in sesiSnapshot.docs) {
          DocumentSnapshot presensiDoc = await firestore
              .collection('Kelas')
              .doc(kelasDoc.id)
              .collection('Sesi')
              .doc(sesiDoc.id)
              .collection('Mahasiswa_Peserta')
              .doc(userNim)
              .get();

          // Periksa apakah dokumen presensi ada dan apakah data valid
          if (presensiDoc.exists) {
            var data = presensiDoc.data() as Map<String, dynamic>;
            if (data['kehadiran'] != null && data['kehadiran'] != '') {

              String waktuFormatted;
              DateTime waktuDateTime;

              if (data['waktu'] != null) {
                Timestamp timestamp = data['waktu'];
                waktuDateTime = timestamp.toDate();
                waktuFormatted = DateFormat('yyyy-MM-dd HH:mm').format(waktuDateTime);
              } else {
                waktuDateTime = DateTime(1970, 1, 1);  // Default value
                waktuFormatted = "-";  // Handle null waktu
              }

              list.add(RiwayatPresensi(
                kelasId: kelasId,
                sNama: sNama,
                kehadiran: data['kehadiran'],
                waktu: waktuFormatted,
                waktuDateTime: waktuDateTime,
              ));
            }
          }
        }
      }

      list.sort((a, b) => b.waktuDateTime.compareTo(a.waktuDateTime));

      riwayatPresensiList.value = list;
    } catch (e) {
      print("Error fetching presensi data: $e");
    } finally {
      isLoading.value = false;
    }
  }


  Future<String> getCurrentUserNim() async {
    String uid = FirebaseAuth.instance.currentUser!.uid;
    var mahasiswaSnapshot = await firestore
        .collection('Mahasiswa')
        .where('uid', isEqualTo: uid)
        .get();
    if (mahasiswaSnapshot.docs.isNotEmpty) {
      return mahasiswaSnapshot.docs.first.data()['m_nim'];
    }
    return '';
  }

  // Fungsi untuk mendapatkan nama mata kuliah dari koleksi Matkul
  Future<String> getNamaMatkul(String kMatkul) async {
    var matkulSnapshot = await firestore
        .collection('Matkul')
        .doc(kMatkul).get();
    if (matkulSnapshot.exists) {
      return matkulSnapshot.data()?['s_nama'] ?? 'Nama Tidak Ditemukan';
    }
    return 'Nama Tidak Ditemukan';
  }
}

class RiwayatPresensi {
  final String kelasId;
  final String sNama;
  final String kehadiran;
  final String waktu;
  final DateTime waktuDateTime;

  RiwayatPresensi({
    required this.kelasId,
    required this.sNama,
    required this.kehadiran,
    required this.waktu,
    required this.waktuDateTime,
  });

  factory RiwayatPresensi.fromFirestore(Map<String, dynamic> data) {
    return RiwayatPresensi(
      kelasId: data['kId'] ?? '',
      sNama: data['sNama'] ?? '',
      kehadiran: data['kehadiran'] ?? '',
      waktu: data['waktu'] ?? '',
      waktuDateTime: data['waktuDateTime'] ?? DateTime.now(),
    );
  }
}