import 'package:firebase_auth/firebase_auth.dart';
import 'package:web_admin/pages/base_model.dart';

class StartupViewModel extends BaseModel {
  Future<bool> isLoggedIn() async {
    return FirebaseAuth.instance.currentUser != null;
  }
}