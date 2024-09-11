import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:presensi/app/controllers/notifikasi_presensi.dart';
import 'package:permission_handler/permission_handler.dart';
import 'app/controllers/page_index_controller.dart';
import 'app/routes/app_pages.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage
  await GetStorage.init();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Meminta izin notifikasi
  await requestNotificationPermission();

  // Register GetStorage with GetX
  Get.put(GetStorage());

  // Register PageIndexController
  Get.put(PageIndexController(), permanent: true);

  Get.put(NotifikasiPresensi());

  runApp(
    StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return MaterialApp(
            home: Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          );
        }

        if (snapshot.data != null) {
          final userRole = GetStorage().read('role');
          return GetMaterialApp(
            title: "Application",
            initialRoute: userRole == 'Administrator' ? Routes.HOME_ADMIN : Routes.HOME,
            getPages: AppPages.routes,
          );
        } else {
          return GetMaterialApp(
            title: "Application",
            initialRoute: Routes.LOGIN,
            getPages: AppPages.routes,
          );
        }
      },
    ),
  );
}

Future<void> requestNotificationPermission() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
}
