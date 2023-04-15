class GiftCardType {
  String? _id;
  String? get id => _id;

  String? _brand;
  String? get brand => _brand;
  set brand(value) => _brand = value;

  String? _logo;
  String? get logo => _logo;

  List<Country> _countries = [];
  List<Country> get countries => _countries;

  GiftCardType.from(Map<String, dynamic> data) {
    _id = data['id'];
    _brand = data['brand'];
    _logo = data['logo'];
    _countries = data['countries'] != null
        ? List.from(data['countries']).map<Country>((e) => Country.from(e)).toList()
        : [];
  }

  Map<String, dynamic> toMap() => {
    'brand': _brand,
    'logo': _logo,
    'countries': _countries.map((e) => e.toMap()).toList()
  };
}

class Country {
  String? _name, _currencySymbol, _currencyCode;

  String? get name => _name;
  String? get currencySymbol => _currencySymbol;
  String? get currencyCode => _currencyCode;

  List<CardInfoType> _cardInfoTypes = [];
  List<CardInfoType> get cardInfoTypes => _cardInfoTypes;

  Country.from(Map<String, dynamic> data) {
    _name = data['name'];
    _currencyCode = data['currency_code'];
    _currencySymbol = data['currency_symbol'];
    _cardInfoTypes = data['card_info_type'] != null
        ? List.from(data['card_info_type']).map<CardInfoType>((e) => CardInfoType.from(e)).toList()
        : [];
  }

  Map<String, dynamic> toMap() => {
    'name': _name,
    'currency_code': _currencyCode,
    'currency_symbol': _currencySymbol,
    'card_info_type': _cardInfoTypes.map((e) => e.toMap()).toList()
  };
}

class CardInfoType {
  String? _card_type;
  String? get cardType => _card_type;
  List<Variant> _variants = [];
  List<Variant> get variants => _variants;

  CardInfoType.from(Map<String, dynamic> data) {
    _card_type = data['card_type'];
    _variants = data['variants'] != null
        ? List.from(data['variants']).map<Variant>((e) => Variant.from(e)).toList()
        : [];
  }

  Map<String, dynamic> toMap() => {
    'card_type': _card_type,
    'variants': _variants.map((e) => e.toMap()).toList()
  };
}

class Variant {
  String? _starting;
  String? get starting => _starting;
  List<ValueRange> _valueRanges = [];
  List<ValueRange> get valueRanges => _valueRanges;

  Variant.from(Map<String, dynamic> data) {
    _starting = data['starting'];
    _valueRanges = data['value_range'] != null
        ? List.from(data['value_range']).map<ValueRange>((e) => ValueRange.from(e)).toList()
        : [];
  }

  Map<String, dynamic> toMap() => {
    'starting': _starting,
    'value_range': _valueRanges.map((e) => e.toMap()).toList()
  };
}

class ValueRange {
  String? _range;
  num? _rate;
  bool? _isFixed;

  String? get range => _range;
  num? get rate => _rate;
  set rate(value) => _rate = value;
  bool? get isFixed => _isFixed;

  ValueRange.from(Map<String, dynamic> data) {
    _range = data['range'];
    _rate = data['rate'];
    _isFixed = data['is_fixed'];
  }

  Map<String, dynamic> toMap() => {
    'range': _range,
    'rate': _rate,
    'is_fixed': _isFixed,
  };
}

class CardDetail {
  String variant, range, cardValue;
  num quantity, rate, cardAmount;

  CardDetail(this.variant, this.range, this.cardValue, this.quantity, this.rate, this.cardAmount);

  Map<String, dynamic> toJson() => {
    'variant': variant,
    'range': range,
    'card_value': cardValue,
    'quantity': quantity,
    'rate': rate,
    'card_amount': cardAmount,
  };
}

class GiftcardInfo {
  String brand;
  num totalCountries;
  List<String> infoTypes;

  GiftcardInfo(this.brand, this.totalCountries, this.infoTypes);
}