import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:kitchflow/app/modules/dashboard/views/dashboard_view.dart';
import 'package:kitchflow/routes/app_pages.dart';

Widget buildTestableWidget(Widget child) {
  return GetMaterialApp(
    initialRoute: '/',
    getPages: [
      GetPage(
        name: '/',
        page: () => child,
      ),
      GetPage(
        name: Routes.BEST_MENU,
        page: () => const Scaffold(
          body: Center(
            child: Text('Best Menu Page'),
          ),
        ),
      ),
    ],
  );
}

void main() {
  testWidgets('Tombol Lihat Semua berhasil ditekan',
      (WidgetTester tester) async {

    await tester.pumpWidget(
      buildTestableWidget(const DashboardView()),
    );

    await tester.pumpAndSettle();

    // Pastikan tombol ada
    expect(find.text('Lihat Semua'), findsOneWidget);

    // Klik tombol
    await tester.tap(find.text('Lihat Semua'));
    await tester.pumpAndSettle();

    // Pastikan pindah halaman
    expect(find.text('Best Menu Page'), findsOneWidget);
  });
}