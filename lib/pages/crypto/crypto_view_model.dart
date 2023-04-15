import 'package:web_admin/models/transactions.dart';
import 'package:web_admin/pages/base_model.dart';

import '../../enums/states.dart';
import '../../models/bitcoin_transaction.dart';
import '../../models/crypto_type.dart';
import '../../repositories/app_repository.dart';
import '../../service_locator.dart';
import '../../services/snackbar_service.dart';

class CryptoViewModel extends BaseModel {
  final AppRepository _appRepository = serviceLocator<AppRepository>();

  List<UserTransactions> get cryptoTransactions => _appRepository.cryptoTransactions;
  List<UserTransactions> get completedCryptoTransactions => _appRepository.completedCryptoTransactions;
  List<UserTransactions> get approvedCryptoTransactions => _appRepository.approvedCryptoTransactions;
  List<CryptoType> get cryptoTypes => _appRepository.cryptoTypes;

  loadTransactions({ int? page }) async {
    progressText = 'Loading crypto transactions...';
    setState(AppState.busy);
    await Future.wait<dynamic>([
      _appRepository.fetchTransactions(TransactionCategory.crypto, 'pending',
        skip: page != null ? page * _appRepository.cryptoTransactions.length : 0,
      ),
      _appRepository.fetchTransactions(TransactionCategory.crypto, 'completed',
        skip: page != null ? page * _appRepository.completedCryptoTransactions.length : 0,
      ),
      ...(userData?.userType == 'admin' ? [
        _appRepository.fetchTransactions(TransactionCategory.crypto, 'approved',
          skip: page != null ? page * _appRepository.approvedCryptoTransactions.length : 0,
        )
      ] : []),
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