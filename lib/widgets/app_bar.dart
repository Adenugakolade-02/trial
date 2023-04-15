import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_admin/constants/app_styles.dart';
import 'package:web_admin/constants/web_routes.dart';
import 'package:web_admin/enums/states.dart';
import 'package:web_admin/pages/homepage/home_view_model.dart';

class DetailsBar extends StatelessWidget {
  final String name;
  final HomeViewModel model;
  const DetailsBar(this.name, this.model, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    color: Colors.white,
    height: 60,
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Text(name, style: normalBlackTextStyle,),
        const SizedBox(width: 10,),
        Container(
          height: 40,
          width: 40,
          decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey
          ),
          child: const Icon(Icons.person, size: 20,),
        ),
        PopupMenuButton(
          icon: const Icon(Icons.arrow_drop_down),
          onSelected: (HomeMenu menu) async {
            switch (menu) {
              case HomeMenu.logout:
                final pref = await SharedPreferences.getInstance();
                await pref.clear();
                await FirebaseAuth.instance.signOut();
                WebRoute.go(WebRoute.login, popAll: true);
                break;
              case HomeMenu.about:
                // TODO: Handle this case.
                break;
            }
          },
          itemBuilder: (BuildContext ctx) => <PopupMenuEntry<HomeMenu>>[
            PopupMenuItem(
              value: HomeMenu.logout,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(Icons.logout, size: 15,),
                  SizedBox(width: 5,),
                  Text('Logout')
                ],
              ),
            ),
            PopupMenuItem(
              value: HomeMenu.about,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: const [
                  Icon(Icons.info_outline, size: 15,),
                  SizedBox(width: 5,),
                  Text('About')
                ],
              ),
            ),
          ],
        ),
      ],
    ),
  );
}