import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_project_btl/services/database.dart';

import '../services/shared_pred.dart';

class Booking extends StatefulWidget {
  String service;

  Booking({required this.service, required String price});

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7AB9EE), // Corrected color code
      body: Container(
        margin: EdgeInsets.only(left: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: Padding(
                padding: const EdgeInsets.only(top: 50.0),
                child: Icon(
                  Icons.arrow_back_ios_new_rounded,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Text(
              "Hãy bắt đầu \ncuộc hành trình",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w500),
            ),
            SizedBox(
              height: 40.0,
            ),
            Container(
              width: MediaQuery.of(context).size.width,
              child: Image.asset(
                "images/discount.png",
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(
              height: 20.0,
            ),
            Text(
              widget.service,
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
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
              onTap: () async
              {
                Map<String, dynamic> userBookingmap = {
                  "Service": widget.service,
                  "Date" :  "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}".toString(),
                  "Time" : _selectedTime.format(context).toString(),
                  "UserName": name,
                  "Image": image,
                  "Email": email,
                  "Price": price,

                };
                await DatabaseMethods().addUserBooking(userBookingmap).then((value)=> {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text(
                "Dịch vụ đã được đặt thành công!!!",
                style: TextStyle(fontSize: 20.0),)))
                });
              },
              child: Container(
                width: MediaQuery.of(context).size.width,
                padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 15.0),
                decoration: BoxDecoration(
                    color: Color(0xFFfe8f33), borderRadius: BorderRadius.circular(20)
                ),
                child:  Center(
                  child: Text("Đặt ngay", style: TextStyle(
                      color: Colors.white,
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold),
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
