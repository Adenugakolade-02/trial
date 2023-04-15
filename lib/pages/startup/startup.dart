import 'package:flutter/material.dart';
import 'package:web_admin/constants/web_routes.dart';
import 'package:web_admin/pages/base_view.dart';
import 'package:web_admin/pages/startup/startup_view_model.dart';

class Startup extends StatefulWidget {
  const Startup({Key? key}) : super(key: key);

  @override
  State<Startup> createState() => _StartupState();
}

class _StartupState extends State<Startup> {
  late StartupViewModel _model;

  @override
  void initState() {
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      if (await _model.isLoggedIn()) {
        WebRoute.go(WebRoute.home, pop: true);
      } else {
        WebRoute.go(WebRoute.login, pop: true);
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) => BaseView<StartupViewModel>(
    onModelReady: (model) => _model = model,
    builder: (_, model, __) => Container(

    ),
  );
}