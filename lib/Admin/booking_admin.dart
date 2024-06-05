import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_btl/services/database.dart';

class BookingAdmin extends StatefulWidget {
  const BookingAdmin({Key? key}) : super(key: key);

  @override
  State<BookingAdmin> createState() => _BookingAdminState();
}

class _BookingAdminState extends State<BookingAdmin> {
  Stream? bookingStream;

  @override
  void initState() {
    super.initState();
    getOnLoad();
  }

  getOnLoad() async {
    bookingStream = await DatabaseMethods().getBookings();
    setState(() {});
  }

  void _showEditDialog(DocumentSnapshot ds) {
    String updatedService = ds["Service"];
    DateTime updatedDate = DateTime.now();
    TimeOfDay updatedTime = TimeOfDay.now();

    try {
      List<String> dateParts = ds["Date"].split('/');
      updatedDate = DateTime(
        int.parse(dateParts[2]),
        int.parse(dateParts[1]),
        int.parse(dateParts[0]),
      );
    } catch (e) {
      print("Lỗi ngày giờ: $e");
    }

    try {
      List<String> timeParts = ds["Time"].split(':');
      updatedTime = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1].split(' ')[0]),
      );
    } catch (e) {
      print("Lỗi thời gian: $e");
    }

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text("Sửa lịch"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: InputDecoration(labelText: "Dịch vụ"),
                onChanged: (value) => updatedService = value,
                controller: TextEditingController(text: updatedService),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final DateTime? picked = await showDatePicker(
                    context: context,
                    initialDate: updatedDate,
                    firstDate: DateTime(2024),
                    lastDate: DateTime(2025),
                  );
                  if (picked != null) {
                    setState(() => updatedDate = picked);
                  }
                },
                child: Text("Select Date: ${updatedDate.day}/${updatedDate.month}/${updatedDate.year}"),
              ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  final TimeOfDay? picked = await showTimePicker(
                    context: context,
                    initialTime: updatedTime,
                  );
                  if (picked != null) {
                    setState(() => updatedTime = picked);
                  }
                },
                child: Text("Select Time: ${updatedTime.format(context)}"),
              ),
            ],
          ),
          actions: [
            TextButton(
              child: Text("Quay lại"),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text("Lưu"),
              onPressed: () async {
                await DatabaseMethods().updateBooking(ds.id, {
                  "Service": updatedService,
                  "Date": "${updatedDate.day}/${updatedDate.month}/${updatedDate.year}",
                  "Time": updatedTime.format(context),
                });
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget allBookings() {
    return StreamBuilder(
      stream: bookingStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) return CircularProgressIndicator();
        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: snapshot.data.docs.length,
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemBuilder: (context, index) {
            DocumentSnapshot ds = snapshot.data.docs[index];
            return Material(
              elevation: 8.0,
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: EdgeInsets.all(10),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  gradient: LinearGradient(colors: [
                    Color(0xFFB91635),
                    Color(0xff621d3c),
                    Color(0xFF311937)
                  ]),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(60),
                          child: Image.network(
                            ds["Image"],
                            height: 80,
                            width: 80,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 10.0),
                    Text("Loại dịch vụ: " + ds["Service"],
                        style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold)),
                    SizedBox(height: 5.0),
                    Text("Tên khách hàng: " + ds["UserName"],
                        style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold)),
                    Text("Ngày: " + ds["Date"],
                        style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold)),
                    Text("Giờ: " + ds["Time"],
                        style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20.0),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            await DatabaseMethods().DeleteBooking(ds.id);
                          },
                          style: ElevatedButton.styleFrom(backgroundColor: Color(0xFFdf711a)),
                          child: Text("Hoàn thành", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                        ElevatedButton(
                          onPressed: () => _showEditDialog(ds),
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.blue),
                          child: Text("Sửa", style: TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    SizedBox(height: 20.0),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF2b1615),
      appBar: AppBar(
        title: Text("Tất cả lịch", style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold)),
        backgroundColor: Color(0xFF2b1615),
        elevation: 0,
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: allBookings(),
      ),
    );
  }
}