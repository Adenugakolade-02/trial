import 'package:flutter/cupertino.dart';

class NavigatorService {

  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get navigatorKey => _navigatorKey;

  final GlobalKey<NavigatorState> _dashboardNavigatorKey = GlobalKey<NavigatorState>();
  GlobalKey<NavigatorState> get dashboardNavigatorKey => _dashboardNavigatorKey;

  void pop<T extends Object>([T? result]) {
    return _navigatorKey.currentState?.pop(result);
  }

  Future<dynamic>? navigateTo(String routeName, {dynamic arguments}) {
    return _navigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic>? popNavigateTo(String routeName, {dynamic arguments}) {
    return _navigatorKey.currentState?.popAndPushNamed(routeName, arguments: arguments);
  }

  Future<dynamic>? popAllNavigateTo(String routeName, {dynamic arguments}) {
    return _navigatorKey.currentState?.pushNamedAndRemoveUntil(routeName, (route) => false, arguments: arguments);
  }

  void dashboardPop<T extends Object>([T? result]) {
    return _dashboardNavigatorKey.currentState?.pop(result);
  }

  Future<dynamic>? dashboardNavigateTo(String routeName, {dynamic arguments}) {
    return _dashboardNavigatorKey.currentState?.pushNamed(routeName, arguments: arguments);
  }

  Future<dynamic>? dashboardPopNavigateTo(String routeName, {dynamic arguments}) {
    return _dashboardNavigatorKey.currentState?.popAndPushNamed(routeName, arguments: arguments);
  }

  Future<dynamic>? dashboardPopAllNavigateTo(String routeName, {dynamic arguments}) {
    return _dashboardNavigatorKey.currentState?.pushNamedAndRemoveUntil(routeName, (route) => false, arguments: arguments);
  }
}