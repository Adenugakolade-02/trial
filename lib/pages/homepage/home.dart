import 'package:flutter/material.dart';
import 'package:web_admin/constants/app_colors.dart';
import 'package:web_admin/constants/web_routes.dart';
import 'package:web_admin/pages/base_view.dart';
import 'package:web_admin/pages/homepage/home_view_model.dart';
import 'package:web_admin/router.dart';
import 'package:web_admin/services/navigation_service.dart';

import '../../service_locator.dart';
import '../../widgets/app_bar.dart';

class Home extends StatelessWidget {
  final String pageRoute;

  const Home({Key? key, required this.pageRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenSize = MediaQuery.of(context).size.width;
    return BaseView<HomeViewModel>(
    onModelReady: (model) => model.listenForDrawerPageChange(),
    builder: (_, model, __) => Scaffold(
      appBar: screenSize <= 1080 
      ? AppBar()
      : null,
      drawer: screenSize <= 1080 ? displayDrawer(model) : null,
        body: Row(
          children: [
            if(screenSize > 1080) displayDrawer(model),
            Expanded(child: Container(
              color: unfocusedColor,
              child: Column(
                children: [
                  DetailsBar('${model.userData?.firstName} ${model.userData?.lastName}', model),
                  Expanded(child: Navigator(
                    key: serviceLocator<NavigatorService>().dashboardNavigatorKey,
                    initialRoute: pageRoute,
                    onGenerateRoute: AppRouter.generateNestedRoute,
                  )),
                  const SizedBox(height: 20,),
                  const Text('Powered by U-GO SERVICES'),
                  const SizedBox(height: 10,),
                ],
              ),
            )),
          ],
        )
    ),
  );
  }

  void setPage(HomeViewModel model, int index, String route) {
    model.setIndex(index);
    WebRoute.dashboardGo(route);
  }

  Widget displayDrawer(HomeViewModel model) => Drawer(
              backgroundColor: Colors.white,
              child: ListView(
                controller: ScrollController(),
                children: [
                  DrawerHeader(child: Image.asset('images/app_logo.png')),
                  ListTile(
                    leading: Icon(Icons.dashboard, color: model.currentIndex == 0 ? primaryColor : textColor),
                    title: Text('Dashboard', style: TextStyle(color: model.currentIndex == 0 ? primaryColor : textColor),),
                    onTap: () => setPage(model, 0, WebRoute.dashboard),
                  ),
                  ListTile(
                    leading: Icon(Icons.currency_bitcoin, color: model.currentIndex == 1 ? primaryColor : textColor),
                    title: Text('Crypto', style: TextStyle(color: model.currentIndex == 1 ? primaryColor : textColor),),
                    onTap: () => setPage(model, 1, WebRoute.cryptoDashboard),
                  ),
                  ListTile(
                    leading: Icon(Icons.card_giftcard, color: model.currentIndex == 2 ? primaryColor : textColor),
                    title: Text('Giftcards', style: TextStyle(color: model.currentIndex == 2 ? primaryColor : textColor),),
                    onTap: () => setPage(model, 2, WebRoute.giftcardDashboard),
                  ),
                  ListTile(
                    leading: Icon(Icons.assignment_returned, color: model.currentIndex == 3 ? primaryColor : textColor),
                    title: Text('Withdrawals', style: TextStyle(color: model.currentIndex == 3 ? primaryColor : textColor),),
                    onTap: () => setPage(model, 3, WebRoute.withdrawalDashboard),
                  ),
                  ListTile(
                    leading: Icon(Icons.update, color: model.currentIndex == 4 ? primaryColor : textColor),
                    title: Text('Home Feeds', style: TextStyle(color: model.currentIndex == 4 ? primaryColor : textColor),),
                    onTap: () => setPage(model, 4, WebRoute.homeFeedDashboard),
                  ),
                  if (model.userData?.userType == 'admin') (
                      ListTile(
                        leading: Icon(Icons.people, color: model.currentIndex == 5 ? primaryColor : textColor),
                        title: Text('Agents', style: TextStyle(color: model.currentIndex == 5 ? primaryColor : textColor),),
                        onTap: () => setPage(model, 5, WebRoute.agentDashboard),
                      )
                  ),
                ],
              ),
            );

}