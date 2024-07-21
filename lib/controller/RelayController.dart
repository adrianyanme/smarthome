   import 'package:get/get.dart';
   import 'package:dio/dio.dart';
   import 'package:shared_preferences/shared_preferences.dart';

   class RelayController extends GetxController {
     Future<void> toggleDevice(String serialNumber, bool turnOn) async {
       SharedPreferences prefs = await SharedPreferences.getInstance();
       var token = prefs.getString('token');

       if (token != null) {
         try {
           var url = turnOn
               ? 'http://baha.adrianyan.tech:8000/api/relay/open'
               : 'http://baha.adrianyan.tech:8000/api/relay/close';

           var response = await Dio().post(
             url,
             data: {
               'serial_number': serialNumber,
             },
             options: Options(
               headers: {
                 'Authorization': 'Bearer $token',
               },
             ),
           );

           if (response.statusCode == 200) {
             Get.snackbar('Success', 'Device toggled successfully', snackPosition: SnackPosition.BOTTOM);
           } else {
             Get.snackbar('Error', 'Failed to toggle device', snackPosition: SnackPosition.BOTTOM);
           }
         } catch (e) {
           Get.snackbar('Error', 'Failed to toggle device', snackPosition: SnackPosition.BOTTOM);
         }
       } else {
         Get.snackbar('Error', 'Token is null', snackPosition: SnackPosition.BOTTOM);
       }
     }
   }