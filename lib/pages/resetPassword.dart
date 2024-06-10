import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChangePassword extends StatefulWidget {
  final String userId;

  const ChangePassword({Key? key, required this.userId}) : super(key: key);

  @override
  State<ChangePassword> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<ChangePassword> {
  final _formKey = GlobalKey<FormState>(); // Một GlobalKey để theo dõi trạng thái của Form.
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _isLoading = false; // Một biến để xác định trạng thái của quá trình đổi mật khẩu
  bool _showCurrentPassword = false; //// Biến để xác định xem mật khẩu hiện tại có được hiển thị dưới dạng văn bản rõ hay không.
  bool _showNewPassword = false;// // Biến để xác định xem mật khẩu mới có được hiển thị dưới dạng văn bản rõ hay không.
  bool _showConfirmPassword = false; // Nhập lại

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7AB9EE),
      body: Container(
        padding: const EdgeInsets.only(top: 30, right: 10, left: 10),
        child: Column(// Column để sắp xếp các thành phần theo cột.
          children: [
            Row(  // Row để sắp xếp các thành phần theo hàng ngang.
              children: [
                GestureDetector( // GestureDetector để xử lý sự kiện nhấn vào icon back
                  onTap: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    color: Colors.black,
                    size: 30,
                  ),
                ),
                const SizedBox(width: 20),
                const Expanded(
                  child: Center(
                    child: Text(
                      "Đổi mật khẩu",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 30.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Form(  // Form để quản lý các trường nhập liệu.
              key: _formKey,// Key của Form để theo dõi trạng thái của Form.
              child: Column( // Column để sắp xếp các trường nhập liệu theo cột.
                children: [
                  TextFormField(
                    controller: _currentPasswordController,
                    obscureText: !_showCurrentPassword,  // Ẩn/Hiện mật khẩu hiện tại dưới dạng văn bản ẩn hoặc rõ
                    decoration: InputDecoration(
                      labelText: "Mật khẩu cũ",
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          // Chọn icon dựa trên trạng thái _showCurrentPassword.
                          _showCurrentPassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _showCurrentPassword = !_showCurrentPassword;
                            // Đảo ngược
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập mật khẩu cũ';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _newPasswordController,  // Sử dụng TextEditingController để quản lý dữ liệu nhập vào.
                    obscureText: !_showNewPassword, // Ẩn/Hiện mật khẩu mới dưới dạng văn bản ẩn hoặc rõ.
                    decoration: InputDecoration(
                      labelText: "Mật khẩu mới",
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showNewPassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _showNewPassword = !_showNewPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập lại mật khẩu cũ';
                      }
                      if (value.length < 6) {
                        return "Mật khẩu phải có ít nhất 6 ký tự";
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 20),
                  TextFormField(
                    controller: _confirmPasswordController,
                    obscureText: !_showConfirmPassword,
                    decoration: InputDecoration(
                      labelText: "Nhập lại mật khẩu",
                      prefixIcon: Icon(Icons.lock_outline),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _showConfirmPassword ? Icons.visibility : Icons.visibility_off,
                        ),
                        onPressed: () {
                          setState(() {
                            _showConfirmPassword = !_showConfirmPassword;
                          });
                        },
                      ),
                    ),
                    validator: (value) { // Validator để kiểm tra dữ liệu nhập vào.
                      if (value == null || value.isEmpty) {
                        return 'Vui lòng nhập lại mật khẩu';
                      }
                      if (value != _newPasswordController.text) {
                        // Kiểm tra nếu mật khẩu nhập lại không khớp với mật khẩu mới.
                        return 'Mật khẩu bạn vừa nhập không khớp';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _changePassword,
                    // Xác định hành động khi nút được nhấn (nếu _isLoading = true thì không thực hiện hành động).
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xff3747af),
                      padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    ),
                    child: _isLoading
                    // Nội dung của nút, có thể là một CircularProgressIndicator nếu đang trong quá trình đổi mật khẩu.
                        ? const CircularProgressIndicator(color: Colors.white)
                        : const Text(
                      "Đổi mật khẩu",
                      style: TextStyle(fontSize: 20, color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

// Phương thức xử lý khi người dùng nhấn vào nút "Đổi mật khẩu".
  void _changePassword() async {
    // Kiểm tra xem dữ liệu nhập vào từ các trường nhập liệu có hợp lệ không.
    if (_formKey.currentState!.validate()) {
      setState(() {
        //Đặt _isLoading thành true để hiển thị CircularProgressIndicator.
        _isLoading = true;
      });
       // Lấy thông tin người dùng hiện tại từ Firebase Authentication.
      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        try {
          // Xác thực lại người dùng với mật khẩu hiện tại
          AuthCredential credential = EmailAuthProvider.credential(
            email: user.email!, // Sử dụng email của người dùng hiện tại.
            password: _currentPasswordController.text,// Sử dụng mật khẩu được nhập vào từ trường nhập liệu "Mật khẩu cũ".
          );
          await user.reauthenticateWithCredential(credential);  // Xác thực lại người dùng với mật khẩu hiện tại

          // Đổi mật khẩu
          // Cập nhật mật khẩu mới cho người dùng.
          await user.updatePassword(_newPasswordController.text);

          // Thông báo thành công và quay lại màn hình trước
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Đổi mật khẩu thành công',style: TextStyle(fontSize: 18.0, color: Colors.white),)),
          );
          Navigator.pop(context);  // Quay lại màn hình trước đó sau khi đổi mật khẩu thành công.
        } on FirebaseAuthException catch (e) {
          print("FirebaseAuthException code: ${e.code}"); // In ra giá trị của e.code

          setState(() {// setState để cập nhật trạng thái _isLoading.
            _isLoading = false;// Đặt _isLoading thành false để dừng hiển thị CircularProgressIndicator.
          });

          String errorMessage;
          switch (e.code) {
              case 'invalid-credential':
                errorMessage = 'mật khẩu hiện tại không đúng';
                break;
            default:
              errorMessage = 'Đã xảy ra lỗi. Vui lòng thử lại.';
          }
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(errorMessage, style: TextStyle(fontSize: 18.0, color: Colors.white),)),
          );
        } catch (e) {
          setState(() {
            _isLoading = false;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(e.toString(), style: TextStyle(fontSize: 18.0, color: Colors.white),)),
          );
        }
      }
      setState(() {
        _isLoading = false;
      });
    }
  }
}