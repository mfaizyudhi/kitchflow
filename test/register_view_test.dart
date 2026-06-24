import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:kitchflow/app/modules/register/views/register_view.dart';

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  Widget buildApp() {
    return GetMaterialApp(
      home: RegisterView(),
    );
  }

  testWidgets('semua form field tampil', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Nama Warteg'), findsOneWidget);
    expect(find.text('Nama Pemilik'), findsOneWidget);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Lokasi Warteg'), findsOneWidget);
  });

  testWidgets('icon password berubah saat di-tap', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.byIcon(Icons.visibility_off_outlined), findsOneWidget);

    await tester.tap(find.byIcon(Icons.visibility_off_outlined));
    await tester.pump();

    expect(find.byIcon(Icons.visibility_outlined), findsOneWidget);
  });

  testWidgets('tombol back memanggil Get.back()', (tester) async {
    await tester.pumpWidget(buildApp());

    await tester.tap(find.byIcon(Icons.arrow_back_ios_new_rounded));
    await tester.pump();
  });

  testWidgets('tombol Buat Akun tampil', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Buat Akun'), findsWidgets);
  });

  testWidgets('link Masuk tampil', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(
        find.byWidgetPredicate((widget) =>
            widget is RichText && widget.text.toPlainText().contains('Masuk')),
        findsWidgets);
  });
}
