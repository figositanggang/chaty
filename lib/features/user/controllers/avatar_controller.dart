import 'package:get/get_rx/get_rx.dart';
import 'package:get/get_state_manager/get_state_manager.dart';

class AvatarController extends GetxController {
  Rx<int> _index = 0.obs;
  int get index => _index.value;
  void setIndex(int value) {
    _index.value = value;
  }
}
