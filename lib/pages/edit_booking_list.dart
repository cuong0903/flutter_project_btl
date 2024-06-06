import 'package:flutter/material.dart';
import 'package:flutter_project_btl/services/database.dart';

class EditBookingPage extends StatefulWidget {
  final String bookingId;

  const EditBookingPage({Key? key, required this.bookingId}) : super(key: key);

  @override
  _EditBookingPageState createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  TextEditingController _serviceController = TextEditingController();
  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();


  @override
  void initState() {
    super.initState();
    _loadBookingData();
  }

  Future<void> _loadBookingData() async {
    Map<String, dynamic>? bookingData = await DatabaseMethods().getBooking(widget.bookingId);
    if (bookingData != null) {
      setState(() {
        _serviceController.text = bookingData["Service"] ?? "";
        _dateController.text = bookingData["Date"] ?? "";
        _timeController.text = bookingData["Time"] ?? "";

      });
    }
  }

  Future<void> _updateBooking() async {
    String service = _serviceController.text.trim();
    String date = _dateController.text.trim();
    String time = _timeController.text.trim();

    if (service.isNotEmpty && date.isNotEmpty && time.isNotEmpty) {
      await DatabaseMethods().updateBooking(widget.bookingId, {
        "Service": service,
        "Date": date,
        "Time": time,

      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã cập nhật lịch đặt')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vui lòng điền đầy đủ thông tin cần thiết')));
    }
  }

  DateTime _selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2024),
      lastDate: DateTime(2025),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateController.text = "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}";
      });
    }
  }

  TimeOfDay _selectedTime = TimeOfDay.now();

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: _selectedTime);
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _timeController.text = _selectedTime.format(context);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7AB9EE),
      appBar: AppBar(
        title: Text('Sửa lịch đặt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _serviceController,
              decoration: InputDecoration(labelText: 'Dịch vụ'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _dateController,
              readOnly: true,
              onTap: () => _selectDate(context),
              decoration: InputDecoration(labelText: 'Ngày'),
            ),
            SizedBox(height: 20.0),
            TextField(
              controller: _timeController,
              readOnly: true,
              onTap: () => _selectTime(context),
              decoration: InputDecoration(labelText: 'Giờ'),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: _updateBooking,
              child: Text('Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }
}
