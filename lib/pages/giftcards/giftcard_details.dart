import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:web_admin/constants/app_colors.dart';
import 'package:web_admin/constants/app_styles.dart';
import 'package:web_admin/enums/states.dart';
import 'package:web_admin/models/gift_card_type.dart';
import 'package:web_admin/pages/base_view.dart';
import 'package:web_admin/pages/giftcards/giftcards_view_model.dart';
import 'package:web_admin/widgets/app_button.dart';
import 'dart:math' as math;

import 'package:web_admin/widgets/app_text_input.dart';

class GiftcardDetails extends StatefulWidget {
  final GiftCardType giftcardType;
  const GiftcardDetails({Key? key, required this.giftcardType}) : super(key: key);

  @override
  State<GiftcardDetails> createState() => _GiftcardDetailsState();
}

class _GiftcardDetailsState extends State<GiftcardDetails> {
  Country? _selectedCountry;
  CardInfoType? _selectedCardInfo;
  Variant? _selectedVariant;
  ValueRange? _selectedValueRange;
  final variantKey = GlobalKey();
  final valueRangeKey = GlobalKey();

  @override
  Widget build(BuildContext context) => BaseView<GiftcardsViewModel>(
    backgroundType: BackgroundType.content,
    title: '${widget.giftcardType.brand} Giftcard Details',
    builder: (_, model, __) => Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 100,),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CachedNetworkImage(imageUrl: widget.giftcardType.logo ?? '', width: 70, height: 70,),
                  const SizedBox(width: 5,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${widget.giftcardType.brand}', style: titleStyle,),
                      Text('${model.extractInfo(widget.giftcardType).totalCountries} ${model.extractInfo(widget.giftcardType).totalCountries > 1 ? 'countries' : 'country'}')
                    ],
                  ),
                  const SizedBox(width: 15,),
                  IconButton(onPressed: () async {
                    String? name = await _editBrandName(context, widget.giftcardType.brand!);
                    setState(() {
                      if (name != null) {
                        widget.giftcardType.brand = name;
                      }
                    });
                  }, icon: const Icon(Icons.edit, size: 20,))
                ],
              ),
              Row(
                children: [
                  AppButton(
                    text: 'Save Changes',
                    color: successButtonColor,
                    textStyle: successButtonStyle,
                    onPressed: () {
                      model.saveCard(widget.giftcardType);
                    },
                  ),
                  const SizedBox(width: 20,),
                  AppButton(
                    text: 'Delete Card',
                    color: debitColor,
                    textStyle: successButtonStyle,
                    onPressed: () async {
                      bool? res = await _deleteCardConfirmation(context);
                      if (res == true) {
                        bool del = await model.deleteCard(widget.giftcardType);
                        if (del) Navigator.of(context).pop();
                      }
                    },
                  )
                ],
              ),
            ],
          ),
          const SizedBox(height: 10,),
          Expanded(child: ScrollConfiguration(
            behavior: MyCustomScrollBehavior(),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  Card(
                    child: Container(
                      width: 500,
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Card Country/Currency', style: subtitleStyle,),
                              AppButton(text: 'Add New Country', onPressed: () async {
                                Country? newCountry = await addCountryDialog(context);
                                if (newCountry == null) return;
                                setState(() {
                                  widget.giftcardType.countries.add(newCountry);
                                });
                              }),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          Expanded(child: ListView(
                            children: widget.giftcardType.countries.map((country) => countryCard(country)).toList(),
                          ))
                        ],
                      ),
                    ),
                  ),
                  Card(
                    child: Container(
                      width: 500,
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Card Info Types', style: subtitleStyle,),
                              _selectedCountry != null ? AppButton(text: 'Add new Info Type', onPressed: () async {
                                CardInfoType? newCardInfo = await addCardInfoDialog(context);
                                if (newCardInfo == null) return;
                                setState(() {
                                  _selectedCountry!.cardInfoTypes.add(newCardInfo);
                                });
                              }) : Container(),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          _selectedCountry != null ? Expanded(child: ListView(
                            children: _selectedCountry!.cardInfoTypes.map((infoTypes) => infoTypeCard(infoTypes)).toList(),
                          )) : const Center(
                            child: Text('Select a country to view details'),
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    key: variantKey,
                    child: Container(
                      width: 500,
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Card Variants', style: subtitleStyle,),
                              _selectedCardInfo != null ? AppButton(text: 'Add New Variant', onPressed: () async {
                                Variant? newVariant = await addVariantDialog(context);
                                if (newVariant == null) return;
                                setState(() {
                                  _selectedCardInfo!.variants.add(newVariant);
                                });
                              }) : Container(),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          _selectedCardInfo != null ? Expanded(child: ListView(
                            children: _selectedCardInfo!.variants.map((variant) => variantCard(variant)).toList(),
                          )) : const Center(
                            child: Text('Select a card info to view details'),
                          )
                        ],
                      ),
                    ),
                  ),
                  Card(
                    key: valueRangeKey,
                    child: Container(
                      width: 500,
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text('Card Value Ranges', style: subtitleStyle,),
                              _selectedVariant != null ? AppButton(text: 'Add New Value Range', onPressed: () async {
                                ValueRange? newValueRange = await addValueRangeDialog(context, _selectedCountry!.currencySymbol!);
                                if (newValueRange == null) return;
                                setState(() {
                                  _selectedVariant!.valueRanges.add(newValueRange);
                                });
                              }) : Container(),
                            ],
                          ),
                          const SizedBox(height: 20,),
                          _selectedVariant != null ? Expanded(child: ListView(
                            children: _selectedVariant!.valueRanges.map((valueRange) => valueRangesCard(valueRange, model)).toList(),
                          )) : const Center(
                            child: Text('Select a card variant to view details'),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),),
        ],
      ),
    ),
  );

  Widget countryCard(Country country) => InkWell(
    onTap: () {
      setState(() {
        _selectedCountry = country;
      });
    },
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${country.name}', style: accentButtonStyle,),
                  const SizedBox(height: 10,),
                  Text('Currency: ${country.currencyCode}'),
                  Text('Card Info Types: ${country.cardInfoTypes.length}')
                ],
              ),
            ),
            const SizedBox(width: 5,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () {
                  setState(() {
                    int index = widget.giftcardType.countries.indexOf(country);
                    widget.giftcardType.countries.removeAt(index);
                  });
                }, icon: const Icon(Icons.cancel, size: 15,)),
                const SizedBox(height: 10,),
                const Icon(Icons.arrow_forward_ios_outlined, size: 15,),
              ],
            )
          ],
        ),
      ),
    ),
  );

  Widget infoTypeCard(CardInfoType type) => InkWell(
    onTap: () {
      setState(() {
        _selectedCardInfo = type;
        // Scrollable.ensureVisible(variantKey.currentContext!);
      });
    },
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${type.cardType}', style: accentButtonStyle,),
                  const SizedBox(height: 10,),
                  Text('Variants: ${type.variants.length}'),
                ],
              ),
            ),
            const SizedBox(width: 5,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () {
                  setState(() {
                    int index = _selectedCountry?.cardInfoTypes.indexOf(type) ?? -1;
                    _selectedCountry?.cardInfoTypes.removeAt(index);
                  });
                }, icon: const Icon(Icons.cancel, size: 15,)),
                const SizedBox(height: 10,),
                const Icon(Icons.arrow_forward_ios_outlined, size: 15,),
              ],
            )
          ],
        ),
      ),
    ),
  );

  Widget variantCard(Variant variant) => InkWell(
    onTap: () {
      setState(() {
        _selectedVariant = variant;
        // Scrollable.ensureVisible(valueRangeKey.currentContext!);
      });
    },
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(variant.starting != null ? 'Card Starting With: ${variant.starting}' : 'Cards with no variant', style: accentButtonStyle,),
                  const SizedBox(height: 10,),
                  Text('Value Ranges: ${variant.valueRanges.length}'),
                ],
              ),
            ),
            const SizedBox(width: 5,),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () {
                  setState(() {
                    int index = _selectedCardInfo?.variants.indexOf(variant) ?? -1;
                    _selectedCardInfo?.variants.removeAt(index);
                  });
                }, icon: const Icon(Icons.cancel, size: 15,)),
                const SizedBox(height: 10,),
                const Icon(Icons.arrow_forward_ios_outlined, size: 15,),
              ],
            )
          ],
        ),
      ),
    ),
  );

  Widget valueRangesCard(ValueRange valueRange, GiftcardsViewModel model) => InkWell(
    onTap: () {
      setState(() {
        _selectedValueRange = valueRange;
      });
    },
    child: Card(
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('${valueRange.range}', style: accentButtonStyle,),
                  const SizedBox(height: 10,),
                  Text('Rate: ${model.formatMoney(valueRange.rate ?? 0)}/${_selectedCountry?.currencyCode}'),
                  Row(
                    children: [
                      const Text('Is amount fixed:'),
                      const SizedBox(width: 5,),
                      Checkbox(value: valueRange.isFixed ?? false, onChanged: null),
                    ],
                  ),
                ],
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(onPressed: () {
                  setState(() {
                    int index = _selectedVariant?.valueRanges.indexOf(valueRange) ?? -1;
                    _selectedVariant?.valueRanges.removeAt(index);
                  });
                }, icon: const Icon(Icons.cancel, size: 15,)),
                const SizedBox(height: 10,),
                TextButton(
                  onPressed: () async {
                    String? rate = await editRateDialog(context, valueRange.rate?.toString() ?? '');
                    setState(() {
                      if (rate != null) {
                        valueRange.rate = num.parse(rate);
                      }
                    });
                  },
                  child: const Text('Change Rate'),
                ),
              ],
            )
          ],
        ),
      ),
    ),
  );
}

