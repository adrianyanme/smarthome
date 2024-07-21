   import 'package:get/get.dart';
   import 'package:dio/dio.dart';
   import 'package:shared_preferences/shared_preferences.dart';

   class ListDeviceController extends GetxController {
    var devices = <Map<String, dynamic>>[].obs;

     Future<void> fetchUserDevices() async {
       SharedPreferences prefs = await SharedPreferences.getInstance();
       var token = prefs.getString('token');

       if (token != null) {
         try {
           var response = await Dio().get(
             'http://baha.adrianyan.tech:8000/api/relay/devices',
             options: Options(
               headers: {
                 'Authorization': 'Bearer $token',
               },
             ),
           );

           if (response.statusCode == 200) {
             devices.value = List<Map<String, dynamic>>.from(response.data['devices']);
           } else {
             Get.snackbar('Error', 'Failed to fetch devices', snackPosition: SnackPosition.BOTTOM);
           }
         } catch (e) {
           Get.snackbar('Error', 'Failed to fetch devices', snackPosition: SnackPosition.BOTTOM);
         }
       } else {
         Get.snackbar('Error', 'Token is null', snackPosition: SnackPosition.BOTTOM);
       }
     }
   }