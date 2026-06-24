import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:kitchflow/app/modules/ai_scan/views/ai_scan_view.dart';

Widget buildTestableWidget(Widget child) {
  return GetMaterialApp(
    home: child,
  );
}

void main() {
  group('AiScanView Test', () {

    testWidgets(
      'Menampilkan widget awal',
      (WidgetTester tester) async {

        await tester.pumpWidget(
          buildTestableWidget(
            const AiScanView(),
          ),
        );

        await tester.pumpAndSettle();

        // cek RichText header ada
        expect(
          find.byType(RichText),
          findsWidgets,
        );

        // cek state awal
        expect(
          find.text('Scan Bahan Makanan'),
          findsOneWidget,
        );

        expect(
          find.text('Kamera'),
          findsOneWidget,
        );

        expect(
          find.text('Galeri'),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Menjalankan proses scan',
      (WidgetTester tester) async {

        await tester.pumpWidget(
          buildTestableWidget(
            const AiScanView(),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.text('Kamera'),
        );

        await tester.pump();

        expect(
          find.text(
            'AI sedang menganalisis...',
          ),
          findsOneWidget,
        );

        await tester.pump(
          const Duration(seconds: 2),
        );

        await tester.pumpAndSettle();

        expect(
          find.text(
            'Hasil Analisis AI',
          ),
          findsOneWidget,
        );

        expect(
          find.text(
            'Rekomendasi Menu',
          ),
          findsOneWidget,
        );
      },
    );

    testWidgets(
      'Tombol ulang mengembalikan ke state awal',
      (WidgetTester tester) async {

        await tester.pumpWidget(
          buildTestableWidget(
            const AiScanView(),
          ),
        );

        await tester.pumpAndSettle();

        await tester.tap(
          find.text('Kamera'),
        );

        await tester.pump();

        await tester.pump(
          const Duration(seconds: 2),
        );

        await tester.pumpAndSettle();

        expect(
          find.text('Ulang'),
          findsOneWidget,
        );

        await tester.tap(
          find.text('Ulang'),
        );

        await tester.pumpAndSettle();

        expect(
          find.text(
            'Scan Bahan Makanan',
          ),
          findsOneWidget,
        );
      },
    );

  });
}