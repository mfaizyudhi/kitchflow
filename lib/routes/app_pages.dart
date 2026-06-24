import 'package:get/get.dart';

import '../app/modules/ai_scan/bindings/ai_scan_binding.dart';
import '../app/modules/analytics/bindings/analytics_binding.dart';
import '../app/modules/best_menu/bindings/best_menu_binding.dart';
import '../app/modules/best_menu/views/best_menu_view.dart';
import '../app/modules/dashboard/bindings/dashboard_binding.dart';
import '../app/modules/hpp/bindings/hpp_binding.dart';
import '../app/modules/hpp/views/hpp_view.dart';
import '../app/modules/inventory/bindings/inventory_binding.dart';
import '../app/modules/login/bindings/login_binding.dart';
import '../app/modules/login/views/login_view.dart';
import '../app/modules/onboarding/bindings/onboarding_binding.dart';
import '../app/modules/onboarding/views/onboarding_view.dart';
import '../app/modules/production/bindings/production_binding.dart';
import '../app/modules/production/views/production_view.dart';
import '../app/modules/profil/bindings/profil_binding.dart';
import '../app/modules/register/bindings/register_binding.dart';
import '../app/modules/register/views/register_view.dart';
import '../app/modules/sales/bindings/sales_binding.dart';
import '../app/modules/sales/views/sales_view.dart';
import '../app/modules/splash/bindings/splash_binding.dart';
import '../app/modules/splash/views/splash_view.dart';
import '../app/modules/tambah_bahan/bindings/tambah_bahan_binding.dart';
import '../app/modules/tambah_bahan/views/tambah_bahan_view.dart';
import '../core/widgets/main_wrapper.dart';

// Import dari lib/app/modules/ (hasil GetCLI)

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;

  static final routes = [
    GetPage(
      name: Routes.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),

    GetPage(
      name: Routes.ONBOARDING,
      page: () => const OnboardingView(),
      binding: OnboardingBinding(),
    ),

    GetPage(
      name: Routes.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),

    GetPage(
      name: Routes.REGISTER,
      page: () => const RegisterView(),
      binding: RegisterBinding(),
    ),

    // MainWrapper mengelola tab: Dashboard, Inventory, AiScan, Analytics, Profil
    GetPage(
      name: Routes.MAIN,
      page: () => const MainWrapper(),
      bindings: [
        DashboardBinding(),
        InventoryBinding(),
        AiScanBinding(),
        AnalyticsBinding(),
        ProfilBinding(),
      ],
    ),

    // Push pages (ada tombol back)
    GetPage(
      name: Routes.HPP,
      page: () => const HppView(),
      binding: HppBinding(),
    ),

    GetPage(
      name: Routes.PRODUCTION,
      page: () => const ProductionView(),
      binding: ProductionBinding(),
    ),

    GetPage(
      name: Routes.SALES,
      page: () => const SalesView(),
      binding: SalesBinding(),
    ),
    GetPage(
      name: Routes.BEST_MENU,
      page: () => const BestMenuView(),
      binding: BestMenuBinding(),
    ),
    GetPage(
      name: Routes.TAMBAH_BAHAN,
      page: () => const TambahBahanView(),
      binding: TambahBahanBinding(),
    ),
  ];
}
