   import 'package:flutter/material.dart';
   import 'package:get/get.dart';
import 'package:smartdoor/controller/LogController.dart';
   

   class NotificationScreen extends StatefulWidget {
     @override
     _NotificationScreenState createState() => _NotificationScreenState();
   }

   class _NotificationScreenState extends State<NotificationScreen> {
     final LogController logController = Get.put(LogController());

     @override
     void initState() {
       super.initState();
       logController.fetchLogs();
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
                   image: AssetImage('assets/bglogin.png'), // Ganti dengan path gambar Anda
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
               child: Obx(() {
                 if (logController.logs.isEmpty) {
                   return const Center(
                     child: Text(
                       'No logs found',
                       style: TextStyle(
                         fontSize: 16,
                         color: Colors.black,
                       ),
                     ),
                   );
                 } else {
                   return ListView.builder(
                     itemCount: logController.logs.length,
                     itemBuilder: (context, index) {
                       var log = logController.logs[index];
                       return Container(
                         margin: const EdgeInsets.only(bottom: 10),
                         padding: const EdgeInsets.all(16.0),
                         decoration: BoxDecoration(
                           color: Colors.white,
                           borderRadius: BorderRadius.circular(10),
                           boxShadow: [
                             BoxShadow(
                               color: Colors.grey.withOpacity(0.5),
                               spreadRadius: 2,
                               blurRadius: 5,
                               offset: const Offset(0, 3),
                             ),
                           ],
                         ),
                         child: Row(
                           children: [
                             const Icon(Icons.lock, size: 40, color: Colors.black),
                             const SizedBox(width: 10),
                             Column(
                               crossAxisAlignment: CrossAxisAlignment.start,
                               children: [
                                 Text(
                                   '${log['username']} ${log['action']} ${log['nama_perangkat']}',
                                   style: const TextStyle(
                                     fontSize: 16,
                                     color: Colors.black,
                                   ),
                                 ),
                                 Text(
                                   log['created_at'],
                                   style: const TextStyle(
                                     fontSize: 14,
                                     color: Colors.grey,
                                   ),
                                 ),
                               ],
                             ),
                           ],
                         ),
                       );
                     },
                   );
                 }
               }),
             ),
           ],
         ),
       );
     }
   }