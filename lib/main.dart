import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'routes/app_pages.dart';

void main() {
  runApp(
    GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KFlow AI',
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
