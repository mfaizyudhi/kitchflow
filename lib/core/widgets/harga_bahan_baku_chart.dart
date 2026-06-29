import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../theme/app_colors.dart';
import 'glass_card.dart';
import 'package:kitchflow/app/modules/dashboard/controllers/dashboard_controller.dart';
import 'dart:math' as math;

/// Widget chart harga bahan baku 7 hari terakhir.
/// Data diambil dari MongoDB via Flask API yang berjalan di Google Colab.
class HargaBahanBakuChart extends StatefulWidget {
  const HargaBahanBakuChart({super.key});
 
  @override
  State<HargaBahanBakuChart> createState() => _HargaBahanBakuChartState();
}
 
class _HargaBahanBakuChartState extends State<HargaBahanBakuChart>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animCtrl;
  late Animation<double> _fadeAnim;
 
  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    _fadeAnim = CurvedAnimation(parent: _animCtrl, curve: Curves.easeOut);
    _animCtrl.forward();
  }
 
  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }
 
  void _onTabChange(int i) {
    setState(() => _selectedIndex = i);
    _animCtrl..reset()..forward();
  }
 
  @override
  Widget build(BuildContext context) {
    final ctrl = Get.find<DashboardController>();
 
    return Obx(() {
      // ── LOADING ────────────────────────────────────────────────────
      if (ctrl.isLoadingHarga.value) {
        return const GlassCard(
          child: SizedBox(
            height: 200,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(color: AppColors.primary, strokeWidth: 2),
                  SizedBox(height: 12),
                  Text('Mengambil data dari MongoDB...',
                      style: TextStyle(color: AppColors.textSecondary, fontSize: 12)),
                ],
              ),
            ),
          ),
        );
      }
 
      // ── ERROR ──────────────────────────────────────────────────────
      if (ctrl.hargaError.value.isNotEmpty) {
        return GlassCard(
          child: SizedBox(
            height: 160,
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.cloud_off_rounded, color: AppColors.textMuted, size: 36),
                  const SizedBox(height: 10),
                  Text(ctrl.hargaError.value,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AppColors.textSecondary, fontSize: 12, height: 1.5)),
                  const SizedBox(height: 16),
                  GestureDetector(
                    onTap: ctrl.refresh,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      decoration: BoxDecoration(
                        color: AppColors.primary.withOpacity(0.15),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: AppColors.primary.withOpacity(0.4)),
                      ),
                      child: const Text('Coba Lagi',
                          style: TextStyle(
                              color: AppColors.primary, fontSize: 12, fontWeight: FontWeight.w600)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }
 
      // ── DATA ───────────────────────────────────────────────────────
      final tabs     = ctrl.daftarKomoditas.isNotEmpty ? ctrl.daftarKomoditas : DashboardController.defaultTabs;
      final safeIdx  = _selectedIndex.clamp(0, tabs.length - 1);
      final selKom   = tabs[safeIdx];
      final selColor = ctrl.colorForKomoditas(selKom);
      final data     = ctrl.hargaBahanBaku[selKom] ?? [];
      final statMap  = ctrl.statistikHarga[selKom];
 
      return GlassCard(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── HEADER ─────────────────────────────────────────────
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(children: [
                  Container(
                    width: 7, height: 7,
                    decoration: const BoxDecoration(
                        color: AppColors.success, shape: BoxShape.circle),
                  ),
                  const SizedBox(width: 6),
                  const Text('Live dari MongoDB • 7 hari terakhir',
                      style: TextStyle(color: AppColors.textMuted, fontSize: 10)),
                ]),
                GestureDetector(
                  onTap: ctrl.refresh,
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: AppColors.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.refresh_rounded,
                        color: AppColors.primary, size: 14),
                  ),
                ),
              ],
            ),
 
            const SizedBox(height: 12),
 
            // ── TAB KOMODITAS ──────────────────────────────────────
            SizedBox(
              height: 34,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: tabs.length,
                separatorBuilder: (_, __) => const SizedBox(width: 8),
                itemBuilder: (_, i) {
                  final isActive = i == safeIdx;
                  final color    = ctrl.colorForKomoditas(tabs[i]);
                  return GestureDetector(
                    onTap: () => _onTabChange(i),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                      decoration: BoxDecoration(
                        color: isActive ? color.withOpacity(0.18) : Colors.transparent,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isActive ? color.withOpacity(0.5) : Colors.white12,
                        ),
                      ),
                      child: Text(tabs[i],
                          style: TextStyle(
                            color: isActive ? color : AppColors.textMuted,
                            fontSize: 11,
                            fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
                          )),
                    ),
                  );
                },
              ),
            ),
 
            const SizedBox(height: 18),
 
            // ── LINE CHART ─────────────────────────────────────────
            FadeTransition(
              opacity: _fadeAnim,
              child: SizedBox(
                height: 140,
                child: data.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.bar_chart_rounded,
                                color: AppColors.textMuted, size: 32),
                            const SizedBox(height: 8),
                            Text('Data "$selKom" belum tersedia',
                                style: const TextStyle(
                                    color: AppColors.textMuted, fontSize: 12)),
                          ],
                        ),
                      )
                    : CustomPaint(
                        painter: _LineChartPainter(data: data, lineColor: selColor),
                        size: const Size(double.infinity, 140),
                      ),
              ),
            ),
 
            // ── LABEL HARI ─────────────────────────────────────────
            if (data.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: data.map((e) => SizedBox(
                  width: 32,
                  child: Text(e['hari'] as String? ?? '',
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: AppColors.textMuted, fontSize: 9)),
                )).toList(),
              ),
            ],
 
            const SizedBox(height: 16),
            const Divider(color: Colors.white10, height: 1),
            const SizedBox(height: 14),
 
            // ── STATISTIK MIN / AVG / MAX ──────────────────────────
            if (statMap != null)
              _StatRow(statMap: statMap, color: selColor)
            else if (data.isNotEmpty)
              _StatRowFromData(data: data, color: selColor),
 
            const SizedBox(height: 10),
 
            // ── SUMBER DATA ────────────────────────────────────────
            const Text('Sumber: PIHPS Nasional — Bank Indonesia',
                style: TextStyle(color: AppColors.textMuted, fontSize: 9)),
          ],
        ),
      );
    });
  }
}
 
