import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_admin/constants/web_routes.dart';
import 'package:web_admin/models/bitcoin_transaction.dart';
import 'package:web_admin/models/crypto_type.dart';
import 'package:web_admin/pages/base_view.dart';
import 'package:web_admin/pages/crypto/crypto_view_model.dart';
import 'package:web_admin/widgets/app_button.dart';
import 'package:web_admin/widgets/transactions_table.dart';

import '../../constants/app_colors.dart';
import '../../constants/app_constants.dart';
import '../../constants/app_styles.dart';
import '../../enums/states.dart';
import '../../models/transactions.dart';
import '../../widgets/app_text_input.dart';
import '../../widgets/transaction_details.dart';

class Crypto extends StatelessWidget {
  const Crypto({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BaseView<CryptoViewModel>(
    onModelReady: (model) => model.loadTransactions(),
    builder: (_, model, __) => Container(
      height: double.infinity,
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: ListView(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Crypto', style: titleStyle,),
          ),
          const SizedBox(height: 30,),
          _buildTopBar(context, model),
          const SizedBox(height: 30,),
          if (model.userData?.userType == 'admin') (
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Approved transactions', style: blackStyle,),
                    // TextButton(
                    //   child: const Text('View all', style: TextStyle(color: faintColor),),
                    //   onPressed: () => WebRoute.dashboardGo(WebRoute.cryptoPending, arguments: 'Approved Crypto Transactions'),
                    // ),
                  ],
                ),
                TransactionsTable(
                  transactions: model.approvedCryptoTransactions,
                  category: TransactionCategory.crypto,
                  model: model,
                  onPressed: (UserTransactions transaction) async {
                    List<String>? res = await TransactionDetailsDialog.openDialog(context, 'Pending Transaction Details', transaction, model);
                    if (res == null) return;
                    if (res[0] == 'pay') {
                      await model.payUser(transaction);
                      model.loadTransactions();
                    }
                  }, onPageChanged: (int value) { model.loadTransactions(page: value); },
                ),
                const SizedBox(height: 30,),
              ],
            )
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Pending transactions', style: blackStyle,),
              // TextButton(
              //   child: const Text('View all', style: TextStyle(color: faintColor),),
              //   onPressed: () => WebRoute.dashboardGo(WebRoute.cryptoPending, arguments: 'Pending Crypto Transactions'),
              // ),
            ],
          ),
          TransactionsTable(
            transactions: model.cryptoTransactions,
            category: TransactionCategory.crypto,
            model: model,
            onPressed: (UserTransactions transaction) async {
              List<String>? res = await TransactionDetailsDialog.openDialog(context, 'Pending Transaction Details', transaction, model);
              if (res == null) return;
              if (res[0] != 'pay') {
                await model.updateTransaction(transaction, res);
                model.loadTransactions();
              }
            }, onPageChanged: (int value) { model.loadTransactions(page: value); },
          ),
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Completed transactions', style: blackStyle,),
              // TextButton(
              //   child: const Text('View all', style: TextStyle(color: faintColor),),
              //   onPressed: () => WebRoute.dashboardGo(WebRoute.cryptoTransactions, arguments: 'Recent Crypto Transactions'),
              // ),
            ],
          ),
          const SizedBox(height: 5,),
          TransactionsTable(
            transactions: model.completedCryptoTransactions,
            category: TransactionCategory.crypto,
            model: model,
            onPressed: (UserTransactions transaction) async {
              List<String>? res = await TransactionDetailsDialog.openDialog(context, 'Completed Transaction Details', transaction, model);
              if (res == null) return;
              if (res[0] != 'pay') {
                await model.updateTransaction(transaction, res);
                model.loadTransactions();
              }
            }, onPageChanged: (int value) { model.loadTransactions(page: value); },
          )
        ],
      ),
    ),
  );

  // made the crypto card scrollable for mobile responsiveness
  Widget _buildTopBar(BuildContext context, CryptoViewModel model) => SingleChildScrollView(
    scrollDirection: Axis.horizontal,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: model.cryptoTypes.map((e) => _buildCryptoCard(context, e, model)).toList(),
    ),
  );

  _openCryptoDialog(BuildContext context, CryptoViewModel model, CryptoType crypto) {
    TextEditingController _50To200 = TextEditingController(text: '');
    TextEditingController _201To500 = TextEditingController(text: '');
    TextEditingController _501To999 = TextEditingController(text: '');
    TextEditingController _1000ToAbove = TextEditingController(text: '');

    return showGeneralDialog(
        context: context,
        barrierDismissible: true,
        barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
        barrierColor: Colors.black.withOpacity(0.5),
        transitionDuration: const Duration(milliseconds: 300),
        transitionBuilder: (context, a1, a2, widget) {
          return Transform.scale(
            scale: a1.value,
            child: Opacity(
              opacity: a1.value,
              child: widget,
            ),
          );

        },
        pageBuilder: (ctx, animation, secondAnimation) => AlertDialog(
          title: Text('Update ${crypto.type} Rate', style: titleStyle,),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Market Rate: \$${NumberFormat('#,##0').format(crypto.cryptoRate ?? 0)}'),
              const SizedBox(height: 10,),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('\$50 - \$200', style: accentButtonStyle,),
                        Text(
                          'Current Admin Rate: ${model.formatMoney(crypto.rate.firstWhereOrNull((element) => element.range == '50-200')?.rate ?? 0)}/USD',
                          style: smallFaintStyle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: AppTextInput(
                      textEditingController: _50To200,
                      label: 'New ${crypto.type} Rate',
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('\$201 - \$500', style: accentButtonStyle,),
                        Text('Current Admin Rate: ${model.formatMoney(crypto.rate.firstWhereOrNull((element) => element.range == '201-500')?.rate ?? 0)}/USD',
                          style: smallFaintStyle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: AppTextInput(
                      textEditingController: _201To500,
                      label: 'New ${crypto.type} Rate',
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('\$501 - \$999', style: accentButtonStyle,),
                        Text('Current Admin Rate: ${model.formatMoney(crypto.rate.firstWhereOrNull((element) => element.range == '501-999')?.rate ?? 0)}/USD',
                          style: smallFaintStyle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: AppTextInput(
                      textEditingController: _501To999,
                      label: 'New ${crypto.type} Rate',
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('\$1000 - Above', style: accentButtonStyle,),
                        Text('Current Admin Rate: ${model.formatMoney(crypto.rate.firstWhereOrNull((element) => element.range == '1000-Above')?.rate ?? 0)}/USD',
                          style: smallFaintStyle,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 15,),
                  Expanded(
                    child: AppTextInput(
                      textEditingController: _1000ToAbove,
                      label: 'New ${crypto.type} Rate',
                    ),
                  )
                ],
              ),
              const SizedBox(height: 20,),
            ],
          ),
          actions: [
            AppButton(
              text: 'Cancel',
              textStyle: normalTextStyle,
              color: unfocusedColor,
              onPressed: () {
                return Navigator.of(ctx).pop();
              },
            ),
            AppButton(text: 'Update Rate', onPressed: () {
              if (_50To200.text.isEmpty) return;
              if (_201To500.text.isEmpty) return;
              if (_501To999.text.isEmpty) return;
              if (_1000ToAbove.text.isEmpty) return;
              crypto.rate = [
                RateRange('50-200', num.parse(_50To200.text)),
                RateRange('201-500', num.parse(_201To500.text)),
                RateRange('501-999', num.parse(_501To999.text)),
                RateRange('1000-Above', num.parse(_1000ToAbove.text)),
              ];
              model.updateCryptoType(crypto);
              return Navigator.of(ctx).pop();
            }),
          ],
        ));
  }

  Widget _buildCryptoCard(BuildContext context, CryptoType crypto, CryptoViewModel model) => InkWell(
    onTap: () {
      _openCryptoDialog(context, model, crypto);
    },
    child: Card(
      child: Container(
        height: 220,
        width: 292,
        padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CachedNetworkImage(imageUrl: crypto.icon ?? AppConstants.placeHolderImage, width: 40, height: 40,),
                const SizedBox(width: 5,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${crypto.type}', style: titleStyle,),
                  ],
                )
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              children: [
                const Icon(Icons.arrow_forward_ios_outlined, size: 12,),
                const SizedBox(width: 5,),
                Text('Market Rate: \$${NumberFormat('#,##0').format(crypto.cryptoRate ?? 0)}')
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: const [
                Icon(Icons.arrow_forward_ios_outlined, size: 12,),
                SizedBox(width: 5,),
                Text('Current Admin Rates:')
              ],
            ),
            Text(_processRates(crypto.rate, model), style: smallFaintStyle,),
            const SizedBox(height: 10,),
            const Padding(
              padding: EdgeInsets.only(left: 15.0),
              child: Text('Click to update admin rate', style: smallFaintStyle,),
            )
          ],
        ),
      ),
    ),
  );

  String _processRates(List<RateRange> ranges, CryptoViewModel model) {
    return ranges.map((e) => "${e.range} @ ${model.formatMoney(e.rate ?? 0)}/USD").join(', ');
  }
}