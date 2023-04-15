import 'dart:html';
import 'dart:typed_data';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:image_picker_for_web/image_picker_for_web.dart';
import 'package:mime/mime.dart';
import 'package:web_admin/constants/app_styles.dart';
import 'package:web_admin/constants/web_routes.dart';
import 'package:web_admin/enums/states.dart';
import 'package:web_admin/models/gift_card_type.dart';
import 'package:web_admin/pages/base_view.dart';
import 'package:web_admin/pages/giftcards/giftcards_view_model.dart';
import 'dart:math' as math;

import '../../constants/app_colors.dart';
import '../../widgets/app_button.dart';
import '../../widgets/app_text_input.dart';

class GiftcardBrands extends StatelessWidget {
  GiftcardBrands({Key? key}) : super(key: key);
  late GiftcardsViewModel _model;

  @override
  Widget build(BuildContext context) => BaseView<GiftcardsViewModel>(
    onModelReady: (model) {
      _model = model;
    },
    backgroundType: BackgroundType.content,
    title: 'Giftcard Brands',
    titleWidget: AppButton(
      text: 'Create New Brand',
      onPressed: () async {
        List<Object?>? res = await _openDialog(context, _model);
        if (res == null) return;
        bool success = await _model.createBrand(res[0] as String, res[1] as String, res[2] as Uint8List, res[3] as String);
        if (success == true) {
          _model.loadData();
        }
      },
    ),
    builder: (_, model, __) {
      double screenSize = MediaQuery.of(context).size.width;
      return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          const SizedBox(height: 100,),
          Expanded(
            child: GridView.count(
              crossAxisCount: (screenSize ~/ 350).toInt(),
              mainAxisSpacing: 10,
              crossAxisSpacing: 10,
              children: model.giftcardTypes.map((e) => giftcard(e, model)).toList(),
            ),
          ),
        ],
      ),
    );
    },
  );

  Widget giftcard(GiftCardType giftCardType, GiftcardsViewModel model) {
    GiftcardInfo giftcardInfo = model.extractInfo(giftCardType);
    return InkWell(
      onTap: () {
        WebRoute.dashboardGo(WebRoute.giftcardDetails, arguments: giftCardType);
      },
      child: Card(
        child: Container(
          height: 174,
          width: 292,
          padding: const EdgeInsets.only(top: 10, left: 10, right: 10),
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CachedNetworkImage(imageUrl: giftCardType.logo ?? '', width: 40, height: 40,),
                  const SizedBox(width: 5,),
                  Text(giftcardInfo.brand, style: titleStyle, overflow: TextOverflow.ellipsis,),
                ],
              ),
              const SizedBox(height: 15,),
              Row(
                children: [
                  const Icon(Icons.arrow_forward_ios_outlined, size: 12,),
                  const SizedBox(width: 5,),
                  Text('${giftcardInfo.totalCountries} ${giftcardInfo.totalCountries > 1 ? 'countries' : 'country'}')
                ],
              ),
              const SizedBox(height: 10,),
              Row(
                children: [
                  const Icon(Icons.arrow_forward_ios_outlined, size: 12,),
                  const SizedBox(width: 5,),
                  Text('${giftcardInfo.infoTypes.length} Card Info Types')
                ],
              ),
              const SizedBox(height: 10,),
              Padding(
                padding: const EdgeInsets.only(left: 15.0),
                child: Text(giftcardInfo.infoTypes.join(', '), style: smallFaintStyle,),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<List<Object?>?> _openDialog(BuildContext context, GiftcardsViewModel model) {
    TextEditingController _brandName = TextEditingController();
    Uint8List? image;
    String? filename;
    String? contentType;

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
        pageBuilder: (ctx, animation, secondAnimation) => StatefulBuilder(
          builder: (bctx, setState) => AlertDialog(
            title: const Text('Create New Giftcard Brand', style: titleStyle,),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                DottedBorder(
                  radius: const Radius.circular(50),
                  borderType: BorderType.RRect,
                  dashPattern: const [3, 3],
                  child: InkWell(
                    onTap: () async {
                      FileUploadInputElement uploadInput = FileUploadInputElement();
                      uploadInput.click();

                      uploadInput.onChange.listen((e) {
                        // read file content as dataURL
                        final files = uploadInput.files;
                        if (files?.length == 1) {
                          final file = files![0];
                          FileReader reader =  FileReader();

                          reader.onLoadEnd.listen((e) {
                            setState(() {
                              image = reader.result as Uint8List?;
                              filename = file.name;
                              contentType = lookupMimeType(filename!);
                            });
                          });

                          reader.onError.listen((fileEvent) {
                            setState(() {
                              image = null;
                              filename = null;
                              contentType = null;
                            });
                          });

                          reader.readAsArrayBuffer(file);
                        }
                      });
                    },
                    child: Container(
                      height: 100,
                      width: 100,
                      decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: unfocusedColor
                      ),
                      child: image != null ? Center(child: Text('$filename', style: smallFaintStyle,)) : const Center(child: Icon(Icons.camera_alt, size: 20,),),
                    ),
                  ),
                ),
                const Text('Click to upload brand logo', style: smallFaintStyle,),
                const SizedBox(height: 20,),
                AppTextInput(
                  textEditingController: _brandName,
                  label: 'New Brand Name',
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
              AppButton(text: 'Create', onPressed: () {
                if (_brandName.text.isEmpty) return;
                if (image == null) return;
                return Navigator.of(ctx).pop([_brandName.text, contentType, image, filename]);
              }),
            ],
          ),
        ));
  }
}