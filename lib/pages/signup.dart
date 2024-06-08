import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_btl/pages/login.dart';
import 'package:flutter_project_btl/services/database.dart';
import 'package:flutter_project_btl/services/shared_pred.dart';
import 'package:random_string/random_string.dart';

import 'home.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool _isPasswordVisible = false; // Biến để theo dõi trạng thái của mật khẩu
  String? name, mail, password;
  TextEditingController nameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController phonenumberController = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  // Phương thức đăng kí tài khoản
  registration() async {
    if (password != null && name != null && mail != null) {
      try {
        // Tạo tài khoản với firebsae
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: mail!, password: password!);

        // Tạo ID ngẫu nhiên cho người dùng
        String id = randomAlphaNumeric(10);

        // Lưu thông tin người dùng vào Shared Preferences
        await SharedpreferenceHelper().saveUserName(nameController.text);
        await SharedpreferenceHelper().saveUserGmail(emailController.text);
        await SharedpreferenceHelper()
            .saveUserPhoneNumber(phonenumberController.text);
        await SharedpreferenceHelper().saveUserImage(
            "https://firebasestorage.googleapis.com/v0/b/barbershop-79626.appspot.com/o/images.png?alt=media&token=75ce2183-2d59-4b48-ae86-c7c8daa2870b");
        await SharedpreferenceHelper().saveUserId(id);

        // Tạo Map chứa thông tin người dùng
        Map<String, dynamic> userInfoMap = {
          "Name": nameController.text,
          "Gmail": emailController.text,
          "Id": id,
          "NumberPhone": phonenumberController.text,
          "Image":
              "https://firebasestorage.googleapis.com/v0/b/barbershop-79626.appspot.com/o/images.png?alt=media&token=75ce2183-2d59-4b48-ae86-c7c8daa2870b",
        };

        // Lưu thông tin người dùng vào cơ sở dữ liệu
        await DatabaseMethods().addUserDetails(userInfoMap, id);
        // Hiển thị thông báo đăng ký thành công
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Đã đăng ký thành công",
          style: TextStyle(fontSize: 18.0, color: Colors.white),
        )));
        // Điều hướng đến trang đăng nhập
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => Login()));
      } on FirebaseAuthException catch (e) {
        // Xử lý các lỗi liên quan đến Firebase Auth
        if (e.code == 'weak-password') {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            "Mật khẩu được cung cấp quá yếu",
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          )));
        } else if (e.code == "email-already-in-use") {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text(
            "Tài khoản đã tồn tại",
            style: TextStyle(fontSize: 18.0, color: Colors.white),
          )));
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Stack(
          children: [
            Container(
              padding: EdgeInsets.only(
                top: 50,
                left: 30.0,
              ),
              height: MediaQuery.of(context).size.height / 2,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  // LinearGradient: Đây là lớp được sử dụng để tạo gradient màu cho nền của
                // Container. Gradient này có ba màu chuyển từ đỏ đến đen.
                gradient: LinearGradient(colors: [
                  Color(0xFF1E88E5),
                  Color(0xFF1565C0),
                  Color(0xFF0D47A1)
                ]),),
              child: Text(
                "Create Your\n Account !",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
            ),
            SingleChildScrollView(
              child: Container(
                padding: EdgeInsets.only(
                    top: 40.0, left: 20.0, right: 30.0, bottom: 30.0),
                margin: EdgeInsets.only(
                    top: MediaQuery.of(context).size.height / 4),
                height: MediaQuery.of(context).size.height,
                width: MediaQuery.of(context).size.width,
                // Cài màu nền và hình dạng ConTaniner
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40))),
                child: Form(
                  key: _formkey,
                  // Sắp xếp các widget con theo hướng dọc.
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Name",
                        style: TextStyle(
                            color: Color(0xff3747af),
                            fontSize: 23.0,
                            fontWeight: FontWeight.w500),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập tên";
                          }
                          return null;
                        },
                        controller: nameController,
                        decoration: InputDecoration(
                            hintText: "Name",
                            prefixIcon: Icon(Icons.person_outline)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Gmail",
                        style: TextStyle(
                            color: Color(0xff3747af),
                            fontSize: 25,
                            fontWeight: FontWeight.w500),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập Gmail";
                          }
                          return null;
                        },
                        controller: emailController,
                        decoration: InputDecoration(
                            hintText: "Gmail",
                            prefixIcon: Icon(Icons.mail_outline)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Phone Number",
                        style: TextStyle(
                            color: Color(0xff3747af),
                            fontSize: 25,
                            fontWeight: FontWeight.w500),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập Số điện thoại";
                          }
                          return null;
                        },
                        controller: phonenumberController,
                        decoration: InputDecoration(
                            hintText: "Phone Number",
                            prefixIcon: Icon(Icons.phone_callback_outlined)),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        "Password",
                        style: TextStyle(
                            color: Color(0xff3747af),
                            fontSize: 25,
                            fontWeight: FontWeight.w500),
                      ),
                      TextFormField(
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Vui lòng nhập Mật khẩu";
                          }
                          return null;
                        },
                        controller: passwordController,
                        decoration: InputDecoration(
                          hintText: "Password",
                          prefixIcon: Icon(Icons.password_outlined),
                          suffixIcon: IconButton(
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                            icon: Icon(
                              _isPasswordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                            ),
                          ),
                        ),
                        obscureText:
                            !_isPasswordVisible, // Đảo ngược giá trị này để ẩn/mở khóa mật khẩu
                      ),
                      SizedBox(
                        height: 60,
                      ),
                      GestureDetector(
                        //GestureDetector được sử dụng để chuyển hướng người dùng đến màn hình đăng nhập
                        onTap: () {
                          if (_formkey.currentState!.validate()) {
                            setState(() {
                              mail = emailController.text;
                              name = nameController.text;
                              password = passwordController.text;
                            });
                          }
                          registration();
                        },
                        child: Container(
                            padding: EdgeInsets.symmetric(vertical: 10.0),
                            width: MediaQuery.of(context).size.width,
                            decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Color(0xFF1E88E5),
                                  Color(0xFF1565C0),
                                  Color(0xFF0D47A1)
                                ]),
                                borderRadius: BorderRadius.circular(30)),
                            child: Center(
                                child: Text(
                              'Đăng ký',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold),
                            ))),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Bạn đã có tài khoản chưa?",
                            style: TextStyle(
                                color: Color(0xFF311937),
                                fontSize: 17.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) => Login()));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              "Đăng nhập",
                              style: TextStyle(
                                  color: Color(0xff3747af),
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
