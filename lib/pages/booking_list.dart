import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_btl/pages/edit_booking_list.dart';
import 'package:flutter_project_btl/services/database.dart';
import 'package:intl/intl.dart';

// Widget StatefulWidget để hiển thị danh sách các đặt lịch.
class BookingList extends StatefulWidget {
  final String Name;
  final List<Map<String, dynamic>> services; // Danh sách các dịch vụ
  const BookingList({Key? key, required this.Name, required this.services}) : super(key: key);

  @override
  State<BookingList> createState() => _BookingListState();
}
// Trạng thái của trang danh sách đặt lịch.
class _BookingListState extends State<BookingList> {
  DateTime? selectedDate;
  String? selectedService;  // Dịch vụ được chọn để lọc danh sách đặt lịch.
  Stream? bookingStream; //  Luồng dữ liệu chứa danh sách các đặt lịch.
  // Danh sách giá của các dịch vụ
  final Map<String, String> servicePrices = {
    'Cạo râu': '50,000 VND',
    'Gội đầu': '30,000 VND',
    'Cắt tóc': '70,000 VND',
    'Cắt tỉa râu công nghệ': '80,000 VND',
    'Chăm sóc da mặt': '120,000 VND',
    'Cắt tóc trẻ em': '60,000 VND',
  };

  @override
  void initState() {
    super.initState();
    getOnLoad();
  }
// Phương thức để lấy danh sách đặt lịch khi trang được tải.
  getOnLoad() async {
    bookingStream = await DatabaseMethods().getBookings();
    setState(() {}); // Cập nhật giao diện
  }


