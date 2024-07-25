import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class LogController extends GetxController {
  var logs = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadLogsFromLocal();
    fetchLogs();
  }

  Future<void> loadLogsFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedLogs = prefs.getString('logs');
    if (savedLogs != null) {
      logs.value = List<Map<String, dynamic>>.from(json.decode(savedLogs));
      print('Loaded logs from local: ${logs.value}');
    }
  }

  Future<void> saveLogsToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('logs', json.encode(logs.value));
    print('Saved logs to local: ${logs.value}');
  }

  Future<void> fetchLogs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    if (token != null) {
      try {
        print('Fetching logs with token: $token');
        var response = await Dio().get(
          'http://baha.adrianyan.tech:8000/api/relay/logs',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        print('Response status: ${response.statusCode}');
        print('Response data: ${response.data}');

        if (response.statusCode == 200) {
          logs.value = List<Map<String, dynamic>>.from(response.data['logs']);
          print('Logs fetched: ${logs.value}');
          saveLogsToLocal();
          update();
        } else {
          print('Failed to fetch logs: ${response.statusCode} ${response.statusMessage}');
          Get.snackbar('Error', 'Failed to fetch logs', snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        print('Error fetching logs: $e');
        if (e is DioException) {
          print('DioException: ${e.response?.data}');
        }
        Get.snackbar('Error', 'Failed to fetch logs', snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      print('Token is null');
      Get.snackbar('Error', 'Token is null', snackPosition: SnackPosition.BOTTOM);
    }
  }

  // Helper method to get formatted date
  String getFormattedDate(String dateString) {
    DateTime date = DateTime.parse(dateString);
    return '${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute}';
  }
}