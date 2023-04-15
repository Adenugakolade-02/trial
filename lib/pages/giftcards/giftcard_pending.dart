import 'package:flutter/material.dart';
import 'package:web_admin/pages/base_view.dart';
import 'package:web_admin/pages/giftcards/giftcards_view_model.dart';

class GiftcardPendingTransactions extends StatelessWidget {
  const GiftcardPendingTransactions({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BaseView<GiftcardsViewModel>(
    builder: (_, model, __) => Container(child: Center(child: Text('Giftcard Pending Transactions'),),),
  );
}