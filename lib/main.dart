import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:life_record/router/app_pages.dart';

import 'database/dbutil.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await DBUtil.init();
  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      getPages: AppPages.pages, //所有的页面集合
      initialRoute: '/', //初始页面
    );
  }
}
