   import 'package:get/get.dart';
   import 'package:dio/dio.dart';
   import 'package:flutter/material.dart';
   import 'package:shared_preferences/shared_preferences.dart';

   class LoginController extends GetxController {
     var isLoading = false.obs;
     var loginController = TextEditingController();
     var passwordController = TextEditingController();

     Future<void> login() async {
       isLoading.value = true;

       try {
         var response = await Dio().post(
           'http://baha.adrianyan.tech:8000/api/login',
           data: {
             'login': loginController.text,
             'password': passwordController.text,
           },
         );

         isLoading.value = false;

         if (response.statusCode == 200) {
           // Simpan token atau informasi sesi
           SharedPreferences prefs = await SharedPreferences.getInstance();
           await prefs.setString('token', response.data.toString());

           // Jika login berhasil, arahkan ke halaman utama
           Get.toNamed('/home');
         } else {
           // Jika login gagal, tampilkan pesan error
           Get.snackbar('Error', 'Login failed', snackPosition: SnackPosition.BOTTOM);
         }
       } catch (e) {
         isLoading.value = false;
         Get.snackbar('Error', 'Login failed', snackPosition: SnackPosition.BOTTOM);
       }
     }
   }