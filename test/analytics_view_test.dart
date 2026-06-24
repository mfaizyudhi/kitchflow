import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:kitchflow/app/modules/analytics/views/analytics_view.dart';
import 'package:kitchflow/routes/app_pages.dart';

Widget buildTestableWidget(Widget child) {
  return GetMaterialApp(
    initialRoute: '/',
    getPages: [

      GetPage(
        name: '/',
        page: () => child,
      ),

      // dummy page tujuan navigasi
      GetPage(
        name: Routes.SALES,
        page: () => const Scaffold(
          body: Center(
            child: Text(
              'Sales Page',
            ),
          ),
        ),
      ),
    ],
  );
}

void main() {
  group('AnalyticsView Test', () {

    testWidgets(
      'Menampilkan widget awal',
      (WidgetTester tester) async {

        await tester.pumpWidget(
          buildTestableWidget(
            const AnalyticsView(),
          ),
        );

        await tester.pumpAndSettle();

        // Header RichText
        expect(
          find.byType(RichText),
          findsWidgets,
        );

        expect(
          find.text(
            'Performa bisnis warteg Anda',
          ),
          findsOneWidget,
        );

        expect(
          find.text(
            'Input Penjualan Harian',
          ),
          findsOneWidget,
        );

        expect(
          find.text(
            'Grafik Pertumbuhan Profit',
          ),
          findsOneWidget,
        );

        expect(
          find.text(
            'Menu Terlaris',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Toggle period berhasil ditekan',
      (WidgetTester tester) async {

        await tester.pumpWidget(
          buildTestableWidget(
            const AnalyticsView(),
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Harian'),
          findsOneWidget,
        );

        expect(
          find.text('Mingguan'),
          findsOneWidget,
        );

        expect(
          find.text('Bulanan'),
          findsOneWidget,
        );

        await tester.tap(
          find.text('Mingguan'),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.text('Bulanan'),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Bulanan'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Tombol Input Penjualan Harian navigasi berhasil',
      (WidgetTester tester) async {

        await tester.pumpWidget(
          buildTestableWidget(
            const AnalyticsView(),
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.text(
            'Input Penjualan Harian',
          ),
          findsOneWidget,
        );

        await tester.tap(
          find.text(
            'Input Penjualan Harian',
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.text(
            'Sales Page',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Data menu terlaris muncul',
      (WidgetTester tester) async {

        await tester.pumpWidget(
          buildTestableWidget(
            const AnalyticsView(),
          ),
        );

        await tester.pumpAndSettle();

        expect(
          find.text(
            'Ayam Bakar AI',
          ),
          findsOneWidget,
        );

        expect(
          find.text(
            'Sayur Lodeh',
          ),
          findsOneWidget,
        );

        expect(
          find.text(
            'Orek Tempe',
          ),
          findsOneWidget,
        );
      },
    );

  });
}