import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class UserController extends GetxController {
  var userData = {}.obs;
  var role = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadUserInfoFromLocal();
    fetchUserInfo();
  }

  Future<void> loadUserInfoFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedUserData = prefs.getString('userData');
    if (savedUserData != null) {
      userData.value = json.decode(savedUserData);
      print('Loaded user data from local: ${userData.value}');
    }
  }

  Future<void> saveUserInfoToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('userData', json.encode(userData.value));
    print('Saved user data to local: ${userData.value}');
  }

  Future<void> fetchUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    if (token != null) {
      try {
        print('Fetching user info with token: $token');
        var response = await Dio().get(
          'http://baha.adrianyan.tech:8000/api/me',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        print('Response status: ${response.statusCode}');
        print('Response data: ${response.data}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          userData.value = response.data;
          print('User data fetched and set: ${userData.value}');
          role.value = userData.value['role'] ?? '';
          saveUserInfoToLocal();
          update();
        } else {
          print('Failed to fetch user info: ${response.statusCode} ${response.statusMessage}');
        }
      } catch (e) {
        print('Error fetching user info: $e');
        if (e is DioException) {
          print('DioException: ${e.response?.data}');
        }
      }
    } else {
      print('Token is null');
    }
  }

  String get username => userData['username'] ?? '';
  String get fullName => '${userData['firstname'] ?? ''} ${userData['lastname'] ?? ''}'.trim();
  String get email => userData['email'] ?? '';
  String get profileImage => userData['profileimg'] ?? '';
}