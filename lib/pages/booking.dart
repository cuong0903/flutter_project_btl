import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_btl/services/database.dart';

import '../services/shared_pred.dart';

class Booking extends StatefulWidget {
  final String service;
  final String price; // Receive the price as a parameter

  Booking({required this.service, required this.price}); // Update the constructor

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {


  String? name, image, email, price;
  getthedatafromsharedpred() async{
    name = await SharedpreferenceHelper().getUserName();
    image = await SharedpreferenceHelper().getUserImage();
    email = await SharedpreferenceHelper().getUserGmail();
    setState(() {

    });
  }
  getontheload() async{
    await getthedatafromsharedpred();
    setState(() {

    });
  }
  @override
  void initState(){
    getontheload();
    super.initState();
  }

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _selectedDate,
        firstDate: DateTime(2024),
        lastDate: DateTime(2025));

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  TimeOfDay _selectedTime = TimeOfDay.now();
  Future<void> _selectTime(BuildContext context) async{
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Xác nhận đặt lịch'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc chắn muốn đặt lịch không?'),
                Text('Dịch vụ: ${widget.service}'),
                Text('Ngày: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                Text('Giờ: ${_selectedTime.format(context)}'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Hủy'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Đồng ý'),
              onPressed: () {
                Navigator.of(context).pop();
                _checkAvailabilityAndBook();
              },
            ),
          ],
        );
      },
    );
  }
  Future<bool> isTimeSlotAvailable(DateTime date, TimeOfDay time) async {
    DateTime startTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    DateTime endTime = startTime.add(Duration(minutes: 30));

    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('Booking')
        .where('Date', isEqualTo: '${date.day}/${date.month}/${date.year}')
        .get();

    for (var doc in querySnapshot.docs) {
      Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
      String timeString = data['Time'];
      List<String> timeParts = timeString.split(':');
      int hour = int.parse(timeParts[0]);
      int minute = int.parse(timeParts[1].split(' ')[0]);
      bool isPM = timeString.contains('PM');
      if (isPM && hour != 12) hour += 12;
      if (!isPM && hour == 12) hour = 0;

      DateTime bookingTime = DateTime(date.year, date.month, date.day, hour, minute);
      DateTime bookingEndTime = bookingTime.add(Duration(minutes: 30));

      if ((bookingTime.isBefore(endTime) && bookingEndTime.isAfter(startTime)) ||
          (bookingTime.isBefore(endTime) && bookingEndTime.isAtSameMomentAs(endTime)) ||
          (bookingTime.isAtSameMomentAs(startTime) && bookingEndTime.isAfter(startTime))) {
        return false;
      }
    }
    return true;
  }

  void _checkAvailabilityAndBook() async {
    bool isAvailable = await isTimeSlotAvailable(_selectedDate, _selectedTime);
    if (isAvailable) {
      Map<String, dynamic> userBookingmap = {
        "Service": widget.service,
        "Date": "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}".toString(),
        "Time": _selectedTime.format(context).toString(),
        "UserName": name,
        "Image": image,
        "Email": email,
        "Price": widget.price,
      };
      await DatabaseMethods().addUserBooking(userBookingmap).then((value) => {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
              "Dịch vụ đã được đặt thành công!!!",
              style: TextStyle(fontSize: 20.0),
            )
        ))
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
            "Thời gian đặt lịch cách nhau 30'. Vui lòng chọn thời gian khác.",
            style: TextStyle(fontSize: 20.0),
          )
      ));
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7AB9EE), // Corrected color code
      body: Container(
        margin: EdgeInsets.only(left: 10, right: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween, // Dàn đều khoảng cách giữa các phần tử
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 50.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Icon(
                      Icons.arrow_back_ios_new_rounded,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0), // Thêm padding cho chữ "service"
                  child: Text(
                    widget.service,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 50.0), // Thêm padding để đảm bảo khoảng cách đều
                  child: SizedBox(width: 30), // Thêm một phần tử ẩn để giữ khoảng cách đều
                ),
              ],
            ),



            SizedBox(
              height: 30.0,
            ),
            Text(
              "Phục hồi tạo hình và tỏa sáng!",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 30.0,
            ),
            ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                width: MediaQuery.of(context).size.width,
              
                child: Image.asset(
                  "images/discount.png",
                  fit: BoxFit.cover,
              
                ),

                
              ),
            ),
            SizedBox(
              height: 20.0,
            ),

            SizedBox(
              height: 10.0,
            ),
            Text(
              'Giá: ${widget.price}',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 30,),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10.0),
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20)),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Text("Đặt ngày ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: (){
                          _selectDate(context);
                        },
                          child: Icon(
                        Icons.calendar_month,
                        color: Colors.white,
                        size: 30.0,
                      )),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                          "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(
              height: 10.0,
            ),
            Container(
              padding: EdgeInsets.only(top: 10, bottom: 10.0),
              decoration: BoxDecoration(
                  color: Colors.red,
                  borderRadius: BorderRadius.circular(20)),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Text("Đặt giờ ",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20.0,
                          fontWeight: FontWeight.w500)),
                  SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                          onTap: (){
                            _selectTime(context);
                          },
                          child: Icon(
                            Icons.alarm,
                            color: Colors.white,
                            size: 30.0,
                          )),
                      SizedBox(
                        width: 20.0,
                      ),
                      Text(
                          _selectedTime.format(context),
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 30.0,
                              fontWeight: FontWeight.bold)),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20.0,),
            GestureDetector(
              onTap: () async {
                await _showConfirmationDialog();
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                decoration: BoxDecoration(
                    color: Color(0xFFfe8f33),
                    borderRadius: BorderRadius.circular(20)
                ),
                child: Center(
                  child: Text(
                    "Đặt ngay",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 22.0,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
