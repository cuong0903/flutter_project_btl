import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_btl/services/database.dart';

import '../services/shared_pred.dart';

class Booking extends StatefulWidget {
  final String service;
  final String price;

  Booking({required this.service, required this.price}); // Cập nhật constructor

  @override
  State<Booking> createState() => _BookingState();
}

class _BookingState extends State<Booking> {
  Stream? stylistStream;
  String? name, image, price, NameWork;
  bool isExpanded = false;
  Map<String, dynamic>? selectedStylist;
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _selectedDate = DateTime.now();
  String formattedTime = '';

  // Hàm async để lấy dữ liệu từ SharedPreferences và Firestore khi widget được tạo.
  getOnLoad() async {
    getthedatafromsharedpred(); // Lấy dữ liệu từ SharedPreferences
    stylistStream = await DatabaseMethods()
        .getStylist(); // Lấy dữ liệu Stylist từ Firestore
    setState(() {});
  }

  // Hàm async để lấy name và image từ SharedPreferences.
  getthedatafromsharedpred() async {
    name = await SharedpreferenceHelper().getUserName();
    image = await SharedpreferenceHelper().getUserImage();
    setState(() {});
  }

  // Hàm được gọi khi widget được tạo, gọi getOnLoad()  khởi tạo dữ liệu.
  @override
  void initState() {
    getOnLoad();
    super.initState();
  }

