import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChildAccountController extends GetxController {
  var childAccounts = [].obs;

  @override
  void onInit() {
    super.onInit();
    fetchChildAccounts();
  }

  Future<void> deleteChildAccount(String childId) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      var token = prefs.getString('token');
      if (token != null) {
        var response = await Dio().post(
          'http://baha.adrianyan.tech:8000/api/delete-child-account/$childId',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        if (response.statusCode == 200) {
          fetchChildAccounts(); // Refresh the child accounts list
          Get.snackbar('Success', 'Child account deleted successfully');
        } else {
          Get.snackbar('Error', 'Failed to delete child account');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while deleting the child account');
    }
  }

  Future<void> fetchChildAccounts() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    if (token != null) {
      try {
        var response = await Dio().get(
          'http://baha.adrianyan.tech:8000/api/child-accounts',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        if (response.statusCode == 200) {
          var data = response.data;
          if (data['children'] != null) {
            childAccounts.value = List<Map<String, dynamic>>.from(data['children']);
            print('Child Accounts Data: ${childAccounts.value}');
          } else {
            print('No children data in response');
          }
        } else {
          print('Failed to fetch child accounts: ${response.statusCode} ${response.statusMessage}');
        }
      } catch (e) {
        print('Error fetching child accounts: $e');
      }
    } else {
      print('Token is null');
    }
  }
}