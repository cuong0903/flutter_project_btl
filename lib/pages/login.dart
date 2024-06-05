import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_project_btl/pages/forgot_password.dart';
import 'package:flutter_project_btl/pages/signup.dart';
import 'package:flutter_project_btl/services/database.dart';
import 'package:flutter_project_btl/services/shared_pred.dart';

import 'home.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  String? mail, password, id;

  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  final _formkey = GlobalKey<FormState>();

  userLogin() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: mail!, password: password!);

      Map<String, dynamic>? userInfo = await DatabaseMethods().getUserInfoByEmail(mail!);
      if (userInfo != null) {
        await SharedpreferenceHelper().saveUserName(userInfo["Name"]);
        await SharedpreferenceHelper().saveUserId(userInfo["Id"]);
        await SharedpreferenceHelper().saveUserImage(userInfo["Image"]);
        // Lưu thêm thông tin khác nếu cần
      }
      Navigator.push(context, MaterialPageRoute(builder: (context) => Home()));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Không có người dùng Tìm thấy Email đó",
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        )));
      } else if (e.code == 'wrong-password') {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(
          "Mật khẩu sai do người dùng cung cấp",
          style: TextStyle(fontSize: 18.0, color: Colors.black),
        )));
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
                  gradient: LinearGradient(colors: [
                Color(0xFFB91635),
                Color(0xff621d3c),
                Color(0xFF311937)
              ])),
              child: Text(
                "Hello\nSign in!",
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              padding: EdgeInsets.only(
                  top: 40.0, left: 20.0, right: 30.0, bottom: 30.0),
              margin:
                  EdgeInsets.only(top: MediaQuery.of(context).size.height / 4),
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40))),
              child: Form(
                key: _formkey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Gmail",
                      style: TextStyle(
                          color: Color(0xFFB91635),
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
                      height: 40,
                    ),
                    Text(
                      "Password",
                      style: TextStyle(
                          color: Color(0xFFB91635),
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
                      ),
                      obscureText: true,
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    GestureDetector(
                      onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> ForgotPassword()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Quên mật khẩu ?",
                            style: TextStyle(
                                color: Color(0xFF311937),
                                fontSize: 18,
                                fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 50.0,
                    ),
                    GestureDetector(
                      onTap: () {
                        if(_formkey.currentState!.validate()){
                          setState(() {
                            mail = emailController.text;
                            password = passwordController.text;
                          });
                          userLogin();
                        }
                      },
                      child: Container(
                          padding: EdgeInsets.symmetric(vertical: 10.0),
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                              gradient: LinearGradient(colors: [
                                Color(0xFFB91635),
                                Color(0xff621d3c),
                                Color(0xFF311937)
                              ]),
                              borderRadius: BorderRadius.circular(30)),
                          child: Center(
                              child: Text(
                            'Đăng nhập',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ))),
                    ),
                    Spacer(),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          "Nếu chưa có tài khoản?",
                          style: TextStyle(
                              color: Color(0xFF311937),
                              fontSize: 17.0,
                              fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context)=> Signup()));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            "Đăng ký",
                            style: TextStyle(
                                color: Color(0xff621d3c),
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
          ],
        ),
      ),
    );
  }
}
