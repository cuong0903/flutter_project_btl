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

  final Map<String, String> defaultServicePrices = {
    'Cạo râu': '50,000 VND',
    'Gội đầu': '30,000 VND',
    'Cắt tóc': '70,000 VND',
    'Cắt tỉa râu công nghệ': '80,000 VND',
    'Chăm sóc da mặt': '120,000 VND',
    'Cắt tóc trẻ em': '60,000 VND',
  };
  late List<Map<String, dynamic>> services;
  late Map<String, String> servicePrices = Map.from(defaultServicePrices);

  // // Service list
  // late List<Map<String, dynamic>> services;
  // late Map<String, String> servicePrices;

  @override
  void initState() {
    super.initState();
    _initializeServices();
    getontheload();
    servicePrices = Map.from(defaultServicePrices);
  }

  void _initializeServices() {
    services = [
      {
        'title': 'Cạo râu',
        'imagePath': 'images/shaving.png',
        'color': Color(0xFF9575CD),
        'onTap': () => _navigateToBooking('Cạo râu'),
        'price': servicePrices['Cạo râu'],
      },
      {
        'title': 'Gội đầu',
        'imagePath': 'images/hair.png',
        'color': Color(0xFFFFB74D),
        'onTap': () => _navigateToBooking('Gội đầu'),
        'price': servicePrices['Gội đầu'],
      },
      {
        'title': 'Cắt tóc',
        'imagePath': 'images/cutting.png',
        'color': Color(0xFF4CAF50),
        'onTap': () => _navigateToBooking('Cắt tóc'),
        'price': servicePrices['Cắt tóc'],
      },
      {
        'title': 'Cắt tỉa râu công nghệ',
        'imagePath': 'images/beard.png',
        'color': Color(0xFFEF5350),
        'onTap': () => _navigateToBooking('Cắt tỉa râu công nghệ'),
        'price': servicePrices['Cắt tỉa râu công nghệ'],
      },
      {
        'title': 'Chăm sóc da mặt',
        'imagePath': 'images/facials.png',
        'color': Color(0xFF29B6F6),
        'onTap': () => _navigateToBooking('Chăm sóc da mặt'),
        'price': servicePrices['Chăm sóc da mặt'],
      },
      {
        'title': 'Cắt tóc trẻ em',
        'imagePath': 'images/kids.png',
        'color': Color(0xFFFFCA28),
        'onTap': () => _navigateToBooking('Cắt tóc trẻ em'),
        'price': servicePrices['Cắt tóc trẻ em'],
      },
    ];
  }

  void _navigateToBooking(String service) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Booking(service: service, price: servicePrices[service] ?? 'Giá không xác định'),
      ),
    );
  }

  Future<void> getthedatafromsharedpred() async {
    Name = await SharedpreferenceHelper().getUserName();
    image = await SharedpreferenceHelper().getUserImage();
    id = await SharedpreferenceHelper().getUserId();
    setState(() {});
  }

  Future<void> getontheload() async {
    await getthedatafromsharedpred();
    servicePrices = Map.from(defaultServicePrices);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7AB9EE),
      body: Container(
        margin: EdgeInsets.only(top: 50.0, left: 20.0, right: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
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
                children: services.map((service) {
                  return _buildServiceCard(
                    service['title']!,
                    service['imagePath']!,
                    service['color']!,
                    service['onTap']!,
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Xin chào, ", style: TextStyle(color: Colors.white, fontSize: 20.0, fontWeight: FontWeight.w500)),
            Text(Name ?? "Người dùng", style: TextStyle(color: Colors.white, fontSize: 22.0, fontWeight: FontWeight.bold))
          ],
        ),
        GestureDetector(
          onTap: () {
            _showPopupMenu();
          },
          child: Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: image == null
                  ? Image.asset("images/images.png", height: 60, width: 60, fit: BoxFit.cover)
                  : Image.network(image!, height: 60, width: 60, fit: BoxFit.cover),
            ),
          ),
        ),
      ],
    );
  }

  void _showPopupMenu() {
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
        _buildPopupMenuItem(Icons.calendar_today, 'Lịch của bạn', () => Navigator.push(context, MaterialPageRoute(builder: (context) => BookingList(Name: Name ?? '', services: services)))),
        _buildPopupMenuItem(Icons.lock, 'Đổi mật khẩu', () => Navigator.push(context, MaterialPageRoute(builder: (context) => ChangePassword(userId: id ?? '')))),
        _buildPopupMenuItem(Icons.logout, 'Đăng xuất', () => Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Login()))),
      ],
    );
  }

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
}
