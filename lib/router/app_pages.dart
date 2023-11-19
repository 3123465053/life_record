import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:life_record/app/pages/home/bindings.dart';
import 'package:life_record/app/pages/home/view.dart';
import 'package:life_record/app/pages/show/binding.dart';
import 'package:life_record/app/pages/show/view.dart';

import 'app_routes.dart';

abstract class AppPages {
  static final pages = [
    GetPage(
      name: AppRoutes.HOME,
      page: () => HomePage(),
      binding: HomeBindings(),
    ),

    GetPage(
      name: AppRoutes.SHOW_NOTE_PAGE,
      page: () => ShowNotePage(),
      binding: ShowNoteBinding(),
    ),
  ];
}
