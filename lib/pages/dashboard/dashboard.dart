import 'package:cached_network_image/cached_network_image.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_admin/constants/app_constants.dart';
import 'package:web_admin/constants/app_styles.dart';
import 'package:web_admin/constants/web_routes.dart';
import 'package:web_admin/enums/states.dart';
import 'package:web_admin/models/crypto_type.dart';
import 'package:web_admin/pages/base_view.dart';
import 'package:web_admin/pages/dashboard/dashboard_view_model.dart';
import 'package:web_admin/repositories/app_repository.dart';
import 'package:web_admin/widgets/app_button.dart';
import 'package:web_admin/widgets/app_text_input.dart';
import 'package:web_admin/widgets/transaction_details.dart';

import '../../constants/app_colors.dart';
import '../../models/transactions.dart';
import '../../widgets/transactions_table.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BaseView<DashboardViewModel>(
    onModelReady: (model) => model.loadTransactions(),
    builder: (_, model, __) => ListView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      children: [
        const SizedBox(height: 10,),
        const Text('Dashboard', style: titleStyle,),
        const SizedBox(height: 15,),
        _buildCards(model, context),
        const SizedBox(height: 58,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Crypto transactions', style: blackStyle,),
            TextButton(
              child: const Text('View all', style: TextStyle(color: accentColor),),
              onPressed: () => model.navigate(PageRouteInfo(1, WebRoute.cryptoDashboard)),
            ),
          ],
        ),
        const SizedBox(height: 25,),
        TransactionsTable(
          transactions: model.bitcoinTransactions,
          category: TransactionCategory.crypto,
          model: model,
          onPressed: (UserTransactions transaction) async {
            List<String>? res = await TransactionDetailsDialog.openDialog(context, 'Crypto Transaction Details', transaction, model);
            if (res == null) return;
            if (res[0] == 'pay') {
              await model.payUser(transaction);
            } else {
              await model.updateTransaction(transaction, res);
            }
            model.loadTransactions();
          }, onPageChanged: (int value) { model.loadTransactions(page: value); },
        ),
        const SizedBox(height: 31,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Giftcard transactions', style: blackStyle,),
            TextButton(
              child: const Text('View all', style: TextStyle(color: accentColor),),
              onPressed: () => model.navigate(PageRouteInfo(2, WebRoute.giftcardDashboard)),
            ),
          ],
        ),
        const SizedBox(height: 25,),
        TransactionsTable(
          transactions: model.giftcardTransactions,
          category: TransactionCategory.giftcard,
          model: model,
          onPressed: (UserTransactions transaction) async {
            List<String>? res = await TransactionDetailsDialog.openDialog(context, 'Giftcard Transaction Details', transaction, model);
            if (res == null) return;
            if (res[0] == 'pay') {
              await model.payUser(transaction);
            } else {
              await model.updateTransaction(transaction, res);
            }
            model.loadTransactions();
          }, onPageChanged: (int value) { model.loadTransactions(page: value); },
        ),
        const SizedBox(height: 31,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Recent Withdrawals', style: blackStyle,),
            TextButton(
              child: const Text('View all', style: TextStyle(color: accentColor),),
              onPressed: () => model.navigate(PageRouteInfo(3, WebRoute.withdrawalDashboard)),
            ),
          ],
        ),
        const SizedBox(height: 25,),
        TransactionsTable(
          transactions: model.withdrawalTransactions,
          category: TransactionCategory.withdrawal,
          model: model,
          onPressed: (UserTransactions transaction) async {
            List<String>? res = await TransactionDetailsDialog.openDialog(context, 'Withdrawal Transaction Details', transaction, model);
            if (res == null) return;
            if (res[0] == 'pay') {
              await model.payUser(transaction);
            } else {
              await model.updateTransaction(transaction, res);
            }
            model.loadTransactions();
          }, onPageChanged: (int value) { model.loadTransactions(page: value); },
        ),
      ],
    ),
  );

  Widget _buildCards(DashboardViewModel model, BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: model.cryptoTypes.map((crypto) => Container(
          width: 300,
          child: Stack(
            children: [
              Container(
                height: 150,
                margin: EdgeInsets.only(left: model.cryptoTypes.indexOf(crypto) == 0 ? 0 : 10),
                padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white,
                ),
                child: InkWell(
                  onTap: () => _openCryptoDialog(context, model, crypto),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Container(
                            width: 30,
                            height: 30,
                            padding: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: CachedNetworkImage(
                              imageUrl: crypto.icon ?? AppConstants.placeHolderImage,
                            ),
                          ),
                          const SizedBox(width: 5,),
                          Text('${crypto.type}', style: normalBlackTextStyle,)
                        ],
                      ),
                      const SizedBox(height: 15,),
                      Text(
                        '${crypto.platform ?? ''}/\$${NumberFormat('#,##0.00').format(crypto.cryptoRate ?? 0)}',
                        style: titleStyle,),
                      Row(
                        children: const [
                          Icon(Icons.arrow_drop_up, color: creditColor,),
                          Text('Current Admin rates:', style: smallFaintStyle,),
                        ],
                      ),
                      Text(_processRates(crypto.rate, model), style: smallFaintStyle, overflow: TextOverflow.ellipsis,)
                    ],
                  ),
                ),
              ),
              Positioned(
                right: 28,
                top: 59,
                child: Image.asset('images/line.png', width: 50,),
              ),
            ],
          ),
        )).toList(),
      ),
    );
  }

  _openCryptoDialog(BuildContext context, DashboardViewModel model, CryptoType crypto) {
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

  String _processRates(List<RateRange> ranges, DashboardViewModel model) {
    return ranges.map((e) => "${e.range} @ ${model.formatMoney(e.rate ?? 0)}/USD").join(', ');
  }
}