// ── STAT ROW dari API /statistik ─────────────────────────────────────────
class _StatRow extends StatelessWidget {
  const _StatRow({required this.statMap, required this.color});
  final Map<String, dynamic> statMap;
  final Color color;
 
  @override
  Widget build(BuildContext context) {
    return Row(children: [
      Expanded(child: _statItem('Terendah', (statMap['min'] as num?)?.toDouble() ?? 0,
          AppColors.success, Icons.arrow_downward_rounded)),
      Container(width: 1, height: 40, color: Colors.white10),
      Expanded(child: _statItem('Rata-rata', (statMap['avg'] as num?)?.toDouble() ?? 0,
          color, Icons.remove_rounded)),
      Container(width: 1, height: 40, color: Colors.white10),
      Expanded(child: _statItem('Tertinggi', (statMap['max'] as num?)?.toDouble() ?? 0,
          AppColors.danger, Icons.arrow_upward_rounded)),
    ]);
  }
}
 
// ── STAT ROW dari data lokal (fallback) ──────────────────────────────────
class _StatRowFromData extends StatelessWidget {
  const _StatRowFromData({required this.data, required this.color});
  final List<Map<String, dynamic>> data;
  final Color color;
 
  @override
  Widget build(BuildContext context) {
    final prices = data.map((e) => (e['harga'] as num?)?.toDouble() ?? 0.0)
        .where((v) => v > 0).toList();
    if (prices.isEmpty) return const SizedBox.shrink();
    final minP = prices.reduce(math.min);
    final maxP = prices.reduce(math.max);
    final avgP = prices.reduce((a, b) => a + b) / prices.length;
 
    return Row(children: [
      Expanded(child: _statItem('Terendah', minP, AppColors.success, Icons.arrow_downward_rounded)),
      Container(width: 1, height: 40, color: Colors.white10),
      Expanded(child: _statItem('Rata-rata', avgP, color, Icons.remove_rounded)),
      Container(width: 1, height: 40, color: Colors.white10),
      Expanded(child: _statItem('Tertinggi', maxP, AppColors.danger, Icons.arrow_upward_rounded)),
    ]);
  }
}
 
Widget _statItem(String label, double value, Color color, IconData icon) {
  return Column(children: [
    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Icon(icon, color: color, size: 11),
      const SizedBox(width: 3),
      Text(label, style: const TextStyle(color: AppColors.textMuted, fontSize: 10)),
    ]),
    const SizedBox(height: 4),
    Text(DashboardController.formatRupiah(value),
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
  ]);
}
 
