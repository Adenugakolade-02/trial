import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:web_admin/pages/base_model.dart';
import 'package:web_admin/widgets/transaction_item.dart';

import '../constants/app_colors.dart';
import '../constants/app_constants.dart';
import '../constants/app_styles.dart';
import '../models/transactions.dart';
import 'app_button.dart';
import 'app_text_input.dart';

class TransactionDetailsDialog {

  static Future<List<String>?> openDialog(BuildContext context, String title, UserTransactions transaction, BaseModel model) {
    final TextEditingController updatedAmount = TextEditingController();
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
          title: Text(title, style: titleStyle,),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TransactionItem('Status', transaction.status,
                  backgroundColor: getBackgroundColor(transaction.status),
                  color: getColor(transaction.status),
                  valueStyle: getStyle(transaction.status),
                  height: 50,
                ),
                if (transaction.status == 'failed') (
                  Column(
                    children: [
                      const SizedBox(height: 15,),
                      TransactionItem('Reason', transaction.description,
                        backgroundColor: getBackgroundColor(transaction.status),
                        color: getColor(transaction.status),
                        valueStyle: getStyle(transaction.status),
                        height: 50,
                      ),
                    ],
                  )
                ),
                const SizedBox(height: 15,),
                loadDetails(transaction, model),
                const SizedBox(height: 15,),
                TransactionItem('To Pay',
                  model.formatMoney(transaction.amount ?? 0),
                  backgroundColor: amountBackgroundColor,
                  height: 60,
                ),
                const SizedBox(height: 15,),
                if (transaction.status == 'pending') (Column(
                  children: [
                    AppTextInput(
                      textEditingController: updatedAmount,
                      label: 'Update Amount (Optional)',
                      hint: 'Update Amount (Optional)',
                      inputType: TextInputType.number,
                    ),
                    const Text('Only update the transaction amount if the terms of transaction changes.',
                      style: smallFaintStyle,
                    )
                  ],
                )),
              ],
            ),
          ),
          actions: transaction.status == 'pending' ? [
            AppButton(
              text: 'Cancel',
              textStyle: normalTextStyle,
              color: unfocusedColor,
              onPressed: () {
                return Navigator.of(ctx).pop(null);
              },
            ),
            AppButton(
              text: 'Decline',
              textStyle: smallDebitStyle,
              color: debitBackgroundColor,
              onPressed: () async {
                String? reason = await _openDeclineReasonDialog(ctx);
                if (reason == null) return;
                return Navigator.of(ctx).pop(['failed', reason]);
              },
            ),
            AppButton(
              text: 'Approve',
              textStyle: smallCreditStyle,
              color: creditBackgroundColor,
              onPressed: () {
                return Navigator.of(ctx).pop(['approved', updatedAmount.text]);
              },
            ),
          ] : (transaction.status == 'approved' && model.userData?.userType == 'admin' ? [
            AppButton(
              text: 'Pay',
              textStyle: successButtonStyle,
              color: creditColor,
              onPressed: () {
                return Navigator.of(ctx).pop(['pay']);
              },
            ),
          ] : []),
        ));
  }

  static Widget loadDetails(UserTransactions transaction, BaseModel model) {
    switch (transaction.category) {
      case 'crypto':
        return Column(
            children: [
              CachedNetworkImage(imageUrl: transaction.cryptoImageRef ?? AppConstants.placeHolderImage, width: 400, height: 300,),
              const SizedBox(height: 15,),
              TransactionItem('Crypto Type', transaction.cryptoType),
              const SizedBox(height: 15,),
              TransactionItem('Wallet Type', transaction.cryptoWalletName),
              const SizedBox(height: 15,),
              TransactionItem('Payment Address', transaction.cryptoWalletAddress),
              const SizedBox(height: 15,),
              TransactionItem('Currency', transaction.currency),
              const SizedBox(height: 15,),
              TransactionItem('Crypto Value', '${transaction.cryptoValue}'),
            ]
        );
      case 'giftcard':
        return Column(
          children: [
            TransactionItem('Gift Card Type', transaction.brand),
            const SizedBox(height: 15,),
            TransactionItem('Currency', transaction.currency),
            const SizedBox(height: 15,),
            ...transaction.cards.map((card) => Container(
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: transactionItemColor
              ),
              child: Column(
                children: [
                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Card details',
                      style: TextStyle(
                        backgroundColor: successButtonColor,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  TransactionItem('Amount Range', card.range),
                  const SizedBox(height: 15,),
                  TransactionItem('Card Value', '${card.value}x${card.quantity}'),
                  const SizedBox(height: 15,),
                  TransactionItem('Rate', '${model.formatMoney(card.rate ?? 0)}/1${transaction.currency}'),
                  const SizedBox(height: 15,),
                  TransactionItem('Amount', model.formatMoney(card.amount ?? 0)),
                  if (card.variant?.isNotEmpty ?? false) const SizedBox(height: 15,),
                  if (card.variant?.isNotEmpty ?? false) TransactionItem('Starting Numbers', card.variant),
                ],
              ),
            )),
            const SizedBox(height: 15,),
            TransactionItem('Card Info Type', transaction.cardInfoType),
          ],
        );
      case 'withdrawal':
        return Column(
          children: [
            TransactionItem('Bank', transaction.bankName),
            const SizedBox(height: 15,),
            TransactionItem('Account Name', transaction.bankAccountName),
            const SizedBox(height: 15,),
            TransactionItem('Account Number', transaction.bankAccountNumber),
          ],
        );
      default:
        return Container();
    }
  }

  static Future<String?> _openDeclineReasonDialog(BuildContext context) {
    TextEditingController _reason = TextEditingController();

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
          title: const Text('Reason For Declining', style: titleStyle,),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppTextInput(
                textEditingController: _reason,
                label: 'Reason',
              ),
            ],
          ),
          actions: [
            AppButton(
              text: 'Cancel',
              textStyle: normalTextStyle,
              color: unfocusedColor,
              onPressed: () {
                return Navigator.of(ctx).pop(null);
              },
            ),
            AppButton(text: 'Decline', onPressed: () {
              if (_reason.text.isEmpty) return;
              return Navigator.of(ctx).pop(_reason.text);
            }),
          ],
        ));
  }
}