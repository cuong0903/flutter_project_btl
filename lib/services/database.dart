import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class DatabaseMethods {
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }

  Future addUserBooking(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Booking")
        .add(userInfoMap);
  }

  Future<Stream<QuerySnapshot>> getBookings() async {
    return await FirebaseFirestore.instance.collection("Booking").snapshots();
  }

  Future DeleteBooking(String id) async {
    return await FirebaseFirestore.instance
        .collection("Booking")
        .doc(id)
        .delete();
  }

  Future updateBooking(String id, Map<String, dynamic> updatedInfo) async {
    return await FirebaseFirestore.instance
        .collection("Booking")
        .doc(id)
        .update(updatedInfo);
  }
}