// ── CUSTOM PAINTER ────────────────────────────────────────────────────────
class _LineChartPainter extends CustomPainter {
  const _LineChartPainter({required this.data, required this.lineColor});
  final List<Map<String, dynamic>> data;
  final Color lineColor;
 
  @override
  void paint(Canvas canvas, Size size) {
    if (data.length < 2) return;
 
    final prices    = data.map((e) => (e['harga'] as num?)?.toDouble() ?? 0.0).toList();
    final minP      = prices.reduce(math.min);
    final maxP      = prices.reduce(math.max);
    final range     = (maxP - minP).abs();
    final effR      = range == 0 ? 1.0 : range;
    const vPad      = 24.0;
 
    Offset toOff(int i) {
      final x    = (i / (data.length - 1)) * size.width;
      final norm = (prices[i] - minP) / effR;
      final y    = size.height - vPad - norm * (size.height - vPad * 2);
      return Offset(x, y);
    }
 
    final pts = List.generate(data.length, toOff);
 
    // Area fill
    final area = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length; i++) {
      final c1 = Offset((pts[i-1].dx + pts[i].dx) / 2, pts[i-1].dy);
      final c2 = Offset((pts[i-1].dx + pts[i].dx) / 2, pts[i].dy);
      area.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, pts[i].dx, pts[i].dy);
    }
    area..lineTo(size.width, size.height)..lineTo(0, size.height)..close();
    canvas.drawPath(area, Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter, end: Alignment.bottomCenter,
        colors: [lineColor.withOpacity(0.28), lineColor.withOpacity(0)],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height)));
 
    // Grid
    final gp = Paint()..color = Colors.white.withOpacity(0.05)..strokeWidth = 1;
    for (int i = 1; i <= 3; i++) {
      final y = size.height / 4 * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), gp);
    }
 
    // Line
    final line = Path()..moveTo(pts.first.dx, pts.first.dy);
    for (int i = 1; i < pts.length; i++) {
      final c1 = Offset((pts[i-1].dx + pts[i].dx) / 2, pts[i-1].dy);
      final c2 = Offset((pts[i-1].dx + pts[i].dx) / 2, pts[i].dy);
      line.cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, pts[i].dx, pts[i].dy);
    }
    canvas.drawPath(line, Paint()
      ..color = lineColor..strokeWidth = 2.2..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round..strokeJoin = StrokeJoin.round);
 
    // Dots + tooltip
    final maxIdx = prices.indexOf(maxP);
    for (int i = 0; i < pts.length; i++) {
      final isMax = i == maxIdx;
      canvas.drawCircle(pts[i], isMax ? 6.0 : 4.0,
          Paint()..color = isMax ? Colors.orange : lineColor);
      canvas.drawCircle(pts[i], isMax ? 3.5 : 2.2, Paint()..color = Colors.white);
      if (isMax) _drawTooltip(canvas, size, pts[i], prices[i]);
    }
  }
 
  void _drawTooltip(Canvas canvas, Size size, Offset pt, double price) {
    final label = DashboardController.formatRupiah(price);
    final tp = TextPainter(
      text: TextSpan(text: label,
          style: TextStyle(color: lineColor, fontSize: 9, fontWeight: FontWeight.bold)),
      textDirection: TextDirection.ltr,
    )..layout();
 
    const hP = 8.0; const vP = 4.0;
    final rW = tp.width + hP * 2;
    final rH = tp.height + vP * 2;
    final left = (pt.dx - rW / 2).clamp(0.0, size.width - rW);
    final top  = (pt.dy - rH - 10).clamp(0.0, size.height - rH);
    final rr   = RRect.fromRectAndRadius(Rect.fromLTWH(left, top, rW, rH), const Radius.circular(7));
 
    canvas.drawRRect(rr, Paint()..color = lineColor.withOpacity(0.18));
    canvas.drawRRect(rr, Paint()..color = lineColor.withOpacity(0.45)
        ..style = PaintingStyle.stroke..strokeWidth = 0.8);
    tp.paint(canvas, Offset(left + hP, top + vP));
  }
 
  @override
  bool shouldRepaint(_LineChartPainter o) => o.data != data || o.lineColor != lineColor;
}