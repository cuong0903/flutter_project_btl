import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_btl/services/database.dart';

class EditBookingPage extends StatefulWidget {
  final String bookingId;
  final List<Map<String, dynamic>> services;
  final Map<String, String> servicePrices; // <-- Expects a Map<String, String>

  const EditBookingPage({
    Key? key,
    required this.bookingId,
    required this.services,
    required this.servicePrices, // <-- Expects a Map<String, String>
  }) : super(key: key);

  @override
  _EditBookingPageState createState() => _EditBookingPageState();
}

class _EditBookingPageState extends State<EditBookingPage> {
  final DatabaseMethods databaseMethods = DatabaseMethods();

  TextEditingController _dateController = TextEditingController();
  TextEditingController _timeController = TextEditingController();
  String _selectedService = "";
  String _selectedStylist = "";
  String _selectedPrice = "";

  @override
  void initState() {
    super.initState();
    _loadBookingData();

  }
  void _updatePrice() {
    _selectedPrice = widget.servicePrices[_selectedService] ?? "";
  }

  Future<void> _loadBookingData() async {
    Map<String, dynamic>? bookingData = await databaseMethods.getBooking(widget.bookingId);
    if (bookingData != null) {
      setState(() {
        _selectedService = bookingData["Service"] ?? "";
        _selectedPrice = widget.servicePrices[_selectedService] ?? ""; // Lấy giá dịch vụ từ Map servicePrices
        _dateController.text = bookingData["Date"] ?? "";
        _timeController.text = bookingData["Time"] ?? "";
        _selectedStylist = bookingData["NameWork"] ?? "";
      });
    }
  }

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
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Booking has been updated')));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Please fill in all necessary information')));
    }
  }

  Future<QuerySnapshot> getStylist() async {
    return await FirebaseFirestore.instance.collection("Stylist").get();
  }

  void _onServiceChanged(String? newValue) {
    setState(() {
      _selectedService = newValue ?? "";
      _updatePrice(); // Update the price when the service is changed
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Booking'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DropdownButtonFormField<String>(
                value: _selectedService.isNotEmpty ? _selectedService : null,
                onChanged: _onServiceChanged,
                items: widget.services.map((service) {
                  return DropdownMenuItem<String>(
                    value: service['title'],
                    child: Text(service['title']),
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
                onTap: () => _selectDate(context),
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
              FutureBuilder<QuerySnapshot>(
                future: getStylist(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<DropdownMenuItem<String>> items = [];
                    if (snapshot.data == null) {
                      items.add(DropdownMenuItem<String>(
                        value: "",
                        child: Text("Không chọn"),
                      ));
                      snapshot.data!.docs.forEach((doc) {
                        items.add(DropdownMenuItem<String>(
                          value: doc['NameWork'],
                          child: Text(doc['NameWork']),
                        ));
                      });
                    } else {
                      if (!snapshot.data!.docs.any((doc) => doc['NameWork'] == "")) {
                        items.add(DropdownMenuItem<String>(
                          value: "Không chọn",
                          child: Text("Không chọn"),
                        ));
                      }
                      snapshot.data!.docs.forEach((doc) {
                        items.add(DropdownMenuItem<String>(
                          value: doc['NameWork'],
                          child: Text(doc['NameWork']),
                        ));
                      });
                    }

                    return DropdownButtonFormField<String>(
                      value: _selectedStylist.isNotEmpty ? _selectedStylist : null,
                      onChanged: (value) {
                        setState(() {
                          _selectedStylist = value ?? "";
                        });
                      },
                      items: items,
                      decoration: InputDecoration(
                        labelText: 'Stylist',
                        border: OutlineInputBorder(),
                        contentPadding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      ),
                    );
                  }
                },
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _updateBooking,
                child: Text('Update'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day}/${picked.month}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(context: context, initialTime: TimeOfDay.now());
    if (picked != null) {
      setState(() {
        _timeController.text = "${picked.hour}:${picked.minute}";
      });
    }
  }
}