  //  Phương thức để hiển thị tất cả các đặt lịch từ luồng dữ liệu Firestore.
  Widget allBookings() {
    return StreamBuilder(  // Widget để xây dựng giao diện dựa trên dữ liệu từ một luồng dữ liệu.
      stream: bookingStream,
      builder: (context, AsyncSnapshot snapshot) {
        if (!snapshot.hasData) {
          return Center(child: CircularProgressIndicator(color: Colors.white));
        }

        // Lọc danh sách đặt lịch dựa trên id của tài khoản đã đăng nhập
        List<DocumentSnapshot> allBookings = snapshot.data.docs
            .where((booking) => booking['Name'] == widget.Name)
            .toList();
        // Lọc danh sách đặt lịch dựa trên ngày và dịch vụ đã chọn
        List<DocumentSnapshot> filteredBookings = _filterBookings(allBookings);
        if (filteredBookings.isEmpty) {
          return Center(
            child: Text(
              'Chưa có lịch nào được booking',
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          );
        }

        return ListView.builder(
          padding: EdgeInsets.zero,
          itemCount: filteredBookings.length,// Số lượng item trong danh sách
          scrollDirection: Axis.vertical, // Hướng cuộn của danh sách
          // Hàm xây dựng mỗi item trong danh sách
          itemBuilder: (context, index) {
            // Lấy thông tin của một đặt lịch từ danh sách đã lọc
            DocumentSnapshot ds = filteredBookings[index];
            return Padding(
              padding: const EdgeInsets.only(bottom: 16.0),
              // Container chứa thông tin của mỗi đặt lịch
              child: Material(
                elevation: 8.0, // Độ nổi
                borderRadius: BorderRadius.circular(20), // Bo góc
                // Nội dung của container
                child: Container(
                  padding: EdgeInsets.all(16),
                  width: MediaQuery.of(context).size.width,
                  // Định dạng nền container
                  decoration: BoxDecoration(
                    gradient: LinearGradient(colors: [
                      Color(0xFF1E88E5),
                      Color(0xFF1565C0),
                      Color(0xFF0D47A1)
                    ]),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  // Danh sách các widget con trong container
                  child: Column(
                    children: [
                      // Hiển thị hình ảnh đại diện của đặt lịch
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(30),
                          child: Image.network(
                            ds["Image"],
                            height: 60,
                            width: 60,
                            fit: BoxFit.cover,
                            // Hiển thị biểu tượng mặc định nếu không có hình ảnh
                            errorBuilder: (context, error, stackTrace) => Icon(
                              Icons.person,
                              size: 60,
                              color: Colors.white70,
                            ),
                          ),
                        ),
                        // Hiển thị tên của đặt lịch
                        title: Text(ds["Name"],
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold)),
                      ),
                      // Đường phân cách giữa các thông tin
                      Divider(color: Colors.white30),
                      SizedBox(height: 10.0),
                      _buildInfoRow(Icons.cut, "Dịch vụ: " + ds["Service"]),
                      _buildInfoRow(Icons.calendar_today, "Ngày: " + ds["Date"]),
                      _buildInfoRow(Icons.access_time, "Giờ: " + ds["Time"]),
                      _buildInfoRow(Icons.price_change_outlined, "Số tiền: " + ds["Price"]),
                      _buildInfoRow(Icons.person, "Tên thợ: " + ds["NameWork"]),
                      SizedBox(height: 20.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          // Nút để xóa đặt lịch
                          ElevatedButton.icon(
                            onPressed: () async {
                              // Hiển thị hộp thoại xác nhận trước khi xóa
                              bool confirm = await showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    title: Text('Xác nhận'),
                                    content: Text('Bạn có chắc chắn muốn xóa lịch đặt này không? Hành động này không thể hoàn tác.'),
                                    actions: [
                                      TextButton(
                                          child: Text('Hủy'),
                                          onPressed: () => Navigator.of(context).pop(false)),
                                      ElevatedButton(
                                          child: Text('Xóa'),
                                          style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.red),
                                          onPressed: () => Navigator.of(context).pop(true)),
                                    ],
                                  );
                                },
                              ) ?? false;
                              // Nếu người dùng xác nhận xóa, thực hiện xóa đặt lịch
                              if (confirm) {
                                await DatabaseMethods().DeleteBooking(ds.id);
                                // Hiển thị thông báo sau khi xóa
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Đã xóa lịch đặt',style: TextStyle(fontSize: 18.0, color: Colors.white),)));
                                }
                              }
                            },
                            icon: Icon(Icons.delete_forever),
                            label: Text("Xóa lịch"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                foregroundColor: Colors.white),
                          ),
                          // Nút để chỉnh sửa đặt lịch
                          ElevatedButton.icon(
                            onPressed: () {
                              // Chuyển đến trang chỉnh sửa đặt lịch
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditBookingPage(
                                    bookingId: ds.id,
                                    services: widget.services,
                                    servicePrices: servicePrices,
                                  ),
                                ),
                              ).then((_) {
                                // Cập nhật lại dữ liệu sau khi chỉnh sửa
                                getOnLoad();
                              });
                            },
                            icon: Icon(Icons.edit),
                            label: Text("Sửa"),
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.orange,
                                foregroundColor: Colors.white),
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

// Tạo một hàng chứa một biểu tượng và một đoạn văn bản.
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
                    fontWeight: FontWeight.w500)),
          ),
        ],
      ),
    );
  }
  // Hiển thị các bộ lọc cho người dùng, bao gồm chọn ngày và chọn dịch vụ.
  Widget _buildFilters() {
    return Column(
      children: [
        Row(
          // sắp xếp các phần tử theo chiều ngang và căn giữa.
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            ElevatedButton(
              // Hiển thị hộp thoại chọn ngày khi người dùng nhấn vào nút
              onPressed: () async {
                final DateTime? pickedDate = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(), // Ngày mặc định khi mở hộp thoại
                  firstDate: DateTime.now(), // Ngày đầu tiên có thể chọn
                  lastDate: DateTime.now().add(Duration(days: 30)),
                );
                // Nếu ngày được chọn và khác với ngày đã chọn trước đó
                if (pickedDate != null && pickedDate != selectedDate) {
                  setState(() {
                    selectedDate = pickedDate;
                  });
                }
              },
              child: Text(selectedDate == null
                  ? 'Chọn ngày'  // Nếu chưa chọn ngày nào, hiển thị văn bản "Chọn ngày"
                  : 'Ngày: ${DateFormat('dd/MM/yyyy').format(selectedDate!)}'), // Nếu đã chọn ngày, hiển thị ngày đã chọn
            ),
            DropdownButton<String>(
              value: selectedService, // Dịch vụ được chọn
              onChanged: (String? newValue) {
                // Cập nhật trạng thái để hiển thị ngày đã chọn
                setState(() {
                  selectedService = newValue;
                });
              },
              // Tạo danh sách các mục cho DropdownButton dựa trên dữ liệu dịch vụ
              items: servicePrices.keys.map((String service) {
                return DropdownMenuItem<String>(
                  value: service,
                  child: Text(service), // Hiển thị tên dịch vụ
                );
              }).toList(),
              hint: Text('Chọn dịch vụ'),
            ),
          ],
        ),

      ],
    );
  }

 // Lọc danh sách đặt lịch dựa trên ngày và dịch vụ được chọn.
  List<DocumentSnapshot> _filterBookings(List<DocumentSnapshot> bookings) {
    // Lọc danh sách đặt lịch dựa trên ngày và dịch vụ được chọn
    if (selectedDate != null) {
      bookings = bookings.where((booking) {
        // Chuyển đổi chuỗi ngày trong đặt lịch thành đối tượng DateTime
        String dateString = booking['Date'];
        DateTime bookingDate = DateFormat('dd/MM/yyyy').parse(dateString);
        // So sánh ngày đặt lịch với ngày được chọn
        return bookingDate.year == selectedDate!.year &&
            bookingDate.month == selectedDate!.month &&
            bookingDate.day == selectedDate!.day;
      }).toList();
    }
    // Lọc danh sách đặt lịch dựa trên dịch vụ được chọn
    if (selectedService != null) {
      bookings = bookings.where((booking) => booking['Service'] == selectedService).toList();
    }
    return bookings;
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
        backgroundColor: Colors.transparent,//AppBar có màu nền trong suốt (Colors.transparent)
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
        // Khi nhấn nút làm mới, cập nhật lại danh sách đặt lịch và bộ lọc
            onPressed: () {
              setState(() {
                selectedDate = null;
                selectedService = null;
                getOnLoad(); // Lấy lại danh sách đặt lịch
              });
            },
          ),
        ],
      ),
      body: Container(
        margin: EdgeInsets.only(top: 20.0, left: 20.0, right: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildFilters(),// bộ lọc
            SizedBox(height: 20),
            Expanded(
              //  danh sách đặt lịch
              child: allBookings(),
            ),
          ],
        ),
      ),
    );
  }
}
