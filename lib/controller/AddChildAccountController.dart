import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartdoor/controller/ChildAccountController.dart';

class AddChildAccountController extends GetxController {
  Future<void> addChildAccount(String email, String username, String firstname, String lastname, String password) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    if (token != null) {
      try {
        var response = await Dio().post(
          'http://baha.adrianyan.tech:8000/api/add-child-account',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
          data: {
            'email': email,
            'username': username,
            'firstname': firstname,
            'lastname': lastname,
            'password': password,
          },
        );

        if (response.statusCode == 200) {
          Get.snackbar('Success', 'Child account added successfully');
          Get.find<ChildAccountController>().fetchChildAccounts();
        } else {
          Get.snackbar('Error', 'Failed to add child account');
        }
      } catch (e) {
        Get.snackbar('Error', 'An error occurred: $e');
      }
    } else {
      Get.snackbar('Error', 'User token not found');
    }
  }
}