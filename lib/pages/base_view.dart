import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:web_admin/constants/app_styles.dart';
import 'package:web_admin/enums/states.dart';
import 'package:web_admin/widgets/back_button.dart';
import 'package:web_admin/widgets/progress.dart';

import '../service_locator.dart';
import 'base_model.dart';

class BaseView<T extends ChangeNotifier> extends StatefulWidget {

  final Widget Function(BuildContext context, T model, Widget? child) builder;
  final Function(T)? onModelReady;
  final bool disposableView;
  final String title;
  final Widget? titleWidget;
  final BackgroundType backgroundType;

  const BaseView({
    Key? key,
    required this.builder,
    this.onModelReady,
    this.disposableView = true,
    this.title = '',
    this.titleWidget,
    this.backgroundType = BackgroundType.main
  }) : super(key: key);

  @override
  _BaseViewState<T> createState() => _BaseViewState<T>();

}

class _BaseViewState<T extends ChangeNotifier> extends State<BaseView<T>> {

  T model = serviceLocator<T>();

  @override
  void initState() {
    if (widget.onModelReady != null) {
      widget.onModelReady!(model);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.disposableView) {
      return ChangeNotifierProvider.value(value: model, child: childView(),);
    }

    return ChangeNotifierProvider<T>(
      create: (_) => model,
      child: childView(),
    );
  }

  Widget childView() {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            if (widget.backgroundType == BackgroundType.main) Consumer<T>(builder: widget.builder,) else Stack(
              children: [
                Consumer<T>(builder: widget.builder,),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                  child: Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            AppBackButton(model as BaseModel),
                            const SizedBox(width: 10,),
                            Text(widget.title, style: titleStyle,),
                          ],
                        ),
                      ),
                      if (widget.titleWidget != null) widget.titleWidget!
                    ],
                  ),
                ),
              ],
            ),
            Consumer<T>(
              builder: (_, _model, child) {
                return WillPopScope(
                    onWillPop: () async {
                      if ((_model as BaseModel).state != AppState.idle) {
                        _model.setState(AppState.idle);
                        return false;
                      } else {
                        return true;
                      }
                    },
                    child: ((_model as BaseModel).state == AppState.busy)
                        ? Progress(_model.progressText)
                        : Container()
                );
                // if ((_model as BaseModel).state == ViewState.Busy) {
                //   return Progress();
                // } else {
                //   return Container();
                // }
              },
            )
          ],
        ),
      ),
    );
  }
}