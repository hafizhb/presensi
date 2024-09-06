import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class HomeAdminController extends GetxController {
  RxBool isLoading = false.obs;
  Rx<DocumentSnapshot<Map<String, dynamic>>?> userSnapshot = Rx<DocumentSnapshot<Map<String, dynamic>>?>(null);

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  void fetchUserData() {
    String uid = auth.currentUser!.uid;
    userSnapshot.bindStream(firestore
        .collection("Admin")
        .doc(uid)
        .snapshots());
  }
}
