   import 'package:get/get.dart';
   import 'package:dio/dio.dart';
   import 'package:shared_preferences/shared_preferences.dart';

   class UserController extends GetxController {
     var username = ''.obs;

     Future<void> fetchUserInfo() async {
       SharedPreferences prefs = await SharedPreferences.getInstance();
       var token = prefs.getString('token');

       if (token != null) {
         try {
           var response = await Dio().get(
             'http://baha.adrianyan.tech:8000/api/me',
             options: Options(
               headers: {
                 'Authorization': 'Bearer $token',
               },
             ),
           );

           if (response.statusCode == 200) {
             username.value = response.data['username'];
           } else {
             Get.snackbar('Error', 'Failed to fetch user info', snackPosition: SnackPosition.BOTTOM);
           }
         } catch (e) {
           Get.snackbar('Error', 'Failed to fetch user info', snackPosition: SnackPosition.BOTTOM);
         }
       }
     }
   }