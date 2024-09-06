import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class LisUserController extends GetxController {
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  var userList = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchUsers();
  }

  void fetchUsers() async {
    try {
      QuerySnapshot querySnapshot = await firestore
          .collection('Mahasiswa')
          .where('role', isEqualTo: 'user')
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        List<Map<String, dynamic>> users = querySnapshot.docs.map((doc) {
          return {'docId': doc.id, ...doc.data() as Map<String, dynamic>};
        }).toList();

        userList.assignAll(users);
      } else {
        userList.clear();
      }
    } catch (e) {
      print("Error fetching users: $e");
    }
  }
}
