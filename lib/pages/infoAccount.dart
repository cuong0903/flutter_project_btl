import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../services/shared_pred.dart';

class Infoaccount extends StatefulWidget {
  final String userId; // ID của người dùng

  const Infoaccount({Key? key, required this.userId}) : super(key: key);

  @override
  State<Infoaccount> createState() => _InfoaccountState();
}

class _InfoaccountState extends State<Infoaccount> {
  late Future<DocumentSnapshot> userFuture; // Future chứa dữ liệu người dùng
  bool isEditing = false;
  final ImagePicker _picker = ImagePicker(); // Đối tượng để chọn hình ảnh
  File? selectedImage;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userFuture = DatabaseMethods().getUsers(widget.userId);  // Lấy dữ liệu người dùng từ cơ sở dữ liệu
  }
  // Phương thức chọn ảnh từ thiết bị
  Future getImage() async {
    try {
      print('Mở thư mục chọn ảnh...');
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery); // Chọn hình ảnh từ thư viện
      print('Chọn ảnh: ${pickedFile?.path}');

      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path); // Lưu hình ảnh đã chọn
        });
      } else {
        print('Không có ảnh nào được chọn.');
      }
    } catch (e) {
      print('Lỗi khi chọn ảnh: $e');
    }
  }

  // Phương thức để chuyển đổi giữa chế độ chỉnh sửa và không chỉnh sửa
  void toggleEdit(Map<String, dynamic> userData) {
    setState(() {
      isEditing = !isEditing; // Đảo ngược trạng thái chỉnh sửa
      // Nếu đang ở chế độ chỉnh sửa, gán các giá trị hiện tại của người dùng vào các controller
      if (isEditing) {
        nameController.text = userData['Name'] ?? '';
        emailController.text = userData['Gmail'] ?? '';
        phoneController.text = userData['NumberPhone'] ?? '';
      }
    });
  }

  // Phương thức để cập nhật thông tin người dùng
  Future<void> updateUserInfo() async {
    Map<String, dynamic> updatedInfo = {
      'Name': nameController.text,
      // 'Gmail': emailController.text,
      'NumberPhone': phoneController.text,
    };
    // Nếu có hình ảnh được chọn, tải lên Firebase Storage
    if (selectedImage != null) {
      try {
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage
            .instance
            .ref()
            .child('profile_images')
            .child('${widget.userId}.jpeg');

        // Tải hình ảnh lên Firebase Storage
        firebase_storage.UploadTask uploadTask = ref.putFile(selectedImage!);
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

        // Lấy đường dẫn URL của hình ảnh đã tải lên
        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        updatedInfo['Image'] = downloadUrl;  // Cập nhật đường dẫn URL của hình ảnh trong thông tin người dùng

        // Lưu đường dẫn URL của hình ảnh vào Shared Preferences
        await SharedpreferenceHelper().saveUserImage(downloadUrl);

      } catch (e) {
        print('Lỗi khi tải ảnh: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tải lên ảnh: $e',style: TextStyle(fontSize: 18.0, color: Colors.white),)),
        );
        return;
      }
    }

    try {
      // Cập nhật thông tin người dùng trong cơ sở dữ liệu
      await DatabaseMethods().getAndUpUsers(widget.userId, updatedInfo);

      // Cập nhật trạng thái và dữ liệu người dùng
      setState(() {
        isEditing = false;
        userFuture = DatabaseMethods().getUsers(widget.userId);
      });

      // Hiển thị thông báo cập nhật thành công
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thông tin đã được cập nhật!', style: TextStyle(fontSize: 18.0, color: Colors.white),)),
      );
    } catch (e) {
      print('Lỗi khi cập nhật thông tin: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        // Hiển thị thông báo lỗi nếu cập nhật thông tin không thành công
        SnackBar(content: Text('Lỗi khi cập nhật thông tin: $e',style: TextStyle(fontSize: 18.0, color: Colors.white),)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF7AB9EE),
      body: Container(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 30),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context), // Hành động khi nhấn nút "Quay lại"
                    child: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.black, size: 30),
                  ),
                  const SizedBox(width: 20),
                  const Expanded(
                    child: Center(
                      child: Text(
                        "Thông tin tài khoản",
                        style: TextStyle(color: Colors.black, fontSize: 30.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            FutureBuilder<DocumentSnapshot>(
              future: userFuture,
              builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  // Hiển thị vòng tròn tiến trình khi đang tải dữ liệu
                  return const Center(child: CircularProgressIndicator());
                }
                // Lỗi
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('Không có sẵn dữ liệu người dùng'));
                }

                // Dữ liệu người dùng từ snapshot
                var userData = snapshot.data!.data() as Map<String, dynamic>;

                return Center(
                  child: GestureDetector(
                    onTap: isEditing ? getImage : null, // Hành động khi nhấn vào hình ảnh (nếu ở chế độ chỉnh sửa)
                    child: Container(
                      padding: const EdgeInsets.all(10.0), // Khoảng cách đệm xung quanh hình ảnh
                      decoration: BoxDecoration(
                        shape: BoxShape.circle, // Hình dạng của container là hình tròn
                        border: Border.all(color: Colors.grey, width: 1), // Viền xám xung quanh hình ảnh
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),  // Bo tròn góc hình ảnh
                        child: selectedImage != null
                            ? Image.file(selectedImage!, fit: BoxFit.cover, width: 160, height: 160) // Hiển thị hình ảnh được chọn từ thư viện
                            : (userData['Image'] != null
                            ? Image.network(userData['Image'], fit: BoxFit.cover, width: 160, height: 160) // Hiển thị hình ảnh người dùng từ Firebase Storage (nếu có)
                            : Image.asset("images/boy.png", fit: BoxFit.cover, width: 160, height: 160)),  // Hiển thị hình ảnh mặc định nếu không có hình ảnh
                      ),
                    ),
                  ),
                );
              },
            ),
            if (isEditing && selectedImage == null)
              TextButton(
                onPressed: getImage, // Hành động khi nhấn vào nút "Chọn ảnh mới" (chỉ khi ở chế độ chỉnh sửa và không có hình ảnh được chọn)
                child: Text("Chọn ảnh mới"),
              ),
            const SizedBox(height: 50),
            Expanded(
              child: FutureBuilder<DocumentSnapshot>(
                future: userFuture,
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const SizedBox(); // Trả về rỗng
                  }

                  // Dữ liệu người dùng từ snapshot
                  var userData = snapshot.data!.data() as Map<String, dynamic>;

                  // Thiết lập giá trị của trường "" nếu không ở chế độ chỉnh sửa
                  if (!isEditing) {
                    nameController.text = userData['Name'] ?? '';
                    emailController.text = userData['Gmail'] ?? '';
                    phoneController.text = userData['NumberPhone'] ?? '';
                  }

                  return Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    child: Column(
                      children: [
                        TextFormField(
                          controller: nameController,
                          readOnly: !isEditing, // Chỉ cho phép chỉnh sửa khi ở chế độ chỉnh sửa
                          decoration: const InputDecoration(
                            hintText: "Username",// Gợi ý cho trường "Tên"
                            prefixIcon: Icon(Icons.person_outline),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          controller: emailController,
                          readOnly: true,
                          decoration: const InputDecoration(
                            hintText: "Gmail",
                            prefixIcon: Icon(Icons.mail_outline),
                          ),
                        ),
                        const SizedBox(height: 30.0),
                        TextFormField(
                          controller: phoneController,
                          readOnly: !isEditing,
                          decoration: const InputDecoration(
                            hintText: "Phone Number",
                            prefixIcon: Icon(Icons.phone_callback_outlined),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 30),
            GestureDetector(
              onTap: () {
                if (isEditing) {
                  updateUserInfo(); // Gọi phương thức cập nhật thông tin
                } else {
                  userFuture.then((snapshot) {
                    var userData = snapshot.data() as Map<String, dynamic>;
                    toggleEdit(userData); // Chuyển đổi chế độ chỉnh sửa khi nhấn vào nú
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40), // Khoảng cách đệm dọc và ngang của nút
                decoration: BoxDecoration(
                  color: Color(0xff3747af),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  isEditing ? "Lưu thay đổi" : "Sửa thông tin",
                  style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}