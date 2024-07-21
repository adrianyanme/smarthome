   import 'package:flutter/material.dart';
   import 'package:get/get.dart';
   import 'package:toggle_switch/toggle_switch.dart';
   import 'package:smartdoor/controller/UserController.dart';
   import 'package:smartdoor/controller/ListDeviceController.dart';
   import 'package:smartdoor/controller/RelayController.dart';
   import 'package:smartdoor/controller/AddDeviceController.dart';

   class HomeScreen extends StatefulWidget {
     const HomeScreen({super.key});

     @override
     _HomeScreenState createState() => _HomeScreenState();
   }

   class _HomeScreenState extends State<HomeScreen> {
     final UserController userController = Get.put(UserController());
     final ListDeviceController listDeviceController = Get.put(ListDeviceController());
     final RelayController relayController = Get.put(RelayController());
     final AddDeviceController addDeviceController = Get.put(AddDeviceController());

     @override
     void initState() {
       super.initState();
       userController.fetchUserInfo();
       listDeviceController.fetchUserDevices();
     }

     void _showAddDeviceDialog() {
       final TextEditingController serialNumberController = TextEditingController();
       final TextEditingController namaPerangkatController = TextEditingController();

       showDialog(
         context: context,
         builder: (BuildContext context) {
           return AlertDialog(
             title: const Text('Add Device'),
             content: Column(
               mainAxisSize: MainAxisSize.min,
               children: [
                 TextField(
                   controller: serialNumberController,
                   decoration: const InputDecoration(
                     labelText: 'Serial Number',
                   ),
                 ),
                 TextField(
                   controller: namaPerangkatController,
                   decoration: const InputDecoration(
                     labelText: 'Nama Perangkat',
                   ),
                 ),
               ],
             ),
             actions: <Widget>[
               TextButton(
                 child: const Text('Cancel'),
                 onPressed: () {
                   Navigator.of(context).pop();
                 },
               ),
               TextButton(
                 child: const Text('Add'),
                 onPressed: () {
                   addDeviceController.addDevice(
                     serialNumberController.text,
                     namaPerangkatController.text,
                   );
                   Navigator.of(context).pop();
                 },
               ),
             ],
           );
         },
       );
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
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   const SizedBox(height: 40),
                   Row(
                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                     children: [
                       Column(
                         crossAxisAlignment: CrossAxisAlignment.start,
                         children: [
                           const Text(
                             'Welcome home,',
                             style: TextStyle(
                               fontSize: 20,
                               fontWeight: FontWeight.normal,
                               color: Colors.black,
                             ),
                           ),
                           Obx(() => Text(
                             userController.username.value,
                             style: const TextStyle(
                               fontSize: 24,
                               fontWeight: FontWeight.bold,
                               color: Colors.black,
                             ),
                           )),
                         ],
                       ),
                       const CircleAvatar(
                         radius: 30,
                         backgroundImage: AssetImage('assets/profile.png'), // Ganti dengan path gambar profil Anda
                       ),
                     ],
                   ),
                   const SizedBox(height: 20),
                   const Text(
                     'SECURITY',
                     style: TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.bold,
                       color: Colors.black,
                     ),
                   ),
                   const SizedBox(height: 10),
                   Container(
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
                     child: const Row(
                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
                       children: [
                         Column(
                           crossAxisAlignment: CrossAxisAlignment.start,
                           children: [
                             Icon(Icons.lock, size: 40, color: Colors.black),
                             SizedBox(height: 10),
                             Text(
                               'Smart Door',
                               style: TextStyle(
                                 fontSize: 18,
                                 fontWeight: FontWeight.bold,
                                 color: Colors.black,
                               ),
                             ),
                           ],
                         ),
                       ],
                     ),
                   ),
                   const SizedBox(height: 20),
                   const Text(
                     'DEVICES',
                     style: TextStyle(
                       fontSize: 16,
                       fontWeight: FontWeight.bold,
                       color: Colors.black,
                     ),
                   ),
                   const SizedBox(height: 10),
                   Expanded(
                     child: GetBuilder<ListDeviceController>(
                       builder: (controller) {
                         if (controller.devices.isEmpty) {
                           return const Text(
                             'No devices found',
                             style: TextStyle(
                               fontSize: 16,
                               color: Colors.black,
                             ),
                           );
                         } else {
                           return ListView.builder(
                             itemCount: controller.devices.length,
                             itemBuilder: (context, index) {
                               var device = controller.devices[index];
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
                                   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                   children: [
                                     Text(
                                       'Pintu: ${device['nama_perangkat']}',
                                       style: const TextStyle(
                                         fontSize: 16,
                                         color: Colors.black,
                                       ),
                                     ),
                                     ToggleSwitch(
                                       initialLabelIndex: 0,
                                       totalSwitches: 2,
                                       labels: ['Off', 'On'],
                                       activeBgColors: [[Colors.red], [Colors.green]],
                                       onToggle: (index) {
                                         if (index == 1) {
                                           relayController.toggleDevice(device['serial_number'], true);
                                         } else {
                                           relayController.toggleDevice(device['serial_number'], false);
                                         }
                                       },
                                     ),
                                   ],
                                 ),
                               );
                             },
                           );
                         }
                       },
                     ),
                   ),
                 ],
               ),
             ),
           ],
         ),
         floatingActionButton: FloatingActionButton(
           onPressed: _showAddDeviceDialog,
           child: const Icon(Icons.add),
           backgroundColor: Colors.teal,
         ),
       );
     }
   }