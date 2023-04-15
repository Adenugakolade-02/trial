import 'package:web_admin/constants/web_routes.dart';
import 'package:web_admin/enums/states.dart';
import 'package:web_admin/pages/base_model.dart';
import 'package:web_admin/repositories/app_repository.dart';
import 'package:web_admin/repositories/auth_repository.dart';
import 'package:web_admin/service_locator.dart';

class HomeViewModel extends BaseModel {
  final AppRepository _appRepository = serviceLocator<AppRepository>();
  final AuthRepository _authRepository = serviceLocator<AuthRepository>();

  int _currentIndex = 0;
  int get currentIndex => _currentIndex;
  bool disposedFlag = false;

  setIndex(int index) {
    _currentIndex = index;
    setState(AppState.idle);
  }

  listenForDrawerPageChange() async {
    _authRepository.listenForAuthChanges();
    listenForUserDataUpdate();
    await _authRepository.getUserDetails();
    _appRepository.drawerPageStream.listen((info) {
      if (disposedFlag) return;
      _currentIndex = info.index;
      setState(AppState.idle);
      WebRoute.dashboardGo(info.route);
    });
  }

  @override
  void dispose() {
    super.dispose();
    disposedFlag = true;
  }
}