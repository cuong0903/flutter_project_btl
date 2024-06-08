import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  State<ForgotPassword> createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();


  Future<void> resetPassword(String email) async {



    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      _showSuccessMessage("Một email đặt lại mật khẩu đã được gửi. Vui lòng kiểm tra email của bạn!");
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException code: ${e.code}');
      print('FirebaseAuthException message: ${e.message}');

      String errorMessage;
      switch (e.code) {

        case 'invalid-email':
          errorMessage = "Địa chỉ email không hợp lệ.";
          break;
        default:
          errorMessage = "Đã xảy ra lỗi. Vui lòng thử lại. (Mã lỗi: ${e.code})";
      }
      _showErrorMessage(errorMessage);
    } catch (e) {
      print('Non-FirebaseAuthException: $e');
      _showErrorMessage("Đã xảy ra lỗi không xác định. Vui lòng thử lại.");
    }
  }

  void _showSuccessMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 18.0),
      ),
      backgroundColor: Colors.green,
    ));
  }

  void _showErrorMessage(String message) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        message,
        style: TextStyle(fontSize: 18.0),
      ),
      backgroundColor: Colors.red,
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Quên Mật Khẩu"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            SizedBox(height: 40.0),
            Text(
              "Nhập email của bạn để đặt lại mật khẩu",
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20.0),
            Form(
              key: _formKey,
              child: TextFormField(
                controller: _emailController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Vui lòng nhập địa chỉ email';
                  }
                  return null;
                },
                style: TextStyle(color: Colors.black),
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                  prefixIcon: Icon(
                    Icons.mail_outline,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
            ),
            SizedBox(height: 20.0),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  String email = _emailController.text.trim();
                  resetPassword(email);
                }
              },
              child: Text(
                "Gửi Email Đặt Lại Mật Khẩu",
                style: TextStyle(
                  fontSize: 16.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }
}