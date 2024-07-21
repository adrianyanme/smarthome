   import 'package:get/get.dart';
   import 'package:dio/dio.dart';
   import 'package:shared_preferences/shared_preferences.dart';

   class LogController extends GetxController {
     var logs = <Map<String, dynamic>>[].obs;

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
           } else {
             print('Failed to fetch logs: ${response.statusCode} ${response.statusMessage}');
             Get.snackbar('Error', 'Failed to fetch logs', snackPosition: SnackPosition.BOTTOM);
           }
         } catch (e) {
           print('Error fetching logs: $e');
           Get.snackbar('Error', 'Failed to fetch logs', snackPosition: SnackPosition.BOTTOM);
         }
       } else {
         print('Token is null');
         Get.snackbar('Error', 'Token is null', snackPosition: SnackPosition.BOTTOM);
       }
     }
   }