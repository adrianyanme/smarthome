import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:file_picker/file_picker.dart';

import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import 'package:smartdoor/controller/UserController.dart';

class ProfileScreen extends StatefulWidget {
  @override

  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  File? _image;

  String? _pdfFileName;

  final UserController userController = Get.find<UserController>();

  Future<void> _pickImage() async {

    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {

      setState(() {
        _image = File(pickedFile.path);

      });

    }

  }

  Future<void> _pickPDF() async {

    FilePickerResult? result = await FilePicker.platform.pickFiles(

      type: FileType.custom,

      allowedExtensions: ['pdf'],

    );


    if (result != null) {
      setState(() {

        _pdfFileName = result.files.single.name;
      });

    }
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token');

    await prefs.remove('userData'); // Hapus data pengguna dari SharedPreferences
    userController.clearUserData(); // Hapus data pengguna dari UserController
    Get.delete<UserController>(); // Hapus instance UserController

    Navigator.of(context).pushReplacementNamed('/login');

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Container(

            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage(
                    'assets/bglogin.png'), // Ganti dengan path gambar Anda
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.white.withOpacity(0.8),
          ),
          // Content

          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,

                children: [

                  const SizedBox(height: 40),

                  Stack(

                    children: [
                      CircleAvatar(

                        radius: 50,
                        backgroundImage: AssetImage('assets/profile.jpg')

                      ),

                      
                    ],

                  ),
                  const SizedBox(height: 20),
                  Obx(() => TextField(

                    controller: TextEditingController(text: userController.username),
                    decoration: const InputDecoration(

                      labelText: 'Username',

                      border: UnderlineInputBorder(),

                    ),
                  )),

                  const SizedBox(height: 10),

                  Obx(() => TextField(

                    controller: TextEditingController(text: userController.email),

                    decoration: const InputDecoration(
                      labelText: 'Email',
                      border: UnderlineInputBorder(),
                    ),

                  )),
                  const SizedBox(height: 10),

                  Obx(() => TextField(

                    controller: TextEditingController(text: userController.fullName),
                    decoration: const InputDecoration(
                      labelText: 'Full Name',

                      border: UnderlineInputBorder(),

                    ),
                  )),

                  const SizedBox(height: 10),

                  Obx(() => TextField(
                    controller: TextEditingController(text: userController.role.value),

                    decoration: const InputDecoration(

                      labelText: 'Role',

                      border: UnderlineInputBorder(),

                    ),
                  )),

                  const SizedBox(height: 20),

                

                


                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: _logout,

                    child: const Text('Logout'),

                    style: ElevatedButton.styleFrom(

                      foregroundColor: Colors.white,

                      backgroundColor: Colors.red,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),

                      ),
                    ),

                  ),

                ],
              ),
            ),
          ),

        ],
      ),
    );
  }
}