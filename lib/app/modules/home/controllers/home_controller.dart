import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  RxBool isLoading = false.obs;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  final storage = GetStorage(); // Access GetStorage instance

  Stream<DocumentSnapshot<Map<String, dynamic>>> streamUser() async* {
    String userNIM = storage.read('m_nim') ?? '';
    yield* firestore
        .collection("Mahasiswa")
        .doc(userNIM)
        .snapshots();
  }
}
