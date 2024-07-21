   import 'package:get/get.dart';
   import 'package:dio/dio.dart';
   import 'package:shared_preferences/shared_preferences.dart';
   import 'ListDeviceController.dart';

   class AddDeviceController extends GetxController {
     Future<void> addDevice(String serialNumber, String namaPerangkat) async {
       SharedPreferences prefs = await SharedPreferences.getInstance();
       var token = prefs.getString('token');

       if (token != null) {
         try {
           print('Adding device with serial number: $serialNumber and name: $namaPerangkat');
           var response = await Dio().post(
             'http://baha.adrianyan.tech:8000/api/relay/add',
             data: {
               'serial_number': serialNumber,
               'nama_perangkat': namaPerangkat,
             },
             options: Options(
               headers: {
                 'Authorization': 'Bearer $token',
               },
             ),
           );

           print('Response status: ${response.statusCode}');
           print('Response data: ${response.data}');

           if (response.statusCode == 201) {
             Get.snackbar('Success', 'Device added successfully', snackPosition: SnackPosition.BOTTOM);
             // Memuat ulang daftar perangkat
             Get.find<ListDeviceController>().fetchUserDevices();
           } else {
             print('Failed to add device: ${response.statusCode} ${response.statusMessage}');
             Get.snackbar('Error', 'Failed to add device', snackPosition: SnackPosition.BOTTOM);
           }
         } catch (e) {
           print('Error adding device: $e');
           Get.snackbar('Error', 'Failed to add device', snackPosition: SnackPosition.BOTTOM);
         }
       } else {
         print('Token is null');
         Get.snackbar('Error', 'Token is null', snackPosition: SnackPosition.BOTTOM);
       }
     }
   }