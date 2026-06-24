import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:kitchflow/app/modules/login/views/login_view.dart';

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  Widget buildApp() {
  return GetMaterialApp(
    home: LoginView(),
    getPages: [
      GetPage(name: '/main', page: () => Scaffold()), // dummy page
    ],
  );
}

  testWidgets('semua elemen tampil', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Lupa Password?'), findsOneWidget);
    expect(find.text('atau'), findsOneWidget);
    expect(find.text('Halo, Selamat Datang'), findsOneWidget);
    expect(find.text('Data Anda aman & terenkripsi'), findsOneWidget);
  });

  testWidgets('logo KitchFlow AI tampil', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.byWidgetPredicate((widget) =>
      widget is RichText &&
      widget.text.toPlainText().contains('KitchFlow AI')
    ), findsWidgets);
  });

  testWidgets('icon password berubah saat di-tap', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();

    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
  });

  testWidgets('tombol Masuk tampil', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Masuk'), findsOneWidget);
  });

  testWidgets('link Daftar Sekarang tampil', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.byWidgetPredicate((widget) =>
      widget is RichText &&
      widget.text.toPlainText().contains('Daftar Sekarang')
    ), findsWidgets);
  });

  testWidgets('tap tombol Masuk tidak error', (tester) async {
    await tester.pumpWidget(buildApp());

    await tester.tap(find.text('Masuk'));
    await tester.pump();
  });

  testWidgets('tap Lupa Password tidak error', (tester) async {
    await tester.pumpWidget(buildApp());

    await tester.tap(find.text('Lupa Password?'));
    await tester.pump();
  });
}