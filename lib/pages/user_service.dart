import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _hashPassword(String password) {
    var bytes = utf8.encode(password);
    var digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<bool> registerUser(String name, String email, String password) async {
    try {
      // Kiểm tra xem email đã tồn tại chưa
      var snapshot = await _firestore.collection("users").where("email", isEqualTo: email).get();
      if (snapshot.docs.isNotEmpty) {
        return false; // Email đã được sử dụng
      }

      String hashedPassword = _hashPassword(password);
      String id = _firestore.collection("users").doc().id;

      await _firestore.collection("users").doc(id).set({
        "name": name,
        "email": email,
        "password": hashedPassword,
        "id": id,
        "image": "https://tudip.com/wp-content/uploads/2019/05/store-data-on-GCP.png",
      });

      return true;
    } catch (e) {
      print("Error registering user: $e");
      return false;
    }
  }

  Future<Map<String, dynamic>?> loginUser(String email, String password) async {
    try {
      String hashedPassword = _hashPassword(password);
      var snapshot = await _firestore.collection("users")
          .where("email", isEqualTo: email)
          .where("password", isEqualTo: hashedPassword)
          .get();

      if (snapshot.docs.isNotEmpty) {
        return snapshot.docs.first.data();
      }
      return null;
    } catch (e) {
      print("Error logging in user: $e");
      return null;
    }
  }
}