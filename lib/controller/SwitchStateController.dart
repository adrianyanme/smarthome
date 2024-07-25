import 'package:get/get.dart';

class SwitchStateController extends GetxController {
  final _switchStates = <String, bool>{}.obs;

  bool getState(String serialNumber) => _switchStates[serialNumber] ?? false;

  void setState(String serialNumber, bool state) {
    _switchStates[serialNumber] = state;
    update();
  }
}