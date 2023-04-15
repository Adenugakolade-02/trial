import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class HttpService {
  static String getBaseURL() {
    const env = String.fromEnvironment('ENV', defaultValue: 'development');
    if (env == 'prod') return 'https://api.trybagc.com/api/v1/';
    return 'https://tryba-staging.herokuapp.com/api/v1/';
  }
  static const String banks = 'banks';
  static const String cards = 'cards';
  static const String transactions = 'transactions';
  static const String wallets = 'wallets';
  static const String accounts = 'accounts';
  static const String users = 'users';
  static const String rateUpdates = 'gift_cards/updates';
  static const String giftcards = 'gift_cards';
  static const String cryptos = 'cryptos';
  static const String userBankAccounts = 'users/bank_accounts';
  static const String dataPlans = 'data-plans';
  static const String discos = 'discos';
  static const String goTvProducts = 'gotv-products';
  static const String dstvProducts = 'dstv-products';
  static const String cryptoWallets = 'crypto-wallets';
  static const String withdraw = 'withdraw';
  static const String cryptoTypes = 'transactions/crypto_types';
  static const String cryptoUpdates = 'rate_update';
  static const String uploadUrl = 'upload_url';

  // A hack because of firebase stupid bug that causes current user to be null
  // on page reload. We have to wait for it to be ready before issuing a network
  // call to use the current user's token for authentication
  static _waitForFirebaseToBeReady() async {
    var user = FirebaseAuth.instance.currentUser;
    if (user != null) return;

    await Future.delayed(const Duration(seconds: 3));
    var user2 = FirebaseAuth.instance.currentUser;
    if (user2 != null) return;

    await Future.delayed(const Duration(seconds: 10));
    var user3 = FirebaseAuth.instance.currentUser;
    if (user3 != null) return;
  }

  static Future<Dio> _getDioClient() async {
    await _waitForFirebaseToBeReady();
    return Dio(BaseOptions(
      baseUrl: getBaseURL(),
      connectTimeout: 60000,
      receiveTimeout: 60000,
      responseType: ResponseType.json
    ))..interceptors.add(QueuedInterceptorsWrapper(
      onRequest: (RequestOptions options, RequestInterceptorHandler handler) async {
        options.headers['Authorization'] = 'Bearer ${await FirebaseAuth.instance.currentUser?.getIdToken(true)}';
        return handler.next(options);
      }
    ))..interceptors.add(LogInterceptor(requestHeader: true, requestBody: true));
  }

  static Future<AppHttpResponse> post(String path, Map<String, dynamic> data) async {
    try {
      Response response = await (await _getDioClient()).post(path, data: data);
      if (kDebugMode) {
        print(response.data);
      }
      return AppHttpResponse(false, response.data['data'], '');
    } on DioError catch (e) {
      return handleError(e);
    }
  }

  static Future<AppHttpResponse> get(String path, Map<String, dynamic> params) async {
    try {
      Response response = await (await _getDioClient()).get(path, queryParameters: params);
      if (kDebugMode) {
        print(response.data);
      }
      return AppHttpResponse(false, response.data['data'], '');
    } on DioError catch (e) {
      return handleError(e);
    }
  }

  static Future<AppHttpResponse> patch(String path, Map<String, dynamic> data) async {
    try {
      Response response = await (await _getDioClient()).patch(path, data: data);
      if (kDebugMode) {
        print(response.data);
      }
      AppHttpResponse res = AppHttpResponse(false, response.data['data'], '');
      return res;
    } on DioError catch (e) {
      return handleError(e);
    }
  }

  static Future<AppHttpResponse> delete(String path, Map<String, dynamic> data) async {
    try {
      Response response = await (await _getDioClient()).delete(path, data: data);
      if (kDebugMode) {
        print(response.data);
      }
      AppHttpResponse res = AppHttpResponse(false, response.data['data'], '');
      return res;
    } on DioError catch (e) {
      return handleError(e);
    }
  }

  static Future<AppHttpResponse> uploadImage(String url, Uint8List data, contentType) async {
    try {
      var response = await http.put(Uri.parse(url), body: data);
      return AppHttpResponse(false, response.statusCode, '');
    } on DioError catch (e) {
      return handleError(e);
    }
  }

  static AppHttpResponse handleError(DioError e) {
    print('ERROR DATA!!!! RESPONSE: ${e.response}');
    if (e.response != null) {
      dynamic data = e.response?.data;
      if (data != null && data is Map) {
        Map<String, dynamic> d = Map.from(data);
        return AppHttpResponse(true, e.response?.data, d['message']);
      } else {
        return AppHttpResponse(true, e.response?.data, e.message,);
      }
    } else {
      return AppHttpResponse(true, e.error, e.message);
    }
  }
}

class AppHttpResponse<T> {
  bool error;
  String message;
  T data;
  AppHttpResponse(this.error, this.data, this.message);
}