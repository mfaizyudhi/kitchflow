import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';

import 'package:kitchflow/app/modules/best_menu/views/best_menu_view.dart';

void main() {

  Widget buildTest() {
    return GetMaterialApp(
      home: const BestMenuView(),
    );
  }

  testWidgets('BestMenuView tampil', (tester) async {
    await tester.pumpWidget(buildTest());
    await tester.pumpAndSettle();

    expect(find.byType(BestMenuView), findsOneWidget);
  });

  testWidgets('filter tampil', (tester) async {
    await tester.pumpWidget(buildTest());
    await tester.pumpAndSettle();

    expect(find.text('Semua'), findsOneWidget);
    expect(find.text('Terlaris'), findsOneWidget);
    expect(find.text('Profit Tinggi'), findsOneWidget);
  });

  testWidgets('list menu tampil', (tester) async {
    await tester.pumpWidget(buildTest());
    await tester.pumpAndSettle();

    expect(find.text('Ayam Goreng'), findsOneWidget);
    expect(find.text('Telor Balado'), findsOneWidget);
  });

  testWidgets('tombol tambah tampil', (tester) async {
    await tester.pumpWidget(buildTest());
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.add_rounded), findsOneWidget);
  });

  testWidgets('bottom sheet tambah menu muncul', (tester) async {
    await tester.pumpWidget(buildTest());
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.add_rounded));
    await tester.pumpAndSettle();

    expect(find.text('Nama Menu'), findsOneWidget);
    expect(find.text('Harga Jual (Rp)'), findsOneWidget);
  });
}