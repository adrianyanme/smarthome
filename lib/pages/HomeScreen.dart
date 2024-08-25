import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:smartdoor/controller/UserController.dart';
import 'package:smartdoor/controller/ListDeviceController.dart';
import 'package:smartdoor/controller/RelayController.dart';
import 'package:smartdoor/controller/AddDeviceController.dart';
import 'package:smartdoor/controller/ChildAccountController.dart';
import 'package:smartdoor/controller/AddChildAccountController.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({Key? key}) : super(key: key) {
    Get.put(UserController());
    Get.put(ListDeviceController());
    Get.put(RelayController());
    Get.put(AddDeviceController());
    Get.put(ChildAccountController());
    Get.put(AddChildAccountController());
  }

  final UserController userController = Get.find<UserController>();
  final ListDeviceController listDeviceController = Get.find<ListDeviceController>();
  final RelayController relayController = Get.find<RelayController>();
  final AddDeviceController addDeviceController = Get.find<AddDeviceController>();
  final ChildAccountController childAccountController = Get.find<ChildAccountController>();
  final AddChildAccountController addChildAccountController = Get.find<AddChildAccountController>();

  void _showAddChildAccountDialog(BuildContext context) {
    final TextEditingController emailController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController firstnameController = TextEditingController();
    final TextEditingController lastnameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Child Account'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: emailController,
                  decoration: const InputDecoration(labelText: 'Email'),
                ),
                TextField(
                  controller: usernameController,
                  decoration: const InputDecoration(labelText: 'Username'),
                ),
                TextField(
                  controller: firstnameController,
                  decoration: const InputDecoration(labelText: 'First Name'),
                ),
                TextField(
                  controller: lastnameController,
                  decoration: const InputDecoration(labelText: 'Last Name'),
                ),
                TextField(
                  controller: passwordController,
                  decoration: const InputDecoration(labelText: 'Password'),
                  obscureText: true,
                ),
              ],
            ),
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
                addChildAccountController.addChildAccount(
                  emailController.text,
                  usernameController.text,
                  firstnameController.text,
                  lastnameController.text,
                  passwordController.text,
                );
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _showAddDeviceDialog(BuildContext context) {
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
                image: AssetImage('assets/bglogin.png'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // Semi-transparent overlay
          Container(
            color: Colors.white.withOpacity(0.8),
          ),
          // Content
          SafeArea(
            child: CustomScrollView(
              slivers: [
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Welcome section
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
                                userController.fullName,
                                style: const TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              )),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Security section
                      const Text(
                        'SECURITY',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ]),
                  ),
                ),
                // Child accounts list
                Obx(() {
                  if (userController.role.value == 'master') {
                    return SliverPadding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      sliver: Obx(() {
                        if (childAccountController.childAccounts.isEmpty) {
                          return SliverToBoxAdapter(
                            child: Text(
                              'No child accounts found',
                              style: TextStyle(fontSize: 16, color: Colors.black),
                            ),
                          );
                        } else {
                          return SliverList(
                            delegate: SliverChildBuilderDelegate(
                              (context, index) {
                                var child = childAccountController.childAccounts[index];
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
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              '${child['firstname']} ${child['lastname']}',
                                              style: TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text('Username: ${child['username']}'),
                                            Text('Email: ${child['email']}'),
                                          ],
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.delete, color: Colors.red),
                                        onPressed: () {
                                          // Tampilkan dialog konfirmasi sebelum menghapus
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                title: Text('Konfirmasi'),
                                                content: Text('Apakah Anda yakin ingin menghapus akun anak ini?'),
                                                actions: <Widget>[
                                                  TextButton(
                                                    child: Text('Batal'),
                                                    onPressed: () {
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    child: Text('Hapus'),
                                                    onPressed: () {
                                                      childAccountController.deleteChildAccount(child['id'].toString());
                                                      Navigator.of(context).pop();
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                              childCount: childAccountController.childAccounts.length,
                            ),
                          );
                        }
                      }),
                    );
                  } else {
                    return SliverToBoxAdapter(child: Container());
                  }
                }),
                SliverPadding(
                  padding: const EdgeInsets.all(16.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      const SizedBox(height: 20),
                      // Devices section
                      const Text(
                        'DEVICES',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 10),
                    ]),
                  ),
                ),
                // Devices list
                SliverPadding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
                  sliver: Obx(() {
                    if (listDeviceController.devices.isEmpty) {
                      return SliverToBoxAdapter(
                        child: Text(
                          'No devices found',
                          style: TextStyle(fontSize: 16, color: Colors.black),
                        ),
                      );
                    } else {
                      return SliverList(
                        delegate: SliverChildBuilderDelegate(
                          (context, index) {
                            var device = listDeviceController.devices[index];
                            String serialNumber = device['serial_number'];
                            bool isOpen = device['status_perangkat'] == 'open';
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
                                    style: TextStyle(fontSize: 16, color: Colors.black),
                                  ),
                                  Row(
                                    children: [
                                      ToggleSwitch(
                                        initialLabelIndex: isOpen ? 1 : 0,
                                        totalSwitches: 2,
                                        labels: ['Off', 'On'],
                                        activeBgColors: [[Colors.red], [Colors.green]],
                                        onToggle: (index) {
                                          if (index != null) {
                                            bool newState = index == 1;
                                            relayController.toggleDevice(serialNumber, newState).then((_) {
                                              listDeviceController.fetchUserDevices();
                                            });
                                          }
                                        },
                                      ),
                                      if (userController.role.value == 'master') // Hanya tampilkan tombol hapus jika peran adalah master
                                        IconButton(
                                          icon: Icon(Icons.delete, color: Colors.red),
                                          onPressed: () {
                                            // Tampilkan dialog konfirmasi sebelum menghapus
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title: Text('Konfirmasi'),
                                                  content: Text('Apakah Anda yakin ingin menghapus perangkat ini?'),
                                                  actions: <Widget>[
                                                    TextButton(
                                                      child: Text('Batal'),
                                                      onPressed: () {
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                    TextButton(
                                                      child: Text('Hapus'),
                                                      onPressed: () {
                                                        listDeviceController.deleteDevice(serialNumber);
                                                        Navigator.of(context).pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          },
                                        ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          },
                          childCount: listDeviceController.devices.length,
                        ),
                      );
                    }
                  }),
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: Obx(() {
        if (userController.role.value == 'master') {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton(
                heroTag: 'addChild',
                onPressed: () => _showAddChildAccountDialog(context),
                child: const Icon(Icons.person_add),
                backgroundColor: Colors.blue,
              ),
              const SizedBox(height: 16),
              FloatingActionButton(
                heroTag: 'addDevice',
                onPressed: () => _showAddDeviceDialog(context),
                child: const Icon(Icons.add),
                backgroundColor: Colors.teal,
              ),
            ],
          );
        } else {
          return Container();
        }
      }),
    );
  }
}