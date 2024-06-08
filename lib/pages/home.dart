import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_btl/pages/booking.dart';
import 'package:flutter_project_btl/pages/booking_list.dart';
import 'package:flutter_project_btl/pages/infoAccount.dart';
import 'package:flutter_project_btl/pages/resetPassword.dart';
import 'package:flutter_project_btl/services/shared_pred.dart';
import 'login.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? Name, image, id;

  // Khai báo giá dịch vụ mặc định
  final Map<String, String> defaultServicePrices = {
    'Cạo râu': '50,000 VND',
    'Gội đầu': '30,000 VND',
    'Cắt tóc': '70,000 VND',
    'Cắt tỉa râu công nghệ': '80,000 VND',
    'Chăm sóc da mặt': '120,000 VND',
    'Cắt tóc trẻ em': '60,000 VND',
  };

  // Khai báo danh sách dịch vụ và giá dịch vụ
  late List<Map<String, dynamic>> services;
  late Map<String, String> servicePrices =
      Map.from(defaultServicePrices); // Sao chép giá dịch vụ mặc định

// Phương thức initState được gọi khi trạng thái được khởi tạo
  @override
  void initState() {
    super.initState();
    _initializeServices();
    getontheload();
    servicePrices =
        Map.from(defaultServicePrices); // Sao chép giá dịch vụ mặc định
  }

  // Khởi tạo danh sách dịch vụ
  void _initializeServices() {
    services = [
      {
        'title': 'Cạo râu',
        'imagePath': 'images/shaving.png',
        'color': Color(0xFF9575CD),
        'onTap': () => _navigateToBooking('Cạo râu'),
      },
      {
        'title': 'Gội đầu',
        'imagePath': 'images/hair.png',
        'color': Color(0xFFFFB74D),
        'onTap': () => _navigateToBooking('Gội đầu'),
      },
      {
        'title': 'Cắt tóc',
        'imagePath': 'images/cutting.png',
        'color': Color(0xFF4CAF50),
        'onTap': () => _navigateToBooking('Cắt tóc'),
      },
      {
        'title': 'Cắt tỉa râu công nghệ',
        'imagePath': 'images/beard.png',
        'color': Color(0xFFEF5350),
        'onTap': () => _navigateToBooking('Cắt tỉa râu công nghệ'),
      },
      {
        'title': 'Chăm sóc da mặt',
        'imagePath': 'images/facials.png',
        'color': Color(0xFF29B6F6),
        'onTap': () => _navigateToBooking('Chăm sóc da mặt'),
      },
      {
        'title': 'Cắt tóc trẻ em',
        'imagePath': 'images/kids.png',
        'color': Color(0xFFFFCA28),
        'onTap': () => _navigateToBooking('Cắt tóc trẻ em'),
      },
    ];
  }

  // Điều hướng tới trang đặt lịch với dịch vụ tương ứng
  void _navigateToBooking(String service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Booking(
            service: service,
            price: servicePrices[service] ?? 'Giá không xác định'),
      ),
    );
  }

// Lấy dữ liệu từ Shared Preferences
  Future<void> getthedatafromsharedpred() async {
    Name = await SharedpreferenceHelper().getUserName();
    image = await SharedpreferenceHelper().getUserImage();
    id = await SharedpreferenceHelper().getUserId();
    setState(() {}); // cập nhật trạng thái
  }

  // Gọi phương thức lấy dữ liệu khi tải trang
  Future<void> getontheload() async {
    await getthedatafromsharedpred();
    servicePrices =
        Map.from(defaultServicePrices); // Sao chép giá dịch vụ mặc định
    setState(() {});
  }

  // Hàm để xử lý đăng xuất
  Future<void> _signOut() async {
    try {
      await FirebaseAuth.instance.signOut(); // Đăng xuất
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => Login()),
      );
    } catch (e) {
      // Xử lý lỗi (ví dụ: hiển thị snackbar)
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
          'Đăng xuất thất bại. Vui lòng thử lại.',
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        )),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7AB9EE),
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20), // căn lề
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start, // căn lề trái
          children: [
            _buildHeader(), //  // Xây dựng phần header
            SizedBox(height: 20.0),
            Divider(color: Colors.white54),
            SizedBox(height: 20.0),
            Text("Dịch vụ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold)),
            SizedBox(height: 20.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                // cột
                childAspectRatio: 1,
                // tỷ lệ khung
                mainAxisSpacing: 20,
                // khoảng cách hàng
                crossAxisSpacing: 20,
                // cột
                children: services.map((service) {
                  return _buildServiceCard(
                    service['title']!,
                    service['imagePath']!,
                    service['color']!,
                    service['onTap']!,
                  );
                }).toList(), // Tạo các thẻ từ danh sách dịch vụ
              ),
            ),
          ],
        ),
      ),
    );
  }

// Xây dựng phần header
  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween, // Căn giữa 2 đầu
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Xin chào, ",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20.0,
                    fontWeight: FontWeight.w500)),
            Text(Name ?? "Người dùng",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 22.0,
                    fontWeight: FontWeight.bold))
          ],
        ),
        GestureDetector(
          onTap: () {
            _showPopupMenu(); // Hiện thị menupop
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle, // hình tròn
              border: Border.all(color: Colors.white, width: 2), // viền trắng
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30), // Làm tròn góc
              child: image == null
                  ? Image.asset("images/images.png",
                      height: 60, width: 60, fit: BoxFit.cover)
                  : Image.network(image!,
                      height: 60, width: 60, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }

  // Hiển thị menu popup
  void _showPopupMenu() {
    final RenderObject? overlay =
        Overlay.of(context).context.findRenderObject(); // Lấy đối tượng Overlay
    final RelativeRect position = RelativeRect.fromLTRB(
      MediaQuery.of(context).size.width - 50,
      100.0,
      MediaQuery.of(context).size.width - 10,
      0.0,
    ); // Vị trí của menu popup
    showMenu(
      context: context,
      position: position,
      items: [
        _buildPopupMenuItem(
            Icons.account_circle,
            'Thông tin tài khoản',
            () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Infoaccount(userId: id ?? '')))),
        _buildPopupMenuItem(
            Icons.calendar_today,
            'Lịch của bạn',
            () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        BookingList(Name: Name ?? '', services: services)))),
        _buildPopupMenuItem(
            Icons.lock,
            'Đổi mật khẩu',
            () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ChangePassword(userId: id ?? '')))),
        _buildPopupMenuItem(
          Icons.logout,
          'Đăng xuất',
          _signOut,
        ),
      ],
    );
  }

  // Xây dựng thẻ dịch vụ
  Widget _buildServiceCard(
      String title, String imagePath, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20), // Làm tròn góc
          boxShadow: [
            BoxShadow(
                color: Colors.black26,// Màu bóng
                blurRadius: 5, // Độ mờ của bóng
                offset: Offset(0, 3))// vị trí
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 80, width: 80, fit: BoxFit.cover),
            SizedBox(height: 10.0),
            Text(title,
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 16.0,
                    fontWeight: FontWeight.bold)),
            Text(servicePrices[title] ?? 'Giá không xác định',
                style: TextStyle(color: Colors.white, fontSize: 14.0)),
          ],
        ),
      ),
    );
  }

  // Xây dựng item menu popup
  PopupMenuItem _buildPopupMenuItem(
      IconData icon, String title, VoidCallback onTap) {
    return PopupMenuItem(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue), // Biểu tượng
        title: Text(title),
        onTap: () {
          Navigator.pop(context);  // Đóng menu popup
          onTap();
        },
      ),
    );
  }
}
