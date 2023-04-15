import 'package:flutter/material.dart';
import 'package:web_admin/constants/app_colors.dart';
import 'package:web_admin/constants/app_styles.dart';
import 'package:web_admin/constants/web_routes.dart';
import 'package:web_admin/enums/states.dart';
import 'package:web_admin/models/bitcoin_transaction.dart';
import 'package:web_admin/pages/base_view.dart';
import 'package:web_admin/pages/crypto/crypto_view_model.dart';
import 'package:web_admin/widgets/transactions_table.dart';

import '../../models/transactions.dart';

class CryptoTransactions extends StatelessWidget {
  final String title;
  const CryptoTransactions({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) => BaseView<CryptoViewModel>(
    onModelReady: (model) => model.loadTransactions(),
    backgroundType: BackgroundType.content,
    title: title,
    builder: (_, model, __) => Container(
      height: double.infinity,
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: ListView(
        children: [

          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pending transactions', style: blackStyle,),
              TextButton(
                child: const Text('View all', style: TextStyle(color: faintColor),),
                onPressed: () => WebRoute.dashboardGo(WebRoute.cryptoPending),
              ),
            ],
          ),
          TransactionsTable(
            transactions: model.cryptoTransactions,
            category: TransactionCategory.crypto,
            model: model,
            onPressed: (UserTransactions transaction) {

            }, onPageChanged: (int value) {  },
          ),
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Recent transactions', style: blackStyle,),
              TextButton(
                child: const Text('View all', style: TextStyle(color: faintColor),),
                onPressed: () => WebRoute.dashboardGo(WebRoute.cryptoTransactions, arguments: 'Recent Transactions'),
              ),
            ],
          ),
          TransactionsTable(
            transactions: model.cryptoTransactions,
            category: TransactionCategory.crypto,
            model: model,
            onPressed: (UserTransactions transaction) {

            }, onPageChanged: (int value) {  },
          )
        ],
      ),
    ),
  );
}