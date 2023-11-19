import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import 'logic.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeLogic());
  }
}