Future<String?> editRateDialog(BuildContext context, String oldRate) {
  TextEditingController _newRate = TextEditingController(text: oldRate);

  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: widget,
        ),
      );

    },
    pageBuilder: (ctx, animation, secondAnimation) => AlertDialog(
      title: const Text('Change Rate'),
      content: AppTextInput(
        textEditingController: _newRate,
        label: 'New Rate',
        hint: '500',
      ),
      actions: [
        AppButton(
          text: 'Cancel',
          textStyle: normalTextStyle,
          color: unfocusedColor,
          onPressed: () {
            return Navigator.of(ctx).pop();
          },
        ),
        AppButton(
          text: 'Change',
          onPressed: () {
            if (_newRate.text.isEmpty) return;
            return Navigator.of(ctx).pop(_newRate.text);
          },
        ),
      ],
  ),);
}

Future<Country?> addCountryDialog(BuildContext context) {
  TextEditingController _newCountry = TextEditingController();
  TextEditingController _newCurrencyCode = TextEditingController();
  TextEditingController _newCurrencySymbol = TextEditingController();

  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: widget,
        ),
      );

    },
    pageBuilder: (ctx, animation, secondAnimation) => AlertDialog(
      title: const Text('Add New Country'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextInput(
            textEditingController: _newCountry,
            label: 'Enter Country',
          ),
          const SizedBox(height: 10,),
          AppTextInput(
            textEditingController: _newCurrencyCode,
            label: 'Enter Currency Code',
            hint: 'NGN',
          ),
          const SizedBox(height: 10,),
          AppTextInput(
            textEditingController: _newCurrencySymbol,
            label: 'Enter Currency Symbol',
            hint: '\$',
          ),
        ],
      ),
      actions: [
        AppButton(
          text: 'Cancel',
          textStyle: normalTextStyle,
          color: unfocusedColor,
          onPressed: () {
            return Navigator.of(ctx).pop();
          },
        ),
        AppButton(
          text: 'Add',
          onPressed: () {
            if (_newCountry.text.isEmpty || _newCurrencyCode.text.isEmpty || _newCurrencySymbol.text.isEmpty) return;
            return Navigator.of(ctx).pop(Country.from({
              'name': _newCountry.text,
              'currency_code': _newCurrencyCode.text,
              'currency_symbol': _newCurrencySymbol.text,
              'card_info_type': [],
            }));
          },
        ),
      ],
    ),);
}

