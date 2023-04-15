import 'package:flutter/material.dart';
import 'package:web_admin/pages/base_view.dart';
import 'package:web_admin/pages/withdrawals/withdrawals_view_model.dart';

class WithdrawalsDeclined extends StatelessWidget {
  const WithdrawalsDeclined({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => BaseView<WithdrawalsViewModel>(
    builder: (_, model, __) => Container(child: Center(child: Text('Withdrawals Declined'),),),
  );
}