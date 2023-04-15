import 'package:web_admin/enums/states.dart';
import 'package:web_admin/models/bitcoin_transaction.dart';
import 'package:web_admin/models/crypto_type.dart';
import 'package:web_admin/models/transactions.dart';
import 'package:web_admin/pages/base_model.dart';
import 'package:web_admin/repositories/app_repository.dart';
import 'package:web_admin/service_locator.dart';

import '../../services/snackbar_service.dart';

class DashboardViewModel extends BaseModel {
  final AppRepository _appRepository = serviceLocator<AppRepository>();

  List<UserTransactions> get bitcoinTransactions => _appRepository.recentCryptoTransactions;
  List<UserTransactions> get giftcardTransactions => _appRepository.recentGiftcardTransactions;
  List<UserTransactions> get withdrawalTransactions => _appRepository.recentWithdrawalTransactions;
  List<CryptoType> get cryptoTypes => _appRepository.cryptoTypes;

  loadTransactions({int? page}) async {
    progressText = 'Loading transactions...';
    setState(AppState.busy);
    await Future.wait<dynamic>([
      _appRepository.fetchTransactions(TransactionCategory.crypto, 'recent',
        skip: page != null ? page * _appRepository.recentCryptoTransactions.length : 0,
      ),
      _appRepository.fetchTransactions(TransactionCategory.giftcard, 'recent',
        skip: page != null ? page * _appRepository.recentGiftcardTransactions.length : 0,
      ),
      _appRepository.fetchTransactions(TransactionCategory.withdrawal, 'recent',
        skip: page != null ? page * _appRepository.recentWithdrawalTransactions.length : 0,
      ),
      _appRepository.fetchCryptoTypes(),
    ]);
    setState(AppState.idle);
  }

  updateCryptoType(CryptoType cryptoType) async {
    progressText = 'Updating crypto details...';
    setState(AppState.busy);
    bool res = await _appRepository.updateCrypto(cryptoType);
    if (res == true) {
      serviceLocator<SnackBarService>().showSnackBar(
        message: 'Successfully updated ${cryptoType.type} rate',
        isError: false,
      );
      await _appRepository.fetchCryptoTypes();
    }
    setState(AppState.idle);
  }
}