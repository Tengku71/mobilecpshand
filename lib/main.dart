import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'app/routes/app_pages.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();  // initialize storage

  final box = GetStorage();
  final token = box.read('token');

  final initialRoute = token != null ? Routes.HOME : AppPages.INITIAL;

  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Application",
      initialRoute: initialRoute,
      getPages: AppPages.routes,
    ),
  );
}
