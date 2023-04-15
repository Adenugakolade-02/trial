import 'package:flutter/material.dart';
import 'package:web_admin/constants/web_routes.dart';
import 'package:web_admin/models/agent_data.dart';
import 'package:web_admin/models/gift_card_type.dart';
import 'package:web_admin/pages/agents/agents.dart';
import 'package:web_admin/pages/agents/agents_create.dart';
import 'package:web_admin/pages/agents/agents_edit.dart';
import 'package:web_admin/pages/crypto/crypto.dart';
import 'package:web_admin/pages/crypto/crypto_pending.dart';
import 'package:web_admin/pages/crypto/crypto_transactions.dart';
import 'package:web_admin/pages/dashboard/dashboard.dart';
import 'package:web_admin/pages/giftcards/giftcard_brands.dart';
import 'package:web_admin/pages/giftcards/giftcard_details.dart';
import 'package:web_admin/pages/giftcards/giftcard_pending.dart';
import 'package:web_admin/pages/giftcards/giftcard_transactions.dart';
import 'package:web_admin/pages/giftcards/giftcards.dart';
import 'package:web_admin/pages/home_feed/home_feed.dart';
import 'package:web_admin/pages/homepage/home.dart';
import 'package:web_admin/pages/login/forgot_password.dart';
import 'package:web_admin/pages/login/login.dart';
import 'package:web_admin/pages/login/password_reset_success.dart';
import 'package:web_admin/pages/startup/startup.dart';
import 'package:web_admin/pages/withdrawals/withdrawals.dart';
import 'package:web_admin/pages/withdrawals/withdrawals_accepted.dart';
import 'package:web_admin/pages/withdrawals/withdrawals_declined.dart';

class AppRouter {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case WebRoute.startup:
        return _buildRoute(const Startup(), settings: settings);
      case WebRoute.login:
        return _buildRoute(Login(), settings: settings);
      case WebRoute.forgotPassword:
        return _buildRoute(ForgotPassword(), settings: settings);
      case WebRoute.forgotPasswordSuccess:
        return _buildRoute(const ForgotPasswordSuccess(), settings: settings);
      case WebRoute.home:
        return _buildRoute(const Home(pageRoute: WebRoute.dashboard), settings: settings);
      default:
        if (settings.name!.startsWith(WebRoute.dashboard)) {
          return _buildRoute(Home(pageRoute: settings.name!), settings: settings);
        }
        return _buildRoute(const Scaffold(
          body: Center(child: Text('Invalid route reached.'),),
        ));
    }
  }

  static Route<dynamic> generateNestedRoute(RouteSettings settings) {
    switch (settings.name) {
      case WebRoute.dashboard:
        return _buildRoute(Dashboard(), settings: settings);
      case WebRoute.cryptoDashboard:
        return _buildRoute(Crypto(), settings: settings);
      case WebRoute.cryptoPending:
        return _buildRoute(CryptoPendingTransactions(title: settings.arguments as String,), settings: settings);
      case WebRoute.cryptoTransactions:
        return _buildRoute(CryptoTransactions(title: settings.arguments as String,), settings: settings);
      case WebRoute.giftcardDashboard:
        return _buildRoute(Giftcards(), settings: settings);
      case WebRoute.giftcardPending:
        return _buildRoute(GiftcardPendingTransactions(), settings: settings);
      case WebRoute.giftcardTransactions:
        return _buildRoute(GiftcardTransactions(), settings: settings);
      case WebRoute.giftcardBrands:
        return _buildRoute(GiftcardBrands(), settings: settings);
      case WebRoute.giftcardDetails:
        return _buildRoute(GiftcardDetails(giftcardType: settings.arguments as GiftCardType), settings: settings);
      case WebRoute.withdrawalDashboard:
        return _buildRoute(Withdrawals(), settings: settings);
      case WebRoute.withdrawalAccepted:
        return _buildRoute(WithdrawalsAccepted(), settings: settings);
      case WebRoute.withdrawalDeclined:
        return _buildRoute(WithdrawalsDeclined(), settings: settings);
      case WebRoute.agentDashboard:
        return _buildRoute(Agents(), settings: settings);
      case WebRoute.agentCreate:
        return _buildRoute(AdminsCreate(), settings: settings);
      case WebRoute.agentEdit:
        return _buildRoute(AdminsEdit(adminData: settings.arguments as AgentData,), settings: settings);
      case WebRoute.homeFeedDashboard:
        return _buildRoute(HomeFeed(), settings: settings);
      default:
        return _buildRoute(Scaffold(
          body: Center(child: Text('Invalid nested route reached. ${settings.name}'),),
        ));
    }
  }
}

Widget _transitionHandler(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
  var begin = const Offset(0.0, 1.0);
  var end = Offset.zero;
  var curve = Curves.ease;
  var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
  return FadeTransition(opacity: animation, child: SlideTransition(position: animation.drive(tween), child: child,),);
}

Duration _forward() {
  return const Duration(milliseconds: 500);
}

Duration _reverse() {
  return const Duration(milliseconds: 500);
}

PageRouteBuilder _buildRoute(Widget child, { RouteSettings? settings }) {
  return PageRouteBuilder(
    settings: settings,
    pageBuilder: (context, animation, secondaryAnimation) => child,
    transitionsBuilder: _transitionHandler, transitionDuration: _forward(), reverseTransitionDuration: _reverse(),
  );
}