class BitcoinTransaction {
  String? _transactionId;
  String? _customerName;
  String? _amount;
  num? _rate;
  String? _wallet;
  num? _amountPaid;
  num? _date;
  String? _status;
  String? _category;

  String? get transactionId => _transactionId;

  String? get customerName => _customerName;

  String? get status => _status;

  num? get date => _date;

  num? get amountPaid => _amountPaid;

  String? get wallet => _wallet;

  num? get rate => _rate;

  String? get amount => _amount;

  String? get category => _category;

  BitcoinTransaction.from(Map<String, dynamic> data) {
    _transactionId = data['transaction_id'];
    _customerName = data['customer_name'];
    _amount = data['amount_range'];
    _rate = data['rate'];
    _wallet = data['wallet'];
    _amountPaid = data['amount_paid'];
    _date = DateTime.parse(data['created_at']).millisecondsSinceEpoch;
    _status = data['status'];
    _category = data['category'];
  }
}