  import 'dart:math';

  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter/cupertino.dart';
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
    Stream? stylistStream;

    String? name, image,  price, NameWork;
    bool isExpanded = false;
    Map<String, dynamic>? selectedStylist;


    getOnLoad() async {
      getthedatafromsharedpred();
      stylistStream = await DatabaseMethods().getStylist();
      setState(() {});
    }

    getthedatafromsharedpred() async{
      name = await SharedpreferenceHelper().getUserName();
      image = await SharedpreferenceHelper().getUserImage();
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
      getOnLoad();
      super.initState();
    }

    Widget stylist() {
      return Container(
        child: Column(
          children: [
            GestureDetector(
              onTap: () {
                setState(() {
                  isExpanded = !isExpanded;
                });
              },
              child: Container(
                color: Colors.grey.shade300,
                padding: EdgeInsets.all(16),
                margin: EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Chọn Stylist',
                      style: TextStyle(color: Colors.black, fontSize: 20.0, fontWeight: FontWeight.w500),
                    ),
                    Icon(isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            AnimatedContainer(
              duration: Duration(milliseconds: 30),
              height: isExpanded ? 265.0 : 0,
              width: MediaQuery.of(context).size.width*2,

              child: isExpanded
                  ? StreamBuilder(
                stream: stylistStream,
                builder: (context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return Center(child: CircularProgressIndicator(color: Colors.white));
                  }
                  List<DocumentSnapshot> stylists = snapshot.data.docs;
                  return SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: List.generate(
                        stylists.length,
                            (index) {
                          final stylist = stylists[index];
                          final stylistData = stylist.data() as Map<String, dynamic>;
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                selectedStylist = stylistData;
                                isExpanded = false;
                              });
                            },
                            child: Container(
                              padding: EdgeInsets.all(8),
                              child: Column(
                                children: [
                                  ClipRRect(
                                    borderRadius: BorderRadius.circular(20), // Đặt BorderRadius cho hình ảnh
                                    child: Image.network(
                                      stylistData['image'],
                                      width: 120, // Đặt chiều rộng của ảnh là 200
                                      height: 150, // Đặt chiều cao của ảnh là 200
                                      errorBuilder: (context, error, stackTrace) => Icon(
                                        Icons.person,
                                        size: 40,
                                        color: Colors.white70,
                                      ),
                                      fit: BoxFit.cover, // Đảm bảo hình ảnh điền đầy khung hình
                                    ),
                                  ),
                                  SizedBox(height: 8),
                                  Text(
                                    "Tên thợ: " + stylistData['NameWork'],
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 20, color: Colors.white),
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Số sao: ",
                                        style: TextStyle(fontSize: 20, color: Colors.white),
                                      ),
                                      Row(
                                        children: List.generate(
                                          int.parse(stylistData['rate']), // Chuyển đổi số sao thành số nguyên
                                              (index) => Icon(
                                            Icons.star, // Sử dụng biểu tượng ngôi sao từ thư viện icon của Flutter
                                            color: Colors.yellow, // Màu sắc của ngôi sao
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              )
                  : Container(),
            ),
            SizedBox(height: 30),
            if (selectedStylist != null)
              Container(
                decoration: BoxDecoration(color: Colors.indigo, borderRadius: BorderRadius.circular(30)),
                padding: EdgeInsets.all(16),
                child: Row(
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20), // Đặt BorderRadius cho hình ảnh
                      child: Image.network(
                        selectedStylist!['image'],
                        width: 120, // Đặt chiều rộng của ảnh là 200
                        height: 150, // Đặt chiều cao của ảnh là 200
                        errorBuilder: (context, error, stackTrace) => Icon(
                          Icons.person,
                          size: 40,
                          color: Colors.white70,
                        ),
                        fit: BoxFit.cover, // Đảm bảo hình ảnh điền đầy khung hình
                      ),
                    ),
                    SizedBox(width: 20),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Tên thợ: " + selectedStylist!['NameWork'],
                            style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500),
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                "Số sao: ",
                                style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500),
                              ),
                              Row(
                                children: List.generate(
                                  int.parse(selectedStylist!['rate']), // Chuyển đổi số sao thành số nguyên
                                      (index) => Icon(
                                    Icons.star, // Sử dụng biểu tượng ngôi sao từ thư viện icon của Flutter
                                    color: Colors.yellow, // Màu sắc của ngôi sao
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }




    DateTime _selectedDate = DateTime.now();

    Future<void> _selectDate(BuildContext context) async {
      final DateTime now = DateTime.now();
      final DateTime initialDateTime = now.add(Duration(minutes: 30));

      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: now,
        firstDate: now,
        initialDatePickerMode: DatePickerMode.day, // Hiển thị chế độ chọn ngày
        initialEntryMode: DatePickerEntryMode.calendarOnly, // Hiển thị lịch ban đầu
        builder: (context, child) {
          return Theme(
            data: ThemeData.light().copyWith(
              colorScheme: ColorScheme.light(
                primary: Colors.red, // Đổi màu tiêu đề của DatePicker
                onPrimary: Colors.white, // Đổi màu chữ của tiêu đề
                onSurface: Colors.black, // Đổi màu chữ khi chọn ngày
              ),
              textButtonTheme: TextButtonThemeData(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.red, // Đổi màu chữ của nút
                ),
              ),
            ),
            child: child ?? SizedBox(),
          );
        },
        lastDate: DateTime(2025),
      );

      if (picked != null && picked != _selectedDate) {
        setState(() {
          _selectedDate = picked;
        });
      }
    }

    TimeOfDay _selectedTime = TimeOfDay.now();
    Future<void> _selectTime(BuildContext context) async {
      final DateTime now = DateTime.now();
      final DateTime initialDateTime = now.add(Duration(minutes: 30));

      final TimeOfDay initialTime = TimeOfDay.fromDateTime(initialDateTime);

      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: initialTime.replacing(minute: initialTime.minute ~/ 30 * 30), // Làm tròn giờ xuống để bắt đầu từ giờ chẵn
        builder: (context, child) {
          return MediaQuery(
            data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true), // Hiển thị định dạng 24 giờ
            child: child ?? SizedBox(),
          );
        },
      );

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
                  Text('Tên thợ: ${selectedStylist?['NameWork'] ?? 'Không chọn'}'),
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
        DateTime selectedDateTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTime.hour, _selectedTime.minute);
        if (selectedDateTime.isAfter(DateTime.now())) {
          // Tiếp tục đặt lịch nếu ngày giờ được chọn là sau thời gian hiện tại
          String? selectedWorkerName = selectedStylist?['NameWork'];
          Map<String, dynamic> userBookingmap = {
            'Name': name,
            'Service': widget.service,
            'Price': widget.price,
            'Image': image,
            'NameWork': selectedStylist?['NameWork'] ?? 'Không chọn',
            'Rate': selectedStylist?['rate'] ?? '0',
            'Time': _selectedTime.format(context),
            'Date': '${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',

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
                "Vui lòng chọn ngày giờ sau thời gian hiện tại.",
                style: TextStyle(fontSize: 20.0),
              )
          ));
        }
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
          child: Container(
            margin: EdgeInsets.only(left: 10, right: 10, bottom: 10, top: 10),
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
               Expanded(
                 child: SingleChildScrollView(
                   child: Column(
                     children: [
                       Text(
                         "Phục hồi tạo hình và tỏa sáng!",
                         style: TextStyle(
                             color: Colors.white,
                             fontSize: 28,
                             fontWeight: FontWeight.w500),
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
                       SingleChildScrollView(
                         child: stylist(
                         ),
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
                           padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
                       ),

                     ],
                   ),
                 ),
               )

              ],
            ),
          ),
        ),
      );
    }
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