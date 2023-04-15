import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:web_admin/constants/app_styles.dart';
import 'package:web_admin/constants/web_routes.dart';
import 'package:web_admin/models/gift_card_type.dart';
import 'package:web_admin/models/transactions.dart';
import 'package:web_admin/pages/base_view.dart';
import 'package:web_admin/pages/giftcards/giftcards_view_model.dart';
import 'dart:math' as math;

import '../../constants/app_colors.dart';
import '../../enums/states.dart';
import '../../widgets/transaction_details.dart';
import '../../widgets/transactions_table.dart';

class Giftcards extends StatelessWidget {
  const Giftcards({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BaseView<GiftcardsViewModel>(
    onModelReady: (model) => model.loadData(),
    builder: (_, model, __) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: ListView(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Giftcards', style: titleStyle,),
          ),
          const SizedBox(height: 20,),
          availableCards(model),
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
                    //   onPressed: () => WebRoute.dashboardGo(WebRoute.giftcardPending, arguments: 'Approved Giftcard Transactions'),
                    // ),
                  ],
                ),
                TransactionsTable(
                  transactions: model.approvedGiftcardTransactions,
                  category: TransactionCategory.giftcard,
                  model: model,
                  onPressed: (UserTransactions transaction) async {
                    List<String>? res = await TransactionDetailsDialog.openDialog(context, 'Approved Transaction Details', transaction, model);
                    if (res == null) return;
                    if (res[0] == 'pay') {
                      await model.payUser(transaction);
                      model.loadData();
                    }
                  }, onPageChanged: (int value) { model.loadData(page: value); },
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
              //   onPressed: () => WebRoute.dashboardGo(WebRoute.giftcardPending, arguments: 'Pending Giftcard Transactions'),
              // ),
            ],
          ),
          TransactionsTable(
            transactions: model.giftcardTransactions,
            category: TransactionCategory.giftcard,
            model: model,
            onPressed: (UserTransactions transaction) async {
              List<String>? res = await TransactionDetailsDialog.openDialog(context, 'Pending Transaction Details', transaction, model);
              if (res == null) return;
              if (res[0] != 'pay') {
                await model.updateTransaction(transaction, res);
                model.loadData();
              }
            }, onPageChanged: (int value) { model.loadData(page: value); },
          ),
          const SizedBox(height: 30,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Completed transactions', style: blackStyle,),
              // TextButton(
              //   child: const Text('View all', style: TextStyle(color: faintColor),),
              //   onPressed: () => WebRoute.dashboardGo(WebRoute.giftcardTransactions, arguments: 'Completed Giftcard Transactions'),
              // ),
            ],
          ),
          TransactionsTable(
            transactions: model.completedGiftcardTransactions,
            category: TransactionCategory.giftcard,
            model: model,
            onPressed: (UserTransactions transaction) async {
              List<String>? res = await TransactionDetailsDialog.openDialog(context, 'Completed Transaction Details', transaction, model);
              if (res == null) return;
              if (res[0] != 'pay') {
                await model.updateTransaction(transaction, res);
                model.loadData();
              }
            }, onPageChanged: (int value) { model.loadData(page: value); },
          ),
        ],
      ),
    ),
  );

  Widget availableCards(GiftcardsViewModel model) => Card(
    child: Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Available Cards (${model.giftcardTypes.length})', style: subtitleStyle,),
              TextButton(onPressed: () {
                WebRoute.dashboardGo(WebRoute.giftcardBrands, arguments: model.giftcardTypes);
              }, child: const Text('View All'))
            ],
          ),
          const SizedBox(height: 20,),
          // made the giftcard scrollable for mobile responsiveness
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: model.shuffledGiftcards.map((e) => giftcard(e, model)).toList(),
              ),
          ),
        ],
      ),
    )
  );

  Widget giftcard(GiftCardType giftCardType, GiftcardsViewModel model) {
    GiftcardInfo giftcardInfo = model.extractInfo(giftCardType);
    return InkWell(
      onTap: () {
        WebRoute.dashboardGo(WebRoute.giftcardDetails, arguments: giftCardType);
      },
      child: Container(
        height: 174,
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
                CachedNetworkImage(imageUrl: giftCardType.logo ?? '', width: 40, height: 40,),
                const SizedBox(width: 5,),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(giftcardInfo.brand, style: titleStyle,),
                  ],
                )
              ],
            ),
            const SizedBox(height: 15,),
            Row(
              children: [
                const Icon(Icons.arrow_forward_ios_outlined, size: 12,),
                const SizedBox(width: 5,),
                Text('${giftcardInfo.totalCountries} ${giftcardInfo.totalCountries > 1 ? 'countries' : 'country'}')
              ],
            ),
            const SizedBox(height: 10,),
            Row(
              children: [
                const Icon(Icons.arrow_forward_ios_outlined, size: 12,),
                const SizedBox(width: 5,),
                Text('${giftcardInfo.infoTypes.length} Card Info Types')
              ],
            ),
            const SizedBox(height: 10,),
            Padding(
              padding: const EdgeInsets.only(left: 15.0),
              child: Text(giftcardInfo.infoTypes.join(', '), style: smallFaintStyle,),
            )
          ],
        ),
      ),
    );
  }
}