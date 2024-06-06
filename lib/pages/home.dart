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
  String? name, image, id, price;

  // Declare defaultServicePrices as a class member
  final Map<String, String> defaultServicePrices = {
    'Cạo râu': '50,000 VND',
    'Gội đầu': '30,000 VND',
    'Cắt tóc': '70,000 VND',
    'Cắt tỉa râu công nghệ': '80,000 VND',
    'Chăm sóc da mặt': '120,000 VND',
    'Cắt tóc trẻ em': '60,000 VND',
  };

  // Declare servicePrices as a class member
  late Map<String, String> servicePrices;

  // Hàm lấy dữ liệu từ SharedPreferences
  getthedatafromsharedpred() async {
    name = await SharedpreferenceHelper().getUserName();
    image = await SharedpreferenceHelper().getUserImage();
    id = await SharedpreferenceHelper().getUserId();
    setState(() {});
  }

  // Hàm gọi khi widget được tạo
  getontheload() async {
    await getthedatafromsharedpred();
    // Initialize servicePrices in getontheload method
    servicePrices = Map.from(defaultServicePrices);
    setState(() {});
  }

  @override
  void initState() {
    getontheload();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7AB9EE), // Màu nền chính: Xanh dương đậm
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Xin chào, ", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500)),
                    Text(name!, style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold))
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    final RenderObject? overlay = Overlay.of(context).context.findRenderObject();
                    final RelativeRect position = RelativeRect.fromLTRB(
                      MediaQuery.of(context).size.width - 50,
                      100.0,
                      MediaQuery.of(context).size.width - 10,
                      0.0,
                    );

                    showMenu(
                      context: context,
                      position: position,
                      items: [
                        _buildPopupMenuItem(Icons.account_circle, 'Thông tin tài khoản', () => Navigator.push(context, MaterialPageRoute(builder: (context) => Infoaccount(userId: id ?? '')))),
                        _buildPopupMenuItem(Icons.calendar_today, 'Lịch của bạn', () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookingList(Name: name ?? '')))),
                        _buildPopupMenuItem(Icons.lock, 'Đổi mật khẩu', () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword(userId: id ?? '')))),
                        _buildPopupMenuItem(Icons.logout, 'Đăng xuất', () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()))),
                      ],
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(30),
                        child: image != null ? Image.network(image!, height: 60, width: 60, fit: BoxFit.cover) : Image.asset("images/images.jpg")
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20.0),
            Divider(color: Colors.white54),
            SizedBox(height: 20.0),
            Text("Dịch vụ", style: TextStyle(color: Colors.white, fontSize: 24.0, fontWeight: FontWeight.bold)),
            SizedBox(height: 20.0),
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 1,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  _buildServiceCard('Cạo râu', 'images/shaving.png', Color(0xFF9575CD), () => _navigateToBooking('Cạo râu')),
                  _buildServiceCard('Gội đầu', 'images/hair.png', Color(0xFFFFB74D), () => _navigateToBooking('Gội đầu')),
                  _buildServiceCard('Cắt tóc', 'images/cutting.png', Color(0xFF4CAF50), () => _navigateToBooking('Cắt tóc')),
                  _buildServiceCard('Cắt tỉa râu công nghệ', 'images/beard.png', Color(0xFFEF5350), () => _navigateToBooking('Cắt tỉa râu công nghệ')),
                  _buildServiceCard('Chăm sóc da mặt', 'images/facials.png', Color(0xFF29B6F6), () => _navigateToBooking('Chăm sóc da mặt')),
                  _buildServiceCard('Cắt tóc trẻ em', 'images/kids.png', Color(0xFFFFCA28), () => _navigateToBooking('Cắt tóc trẻ em')),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget cho thẻ dịch vụ
  Widget _buildServiceCard(String title, String imagePath, Color color, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 5, offset: Offset(0, 3))],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(imagePath, height: 80, width: 80, fit: BoxFit.cover),
            SizedBox(height: 10.0),
            Text(title, textAlign: TextAlign.center, style: TextStyle(color: Colors.white, fontSize: 16.0, fontWeight: FontWeight.bold)),
            // Hiển thị giá của dịch vụ
            Text(servicePrices[title] ?? 'Giá không xác định', style: TextStyle(color: Colors.white, fontSize: 14.0)),
          ],
        ),
      ),
    );
  }

  PopupMenuItem _buildPopupMenuItem(IconData icon, String title, VoidCallback onTap) {
    return PopupMenuItem(
      child: ListTile(
        leading: Icon(icon, color: Colors.blue),
        title: Text(title),
        onTap: () {
          Navigator.pop(context);
          onTap();
        },
      ),
    );
  }

  // Hàm điều hướng đến trang đặt dịch vụ
  void _navigateToBooking(String service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Booking(service: service, price: servicePrices[service] ?? 'Giá không xác định'),
      ),
    );
  }
}
