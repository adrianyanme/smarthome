import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';

class ListDeviceController extends GetxController {
  var devices = <Map<String, dynamic>>[].obs;
  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    loadDevicesFromLocal();
    fetchUserDevices();
    // Memulai pembaruan berkala setiap 5 detik
    _timer = Timer.periodic(Duration(seconds: 5), (_) => fetchUserDevices());
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }

  Future<void> loadDevicesFromLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? devicesJson = prefs.getString('devices');
    if (devicesJson != null) {
      devices.value = List<Map<String, dynamic>>.from(json.decode(devicesJson));
      update();
    }
  }

  Future<void> saveDevicesToLocal() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('devices', json.encode(devices));
  }

  Future<void> fetchUserDevices() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    if (token != null) {
      try {
        var response = await Dio().get(
          'http://baha.adrianyan.tech:8000/api/relay/devices',
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        if (response.statusCode == 200) {
          devices.value = List<Map<String, dynamic>>.from(response.data['devices']);
          update();
          saveDevicesToLocal(); // Simpan data ke penyimpanan lokal
        } else {
          print('Failed to fetch devices: ${response.statusCode} ${response.statusMessage}');
        }
      } catch (e) {
        print('Error fetching devices: $e');
        // Jika terjadi error, kita tetap menggunakan data lokal yang sudah dimuat
      }
    } else {
      print('Token is null');
    }
  }

  Future<void> deleteDevice(String serialNumber) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    if (token != null) {
      try {
        print('Deleting device with serial number: $serialNumber');
        var response = await Dio().post(
          'http://baha.adrianyan.tech:8000/api/relay/devices/delete',
          data: {
            'serial_number': serialNumber,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        print('Delete response status: ${response.statusCode}');
        print('Delete response data: ${response.data}');

        if (response.statusCode == 201) {
          devices.removeWhere((device) => device['serial_number'] == serialNumber);
          update();
          Get.snackbar('Success', 'Device deleted successfully', snackPosition: SnackPosition.BOTTOM);
        } else {
          print('Failed to delete device: ${response.statusCode} ${response.statusMessage}');
          Get.snackbar('Error', 'Failed to delete device', snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        print('Error deleting device: $e');
        Get.snackbar('Error', 'Failed to delete device', snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      print('Token is null');
      Get.snackbar('Error', 'Token is null', snackPosition: SnackPosition.BOTTOM);
    }
  }
}