Future<CardInfoType?> addCardInfoDialog(BuildContext context) {
  TextEditingController _newCardInfo = TextEditingController();

  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: widget,
        ),
      );

    },
    pageBuilder: (ctx, animation, secondAnimation) => AlertDialog(
      title: const Text('Add New Card Info Type'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextInput(
            textEditingController: _newCardInfo,
            label: 'Enter Card Type',
          ),
        ],
      ),
      actions: [
        AppButton(
          text: 'Cancel',
          textStyle: normalTextStyle,
          color: unfocusedColor,
          onPressed: () {
            return Navigator.of(ctx).pop();
          },
        ),
        AppButton(
          text: 'Add',
          onPressed: () {
            if (_newCardInfo.text.isEmpty) return;
            return Navigator.of(ctx).pop(CardInfoType.from({
              'card_type': _newCardInfo.text,
              'variants': [],
            }));
          },
        ),
      ],
    ),);
}

Future<Variant?> addVariantDialog(BuildContext context) {
  TextEditingController _newVariant = TextEditingController();
  bool _hasVariant = false;

  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: widget,
        ),
      );

    },
    pageBuilder: (ctx, animation, secondAnimation) => StatefulBuilder(builder: (stctx, setState) => AlertDialog(
      title: const Text('Add New Card Variant'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CheckboxListTile(
            title: const Text('Card has variant?'),
            value: _hasVariant,
            onChanged: (v) {
              setState(() {
                _hasVariant = v ?? false;
              });
            },
          ),
          if (_hasVariant) (
              AppTextInput(
                textEditingController: _newVariant,
                label: 'Enter Card Variant',
              )
          ),
        ],
      ),
      actions: [
        AppButton(
          text: 'Cancel',
          textStyle: normalTextStyle,
          color: unfocusedColor,
          onPressed: () {
            return Navigator.of(ctx).pop();
          },
        ),
        AppButton(
          text: 'Add',
          onPressed: () {
            if (_hasVariant == true && _newVariant.text.isEmpty) return;
            return Navigator.of(ctx).pop(Variant.from({
              'starting': _hasVariant ? _newVariant.text : null,
              'value_range': [],
            }));
          },
        ),
      ],
    ),));
}

