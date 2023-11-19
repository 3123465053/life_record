
import 'package:get/get.dart';

import 'logic.dart';

class ShowNoteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ShowNoteLogic());
  }
}