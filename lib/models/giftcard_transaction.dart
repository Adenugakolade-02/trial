class GiftcardTransaction {
  String? _transactionId;
  String? _customerName;
  String? _range;
  String? _rate;
  String? _wallet;
  num? _amountPaid;
  String? _date;
  String? _status;

  String? get transactionId => _transactionId;

  String? get customerName => _customerName;

  String? get status => _status;

  String? get date => _date;

  num? get amountPaid => _amountPaid;

  String? get wallet => _wallet;

  String? get rate => _rate;

  String? get range => _range;

  GiftcardTransaction.from(Map<String, dynamic> data) {
    _transactionId = data['transaction_id'];
    _customerName = data['customer_name'];
    _range = data['range'];
    _rate = data['rate'];
    _wallet = data['wallet'];
    _amountPaid = data['amount_paid'];
    _date = data['date'];
    _status = data['status'];
  }
}