Future<ValueRange?> addValueRangeDialog(BuildContext context, String symbol) {
  TextEditingController _minValue = TextEditingController();
  TextEditingController _maxValue = TextEditingController();
  TextEditingController _rate = TextEditingController();

  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: widget,
        ),
      );

    },
    pageBuilder: (ctx, animation, secondAnimation) => AlertDialog(
      title: const Text('Add New Card Info Type'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextInput(
            textEditingController: _minValue,
            label: 'Enter Min. Value',
          ),
          const SizedBox(height: 10,),
          AppTextInput(
            textEditingController: _maxValue,
            label: 'Enter Max. Value',
          ),
          const Text('If you have no max card value, leave it blank', style: smallFaintStyle,),
          const SizedBox(height: 10,),
          AppTextInput(
            textEditingController: _rate,
            label: 'Enter Rate',
          ),
        ],
      ),
      actions: [
        AppButton(
          text: 'Cancel',
          textStyle: normalTextStyle,
          color: unfocusedColor,
          onPressed: () {
            return Navigator.of(ctx).pop();
          },
        ),
        AppButton(
          text: 'Add',
          onPressed: () {
            if (_minValue.text.isEmpty || _rate.text.isEmpty) return;
            return Navigator.of(ctx).pop(ValueRange.from({
              'range': '$symbol${_minValue.text}${_maxValue.text.isNotEmpty ? ' - $symbol${_maxValue.text}' : ''}',
              'is_fixed': _maxValue.text.isEmpty,
              'rate': num.parse(_rate.text),
            }));
          },
        ),
      ],
    ),);
}

Future<bool?> _deleteCardConfirmation(BuildContext context) {

  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: widget,
        ),
      );

    },
    pageBuilder: (ctx, animation, secondAnimation) => AlertDialog(
      title: const Text('Delete Confirmation', style: titleStyle,),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: const [
          Text('You are about to delete a card, this action is irreversible. Are you sure?', style: subtitleStyle,)
        ],
      ),
      actions: [
        AppButton(
          text: 'Cancel',
          textStyle: normalTextStyle,
          color: unfocusedColor,
          onPressed: () {
            return Navigator.of(ctx).pop();
          },
        ),
        AppButton(
          text: 'Delete',
          onPressed: () {
            return Navigator.of(ctx).pop(true);
          },
        ),
      ],
    ),);
}

Future<String?> _editBrandName(BuildContext context, String currentName) {
  TextEditingController _name = TextEditingController(text: currentName);

  return showGeneralDialog(
    context: context,
    barrierDismissible: true,
    barrierLabel: MaterialLocalizations.of(context).modalBarrierDismissLabel,
    barrierColor: Colors.black.withOpacity(0.5),
    transitionDuration: const Duration(milliseconds: 300),
    transitionBuilder: (context, a1, a2, widget) {
      return Transform.scale(
        scale: a1.value,
        child: Opacity(
          opacity: a1.value,
          child: widget,
        ),
      );

    },
    pageBuilder: (ctx, animation, secondAnimation) => AlertDialog(
      title: const Text('Change Brand Name', style: titleStyle,),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextInput(
            textEditingController: _name,
            label: 'Enter Brand `name',
          ),
        ],
      ),
      actions: [
        AppButton(
          text: 'Cancel',
          textStyle: normalTextStyle,
          color: unfocusedColor,
          onPressed: () {
            return Navigator.of(ctx).pop();
          },
        ),
        AppButton(
          text: 'Change',
          onPressed: () {
            if (_name.text.isEmpty) return;
            return Navigator.of(ctx).pop(_name.text);
          },
        ),
      ],
    ),);
}

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods and getters like dragDevices
  @override
  Set<PointerDeviceKind> get dragDevices => {
    PointerDeviceKind.touch,
    PointerDeviceKind.mouse,
  };
}
