import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_btl/services/database.dart';

class EditBookingPage extends StatefulWidget {
  final String bookingId;
  final List<Map<String, dynamic>> services;
  final Map<String, String> servicePrices; // Lưu trữ giá dịch vụ
  const EditBookingPage({
    Key? key,
    required this.bookingId,
    required this.services,
    required this.servicePrices,  // Dự kiến là một Map<String, String> chứa tên dịch vụ và giá của nó
  }) : super(key: key);

  @override
  _EditBookingPageState createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  final DatabaseMethods databaseMethods = DatabaseMethods();// Đối tượng để giao tiếp với cơ sở dữ liệu

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  String _selectedService = "";
  String _selectedStylist = "";
  String _selectedPrice = "";

  List<DropdownMenuItem<String>> stylistItems = []; // Danh sách các mục DropdownMenuItem để chọn nhà tạo mẫu

  @override
  void initState() {
    super.initState();
    _loadBookingData(); // Load dữ liệu đặt lịch khi widget được khởi tạo
    _loadStylistData(); // Load dữ liệu của các nhà tạo mẫu khi widget được khởi tạo
  }
// Cập nhật giá địch vụ được chọn
  void _updatePrice(String? newValue) {
    if (newValue != null) {
      _selectedPrice = widget.servicePrices[newValue] ?? ""; // Cập nhật giá dựa trên dịch vụ được chọn
    }
  }


  // Hàm tải dữ liệu của các nhà tạo mẫu từ cơ sở dữ liệu Firestore
  Future<void> _loadStylistData() async {
    try {
      QuerySnapshot snapshot = await FirebaseFirestore.instance.collection("Stylist").get();
      List<DropdownMenuItem<String>> items = [];
      // if (!snapshot.docs.any((doc) => doc['NameWork'] == "Không chọn")) {
      //   items.add(DropdownMenuItem<String>(
      //     value: "Không chọn",
      //     child: Text("Không chọn"),
      //   ));
      // }

      // Thêm tên thợ vào danh sách
      snapshot.docs.forEach((doc) {
        items.add(DropdownMenuItem<String>(
          value: doc['NameWork'],
          child: Row(
            children: [
              // Hiển thị hình ảnh
              ClipRRect(
                borderRadius: BorderRadius.circular(30),
                child: Image.network(
                  doc['image'],
                  height: 30,
                  width: 30,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(width: 10), // Khoảng cách giữa hình ảnh và văn bản
              // Hiển thị văn bản
              Text(doc['NameWork']),
            ],
          ),
        ));
      });
      setState(() {
        stylistItems = items; // Cập nhật danh sách các nhà tạo mẫu
      });
    } catch (e) {

    }
  }

// Hàm xử lý sự kiện khi dịch vụ được chọn thay đổi
  void _onServiceChanged(String? newValue) {
    setState(() {
      _selectedService = newValue ?? ""; // Cập nhật dịch vụ được chọn
      _updatePrice(newValue);  // Gửi giá trị mới cho hàm _updatePrice để cập nhật giá
    });
  }

  // Hàm tải dữ liệu của lịch đặt từ cơ sở dữ liệu Firestore
  Future<void> _loadBookingData() async {
    Map<String, dynamic>? bookingData = await databaseMethods.getBooking(widget.bookingId);
    if (bookingData != null) {
      setState(() {
        _selectedService = bookingData["Service"] ?? "";
        _selectedPrice = widget.servicePrices[_selectedService] ?? "";
        _dateController.text = bookingData["Date"] ?? "";
        _timeController.text = bookingData["Time"] ?? "";
        _selectedStylist = bookingData["NameWork"] ?? "";
      });
    }
  }

  // Hàm cập nhật thông tin của lịch đặt lên cơ sở dữ liệu Firestore
  Future<void> _updateBooking() async {
    String date = _dateController.text.trim();
    String time = _timeController.text.trim();

    if (_selectedService.isNotEmpty && date.isNotEmpty && time.isNotEmpty) {
      await databaseMethods.updateBooking(widget.bookingId, {
        "Service": _selectedService,
        "Price": _selectedPrice,
        "Date": date,
        "Time": time,
        "NameWork": _selectedStylist,

      });
      // Gửi thông tin cập nhật lên cơ sở dữ liệu
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Sửa lịch thành công!', style: TextStyle(fontSize: 18.0, color: Colors.white),)));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vui lòng điền đầy đủ thông tin cần thiết',style: TextStyle(fontSize: 18.0, color: Colors.white),)));
    }
  }
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 30)),
    );

// Kiểm tra xem người dùng đã chọn ngày hay chưa
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}"; // Hiển thị ngày đã chọn
      });
    }
  }

  // Hàm xử lý sự kiện khi người dùng chọn giờ từ TimePicker
  Future<void> _selectTime(BuildContext context) async {
    // Hiển thị TimePicker và chờ người dùng chọn giờ
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    // Kiểm tra xem người dùng đã chọn giờ hay chưa
    if (picked != null) {
      setState(() {
        _timeController.text = "${picked.hour}:${picked.minute}"; // Hiển thị giờ đã chọn
        // Format giờ được chọn thành dạng 'HH:MM' và hiển thị trong trường nhập liệu
      });
    }

  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Booking'),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedService.isNotEmpty ? _selectedService : null,
                onChanged: _onServiceChanged,// chọn dịch vụ
                items: widget.services.map((service) {
                  String title = service['title'];
                  String price = widget.servicePrices[title] ?? ''; // Lấy giá dựa trên tên dịch vụ
                  return DropdownMenuItem<String>(
                    value: title,
                    child: Text('$title - $price'),// Hiển thị tên dịch vụ và giá
                  );
                }).toList(),
                decoration: InputDecoration(
                  labelText: 'Service',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                ),
              ),

              SizedBox(height: 20.0),
              TextField(
                controller: _dateController,
                readOnly: true,
                onTap: () => _selectDate(context), // Gọi hàm chọn ngày khi TextField được nhấn
                decoration: InputDecoration(labelText: 'Date'),
              ),
              SizedBox(height: 20.0),
              TextField(
                controller: _timeController,
                readOnly: true,
                onTap: () => _selectTime(context),
                decoration: InputDecoration(labelText: 'Time'),
              ),
              SizedBox(height: 20.0),
              DropdownButtonFormField<String>(
                value: _selectedStylist.isNotEmpty ? _selectedStylist : null,
                onChanged: (value) {
                  setState(() {
                    _selectedStylist = value ?? "";
                  });
                },
                items: stylistItems,
                decoration: InputDecoration(
                  labelText: 'Stylist',
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
                ),
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _updateBooking, // Nút để cập nhật thông tin đặt lịch
                child: Text('Cập nhật'),
              ),
            ],
          ),
        ),
      ),
    );
  }
  // Hàm xử lý sự kiện khi người dùng chọn ngày từ DatePicker

}
