import 'package:flutter/material.dart';
import 'package:web_admin/constants/app_colors.dart';
import 'package:web_admin/models/home_feed.dart';
import 'package:web_admin/pages/base_view.dart';
import 'package:web_admin/pages/home_feed/home_feed_view_model.dart';
import 'package:web_admin/widgets/app_text_input.dart';

import '../../constants/app_styles.dart';
import '../../widgets/app_button.dart';

class HomeFeed extends StatelessWidget {
  HomeFeed({Key? key}) : super(key: key);
  final TextEditingController _brand = TextEditingController();
  final TextEditingController _range = TextEditingController();
  final TextEditingController _rate = TextEditingController();
  final TextEditingController _currency = TextEditingController();
  final TextEditingController _variant = TextEditingController();
  final TextEditingController _cardInfoType = TextEditingController();

  @override
  Widget build(BuildContext context) => BaseView<HomeFeedViewModel>(
    onModelReady: (model) => model.loadFeeds(),
    builder: (_, model, __) => Container(
      height: double.infinity,
      width: double.infinity,
      margin: const EdgeInsets.all(20),
      alignment: Alignment.center,
      child: Column(
        children: [
          const Align(
            alignment: Alignment.centerLeft,
            child: Text('Home Feed Updates', style: titleStyle,),
          ),
          const SizedBox(height: 30,),
          Expanded(
            child: Row(
              children: [
                Expanded(
                  child: Card(
                    child: Column(
                      children: [
                        const SizedBox(height: 15,),
                        const Text('Current Home Feed Updates', style: bigAccentButtonStyle,),
                        const SizedBox(height: 15,),
                        Expanded(
                          child: ListView(
                            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                            children: model.homeFeeds.map((e) => feedCard(e, model)).toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Container(width: 2, color: unfocusedColor,),
                Expanded(
                  child: Card(
                    child: ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      children: [
                        const Align(
                          alignment: Alignment.center,
                          child: Text('Create New Home Feed Update', style: bigAccentButtonStyle,),
                        ),
                        const SizedBox(height: 30,),
                        AppTextInput(
                          textEditingController: _brand,
                          label: 'Asset/Brand',
                          hint: 'Asset/Brand',
                        ),
                        const SizedBox(height: 10,),
                        AppTextInput(
                          textEditingController: _range,
                          label: 'Value Range',
                          hint: 'Value Range',
                        ),
                        const SizedBox(height: 10,),
                        AppTextInput(
                          textEditingController: _rate,
                          label: 'Rate',
                          hint: 'Rate',
                        ),
                        const SizedBox(height: 10,),
                        AppTextInput(
                          textEditingController: _currency,
                          label: 'Currency',
                          hint: 'Currency',
                        ),
                        const SizedBox(height: 10,),
                        AppTextInput(
                          textEditingController: _cardInfoType,
                          label: 'Card Info Type',
                          hint: 'Card Info Type',
                        ),
                        const SizedBox(height: 10,),
                        AppTextInput(
                          textEditingController: _variant,
                          label: 'Card Starting Numbers',
                          hint: 'Card Starting Numbers',
                        ),
                        const SizedBox(height: 30,),
                        Align(
                          alignment: Alignment.center,
                          child: AppButton(text: 'Create Feed Update', onPressed: () async {
                            if (_brand.text.isEmpty) return;
                            if (_range.text.isEmpty) return;
                            if (_rate.text.isEmpty) return;
                            bool res = await model.createFeeds(HomeFeedData(
                              _brand.text,
                              _range.text,
                              _currency.text,
                              _cardInfoType.text,
                              _variant.text,
                              _rate.text,
                            ));
                            if (res == true) {
                              _brand.clear();
                              _range.clear();
                              _currency.clear();
                              _cardInfoType.clear();
                              _variant.clear();
                              _rate.clear();
                            }
                          }),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    ),
  );

  Widget feedCard(HomeFeedData data, HomeFeedViewModel model) => Card(
    child: Padding(
      padding: const EdgeInsets.all(15.0),
      child: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Asset: ${data.brand}'),
              const SizedBox(height: 5,),
              Text('Value Range: ${data.range}'),
              const SizedBox(height: 5,),
              Text('Rate: ${data.rate}'),
              const SizedBox(height: 5,),
              Text('Currency: ${data.currency ?? "--"}'),
              const SizedBox(height: 5,),
              Text('Card Info Type: ${data.cardInfoType ?? "--"}'),
              const SizedBox(height: 5,),
              Text('Variant: ${data.variant ?? "--"}'),
            ],
          ),
          Positioned(
            top: 10,
            right: 10,
            child: IconButton(
              onPressed: () {
                model.removeFeeds(data);
              }, icon: const Icon(Icons.delete),
            ),
          )
        ],
      ),
    ),
  );
}