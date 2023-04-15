class UserTransactions {
  String? _id;
  String? get id => _id;

  String? _title;
  String? get title => _title;

  num? _amount;
  num? get amount => _amount;

  num? _timestamp;
  num? get timestamp => _timestamp;

  String? _type;
  String? get type => _type;

  String? _description;
  String? get description => _description;
  set description(value) => _description = value;

  String? _status;
  String? get status => _status;

  String? _category;
  String? get category => _category;

  String? _name;
  String? get name => _name;

  // Airtime
  String? _phoneNumber;
  String? get phoneNumber => _phoneNumber;

  String? _networkBrand;
  String? get networkBrand => _networkBrand;

  // Data
  String? _dataPlan;
  String? get dataPlan => _dataPlan;

  // Cables
  String? _subscriptionPlan;
  String? get subscriptionPlan => _subscriptionPlan;

  String? _smartCardNumber;
  String? get smartCardNumber => _smartCardNumber;

  // Power
  String? _disco;
  String? get disco => _disco;

  String? _meterNumber;
  String? get meterNumber => _meterNumber;

  // Giftcard
  String? _brand, _brandLogo, _currency,
      _cardInfoType;
  List<CardSelection> _cards = [];

  String? get brand => _brand;
  String? get brandLogo => _brandLogo;
  String? get currency => _currency;
  String? get cardInfoType => _cardInfoType;
  List<CardSelection> get cards => _cards;

  // Crypto
  String? _cryptoType, _cryptoRate, _cryptoWalletName, _cryptoWalletAddress, _cryptoImageRef;
  num? _cryptoValue, _rate;
  String? get cryptoType => _cryptoType;
  String? get cryptoRate => _cryptoRate;
  num? get cryptoValue => _cryptoValue;
  num? get rate => _rate;
  String? get cryptoWalletName => _cryptoWalletName;
  String? get cryptoWalletAddress => _cryptoWalletAddress;
  String? get cryptoImageRef => _cryptoImageRef;

  // Withdrawal
  String? _bankName, _bankAccountName, _bankAccountNumber;
  String? get bankName => _bankName;
  String? get bankAccountName => _bankAccountName;
  String? get bankAccountNumber => _bankAccountNumber;

  UserTransactions.from(Map<String, dynamic> data) {
    _id = data['id'];
    _title = data['title'];
    _amount = data['amount'];
    _timestamp = DateTime.parse(data['created_at']).millisecondsSinceEpoch;
    _type = data['transaction_type'];
    _description = data['description'];
    _status = data['status'];
    _category = data['category']; // airtime, data, cables, power, giftcard, crypto, withdrawal
    _name = data['owner'] != null ? '${data['owner']['first_name']} ${data['owner']['last_name']}' : '';
    _phoneNumber = data['phone_number'];
    _networkBrand = data['network_brand'];
    _dataPlan = data['data_plan'];
    _subscriptionPlan = data['subscription_plan'];
    _smartCardNumber = data['smart_card_number'];
    _disco = data['disco'];
    _meterNumber = data['meter_number'];
    _brand = data['brand'];
    _brandLogo = data['brand_logo'];
    _currency = data['currency'];
    _cardInfoType = data['card_info_type'];
    _cards = data['cards'] != null
        ? List.from(data['cards']).map<CardSelection>((e) => CardSelection.fromJson(e)).toList()
        : [];
    _cryptoType = data['crypto_type'];
    _cryptoRate = data['crypto_rate'];
    _cryptoValue = data['crypto_value'];
    _rate = data['rate'];
    _cryptoWalletName = data['crypto_wallet_name'];
    _cryptoWalletAddress = data['crypto_wallet_address'];
    _cryptoImageRef = data['crypto_image_ref'];
    _bankName = data['bank_name'];
    _bankAccountName = data['bank_account_name'];
    _bankAccountNumber = data['bank_account_number'];
  }
}

class CardSelection {
  String? _variant, _range;
  num? _value, _quantity, _rate, _amount;

  String? get variant => _variant;
  String? get range => _range;
  num? get value => _value;
  num? get quantity => _quantity;
  num? get rate => _rate;
  num? get amount => _amount;

  CardSelection.fromJson(Map<String, dynamic> data) {
    _variant = data['variant'];
    _range = data['range'];
    _value = data['card_value'];
    _quantity = data['quantity'];
    _rate = data['rate'];
    _amount = data['card_amount'];
  }
}