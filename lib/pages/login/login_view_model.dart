import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:web_admin/pages/base_model.dart';

import '../../enums/states.dart';
import '../../repositories/auth_repository.dart';
import '../../service_locator.dart';

class LoginViewModel extends BaseModel {
  final AuthRepository _authRepository = serviceLocator<AuthRepository>();

  Future<String> login(String email, String password) async {
    if (email.isEmpty) return 'Please fill your registered email';
    if (password.isEmpty) return 'Please fill your password';

    progressText = 'Logging in...';
    setState(AppState.busy);

    try {
      UserCredential credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email, password: password,
      );

      if (credential.user == null) return 'Login failed';

      _authRepository.currentUser = credential.user;
      String? fcmToken = await FirebaseMessaging.instance.getToken(vapidKey: 'BJHRcUw0zZzh5atZneWFw3Dni7i-j-QhXMfWFROrf8pSZWppq3jND8O8XNV2uR6she7Boal5dLVukBvp8b0qlUQ');
      print(fcmToken);
      await _authRepository.updateUserDetails({ 'fcm_token': fcmToken });
      await _authRepository.getUserDetails();
      setState(AppState.idle);
      return 'success';
    } on FirebaseAuthException catch(e) {
      setState(AppState.idle);
      return e.message ?? 'An error occurred';
    }
  }
}