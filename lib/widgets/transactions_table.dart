import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_admin/constants/app_colors.dart';
import 'package:web_admin/constants/app_styles.dart';
import 'package:web_admin/enums/states.dart';
import 'package:web_admin/models/transactions.dart';
import 'package:web_admin/pages/base_model.dart';

class TransactionsTable extends StatelessWidget {
  final List<UserTransactions> transactions;
  final TransactionCategory category;
  final BaseModel model;
  final ValueChanged<UserTransactions> onPressed;
  final ValueChanged<int> onPageChanged;
  final int pageSize;

  const TransactionsTable({
    Key? key,
    required this.transactions,
    required this.category,
    required this.onPressed,
    required this.model,
    required this.onPageChanged,
    this.pageSize = 10,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: Colors.white
    ),
    child: loadTable(context, category, transactions, pageSize),
  );

  Widget loadTable(BuildContext context, TransactionCategory category, List<UserTransactions> transactions, int pageSize) {
    switch (category) {
      case TransactionCategory.airtime:
        return const Center(child: Text('No data to display.'),);
      case TransactionCategory.data:
        return const Center(child: Text('No data to display.'),);
      case TransactionCategory.cables:
        return const Center(child: Text('No data to display.'),);
      case TransactionCategory.power:
        return const Center(child: Text('No data to display.'),);
      case TransactionCategory.giftcard:
        return transactionTable(pageSize, ['Name', 'Brand', 'Currency', 'Cards', 'Expected Payment', 'Date', 'Status']);
      case TransactionCategory.crypto:
        return transactionTable(pageSize, ['Name', 'Type', 'Amount', 'Rate', 'Expected Payment', 'Date', 'Status']);
      case TransactionCategory.withdrawal:
        return transactionTable(pageSize, ['Name', 'Amount', 'Bank', 'Account No.', 'Date', 'Status']);
    }
  }

  Widget transactionTable(int pageSize, List<String> headings) => PaginatedDataTable(
    rowsPerPage: pageSize,
    showCheckboxColumn: false,
    columns: headings.map((e) => DataColumn(label: Text(e, style: boldBlackStyle,))).toList(),
    source: TableRow(transactions, onPressed, model),
    onPageChanged: onPageChanged,
  );
}

class TableRow extends DataTableSource {
  final List<UserTransactions> transactions;
  final ValueChanged<UserTransactions> onPressed;
  final BaseModel model;

  TableRow(this.transactions, this.onPressed, this.model);

  @override
  DataRow? getRow(int index) {
    return getTransactionRow(transactions[index], model);
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => transactions.length;

  @override
  int get selectedRowCount => 0;

  DataRow? getTransactionRow(UserTransactions transaction, BaseModel model) {
    switch (transaction.category) {
      case 'crypto':
        return DataRow(
            cells: [
              DataCell(Text('${transaction.name}', style: smallBlackStyle,)),
              DataCell(Text('${transaction.cryptoType}', style: smallBlackStyle)),
              DataCell(Text('\$${NumberFormat('#,##0').format(transaction.cryptoValue ?? 0)}', style: smallBlackStyle)),
              DataCell(Text('${model.formatMoney(transaction.rate ?? 0)}/USD', style: smallBlackStyle)),
              DataCell(Text(model.formatMoney(transaction.amount ?? 0), style: smallBlackStyle)),
              DataCell(Text(model.formatDate(transaction.timestamp ?? DateTime.now().millisecondsSinceEpoch), style: smallBlackStyle)),
              DataCell(status(transaction.status ?? '')),
            ],
            onSelectChanged: (s) {
              if (s == true) onPressed(transaction);
            }
        );
      case 'giftcard':
        return DataRow(
            cells: [
              DataCell(Text('${transaction.name}', style: smallBlackStyle,)),
              DataCell(Text('${transaction.brand}', style: smallBlackStyle)),
              DataCell(Text('${transaction.currency}', style: smallBlackStyle)),
              DataCell(Text('${transaction.cards.length}', style: smallBlackStyle)),
              DataCell(Text(model.formatMoney(transaction.amount ?? 0), style: smallBlackStyle)),
              DataCell(Text(model.formatDate(transaction.timestamp ?? DateTime.now().millisecondsSinceEpoch), style: smallBlackStyle)),
              DataCell(status(transaction.status ?? '')),
            ],
            onSelectChanged: (s) {
              if (s == true) onPressed(transaction);
            }
        );
      case 'withdrawal':
        return DataRow(
            cells: [
              DataCell(Text('${transaction.name}', style: smallBlackStyle,)),
              DataCell(Text(model.formatMoney(transaction.amount ?? 0), style: smallBlackStyle)),
              DataCell(Text('${transaction.bankName}', style: smallBlackStyle)),
              DataCell(Text('${transaction.bankAccountNumber}', style: smallBlackStyle)),
              DataCell(Text(model.formatDate(transaction.timestamp ?? DateTime.now().millisecondsSinceEpoch), style: smallBlackStyle)),
              DataCell(status(transaction.status ?? '')),
            ],
            onSelectChanged: (s) {
              if (s == true) onPressed(transaction);
            }
        );
      default:
        return null;
    }
  }

  Widget status(String status) {
    Color background;
    Color color;

    switch (status) {
      case 'pending':
        background = pendingBackgroundColor;
        color = pendingColor;
        break;
      case 'completed':
        background = creditBackgroundColor;
        color = creditColor;
        break;
      case 'failed':
        background = failedBackgroundColor;
        color = debitColor;
        break;
      default:
        background = unfocusedColor;
        color = authInputColor;
    }
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
          color: background,
          borderRadius: BorderRadius.circular(5)
      ),
      child: Text(status, style: TextStyle(color: color, fontSize: 12)),
    );
  }

}