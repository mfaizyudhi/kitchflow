// core/widgets/main_wrapper.dart

import 'package:flutter/material.dart'; 
import '../../app/modules/dashboard/views/dashboard_view.dart';
import '../../app/modules/inventory/views/inventory_view.dart';
import '../../app/modules/ai_scan/views/ai_scan_view.dart';
import '../../app/modules/analytics/views/analytics_view.dart';
import '../../app/modules/profil/views/profil_view.dart';
import 'bottom_navbar.dart';

class MainWrapper extends StatefulWidget {
  const MainWrapper({super.key});

  @override
  State<MainWrapper> createState() => _MainWrapperState();
}

class _MainWrapperState extends State<MainWrapper> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    DashboardView(),
    InventoryView(),
    AiScanView(),
    AnalyticsView(),
    ProfilView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0F1E),
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavbar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
      ),
    );
  }
}