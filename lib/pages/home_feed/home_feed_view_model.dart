import 'package:web_admin/enums/states.dart';
import 'package:web_admin/models/home_feed.dart';
import 'package:web_admin/pages/base_model.dart';

import '../../repositories/app_repository.dart';
import '../../service_locator.dart';
import '../../services/snackbar_service.dart';

class HomeFeedViewModel extends BaseModel {
  final AppRepository _appRepository = serviceLocator<AppRepository>();
  List<HomeFeedData> get homeFeeds => _appRepository.homeFeeds;

  loadFeeds() async {
    progressText = 'Loading feeds...';
    setState(AppState.busy);
    await _appRepository.fetchHomeFeeds();
    setState(AppState.idle);
  }

  Future<bool> createFeeds(HomeFeedData data) async {
    progressText = 'Creating feed update...';
    setState(AppState.busy);
    bool res = await _appRepository.createHomeFeeds(data);
    if (res == true) {
      serviceLocator<SnackBarService>().showSnackBar(
        message: 'Successfully created update',
        isError: false,
      );
      await _appRepository.fetchHomeFeeds();
      setState(AppState.idle);
      return true;
    }
    setState(AppState.idle);
    return false;
  }

  Future<bool> removeFeeds(HomeFeedData data) async {
    progressText = 'Removing feed update...';
    setState(AppState.busy);
    bool res = await _appRepository.deleteHomeFeeds(data);
    if (res == true) {
      serviceLocator<SnackBarService>().showSnackBar(
        message: 'Successfully removed update',
        isError: false,
      );
      await _appRepository.fetchHomeFeeds();
      setState(AppState.idle);
      return true;
    }
    setState(AppState.idle);
    return false;
  }
}