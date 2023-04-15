class CryptoType {
  String? _id;
  String? get id => _id;

  String? _type;
  String? get type => _type;

  String? _platform;
  String? get platform => _platform;

  String? _icon;
  String? get icon => _icon;

  List<RateRange> _rate = [];
  List<RateRange> get rate => _rate;
  set rate (value) => _rate = value;

  num? _cryptoRate;
  num? get cryptoRate => _cryptoRate;

  CryptoType.from(Map<String, dynamic> data) {
    _id = data['id'];
    _type = data['type'];
    _platform = data['platform'];
    _icon = data['icon'];
    _rate = data['rate'] != null
        ? List.from(data['rate']).map<RateRange>((e) => RateRange.from(e)).toList()
        : [];
    _cryptoRate = data['crypto_rate'];
  }
}

class RateRange {
  String? _range;
  String? get range => _range;
  num? _rate;
  num? get rate => _rate;

  RateRange(this._range, this._rate);

  RateRange.from(Map<String, dynamic> data) {
    _range = data['range'];
    _rate = data['value'];
  }

  Map<String, dynamic> toMap() {
    return {
      'range': _range,
      'value': _rate,
    };
  }
}