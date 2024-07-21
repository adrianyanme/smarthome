   import 'package:flutter/material.dart';
   import 'package:get/get.dart';
   import 'package:google_fonts/google_fonts.dart';
   import 'package:shared_preferences/shared_preferences.dart';
   import 'pages/LoginPage.dart';
   import 'pages/RegisterPage.dart';
   import 'pages/HomePage.dart';

   void main() async {
     WidgetsFlutterBinding.ensureInitialized();
     SharedPreferences prefs = await SharedPreferences.getInstance();
     var token = prefs.getString('token');
     runApp(MyApp(token: token));
   }

   class MyApp extends StatelessWidget {
     final String? token;

     MyApp({this.token});

     @override
     Widget build(BuildContext context) {
       return GetMaterialApp(
         debugShowCheckedModeBanner: false,
         theme: ThemeData(
           textTheme: GoogleFonts.poppinsTextTheme(
             Theme.of(context).textTheme,
           ),
         ),
         initialRoute: token == null ? '/' : '/home',
         getPages: [
           GetPage(name: '/', page: () => LoginPage()),
           GetPage(name: '/register', page: () => RegisterPage()),
           GetPage(name: '/home', page: () => HomePage()),
         ],
       );
     }
   }