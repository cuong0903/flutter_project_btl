import 'package:shared_preferences/shared_preferences.dart';

class SharedpreferenceHelper{
  // biến này thuộc về lớp, không phải của mỗi thể hiện của lớ
  static String userIdkey = "USERKEY";
  static String userNamekey = "USERNAMEKEY";
  static String userGmailkey = "USERGMAILKEY";
  static String userPhoneNumberkey = "USERPHONENUMBERKEY";
  static String userImagekey = "USERIMAGEKEY";

  Future<bool> saveUserId(String getUserId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    //  để lưu trữ giá trị của userId vào SharedPreferences.
    return prefs.setString(userIdkey, getUserId);
  }

  Future<bool> saveUserName(String getUserName) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userNamekey, getUserName);
  }

  Future<bool> saveUserGmail(String getUserGmail) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userGmailkey, getUserGmail);
  }
  Future<bool> saveUserPhoneNumber(String getPhoneNumber) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userPhoneNumberkey, getPhoneNumber);
  }

  Future<bool> saveUserImage(String getUserImage) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userImagekey, getUserImage);
  }


  // Lấy giá trị
  Future<String?> getUserId() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userIdkey);
  }

  Future<String?> getUserName() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userNamekey);
  }

  Future<String?> getUserGmail() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userGmailkey);
  }
  Future<String?> getPhoneNumber() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userPhoneNumberkey);
  }

  Future<String?> getUserImage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userImagekey);
  }

}