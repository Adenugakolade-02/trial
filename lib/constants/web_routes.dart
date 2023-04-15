import '../service_locator.dart';
import '../services/navigation_service.dart';

class WebRoute {
  static const startup = '/';
  static const login = 'login';
  static const forgotPassword = 'forgotPassword';
  static const forgotPasswordSuccess = 'forgotPasswordSuccess';
  static const home = 'home';

  static const dashboard = 'dashboard';
  static const cryptoDashboard = '$dashboard/crypto/';
  static const cryptoPending = '$dashboard/crypto/pending';
  static const cryptoTransactions = '$dashboard/crypto/transactions';

  static const giftcardDashboard = '$dashboard/giftcard/';
  static const giftcardPending = '$dashboard/giftcard/pending';
  static const giftcardTransactions = '$dashboard/giftcard/transactions';
  static const giftcardBrands = '$dashboard/giftcard/brands';
  static const giftcardDetails = '$dashboard/giftcard/details';

  static const agentDashboard = '$dashboard/agent/';
  static const agentCreate = '$dashboard/agent/create';
  static const agentEdit = '$dashboard/agent/edit';

  static const withdrawalDashboard = '$dashboard/withdrawal/';
  static const withdrawalAccepted = '$dashboard/withdrawal/accepted';
  static const withdrawalDeclined = '$dashboard/withdrawal/declined';

  static const homeFeedDashboard = '$dashboard/feed/';


  static Future go(String destination, { dynamic arguments, bool? pop, bool? popAll }) async {
    if (pop == true) {
      return await serviceLocator<NavigatorService>().popNavigateTo(destination, arguments: arguments);
    } else if (popAll == true) {
      return await serviceLocator<NavigatorService>().popAllNavigateTo(destination, arguments: arguments);
    } else {
      return await serviceLocator<NavigatorService>().navigateTo(destination, arguments: arguments);
    }
  }

  static pop<T extends Object>([T? result]) {
    return serviceLocator<NavigatorService>().pop(result);
  }

  static Future dashboardGo(String destination, { dynamic arguments, bool? pop, bool? popAll }) async {
    if (pop == true) {
      return await serviceLocator<NavigatorService>().dashboardPopNavigateTo(destination, arguments: arguments);
    } else if (popAll == true) {
      return await serviceLocator<NavigatorService>().dashboardPopAllNavigateTo(destination, arguments: arguments);
    } else {
      return await serviceLocator<NavigatorService>().dashboardNavigateTo(destination, arguments: arguments);
    }
  }

  static dashboardPop<T extends Object>([T? result]) {
    return serviceLocator<NavigatorService>().dashboardPop(result);
  }
}