import 'package:get_it/get_it.dart';
import 'package:web_admin/pages/agents/agents_view_model.dart';
import 'package:web_admin/pages/crypto/crypto_view_model.dart';
import 'package:web_admin/pages/dashboard/dashboard_view_model.dart';
import 'package:web_admin/pages/giftcards/giftcards_view_model.dart';
import 'package:web_admin/pages/home_feed/home_feed_view_model.dart';
import 'package:web_admin/pages/homepage/home_view_model.dart';
import 'package:web_admin/pages/login/login_view_model.dart';
import 'package:web_admin/pages/startup/startup_view_model.dart';
import 'package:web_admin/pages/withdrawals/withdrawals_view_model.dart';
import 'package:web_admin/repositories/app_repository.dart';
import 'package:web_admin/repositories/auth_repository.dart';
import 'package:web_admin/services/navigation_service.dart';
import 'package:web_admin/services/snackbar_service.dart';

GetIt serviceLocator = GetIt.instance;

void setupLocator() {
  // Services Initialization
  serviceLocator.registerLazySingleton(() => AuthRepository());
  serviceLocator.registerLazySingleton(() => AppRepository());
  serviceLocator.registerLazySingleton(() => NavigatorService());
  serviceLocator.registerLazySingleton(() => SnackBarService());

  serviceLocator.registerFactory(() => StartupViewModel());
  serviceLocator.registerFactory(() => LoginViewModel());
  serviceLocator.registerFactory(() => HomeViewModel());
  serviceLocator.registerFactory(() => DashboardViewModel());
  serviceLocator.registerFactory(() => CryptoViewModel());
  serviceLocator.registerFactory(() => GiftcardsViewModel());
  serviceLocator.registerFactory(() => AdminsViewModel());
  serviceLocator.registerFactory(() => WithdrawalsViewModel());
  serviceLocator.registerFactory(() => HomeFeedViewModel());
}