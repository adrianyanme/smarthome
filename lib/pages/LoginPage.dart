   import 'package:flutter/material.dart';
   import 'package:get/get.dart';
import 'package:smartdoor/controller/LoginController.dart';
  

   class LoginPage extends StatelessWidget {
     final LoginController loginController = Get.put(LoginController());

     @override
     Widget build(BuildContext context) {
       return Scaffold(
         body: Stack(
           children: [
             // Background image
             Container(
               decoration: const BoxDecoration(
                 image: DecorationImage(
                   image: AssetImage('assets/bglogin.png'), // Ganti dengan path gambar Anda
                   fit: BoxFit.cover,
                 ),
               ),
             ),
             // Semi-transparent overlay
             Container(
               color: Colors.black.withOpacity(0.3),
             ),
             // Login form
             Center(
               child: SingleChildScrollView(
                 child: Padding(
                   padding: const EdgeInsets.all(16.0),
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.center,
                     children: [
                       const Text(
                         'Welcome to',
                         style: TextStyle(
                           fontSize: 24,
                           fontWeight: FontWeight.bold,
                           color: Colors.white,
                         ),
                       ),
                       const Text(
                         'Smart Home',
                         style: TextStyle(
                           fontSize: 32,
                           fontWeight: FontWeight.bold,
                           color: Colors.teal,
                         ),
                       ),
                       const Text(
                         'Let\'s manage your smart home',
                         style: TextStyle(
                           fontSize: 16,
                           color: Colors.white,
                         ),
                       ),
                       const SizedBox(height: 40),
                       TextField(
                         controller: loginController.loginController,
                         decoration: const InputDecoration(
                           labelText: 'Username',
                           labelStyle: TextStyle(color: Colors.white),
                           enabledBorder: UnderlineInputBorder(
                             borderSide: BorderSide(color: Colors.white),
                           ),
                           focusedBorder: UnderlineInputBorder(
                             borderSide: BorderSide(color: Colors.teal),
                           ),
                         ),
                         style: const TextStyle(color: Colors.white),
                       ),
                       const SizedBox(height: 20),
                       Obx(() => TextField(
                         controller: loginController.passwordController,
                         decoration: InputDecoration(
                           labelText: 'Password',
                           labelStyle: const TextStyle(color: Colors.white),
                           enabledBorder: const UnderlineInputBorder(
                             borderSide: BorderSide(color: Colors.white),
                           ),
                           focusedBorder: const UnderlineInputBorder(
                             borderSide: BorderSide(color: Colors.teal),
                           ),
                           suffixIcon: IconButton(
                             icon: Icon(
                               loginController.isLoading.value
                                   ? Icons.visibility
                                   : Icons.visibility_off,
                               color: Colors.white,
                             ),
                             onPressed: () {
                               loginController.isLoading.value = !loginController.isLoading.value;
                             },
                           ),
                         ),
                         obscureText: loginController.isLoading.value,
                         style: const TextStyle(color: Colors.white),
                       )),
                       const SizedBox(height: 20),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.start,
                         children: [
                           const Text(
                             "Don't have an account?",
                             style: TextStyle(color: Colors.white),
                           ),
                           TextButton(
                             onPressed: () {
                               Get.toNamed('/register'); // Ubah ini
                             },
                             child: const Text(
                               'Register',
                               style: TextStyle(color: Colors.teal),
                             ),
                           ),
                         ],
                       ),
                       const SizedBox(height: 20),
                       Obx(() => loginController.isLoading.value
                           ? const CircularProgressIndicator()
                           : ElevatedButton(
                               onPressed: loginController.login,
                               style: ElevatedButton.styleFrom(
                                 foregroundColor: Colors.black,
                                 backgroundColor: Colors.white,
                                 shape: RoundedRectangleBorder(
                                   borderRadius: BorderRadius.circular(30),
                                 ),
                                 padding: const EdgeInsets.symmetric(vertical: 15),
                               ),
                               child: const Text('Login'),
                             )),
                     ],
                   ),
                 ),
               ),
             ),
           ],
         ),
       );
     }
   }