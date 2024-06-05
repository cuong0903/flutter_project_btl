import 'package:flutter/material.dart';
import 'package:flutter_project_btl/Admin/admin_login.dart';
import 'package:flutter_project_btl/pages/booking.dart';
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

  String? name, image, id;
  getthedatafromsharedpred() async{
    name = await SharedpreferenceHelper().getUserName();
    image = await SharedpreferenceHelper().getUserImage();
    id = await SharedpreferenceHelper().getUserId(); // Thêm dòng này
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0x22b1615),
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
                    Text("Xin chào, ", style: TextStyle(color: Color.fromARGB(197,255, 255, 255),
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500),),
                    Text(name!, style: TextStyle(color: Colors.white,
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold),)
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: () {
                        // Lấy kích thước của màn hình
                        final RenderObject? overlay = Overlay.of(context).context.findRenderObject();
                        final RelativeRect position = RelativeRect.fromLTRB(
                          MediaQuery.of(context).size.width - 50,
                          100.0,
                          MediaQuery.of(context).size.width - 10,
                          0.0,
                        );

                        // Hiển thị menu khi widget được nhấn
                        showMenu(
                          context: context,
                          position: position,
                          items: [
                            PopupMenuItem(
                              child: ListTile(
                                leading: Icon(Icons.admin_panel_settings),
                                title: Text('Tài khoản admin'),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> AdminLogin()));
                                },
                              ),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                leading: Icon(Icons.account_circle),
                                title: Text('Thông tin tài khoản'),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> Infoaccount(userId: id ?? '',)));
                                },
                              ),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                leading: Icon(Icons.lock),
                                title: Text('Đổi mật khẩu'),
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> ChangePassword(userId: id ?? '',)));
                                },
                              ),
                            ),
                            PopupMenuItem(
                              child: ListTile(
                                leading: Icon(Icons.logout),
                                title: Text('Đăng xuất'),
                                onTap: () {
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(builder: (context) => Login()),
                                  );
                                },
                              ),
                            ),
                          ],
                        );
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(20),
                        child: image != null ? Image.network(image!, height: 60, width: 60, fit: BoxFit.cover) :
                        Image.asset("images/images.jpg")

                      ),
                    ),
                  ],
                ),



              ],

            ),
            SizedBox(height: 20.0,),
            Divider(
              color: Colors.white30,
            ),
            SizedBox(height: 20.0,),
            Text("Dịch vụ", style: TextStyle(color: Colors.white,
                fontSize: 20.0,
                fontWeight: FontWeight.bold),),
            SizedBox(height: 20.0,),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Booking(service: 'Cạo râu')));
                    },
                    child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                            color: Color(0xFFe29452), borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('images/shaving.png', height: 80,width: 80, fit: BoxFit.cover,),
                            SizedBox(height: 10.0,),
                            Text("Cạo râu ", style: TextStyle(color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),),
                          ],
                        )
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                Flexible(
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Booking(service: 'Gội đầu')));
                    },
                    child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                            color: Color(0xFFe29452), borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('images/hair.png', height: 80,width: 80, fit: BoxFit.cover,),
                            SizedBox(height: 10,),
                            Text("Gội đầu", style: TextStyle(color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),),
                          ],
                        )
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Booking(service: 'Cắt tóc')));
                    },
                    child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                            color: Color(0xFFe29452), borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('images/cutting.png', height: 80,width: 80, fit: BoxFit.cover,),
                            SizedBox(height: 10.0,),
                            Text("Cắt tóc", style: TextStyle(color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),),
                          ],
                        )
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                Flexible(
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Booking(service: 'Cắt tỉa râu công nghệ')));
                    },
                    child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                            color: Color(0xFFe29452), borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('images/beard.png', height: 80,width: 80, fit: BoxFit.cover,),
                            SizedBox(height: 10,),
                            Text("Cắt tỉa râu công nghệ", style: TextStyle(color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),),
                          ],
                        )
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20,),
            Row(
              children: [
                Flexible(
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Booking(service: 'Chăm sóc da mặt')));
                    },
                    child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                            color: Color(0xFFe29452), borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('images/facials.png', height: 80,width: 80, fit: BoxFit.cover,),
                            SizedBox(height: 10.0,),
                            Text("Chăm sóc da mặt", style: TextStyle(color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),),
                          ],
                        )
                    ),
                  ),
                ),
                SizedBox(width: 20,),
                Flexible(
                  fit: FlexFit.tight,
                  child: GestureDetector(
                    onTap: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=> Booking(service: 'Cắt tóc trẻ em')));
                    },
                    child: Container(
                        height: 150,
                        decoration: BoxDecoration(
                            color: Color(0xFFe29452), borderRadius: BorderRadius.circular(20)
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset('images/kids.png', height: 80,width: 80, fit: BoxFit.cover,),
                            SizedBox(height: 10,),
                            Text("Cắt tóc trẻ em", style: TextStyle(color: Colors.white,
                                fontSize: 18.0,
                                fontWeight: FontWeight.bold),),
                          ],
                        )
                    ),
                  ),
                ),
              ],
            ),

          ],
        ),),
    );
  }
}
