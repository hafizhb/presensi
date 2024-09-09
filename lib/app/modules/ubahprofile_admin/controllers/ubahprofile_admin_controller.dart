import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as s;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

import '../../../widgets/custom_toast.dart';

class UbahprofileAdminController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController namaC = TextEditingController();
  TextEditingController emailC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  s.FirebaseStorage storage = s.FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();
  XFile? image;

  Future<void> updateProfile() async {
    String uid = auth.currentUser!.uid;
    if (namaC.text.isNotEmpty && emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
        Map<String, dynamic> data = {
          "nama": namaC.text,
        };
        if (image != null) {
          // upload avatar image to storage
          File file = File(image!.path);
          String ext = image!.name.split(".").last;
          String upDir = "${uid}/avatar.$ext";
          await storage.ref(upDir).putFile(file);
          String avatarUrl = await storage.ref(upDir).getDownloadURL();

          data.addAll({"avatar": "$avatarUrl"});
        }
        await firestore.collection("Admin").doc(uid).update(data);
        image = null;
        Get.back();
        CustomToast.successToast('Success', 'Success Update Profile');
      } catch (e) {
        CustomToast.errorToast('Error', 'Cant Update Profile. Err : ${e.toString()}');
      } finally {
        isLoading.value = false;
      }
    } else {
      CustomToast.errorToast('Error', 'You must fill all form');
    }
  }

  void pickImage() async {
    if (Platform.isAndroid) {
      final androidInfo = await DeviceInfoPlugin().androidInfo;
      if (androidInfo.version.sdkInt <= 32) {
        var status = await Permission.storage.request();
        if (status.isGranted) {
          image = await picker.pickImage(source: ImageSource.gallery);
        }
      } else {
        var status = await Permission.photos.request();
        if (status.isGranted) {
          image = await picker.pickImage(source: ImageSource.gallery);
        }
      }
    } else {
      var status = await Permission.photos.request();
      if (status.isGranted) {
        image = await picker.pickImage(source: ImageSource.gallery);
      }
    }

    if (image != null) {
      print(image!.path);
      print(image!.name.split(".").last);
    } else {
      Get.snackbar("Izin Ditolak", "Tidak dapat mengakses galeri.");
    }

    update();
  }
}
