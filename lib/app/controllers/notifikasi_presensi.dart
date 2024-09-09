import 'dart:async';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get_storage/get_storage.dart';
import 'package:permission_handler/permission_handler.dart';

class NotifikasiPresensi extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  List<StreamSubscription> _subscriptions = [];

  @override
  void onInit() {
    super.onInit();
    _initializeNotifications();
    _requestNotificationPermissions();
    _listenToKehadiranChanges();
  }

  void _initializeNotifications() {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('@mipmap/ic_launcher');

    final InitializationSettings initializationSettings =
    InitializationSettings(
      android: initializationSettingsAndroid,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse:
          (NotificationResponse notificationResponse) {
        print('Notification payload: ${notificationResponse.payload}');
      },
    );
  }

  Future<void> _requestNotificationPermissions() async {
    if (await Permission.notification.isDenied) {
      await Permission.notification.request();
    }
  }

  void _listenToKehadiranChanges() async {
    String userNim = await getCurrentUserNim();

    try {
      QuerySnapshot kelasSnapshot = await firestore.collection('Kelas').get();

      for (var kelasDoc in kelasSnapshot.docs) {
        String kelasId = kelasDoc.id;
        String kMatkul = kelasDoc['k_matkul'];
        String sNama = await getNamaMatkul(kMatkul);

        QuerySnapshot sesiSnapshot = await firestore
            .collection('Kelas')
            .doc(kelasId)
            .collection('Sesi')
            .get();

        for (var sesiDoc in sesiSnapshot.docs) {
          String sesiId = sesiDoc.id;

          StreamSubscription subscription = firestore
              .collection('Kelas')
              .doc(kelasId)
              .collection('Sesi')
              .doc(sesiId)
              .collection('Mahasiswa_Peserta')
              .doc(userNim)
              .snapshots()
              .listen((snapshot) {
            if (snapshot.exists) {
              String? kehadiran = snapshot.data()?['kehadiran'];

              if (kehadiran != null && kehadiran.isNotEmpty) {
                String notificationKey =
                    '${kelasId}_${sesiId}_${userNim}_${kehadiran}_${kMatkul}';
                print(
                    'Received kehadiran update: $kehadiran for key: $notificationKey');

                if (!isNotificationSent(notificationKey)) {
                  _showNotification(kelasId, sesiId, kehadiran, kMatkul);
                  markNotificationAsSent(notificationKey);
                }
              }
            }
          });

          _subscriptions.add(subscription);
        }
      }
    } catch (e) {
      print('Error listening to kehadiran changes: $e');
    }
  }

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

  Future<String> getNamaMatkul(String kMatkul) async {
    var matkulSnapshot = await firestore
        .collection('Matkul')
        .doc(kMatkul).get();
    if (matkulSnapshot.exists) {
      return matkulSnapshot.data()?['s_nama'] ?? 'Nama Tidak Ditemukan';
    }
    return 'Nama Tidak Ditemukan';
  }

  Future<void> _showNotification(
      String kelasId, String sesiId, String kehadiran, String kMatkul) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'kehadiran_channel_id',
      'Kehadiran Notifications',
      importance: Importance.max,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await flutterLocalNotificationsPlugin.show(
      0,
      'Status Kehadiran Diperbarui',
      'Status kehadiran: $kehadiran pada mata kuliah $kMatkul di $sesiId',
      platformChannelSpecifics,
      payload: 'Kehadiran Updated',
    );

    print(
        'Notifikasi dikirim untuk kelas $kMatkul sesi $sesiId dengan status $kehadiran');
  }

  void markNotificationAsSent(String key) {
    GetStorage().write(key, true);
  }

  bool isNotificationSent(String key) {
    return GetStorage().read(key) ?? false;
  }

  @override
  void onClose() {
    for (var subscription in _subscriptions) {
      subscription.cancel();
    }
    super.onClose();
  }
}
