part of 'app_pages.dart';

abstract class Routes {
  Routes._();

  static const SPLASH = '/splash';
  static const ONBOARDING = '/onboarding';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const MAIN = '/main';
  static const HPP = '/hpp';
  static const PRODUCTION = '/production';
  static const SALES = '/sales';
  static const ANALYTICS = '/analytics';
  static const PROFIL = '/profil';

  // Tab navbar - dihandle MainWrapper, tidak perlu route sendiri
  // tapi tetap didefinisikan untuk binding
  static const DASHBOARD = '/dashboard';
  static const INVENTORY = '/inventory';
  static const AI_SCAN = '/hpp';
  static const BEST_MENU = '/best-menu';
  static const TAMBAH_BAHAN = '/tambah-bahan';
}
