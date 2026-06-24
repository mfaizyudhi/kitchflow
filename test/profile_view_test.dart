import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:kitchflow/app/modules/profil/views/profil_view.dart';
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
        name: Routes.LOGIN,
        page: () => const Scaffold(
          body: Center(
            child: Text('Login Page'),
          ),
        ),
      ),
    ],
  );
}

void main() {
  group('ProfilView Test', () {

    testWidgets(
      'Menampilkan widget awal',
      (WidgetTester tester) async {

        await tester.pumpWidget(
          buildTestableWidget(
            const ProfilView(),
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.byType(RichText),
          findsWidgets,
        );

        expect(
          find.text(
            'Kelola akun dan preferensi aplikasi',
          ),
          findsOneWidget,
        );

        expect(
          find.text(
            'Warteg Bahari Digital',
          ),
          findsOneWidget,
        );

        expect(
          find.text(
            'Pengaturan Akun',
          ),
          findsOneWidget,
        );

        expect(
          find.text(
            'Fitur & AI',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Menampilkan data profil',
      (WidgetTester tester) async {

        await tester.pumpWidget(
          buildTestableWidget(
            const ProfilView(),
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.text(
            'ID: AI-WRT-0063',
          ),
          findsOneWidget,
        );

        expect(
          find.text(
            'AKTIF',
          ),
          findsOneWidget,
        );

        expect(
          find.text(
            'PREMIUM AI',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Switch AI dapat ditekan',
      (WidgetTester tester) async {

        await tester.pumpWidget(
          buildTestableWidget(
            const ProfilView(),
          ),
        );

        await tester.pumpAndSettle();

        final switchFinder = find.byType(Switch).first;

        // scroll sampai switch terlihat
        await tester.ensureVisible(
          switchFinder,
        );

        await tester.pumpAndSettle();

        await tester.tap(
          switchFinder,
        );

        await tester.pumpAndSettle();

        expect(
          find.byType(Switch),
          findsNWidgets(4),
        );
      },
    );

    testWidgets(
      'Logout berhasil navigasi',
      (WidgetTester tester) async {

        await tester.pumpWidget(
          buildTestableWidget(
            const ProfilView(),
          ),
        );

        await tester.pumpAndSettle();

        final logoutFinder =
            find.text('Logout Dari Sesi');

        // scroll sampai tombol terlihat
        await tester.scrollUntilVisible(
          logoutFinder,
          300,
        );

        await tester.pumpAndSettle();

        expect(
          logoutFinder,
          findsOneWidget,
        );

        await tester.tap(
          logoutFinder,
        );

        await tester.pumpAndSettle();

        expect(
          find.text(
            'Login Page',
          ),
          findsOneWidget,
        );
      },
    );
  });
}