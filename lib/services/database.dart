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

  Future<DocumentSnapshot> getUsers(String id) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .get(); // Thêm .get() để trả về DocumentSnapshot
  }

  Future updatePassword(String id, Map<String, dynamic> updatedPassword) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update(updatedPassword);
  }

  Future<Map<String, dynamic>> getUserDetails(String userId) async {
    DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
    return userDoc.data() as Map<String, dynamic>;
  }


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

  Future getAndUpUsers(String id, Map<String, dynamic> userAccount) async {
    return await FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .update(userAccount);
  }

  // Future getBookings(String id, Map<String, dynamic> userBookingList) async {
  //   return await FirebaseFirestore.instance
  //       .collection("Booking")
  //       .doc(id)
  //       .update(userBookingList);
  // }
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




}