  //  Hàm async hiển thị TimePicker để người dùng chọn giờ.
  //  Nó sử dụng showTimePicker từ Flutter.
  Future<void> _selectTime(BuildContext context) async {
    final DateTime now = DateTime.now();
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(alwaysUse24HourFormat: true),
          // Hiển thị định dạng 24 giờ
          child: child ?? SizedBox(),
        );
      },
      initialTime: _selectedTime,
    );

    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  //Hàm async hiển thị DatePicker để người dùng chọn ngày.
  // Nó sử dụng showDatePicker từ Flutter và tùy chỉnh giao diện bằng ThemeData.
  Future<void> _selectDate(BuildContext context) async {
    final DateTime now = DateTime.now();
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      initialDatePickerMode: DatePickerMode.day,
      // Hiển thị chế độ chọn ngày
      initialEntryMode: DatePickerEntryMode.calendarOnly,
      // Hiển thị lịch ban đầu
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
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  // Widget hiển thị danh sách Stylist
  Widget stylist() {
    return Container(
      child: Column(
        children: [
          // Sử dụng GestureDetector để bắt sự kiện tap và thay đổi isExpanded.
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
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500),
                  ),
                  Icon(
                      isExpanded ? Icons.arrow_drop_up : Icons.arrow_drop_down),
                ],
              ),
            ),
          ),
          // AnimatedContainer để tạo hiệu ứng mở/đóng danh sách.
          AnimatedContainer(
            duration: Duration(milliseconds: 30),
            height: isExpanded ? 265.0 : 10,
            child: isExpanded
                // StreamBuilder để hiển thị danh sách stylist từ stylistStream.
                ? StreamBuilder(
                    stream: stylistStream,
                    builder: (context, AsyncSnapshot snapshot) {
                      if (!snapshot.hasData) {
                        return Center(
                            child:
                                CircularProgressIndicator(color: Colors.white));
                      }
                      List<DocumentSnapshot> stylists = snapshot.data.docs;
                      return SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          //tạo ra một danh sách các widget.
                          children: List.generate(
                            stylists.length,
                            (index) {
                              // Lấy stylist hiện tại từ danh sách stylists dựa trên chỉ số index.
                              final stylist = stylists[index];
                              final stylistData =
                                  stylist.data() as Map<String, dynamic>;
                              return GestureDetector(
                                onTap: () {
                                  setState(() {
                                    // Gán dữ liệu
                                    selectedStylist = stylistData;
                                    isExpanded = false;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.all(8),
                                  child: Column(
                                    children: [
                                      // Sử dụng ClipRRect và Image.network để hiển thị ảnh stylist với bo góc.
                                      ClipRRect(
                                        borderRadius: BorderRadius.circular(20),
                                        // Đặt BorderRadius cho hình ảnh
                                        child: Image.network(
                                          stylistData['image'],
                                          width:
                                              120, // Đặt chiều rộng của ảnh là 200
                                          height:
                                              150, // Đặt chiều cao của ảnh là 200
                                          errorBuilder:
                                              (context, error, stackTrace) =>
                                                  Icon(
                                            Icons.person,
                                            size: 40,
                                            color: Colors.white70,
                                          ),
                                          fit: BoxFit
                                              .cover, // Đảm bảo hình ảnh điền đầy khung hình
                                        ),
                                      ),
                                      SizedBox(height: 8),
                                      Text(
                                        "Tên thợ: " + stylistData['NameWork'],
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontSize: 20, color: Colors.white),
                                      ),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            "Số sao: ",
                                            style: TextStyle(
                                                fontSize: 20,
                                                color: Colors.white),
                                          ),
                                          Row(
                                            children: List.generate(
                                              int.parse(stylistData['rate']),
                                              // Chuyển đổi số sao thành số nguyên
                                              (index) => Icon(
                                                Icons.star,
                                                // Sử dụng biểu tượng ngôi sao từ thư viện icon của Flutter
                                                color: Colors
                                                    .yellow, // Màu sắc của ngôi sao
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
          SizedBox(height: 10),

          if (selectedStylist != null)
            Container(
              decoration: BoxDecoration(
                  color: Colors.indigo,
                  borderRadius: BorderRadius.circular(30)),
              padding: EdgeInsets.all(16),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    // Đặt BorderRadius cho hình ảnh
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
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20.0,
                              fontWeight: FontWeight.w500),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              "Số sao: ",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w500),
                            ),
                            Row(
                              children: List.generate(
                                int.parse(selectedStylist!['rate']),
                                // Chuyển đổi số sao thành số nguyên
                                (index) => Icon(
                                  Icons.star,
                                  // Sử dụng biểu tượng ngôi sao từ thư viện icon của Flutter
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

  //Hiển thị AlertDialog để xác nhận thông tin đặt lịch.
  Future<void> _showConfirmationDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          //AlertDialog: Widget hiển thị hộp thoạ
          title: Text('Xác nhận đặt lịch'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bạn có chắc chắn muốn đặt lịch không?'),
                Text('Dịch vụ: ${widget.service}'),
                Text(
                    'Ngày: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}'),
                Text('Giờ: ${_selectedTime.format(context)}'),
                Text(
                    'Tên thợ: ${selectedStylist?['NameWork'] ?? 'Không chọn'}'),
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
  // kiểm tra xem một khoảng thời gian cụ thể có sẵn để đặt lịch
  Future<bool> isTimeSlotAvailable(DateTime date, TimeOfDay time) async {
    // Tạo DateTime từ ngày và giờ đã chọn
    final startTime = DateTime(date.year, date.month, date.day, time.hour, time.minute);
    final endTime = startTime.add(Duration(minutes: 30));

    // Truy vấn Firestore để kiểm tra khoảng thời gian đã chọn
    final querySnapshot = await FirebaseFirestore.instance
        .collection('Booking')
        .where('startTime', isGreaterThanOrEqualTo: Timestamp.fromDate(startTime))
        .where('endTime', isLessThanOrEqualTo: Timestamp.fromDate(endTime))
        .get();

    // Trả về true nếu không có lịch đặt nào trong khoảng thời gian này,
    return querySnapshot.docs.isEmpty;
  }

  void _checkAvailabilityAndBook() async {
    // Kiểm tra tính khả dụng của khoảng thời gian
    final isAvailable = await isTimeSlotAvailable(_selectedDate, _selectedTime);
    if (!isAvailable) {
      _showSnackBar('Bạn phải đặt sau thời gian $formattedTime 30 PHÚT');
      return;
    }

    // Tạo DateTime từ ngày và giờ đã chọn
    final selectedDateTime = DateTime(_selectedDate.year, _selectedDate.month, _selectedDate.day, _selectedTime.hour, _selectedTime.minute);
    // Kiểm tra xem thời gian đã chọn có sau thời gian hiện tại không
    if (!selectedDateTime.isAfter(DateTime.now())) {
      _showSnackBar('Vui lòng chọn ngày giờ sau thời gian hiện tại.');
      return;
    }

    try {
      // Tạo map chứa thông tin đặt lịch
      final userBookingMap = {
        'Name': name,
        'Service': widget.service,
        'Price': widget.price,
        'Image': image,
        'NameWork': selectedStylist?['NameWork'],
        'Rate': selectedStylist?['rate'] ?? '0',
        'startTime': Timestamp.fromDate(selectedDateTime),
        'endTime': Timestamp.fromDate(selectedDateTime.add(Duration(minutes: 30))),
      };

      // Thêm thông tin đặt lịch vào Firestore
      await DatabaseMethods().addUserBooking(userBookingMap);
      _showSnackBar('Dịch vụ đã được đặt thành công!!!');
    } catch (e) {
      _showSnackBar('Đã xảy ra lỗi khi đặt lịch: $e');
    }
  }

  //Phương thức hiển thị một SnackBar với thông báo.
  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(fontSize: 20.0),
        ),
      ),
    );
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
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                // Dàn đều khoảng cách giữa các phần tử
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 30.0),
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
                    padding: const EdgeInsets.only(top: 50.0),
                    // Thêm padding cho chữ "service"
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
                    padding: const EdgeInsets.only(top: 50.0),
                    // Thêm padding để đảm bảo khoảng cách đều
                    child: SizedBox(
                        width:
                            30), // Thêm một phần tử ẩn để giữ khoảng cách đều
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
                          // decoration: BoxDecoration(
                          //   border: Border.all( // Tạo một đường viền với mọi cạnh đều có cùng một kiểu và độ dày
                          //     color: Colors.black, // Màu của đường viền
                          //     width: 0.0,
                          //
                          //     // Độ dày của đường viền
                          //   ),
                          // ),
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
                      SizedBox(
                        height: 30,
                      ),
                      SingleChildScrollView(
                        child: stylist(),
                      ),
                      SizedBox(
                        height: 10,
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
                                    onTap: () {
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
                                    onTap: () {
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
                                Text(_selectedTime.format(context),
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 30.0,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 30),
                      // Widget hiển thị thông tin tóm tắt đặt lịc
                      if ((selectedStylist != null))
                        Container(
                          padding: EdgeInsets.all(10),
                          // Khoảng cách bên trong của container.
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            // Đặt BorderRadius cho container.
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                Colors.purple.shade900, // Màu gradient bắt đầu.
                                Colors.black87, // Màu gradient kết thúc.
                              ],
                            ),
                          ),
                          child: Column(
                            children: [
                              Text(
                                "Tóm tắt đặt lịch",
                                style: TextStyle(
                                    color: Colors.white70,
                                    fontSize: 22), // Kiểu chữ của text.
                              ),
                              ListTile(
                                leading: Icon(Icons.calendar_today,
                                    color: Colors.white70), // Icon lịch.
                                title: Text(
                                  'Ngày: ${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}',
                                  // Hiển thị ngày đã chọn.
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18), // Kiểu chữ của text.
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.access_time,
                                    color: Colors.white70),
                                // Icon đồng hồ.
                                title: Text(
                                  'Giờ: ${_selectedTime.hour}:${_selectedTime.minute}', // Hiển thị giờ đã chọn.
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18), // Kiểu chữ của text.
                                ),
                              ),
                              ListTile(
                                leading:
                                    Icon(Icons.person, color: Colors.white70),
                                // Icon người.
                                title: Text(
                                  'Stylist: ${selectedStylist!['NameWork']}',
                                  // Hiển thị tên stylist đã chọn.
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18), // Kiểu chữ của text.
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.miscellaneous_services,
                                    color: Colors.white70), // Icon dịch vụ.
                                title: Text(
                                  'Dịch vụ: ${widget.service}',
                                  // Hiển thị dịch vụ đã chọn.
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18), // Kiểu chữ của text.
                                ),
                              ),
                              ListTile(
                                leading: Icon(Icons.attach_money,
                                    color: Colors.white70),
                                // Icon tiền.
                                title: Text(
                                  'Giá: ${widget.price}đ',
                                  // Hiển thị giá dịch vụ.
                                  style: TextStyle(
                                      color: Colors.white70,
                                      fontSize: 18), // Kiểu chữ của text.
                                ),
                              ),
                              SizedBox(height: 30),
                              ElevatedButton(
                                onPressed: () async {
                                  // Gọi hàm hiển thị dialog xác nhận đặt lịch.
                                  await _showConfirmationDialog();
                                },
                                child: Text(
                                  'Đặt Lịch',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20.0,
                                      fontWeight:
                                          FontWeight.w500), // Kiểu chữ của nút.
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.red,
                                  // Màu nền của nút.
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 40.0,
                                      vertical:
                                          15.0), // Khoảng cách bên trong của nút.
                                ),
                              ),
                            ],
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
