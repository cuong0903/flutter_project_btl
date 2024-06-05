import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/database.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import '../services/shared_pred.dart';

class Infoaccount extends StatefulWidget {
  final String userId;

  const Infoaccount({Key? key, required this.userId}) : super(key: key);

  @override
  State<Infoaccount> createState() => _InfoaccountState();
}

class _InfoaccountState extends State<Infoaccount> {
  late Future<DocumentSnapshot> userFuture;
  bool isEditing = false;
  final ImagePicker _picker = ImagePicker();
  File? selectedImage;

  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    userFuture = DatabaseMethods().getUsers(widget.userId);
  }
  Future getImage() async {
    try {
      print('Starting to pick image...');
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      print('Image picked: ${pickedFile?.path}');

      if (pickedFile != null) {
        setState(() {
          selectedImage = File(pickedFile.path);
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }



  void toggleEdit(Map<String, dynamic> userData) {
    setState(() {
      isEditing = !isEditing;
      if (isEditing) {
        nameController.text = userData['Name'] ?? '';
        emailController.text = userData['Gmail'] ?? '';
        phoneController.text = userData['NumberPhone'] ?? '';
      }
    });
  }

  Future<void> updateUserInfo() async {
    Map<String, dynamic> updatedInfo = {
      'Name': nameController.text,
      // 'Gmail': emailController.text,
      'NumberPhone': phoneController.text,
    };

    if (selectedImage != null) {
      try {
        firebase_storage.Reference ref = firebase_storage.FirebaseStorage
            .instance
            .ref()
            .child('profile_images')
            .child('${widget.userId}.jpeg');

        firebase_storage.UploadTask uploadTask = ref.putFile(selectedImage!);
        firebase_storage.TaskSnapshot taskSnapshot = await uploadTask;

        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        updatedInfo['Image'] = downloadUrl;

        await SharedpreferenceHelper().saveUserImage(downloadUrl);

      } catch (e) {
        print('Error uploading image: $e');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Lỗi khi tải lên ảnh: $e')),
        );
        return;
      }
    }

    try {
      await DatabaseMethods().getAndUpUsers(widget.userId, updatedInfo);

      setState(() {
        isEditing = false;
        userFuture = DatabaseMethods().getUsers(widget.userId);
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thông tin đã được cập nhật!')),
      );
    } catch (e) {
      print('Error updating user info: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Lỗi khi cập nhật thông tin: $e')),
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
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
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
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData || !snapshot.data!.exists) {
                  return const Center(child: Text('Không có sẵn dữ liệu người dùng'));
                }

                var userData = snapshot.data!.data() as Map<String, dynamic>;

                return Center(
                  child: GestureDetector(
                    onTap: isEditing ? getImage : null,
                    child: Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.grey, width: 1),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(80),
                        child: selectedImage != null
                            ? Image.file(selectedImage!, fit: BoxFit.cover, width: 160, height: 160)
                            : (userData['Image'] != null
                            ? Image.network(userData['Image'], fit: BoxFit.cover, width: 160, height: 160)
                            : Image.network("images/boy.png", fit: BoxFit.cover, width: 160, height: 160)),
                      ),
                    ),
                  ),
                );
              },
            ),
            if (isEditing && selectedImage == null)
              TextButton(
                onPressed: getImage,
                child: Text("Chọn ảnh mới"),
              ),
            const SizedBox(height: 50),
            Expanded(
              child: FutureBuilder<DocumentSnapshot>(
                future: userFuture,
                builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                  if (!snapshot.hasData || !snapshot.data!.exists) {
                    return const SizedBox();
                  }

                  var userData = snapshot.data!.data() as Map<String, dynamic>;

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
                          readOnly: !isEditing,
                          decoration: const InputDecoration(
                            hintText: "Username",
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
                  updateUserInfo();
                } else {
                  userFuture.then((snapshot) {
                    var userData = snapshot.data() as Map<String, dynamic>;
                    toggleEdit(userData);
                  });
                }
              },
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 40),
                decoration: BoxDecoration(
                  color: Colors.red,
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