import 'package:flutter/material.dart';
import 'package:web_admin/enums/states.dart';
import 'package:web_admin/pages/base_view.dart';
import 'package:web_admin/pages/crypto/crypto_view_model.dart';

class CryptoPendingTransactions extends StatelessWidget {
  final String title;
  const CryptoPendingTransactions({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) => BaseView<CryptoViewModel>(
    backgroundType: BackgroundType.content,
    title: title,
    builder: (_, model, __) => Container(child: Center(child: Text('Bitcoin Pending Transactions'),),),
  );
}