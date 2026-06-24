import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:kitchflow/app/modules/tambah_bahan/views/tambah_bahan_view.dart';

void main() {
  setUp(() {
    Get.testMode = true;
  });

  tearDown(() {
    Get.reset();
  });

  Widget buildApp() {
    return GetMaterialApp(
      home: TambahBahanView(),
    );
  }

  testWidgets('header tampil', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(
      find.byWidgetPredicate(
        (widget) =>
            widget is RichText &&
            widget.text.toPlainText().contains('Tambah Bahan'),
      ),
      findsWidgets,
    );

    expect(
      find.text('Kelola stok bahan makanan gudang'),
      findsOneWidget,
    );
  });

  testWidgets('lokasi wilayah tampil', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Lokasi Wilayah Aktif'), findsOneWidget);
    expect(find.text('Kota Tegal, Jawa Tengah'), findsOneWidget);
    expect(find.text('Aktif'), findsOneWidget);
  });

  testWidgets('list stok awal tampil', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Ayam Broiler'), findsOneWidget);
    expect(find.text('Minyak Goreng'), findsOneWidget);
    expect(find.text('Beras Putih'), findsOneWidget);
  });

  testWidgets('jumlah item stok sesuai', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('5 item'), findsOneWidget);
  });

  testWidgets('form tambah bahan tampil', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Nama Bahan'), findsOneWidget);
    expect(find.text('Satuan'), findsOneWidget);
    expect(find.text('Kategori'), findsOneWidget);
    expect(find.text('Harga Beli (Rp)'), findsOneWidget);
    expect(find.text('Berat/Volume Total'), findsOneWidget);
    expect(find.text('Stok Awal'), findsOneWidget);
    expect(find.text('Tambah ke Gudang'), findsOneWidget);
  });

  testWidgets('kategori filter tampil', (tester) async {
    await tester.pumpWidget(buildApp());

    expect(find.text('Protein'), findsOneWidget);
    expect(find.text('Sayuran'), findsOneWidget);
    expect(find.text('Bumbu'), findsOneWidget);
    expect(find.text('Minyak'), findsOneWidget);
    expect(find.text('Lainnya'), findsOneWidget);
  });

  testWidgets('hapus item stok berhasil', (tester) async {
    await tester.pumpWidget(buildApp());

    await tester.tap(
      find.byIcon(Icons.delete_outline_rounded).first,
    );

    await tester.pump();

    expect(find.text('4 item'), findsOneWidget);
    expect(find.text('Ayam Broiler'), findsNothing);
  });

  testWidgets('tombol back tidak error', (tester) async {
    await tester.pumpWidget(buildApp());

    await tester.tap(
      find.byIcon(Icons.arrow_back_ios_new_rounded),
    );

    await tester.pump();
  });
}