import 'package:flutter/material.dart';
import 'package:web_admin/constants/app_colors.dart';
import 'package:web_admin/constants/app_styles.dart';
import 'package:web_admin/pages/base_view.dart';
import 'package:web_admin/pages/withdrawals/withdrawals_view_model.dart';

import '../../enums/states.dart';
import '../../models/transactions.dart';
import '../../widgets/transaction_details.dart';
import '../../widgets/transactions_table.dart';

class Withdrawals extends StatefulWidget {
  const Withdrawals({Key? key}) : super(key: key);

  @override
  State<Withdrawals> createState() => _WithdrawalsState();
}

class _WithdrawalsState extends State<Withdrawals> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> sortList = ['Name', 'Date created', 'Active', 'Email'];
  String? selectedSorting = 'Name';
  int _selectedPosition = 0;

  @override
  Widget build(BuildContext context) => BaseView<WithdrawalsViewModel>(
    onModelReady: (model) => model.loadWithdrawals('pending'),
    builder: (_, model, __) => ListView(
      padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 10),
      children: [
        const Align(
          alignment: Alignment.centerLeft,
          child: Text('Withdrawals', style: titleStyle,),
        ),
        const SizedBox(height: 30,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(_selectedPosition == 0 ? accountBackgroundColor : Colors.white),
                          ),
                          child: Text('Pending', style: _selectedPosition == 0 ? bigAccentButtonStyle : normalFaintStyle,),
                          onPressed: () {
                            setState(() {
                              _selectedPosition = 0;
                              model.loadWithdrawals('pending');
                            });
                          },
                        ),
                      ),
                      if (model.userData?.userType == 'admin') (
                          Expanded(
                            child: TextButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all<Color>(_selectedPosition == 1 ? accountBackgroundColor : Colors.white),
                              ),
                              child: Text('Accepted', style: _selectedPosition == 1 ? bigAccentButtonStyle : normalFaintStyle,),
                              onPressed: () {
                                setState(() {
                                  _selectedPosition = 1;
                                  model.loadWithdrawals('approved');
                                });
                              },
                            ),
                          )
                      ),
                      Expanded(
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(_selectedPosition == 2 ? accountBackgroundColor : Colors.white),
                          ),
                          child: Text('Rejected', style: _selectedPosition == 2 ? bigAccentButtonStyle : normalFaintStyle,),
                          onPressed: () {
                            setState(() {
                              _selectedPosition = 2;
                              model.loadWithdrawals('failed');
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all<Color>(_selectedPosition == 3 ? accountBackgroundColor : Colors.white),
                          ),
                          child: Text('Completed', style: _selectedPosition == 3 ? bigAccentButtonStyle : normalFaintStyle,),
                          onPressed: () {
                            setState(() {
                              _selectedPosition = 3;
                              model.loadWithdrawals('completed');
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () {},
                    child: SizedBox(
                      width: 200,
                      child: Row(
                        children: const [
                          Text('Export List', style: normalBlackStyle,),
                          SizedBox(width: 5,),
                          Icon(Icons.cloud_download_outlined, size: 18,)
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20,),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.white,
                  hintText: 'search',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(width: 2, color: unfocusedColor),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.text,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Card(
                    child: Container(
                      height: 45,
                      width: 200,
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Sort by'),
                          Container(width: 2, height: 30, color: unfocusedColor,),
                          DropdownButton<String>(
                            value: selectedSorting,
                            underline: Container(),
                            items: sortList.map((e) => DropdownMenuItem<String>(
                              value: e,
                              child: Text(e),
                            )).toList(),
                            onChanged: (s) {
                              setState(() {
                                selectedSorting = s;
                              });
                            },
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20,),
        if (_selectedPosition == 0) (
            TransactionsTable(
              transactions: model.withdrawalTransactions,
              category: TransactionCategory.withdrawal,
              model: model,
              onPressed: (UserTransactions transaction) async {
                List<String>? res = await TransactionDetailsDialog.openDialog(context, 'Pending Transaction Details', transaction, model);
                if (res == null) return;
                if (res[0] != 'pay') {
                  await model.updateTransaction(transaction, res);
                  model.loadWithdrawals('pending');
                }
              }, onPageChanged: (int value) { model.loadWithdrawals('pending', page: value); },
            )
        ),
        if (_selectedPosition == 1) (
            TransactionsTable(
              transactions: model.approvedWithdrawalTransactions,
              category: TransactionCategory.withdrawal,
              model: model,
              onPressed: (UserTransactions transaction) async {
                List<String>? res = await TransactionDetailsDialog.openDialog(context, 'Approved Transaction Details', transaction, model);
                if (res == null) return;
                if (res[0] == 'pay') {
                  await model.payUser(transaction);
                  model.loadWithdrawals('approved');
                }
              }, onPageChanged: (int value) { model.loadWithdrawals('approved', page: value); },
            )
        ),
        if (_selectedPosition == 2) (
            TransactionsTable(
              transactions: model.failedWithdrawalTransactions,
              category: TransactionCategory.withdrawal,
              model: model,
              onPressed: (UserTransactions transaction) async {
                await TransactionDetailsDialog.openDialog(context, 'Rejected Transaction Details', transaction, model);
              }, onPageChanged: (int value) { model.loadWithdrawals('failed', page: value); },
            )
        ),
        if (_selectedPosition == 3) (
            TransactionsTable(
              transactions: model.completedWithdrawalTransactions,
              category: TransactionCategory.withdrawal,
              model: model,
              onPressed: (UserTransactions transaction) async {
                await TransactionDetailsDialog.openDialog(context, 'Completed Transaction Details', transaction, model);
              }, onPageChanged: (int value) { model.loadWithdrawals('completed', page: value); },
            )
        ),
      ],
    ),
  );

  Widget topDetails(WithdrawalsViewModel model) => Container();
}