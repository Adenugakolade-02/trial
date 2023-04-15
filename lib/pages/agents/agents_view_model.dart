import 'package:web_admin/enums/states.dart';
import 'package:web_admin/models/agent_data.dart';
import 'package:web_admin/pages/base_model.dart';
import 'package:web_admin/repositories/app_repository.dart';
import 'package:web_admin/service_locator.dart';

import '../../services/snackbar_service.dart';

class AdminsViewModel extends BaseModel {
  final AppRepository _appRepository = serviceLocator<AppRepository>();
  List<AgentData> get agents => _appRepository.agents;

  loadAgents() async {
    progressText = 'Loading agents...';
    setState(AppState.busy);
    await _appRepository.fetchAgents();
    setState(AppState.idle);
  }

  Future<bool> addAgent(
      String firstName,
      String lastName,
      String email,
      String password,
      String phoneNumber,
      ) async {
    progressText = 'Creating agent...';
    setState(AppState.busy);
    try {
      await _appRepository.createAgent(
        firstName, lastName, email, password, phoneNumber,
      );
      setState(AppState.idle);
      return true;
    } catch (e) {
      serviceLocator<SnackBarService>().showSnackBar(
        message: e.toString(),
      );
    }
    setState(AppState.idle);
    return false;
  }

  updateAgent(
      String id,
      String firstName,
      String lastName,
      String email,
      String password,
      String phoneNumber,
      String status,
      ) async {
    progressText = 'Updating agent...';
    setState(AppState.busy);
    String? res = await _appRepository.updateAgent(
      id, firstName, lastName, email, password, phoneNumber, status,
    );

    if (res != null) {
      serviceLocator<SnackBarService>().showSnackBar(
        message: res,
      );
    }
    setState(AppState.idle);
  }

  blockAgent(AgentData data) async {
    progressText = 'Blocking agent...';
    setState(AppState.busy);
    String? res = await _appRepository.blockAgent(data);
    if (res != null) {
      serviceLocator<SnackBarService>().showSnackBar(
        message: res,
      );
    }
    setState(AppState.idle);
  }
}