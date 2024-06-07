import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class DatabaseMethods {
  //Users
  // Thêm user mới
  Future addUserDetails(Map<String, dynamic> userInfoMap, String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .set(userInfoMap);
  }
  // hiển thông tin user từ id
  Future<DocumentSnapshot> getUsers(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get(); // Thêm .get() để trả về DocumentSnapshot
  }
  // Đổi password user
  Future updatePassword(String id, Map<String, dynamic> updatedPassword) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update(updatedPassword);
  }
// hiển thị update user
  Future getAndUpUsers(String id, Map<String, dynamic> userAccount) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update(userAccount);
  }
  // Future<Map<String, dynamic>> getUserDetails(String userId) async {
  //   DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
  //   return userDoc.data() as Map<String, dynamic>;
  // }



  // Booking
  // Thêm booking mới
  Future addUserBooking(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("Booking")
        .add(userInfoMap);
  }
  // Hiển thị booking
  Future<Stream<QuerySnapshot>> getBookings() async {
    return await FirebaseFirestore.instance.collection("Booking").snapshots();
  }
  // Xóa booking
  Future DeleteBooking(String id) async {
    return await FirebaseFirestore.instance
        .collection("Booking")
        .doc(id)
        .delete();
  }
// Sửa booking
  Future updateBooking(String id, Map<String, dynamic> updatedInfo) async {
    return await FirebaseFirestore.instance
        .collection("Booking")
        .doc(id)
        .update(updatedInfo);
  }

  // hiển thị booking theo id
  Future<Map<String, dynamic>?> getBooking(String bookingId) async {
    try {
      DocumentSnapshot bookingSnapshot = await FirebaseFirestore.instance
          .collection("Booking")
          .doc(bookingId)
          .get();

      if (bookingSnapshot.exists) {
        return bookingSnapshot.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print("Error getting booking: $e");
      return null;
    }
  }

// lấy maill user login
  Future<Map<String, dynamic>?> getUserInfoByEmail(String email) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection("users")
        .where("Gmail", isEqualTo: email)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      return querySnapshot.docs.first.data() as Map<String, dynamic>;
    }

    return null;
  }

  // Stylist

  Future<Stream<QuerySnapshot>> getStylist() async {
    return await FirebaseFirestore.instance.collection("Stylist").snapshots();
  }


}
