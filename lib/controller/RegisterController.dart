import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterController extends GetxController {
  var isLoading = false.obs;
  var emailController = TextEditingController();
  var usernameController = TextEditingController();
  var firstnameController = TextEditingController();
  var lastnameController = TextEditingController();
  var passwordController = TextEditingController();

  Future<void> register() async {
    isLoading.value = true;

    try {
      var response = await Dio().post(
        'http://baha.adrianyan.tech:8000/api/register-master',
        data: {
          'email': emailController.text,
          'username': usernameController.text,
          'firstname': firstnameController.text,
          'lastname': lastnameController.text,
          'password': passwordController.text,
        },
      );

      isLoading.value = false;

      if (response.statusCode == 201) {
        // Simpan token atau informasi sesi jika diperlukan
        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', response.data.toString());

        // Jika registrasi berhasil, arahkan ke halaman login
        Get.toNamed('/login');
      } else {
        // Jika registrasi gagal, tampilkan pesan error
        Get.snackbar('Error', 'Registration failed', snackPosition: SnackPosition.BOTTOM);
      }
    } catch (e) {
      isLoading.value = false;
      Get.snackbar('Error', 'Registration failed', snackPosition: SnackPosition.BOTTOM);
    }
  }
}