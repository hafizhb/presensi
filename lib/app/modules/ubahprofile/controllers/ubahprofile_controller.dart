import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';


class UbahprofileController extends GetxController {
  RxBool isLoading = false.obs;
  TextEditingController m_namaC = TextEditingController();
  TextEditingController m_nimC = TextEditingController();
  TextEditingController m_emailC = TextEditingController();

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;

  final ImagePicker picker = ImagePicker();
  XFile? image;

  Future<void> updateProfile() async {
    String uid = auth.currentUser!.uid;

    if (m_namaC.text.isNotEmpty && m_nimC.text.isNotEmpty && m_emailC.text.isNotEmpty) {
      isLoading.value = true;
      try {
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

        String userNIM = mahasiswaDoc.get('m_nim');

        Map<String, dynamic> data = {
          "m_nama": m_namaC.text,
        };

        if (image != null) {
          // upload avatar image to storage
          File file = File(image!.path);
          String ext = image!.name.split(".").last;
          String upDir = "${uid}/avatar.$ext";
          await storage.ref(upDir).putFile(file);
          String avatarUrl = await storage.ref(upDir).getDownloadURL();
          data.addAll({"avatar": avatarUrl});
        }

        await firestore.collection("Mahasiswa").doc(userNIM).update(data);
        image = null;
        Get.back();
        Get.snackbar("Success", "Profile Berhasil Diubah");
      } catch (e) {
        Get.snackbar("Error", "Tidak Dapat Mengubah Profile : ${e.toString()}");
      } finally {
        isLoading.value = false;
      }
    } else {
      Get.snackbar("Error", "Semua Data Harus Diisi");
    }
  }

  void pickImage() async {
    image = await picker.pickImage(source: ImageSource.gallery);
    update();
  }

  void deleteProfile() async {
    String uid = auth.currentUser!.uid;
    try {
      await firestore.collection("Mahasiswa").doc(uid).update({
        "avatar": FieldValue.delete(),
      });
      Get.back();
      Get.snackbar("Success", "Profile picture deleted successfully");
    } catch (e) {
      Get.snackbar("Error", "Cannot delete profile picture: ${e.toString()}");
    } finally {
      update();
    }
  }
}