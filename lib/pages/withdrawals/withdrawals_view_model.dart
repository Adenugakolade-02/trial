import 'package:web_admin/pages/base_model.dart';

import '../../enums/states.dart';
import '../../models/transactions.dart';
import '../../repositories/app_repository.dart';
import '../../service_locator.dart';

class WithdrawalsViewModel extends BaseModel {
  final AppRepository _appRepository = serviceLocator<AppRepository>();
  List<UserTransactions> get withdrawalTransactions => _appRepository.withdrawalTransactions;
  List<UserTransactions> get approvedWithdrawalTransactions => _appRepository.approvedWithdrawalTransactions;
  List<UserTransactions> get failedWithdrawalTransactions => _appRepository.failedWithdrawalTransactions;
  List<UserTransactions> get completedWithdrawalTransactions => _appRepository.completedWithdrawalTransactions;

  loadWithdrawals(String type, { int? page }) async {
    progressText = 'Loading transactions...';
    setState(AppState.busy);
    await _appRepository.fetchTransactions(TransactionCategory.withdrawal, type,
      skip: page != null ? page * getTransactionLength(type) : 0,
    );
    setState(AppState.idle);
  }

  int getTransactionLength(String type) {
    switch (type) {
      case 'pending':
        return _appRepository.withdrawalTransactions.length;
      case 'approved':
        return _appRepository.approvedWithdrawalTransactions.length;
      case 'failed':
        return _appRepository.failedWithdrawalTransactions.length;
      case 'completed':
        return _appRepository.completedWithdrawalTransactions.length;
      default:
        return 0;
    }
  }
}