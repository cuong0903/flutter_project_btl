import 'package:shared_preferences/shared_preferences.dart';

class SharedpreferenceHelper{
  static String userIdkey = "USERKEY";
  static String userNamekey = "USERNAMEKEY";
  static String userGmailkey = "USERGMAILKEY";
  static String userImagekey = "USERIMAGEKEY";

  Future<bool> saveUserId(String getUserId) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
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

  Future<bool> saveUserImage(String getUserImage) async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.setString(userImagekey, getUserImage);
  }

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

  Future<String?> getUserImage() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(userImagekey);
  }

}