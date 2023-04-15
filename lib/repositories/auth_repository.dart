import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:web_admin/models/user_data.dart';

import '../services/http_service.dart';

class AuthRepository {

  UserData? _userData;
  UserData? get userData => _userData;
  User? _currentUser;
  User? get currentUser => _currentUser;
  set currentUser(user) => _currentUser = user;

  set userData(data) => _userData = data;
  final StreamController<UserData?> _userDataStreamController = StreamController<UserData?>.broadcast();
  Stream<UserData?> get userDataStream => _userDataStreamController.stream;

  Future getUserDetails() async {
    final pref = await SharedPreferences.getInstance();
    String? dataString = pref.getString('user_data');

    if (dataString != null) {
      _currentUser = FirebaseAuth.instance.currentUser;
      UserData data = UserData.fromJson(jsonDecode(pref.getString('user_data') ?? ''));
      _userData = data;
      _userDataStreamController.add(_userData);
    } else if (_currentUser != null) {
      AppHttpResponse response = await HttpService.get('${HttpService.users}/${_currentUser?.uid}', {});
      if (!response.error) {
        _userData = UserData.fromJson(response.data);
        await pref.setString('user_data', jsonEncode(UserData.toJson(_userData!)).toString());
        _userDataStreamController.add(_userData);
      }
    }
  }

  listenForAuthChanges() {
    if (kDebugMode) print('REGISTERING USER AUTH STATE LISTENER');
    FirebaseAuth.instance.idTokenChanges().listen((firebaseUser) async {
      if (kDebugMode) print('LISTENER FIRED WITH $firebaseUser');
      _currentUser = firebaseUser;
      // await getUserDetails();
    });
  }

  Future<AppHttpResponse> updateUserDetails(Map<String, dynamic> data) async {
    AppHttpResponse response = await HttpService
        .patch('${HttpService.users}/${_currentUser?.uid}', data);

    if (!response.error) {
      _userData = UserData.fromJson(response.data);
      _userDataStreamController.add(_userData);
    }
    return response;
  }
}