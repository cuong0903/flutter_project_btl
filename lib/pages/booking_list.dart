import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_btl/pages/edit_booking_list.dart';
import 'package:flutter_project_btl/services/database.dart';

import '../services/shared_pred.dart';

class BookingList extends StatefulWidget {
  final String Name;

  const BookingList({Key? key, required this.Name}) : super(key: key);

  @override
  State<BookingList> createState() => _BookingListState();
}

class _BookingListState extends State<BookingList> {
  Stream? bookingStream;

  getthedatafromsharedpred() async {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    getOnLoad();
  }

  getOnLoad() async {
    getthedatafromsharedpred();
    bookingStream = await DatabaseMethods().getBookings();
    setState(() {});
  }

  Widget allBookings() {
    return StreamBuilder(
      stream: bookingStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData)
          return Center(child: CircularProgressIndicator(color: Colors.white));
        // Duyệt qua từng DocumentSnapshot trong snapshot
        for (DocumentSnapshot doc in snapshot.data.docs) {
          print(doc.data());
        }
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length, // Sử dụng filteredBookings.length thay vì snapshot.data.docs.length
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            String bookingName = ds["UserName"] ?? "";
            if (bookingName != widget.Name) return SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              child: Material(
                elevation: 8.0,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFF1E88E5),
                      Color(0xFF1565C0),
                      Color(0xFF0D47A1)
                    ]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            ds["Image"],
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) => Icon(
                                Icons.person,
                                size: 60,
                                color: Colors.white70),
                          ),
                        ),
                        title: Text(ds["UserName"],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)),
                      ),
                      Divider(color: Colors.white30),
                      SizedBox(height: 10.0),
                      _buildInfoRow(Icons.cut, "Dịch vụ: " + ds["Service"]),
                      _buildInfoRow(
                          Icons.calendar_today, "Ngày: " + ds["Date"]),
                      _buildInfoRow(Icons.access_time, "Giờ: " + ds["Time"]),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton.icon(
                            onPressed: () async {
                              bool confirm = await showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        title: Text('Xác nhận'),
                                        content: Text(
                                            'Bạn có chắc chắn muốn xóa lịch đặt này không? Hành động này không thể hoàn tác.'),
                                        actions: [
                                          TextButton(
                                              child: Text('Hủy'),
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(false)),
                                          ElevatedButton(
                                              child: Text('Xóa'),
                                              style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red),
                                              onPressed: () =>
                                                  Navigator.of(context)
                                                      .pop(true)),
                                        ],
                                      );
                                    },
                                  ) ??
                                  false;
                              if (confirm) {
                                await DatabaseMethods().DeleteBooking(ds.id);
                                ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Đã xóa lịch đặt')));
                              }
                            },
                            icon: Icon(Icons.delete_forever),
                            label: Text("Xóa lịch"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white),
                          ),
                          ElevatedButton.icon(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditBookingPage(bookingId: ds.id),
                                ),
                              ).then((_) {
                                // Tải lại dữ liệu sau khi quay lại
                                getOnLoad();
                              });
                            },
                            icon: Icon(Icons.edit),
                            label: Text("Sửa"),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.orange,
                              foregroundColor: Colors.white,
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Row(
        children: [
          Icon(icon, color: Colors.white70),
          SizedBox(width: 10),
          Expanded(
              child: Text(text,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500))),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF1E88E5),
      appBar: AppBar(
        title: Text("Lịch của bạn",
            style: TextStyle(
                color: Colors.white,
                fontSize: 24.0,
                fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: allBookings(),
      ),
    );
  }
}
