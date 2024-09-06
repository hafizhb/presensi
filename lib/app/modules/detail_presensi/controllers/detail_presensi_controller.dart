import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class DetailPresensiController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  var presensiList = <Map<String, dynamic>>[].obs;
  var isLoading = true.obs;
  late String kelasId;
  late String userNim;

  set setKelasId(String id) {
    kelasId = id;
    fetchPresensiDetails();
  }

  @override
  void onInit() {
    super.onInit();
    userNim = '';
    initializeDateFormatting('id_ID', null).then((_) {
      fetchPresensiDetails();
    });
  }

  // Mendapatkan detail presensi dari kelas
  void fetchPresensiDetails() async {
    try {
      isLoading(true);
      userNim = await getCurrentUserNim();
      var sesiSnapshot = await firestore
          .collection('Kelas')
          .doc(kelasId)
          .collection('Sesi')
          .get();

      List<Map<String, dynamic>> fetchedPresensiList = [];

      for (var sesiDoc in sesiSnapshot.docs) {
        String mingguId = sesiDoc.id;
        String kJam = sesiDoc.data()['k_jam'] ?? '';
        String kTanggal = sesiDoc.data()['k_tanggal'] ?? '';

        String hari = '';
        if (kTanggal.isNotEmpty) {
          try {
            DateTime tanggal = DateTime.parse(kTanggal);
            hari = DateFormat('EEEE', 'id_ID').format(tanggal);
            print('Parsed tanggal: $tanggal, hari: $hari');
          } catch (e) {
            print('Error parsing kTanggal: $kTanggal, Error: $e');
          }
        }

        // Mengambil data presensi mahasiswa berdasarkan NIM yang sedang login
        var mahasiswaPresensiDoc = await firestore
            .collection('Kelas')
            .doc(kelasId)
            .collection('Sesi')
            .doc(mingguId)
            .collection('Mahasiswa_Peserta')
            .doc(userNim)
            .get();

        if (mahasiswaPresensiDoc.exists) {
          String kehadiran = mahasiswaPresensiDoc.data()?['kehadiran'] ?? '';
          var waktuTimestamp = mahasiswaPresensiDoc.data()?['waktu'];

          String waktuFormatted = '';
          if (waktuTimestamp != null && waktuTimestamp is Timestamp) {
            DateTime waktu = waktuTimestamp.toDate();
            waktuFormatted = DateFormat('yyyy-MM-dd HH:mm').format(waktu);
          }

          fetchedPresensiList.add({
            'minggu': mingguId,
            'hari': hari,
            'k_jam': kJam,
            'k_tanggal': kTanggal,
            'kehadiran': kehadiran,
            'waktu': waktuFormatted,
          });
        }
      }

      presensiList.assignAll(fetchedPresensiList);
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
}