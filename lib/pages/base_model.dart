import 'package:flutter/foundation.dart';
import 'package:intl/intl.dart';
import 'package:web_admin/constants/app_constants.dart';
import 'package:web_admin/enums/states.dart';
import 'package:web_admin/models/transactions.dart';
import 'package:web_admin/models/user_data.dart';
import 'package:web_admin/repositories/app_repository.dart';
import 'package:web_admin/repositories/auth_repository.dart';

import '../service_locator.dart';

class BaseModel extends ChangeNotifier {
  final AuthRepository _authRepository = serviceLocator<AuthRepository>();
  final AppRepository _appRepository = serviceLocator<AppRepository>();

  AppState _state = AppState.idle;
  String _progressText = 'Please wait...';

  AppState get state => _state;
  String get progressText => _progressText;
  set progressText(text) => _progressText = text;

  UserData? get userData => _authRepository.userData;

  bool disposed = false;

  setState(AppState newState) {
    _state = newState;
    notifyListeners();
  }

  String formatMoney(num amount, { bool includeDecimal = true, }) {
    // if (amount == null) return '${currency(currencyCode)}0.00';
    final format = NumberFormat("#,##0${includeDecimal ? '.00' : ''}", 'en-US');
    return "${currency(AppConstants.nairaCurrencyCode)}${format.format(amount)}";
  }

  String formatDate(num timestamp) {
    final f = DateFormat('dd MMM, yyyy - hh:mm a');
    return f.format(DateTime.fromMillisecondsSinceEpoch(int.parse(timestamp.toString())));
  }

  String formatDay(int timestamp) {
    final f = DateFormat('dd MMM, yyyy');
    return f.format(DateTime.fromMillisecondsSinceEpoch(timestamp));
  }

  String currency(String currencyCode) {
    return NumberFormat.simpleCurrency(name: 'NGN').currencySymbol;
  }

  listenForUserDataUpdate() {
    _authRepository.userDataStream.listen((event) {
      if (disposed) return;
      _authRepository.userData = event;
      setState(AppState.idle);
    });
  }

  navigate(PageRouteInfo info) {
    _appRepository.updatePageIndex(info);
  }

  updateTransaction(UserTransactions transaction, List<String> action) async {
    _progressText = '${action[0] == 'approved' ? 'Approving' : 'Declining'} transaction...';
    setState(AppState.busy);
    await _appRepository.updateTransaction(transaction, action);
    setState(AppState.idle);
  }

  payUser(UserTransactions transaction) async {
    _progressText = 'Paying customer...';
    setState(AppState.busy);
    await _appRepository.payCustomer(transaction);
    setState(AppState.idle);
  }

  @override
  void dispose() {
    disposed = true;
    super.dispose();
  }
}