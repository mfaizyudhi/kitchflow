import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:kitchflow/app/modules/inventory/views/inventory_view.dart';
import 'package:kitchflow/routes/app_pages.dart';

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  Widget buildApp() {
    return GetMaterialApp(
      home: InventoryView(),
      getPages: [
        GetPage(
          name: Routes.TAMBAH_BAHAN,
          page: () => const Scaffold(),
        ),
      ],
    );
  }

  testWidgets('header tampil', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Inventory'), findsOneWidget);
    expect(find.text('Kelola stok bahan makanan'), findsOneWidget);
  });

  // ===== PERBAIKAN =====
  testWidgets('summary card tampil', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Total Item'), findsOneWidget);

    // karena text muncul lebih dari 1
    expect(find.text('Menipis'), findsWidgets);
    expect(find.text('Habis'), findsWidgets);
  });

  testWidgets('search field tampil', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.byType(TextField), findsWidgets);
  });

  testWidgets('kategori filter tampil', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Protein'), findsWidgets);
    expect(find.text('Sayuran'), findsOneWidget);
    expect(find.text('Bumbu'), findsOneWidget);
    expect(find.text('Lainnya'), findsOneWidget);
  });

  testWidgets('tap kategori Protein memfilter list', (tester) async {
    await tester.pumpWidget(buildApp());

    await tester.tap(find.text('Protein').first);
    await tester.pump();

    expect(find.text('Ayam Broiler'), findsOneWidget);
    expect(find.text('Beras'), findsNothing);
  });

  testWidgets('tap kategori Sayuran memfilter list', (tester) async {
    await tester.pumpWidget(buildApp());

    await tester.tap(find.text('Sayuran'));
    await tester.pump();

    expect(find.text('Cabe Merah'), findsOneWidget);
    expect(find.text('Ayam Broiler'), findsNothing);
  });

  testWidgets('tombol tambah tidak error', (tester) async {
    await tester.pumpWidget(buildApp());

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();
  });
}