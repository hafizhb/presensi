import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../controllers/notifikasi_presensi.dart';

class RiwayatPresensiController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  RxList<RiwayatPresensi> riwayatPresensiList = <RiwayatPresensi>[].obs;
  RxBool isLoading = true.obs;
  List<String> displayedNotifications = [];
  String currentUserNim = '';

  final NotifikasiPresensi notifikasiPresensi = NotifikasiPresensi();

  @override
  void onInit() {
    super.onInit();
    monitorPresensiChanges();
  }

  Future<void> loadCurrentUserNim() async {
    currentUserNim = await getCurrentUserNim();
    loadDisplayedNotifications(currentUserNim);
  }

  void loadDisplayedNotifications(String nim) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    displayedNotifications = prefs.getStringList('displayedNotifications_$nim') ?? [];
  }

  void saveDisplayedNotifications(String nim) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('displayedNotifications_$nim', displayedNotifications);
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


  Future<String> getNamaMatkul(String kMatkul) async {
    var matkulSnapshot = await firestore
        .collection('Matkul')
        .doc(kMatkul).get();
    if (matkulSnapshot.exists) {
      return matkulSnapshot.data()?['s_nama'] ?? 'Nama Tidak Ditemukan';
    }
    return 'Nama Tidak Ditemukan';
  }

  void monitorPresensiChanges() async {
    await loadCurrentUserNim();

    firestore.collection('Kelas').snapshots().listen((kelasSnapshot) {
      for (var kelasDoc in kelasSnapshot.docs) {
        firestore.collection('Kelas')
            .doc(kelasDoc.id)
            .collection('Sesi')
            .snapshots()
            .listen((sesiSnapshot) {
          for (var sesiDoc in sesiSnapshot.docs) {
            firestore.collection('Kelas')
                .doc(kelasDoc.id)
                .collection('Sesi')
                .doc(sesiDoc.id)
                .collection('Mahasiswa_Peserta')
                .doc(currentUserNim)
                .snapshots()
                .listen((presensiDoc) async {
              if (presensiDoc.exists) {
                var data = presensiDoc.data() as Map<String, dynamic>;
                if (data['kehadiran'] != null && data['kehadiran'] != '') {
                  String sNama = await getNamaMatkul(kelasDoc['k_matkul']);
                  DateTime waktuDateTime = (data['waktu'] as Timestamp).toDate();
                  String waktuFormatted = DateFormat('yyyy-MM-dd HH:mm').format(waktuDateTime);

                  RiwayatPresensi newPresensi = RiwayatPresensi(
                    kelasId: kelasDoc.id,
                    sNama: sNama,
                    kehadiran: data['kehadiran'],
                    waktu: waktuFormatted,
                    waktuDateTime: waktuDateTime,
                  );

                  riwayatPresensiList.add(newPresensi);

                  // Mengurutkan berdasarkan waktuDateTime
                  riwayatPresensiList.sort((a, b) => b.waktuDateTime.compareTo(a.waktuDateTime));

                  String notifikasiId = '${kelasDoc.id}_${sesiDoc.id}';
                  if (!displayedNotifications.contains(notifikasiId)) {
                    notifikasiPresensi.showNotification(
                      "Presensi Baru",
                      "$sNama: ${data['kehadiran']} pada $waktuFormatted",
                    );
                    displayedNotifications.add(notifikasiId);
                    saveDisplayedNotifications(currentUserNim);
                  }
                }
              }
            });
          }
        });
      }
      isLoading.value = false;
    });
  }

}

// Riwayat Presensi model
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
