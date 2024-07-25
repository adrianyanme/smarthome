import 'package:get/get.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartdoor/controller/ListDeviceController.dart';

class RelayController extends GetxController {
  final ListDeviceController listDeviceController = Get.find();

  Future<void> toggleDevice(String serialNumber, bool turnOn) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var token = prefs.getString('token');

    if (token != null) {
      try {
        var url = turnOn
            ? 'http://baha.adrianyan.tech:8000/api/relay/open'
            : 'http://baha.adrianyan.tech:8000/api/relay/close';

        print("Toggling device: $serialNumber to ${turnOn ? 'open' : 'close'}");
        var response = await Dio().post(
          url,
          data: {
            'serial_number': serialNumber,
          },
          options: Options(
            headers: {
              'Authorization': 'Bearer $token',
            },
          ),
        );

        print("Toggle device response: ${response.data}");

        if (response.statusCode == 200) {
          // Perbarui status perangkat lokal
          var updatedDevices = listDeviceController.devices.map((device) {
            if (device['serial_number'] == serialNumber) {
              device['status_perangkat'] = turnOn ? 'open' : 'closed';
            }
            return device;
          }).toList();
          listDeviceController.devices.value = updatedDevices;
          listDeviceController.update();

          Get.snackbar('Success', 'Device toggled successfully', snackPosition: SnackPosition.BOTTOM);
        } else {
          Get.snackbar('Error', 'Failed to toggle device', snackPosition: SnackPosition.BOTTOM);
        }
      } catch (e) {
        print('Error toggling device: $e');
        Get.snackbar('Error', 'Failed to toggle device', snackPosition: SnackPosition.BOTTOM);
      }
    } else {
      print("No token found");
      Get.snackbar('Error', 'User token not found', snackPosition: SnackPosition.BOTTOM);
    }
  }
}