import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://ldtjqmuqlsbainvyhhvu.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImxkdGpxbXVxbHNiYWludnloaHZ1Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODE2NjMzNjYsImV4cCI6MjA5NzIzOTM2Nn0.RKi2qXMHMjDl7GnFvmFdv76KC7qjyxizjMFxmIjifmk',
  );

  final session =
      Supabase.instance.client.auth.currentSession;

  runApp(
    MyApp(
      isLoggedIn: session != null,
    ),
  );
}

class MyApp extends StatelessWidget {
  final bool isLoggedIn;

  const MyApp({
    super.key,
    required this.isLoggedIn,
  });

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'KFlow AI',
      initialRoute: isLoggedIn
          ? '/main'
          : AppPages.INITIAL,
      getPages: AppPages.routes,
    );
  }
}