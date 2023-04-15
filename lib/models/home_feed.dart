class HomeFeedData {
  String? _id, _brand, _range, _currency, _cardInfoType, _variant, _rate;

  String? get id => _id;

  String? get brand => _brand;

  String? get range => _range;

  String? get rate => _rate;

  String? get variant => _variant;

  String? get cardInfoType => _cardInfoType;

  String? get currency => _currency;

  HomeFeedData(this._brand, this._range, this._currency,
      this._cardInfoType, this._variant, this._rate);

  HomeFeedData.from(Map<String, dynamic> data) {
    _id = data['id'];
    _brand = data['brand'];
    _range = data['range'];
    _currency = data['country'];
    _cardInfoType = data['card_type'];
    _variant = data['starting'];
    _rate = data['rate'];
  }

  Map<String, dynamic> toMap() {
    return {
      'brand': _brand,
      'range': _range,
      'country': _currency,
      'card_type': _cardInfoType,
      'starting': _variant,
      'rate': _rate,
    };
  }
}