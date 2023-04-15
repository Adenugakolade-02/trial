import 'dart:async';
import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:web_admin/enums/states.dart';
import 'package:web_admin/models/agent_data.dart';
import 'package:web_admin/models/bitcoin_transaction.dart';
import 'package:web_admin/models/gift_card_type.dart';
import 'package:web_admin/models/giftcard_transaction.dart';
import 'package:web_admin/models/home_feed.dart';
import 'package:web_admin/models/transactions.dart';

import '../models/crypto_type.dart';
import '../services/http_service.dart';

class PageRouteInfo {
  String route;
  int index;
  PageRouteInfo(this.index, this.route);
}

class AppRepository {
  final StreamController<PageRouteInfo> _drawerPageController = StreamController<PageRouteInfo>.broadcast();

  Stream<PageRouteInfo> get drawerPageStream => _drawerPageController.stream;

  List<UserTransactions> _cryptoTransactions = [];
  List<UserTransactions> get cryptoTransactions => _cryptoTransactions;

  List<UserTransactions> _giftcardTransactions = [];
  List<UserTransactions> get giftcardTransactions => _giftcardTransactions;

  List<UserTransactions> _withdrawalTransactions = [];
  List<UserTransactions> get withdrawalTransactions => _withdrawalTransactions;

  List<UserTransactions> _failedCryptoTransactions = [];
  List<UserTransactions> get failedCryptoTransactions => _failedCryptoTransactions;

  List<UserTransactions> _failedGiftcardTransactions = [];
  List<UserTransactions> get failedGiftcardTransactions => _failedGiftcardTransactions;

  List<UserTransactions> _failedWithdrawalTransactions = [];
  List<UserTransactions> get failedWithdrawalTransactions => _failedWithdrawalTransactions;

  List<UserTransactions> _completedCryptoTransactions = [];
  List<UserTransactions> get completedCryptoTransactions => _completedCryptoTransactions;

  List<UserTransactions> _completedGiftcardTransactions = [];
  List<UserTransactions> get completedGiftcardTransactions => _completedGiftcardTransactions;

  List<UserTransactions> _completedWithdrawalTransactions = [];
  List<UserTransactions> get completedWithdrawalTransactions => _completedWithdrawalTransactions;

  List<UserTransactions> _approvedCryptoTransactions = [];
  List<UserTransactions> get approvedCryptoTransactions => _approvedCryptoTransactions;

  List<UserTransactions> _approvedGiftcardTransactions = [];
  List<UserTransactions> get approvedGiftcardTransactions => _approvedGiftcardTransactions;

  List<UserTransactions> _approvedWithdrawalTransactions = [];
  List<UserTransactions> get approvedWithdrawalTransactions => _approvedWithdrawalTransactions;

  List<UserTransactions> _recentCryptoTransactions = [];
  List<UserTransactions> get recentCryptoTransactions => _recentCryptoTransactions;

  List<UserTransactions> _recentGiftcardTransactions = [];
  List<UserTransactions> get recentGiftcardTransactions => _recentGiftcardTransactions;

  List<UserTransactions> _recentWithdrawalTransactions = [];
  List<UserTransactions> get recentWithdrawalTransactions => _recentWithdrawalTransactions;

  List<CryptoType> _cryptoTypes = [];
  List<CryptoType> get cryptoTypes => _cryptoTypes;

  List<AgentData> _agents = [];
  List<AgentData> get agents => _agents;

  List<GiftCardType> _giftcardTypes = [];
  List<GiftCardType> get giftcardTypes => _giftcardTypes;

  List<GiftCardType> _shuffledGiftcards = [];
  List<GiftCardType> get shuffledGiftcards => _shuffledGiftcards;

  List<HomeFeedData> _homeFeeds = [];
  List<HomeFeedData> get homeFeeds => _homeFeeds;

  updatePageIndex(PageRouteInfo info) {
    _drawerPageController.add(info);
  }

  Future fetchTransactions(TransactionCategory category, String type, { int limit = 20, int skip = 0 }) async {
    AppHttpResponse response = await HttpService.get(HttpService.transactions, {
      'limit': limit,
      'type': type,
      'page': skip,
      'category': category.name,
    });
    if (response.error || response.data == null) return;

    switch (category) {
      case TransactionCategory.airtime:
        // TODO: Handle this case.
        break;
      case TransactionCategory.data:
        // TODO: Handle this case.
        break;
      case TransactionCategory.cables:
        // TODO: Handle this case.
        break;
      case TransactionCategory.power:
        // TODO: Handle this case.
        break;
      case TransactionCategory.giftcard: {
        switch (type) {
          case 'recent':
            _recentGiftcardTransactions = skip > 0 ? [..._recentGiftcardTransactions, ...List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList()] : List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList();
            break;
          case 'pending':
            _giftcardTransactions = skip > 0 ? [...giftcardTransactions, ...List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList()] : List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList();
            break;
          case 'failed':
            _failedGiftcardTransactions = skip > 0 ? [..._failedGiftcardTransactions, ...List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList()] : List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList();
            break;
          case 'approved':
            _approvedGiftcardTransactions = skip > 0 ? [..._approvedGiftcardTransactions, ...List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList()] : List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList();
            break;
          case 'completed':
            _completedGiftcardTransactions = skip > 0 ? [..._completedGiftcardTransactions, ...List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList()] : List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList();
            break;
        }
      }
        break;
      case TransactionCategory.crypto: {
        switch (type) {
          case 'recent':
            _recentCryptoTransactions = skip > 0 ? [..._recentCryptoTransactions, ...List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList()] : List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList();
            break;
          case 'pending':
            _cryptoTransactions = skip > 0 ? [..._cryptoTransactions, ...List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList()] : List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList();
            break;
          case 'failed':
            _failedCryptoTransactions = skip > 0 ? [..._failedCryptoTransactions, ...List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList()] : List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList();
            break;
          case 'approved':
            _approvedCryptoTransactions = skip > 0 ? [..._approvedCryptoTransactions, ...List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList()] : List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList();
            break;
          case 'completed':
            _completedCryptoTransactions = skip > 0 ? [..._completedCryptoTransactions, ...List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList()] : List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList();
            break;
        }
      }
        break;
      case TransactionCategory.withdrawal: {
        switch (type) {
          case 'recent':
            _recentWithdrawalTransactions = skip > 0 ? [..._recentWithdrawalTransactions, ...List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList()] : List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList();
            break;
          case 'pending':
            _withdrawalTransactions = skip > 0 ? [..._withdrawalTransactions, ...List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList()] : List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList();
            break;
          case 'failed':
            _failedWithdrawalTransactions = skip > 0 ? [..._failedWithdrawalTransactions, ...List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList()] : List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList();
            break;
          case 'approved':
            _approvedWithdrawalTransactions = skip > 0 ? [..._approvedWithdrawalTransactions, ...List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList()] : List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList();
            break;
          case 'completed':
            _completedWithdrawalTransactions = skip > 0 ? [..._completedWithdrawalTransactions, ...List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList()] : List.from(response.data[type])
                .map<UserTransactions>((e) => UserTransactions.from(e)).toList();
            break;
        }
      }
        break;
    }
  }

  fetchCryptoTypes() async {
    AppHttpResponse response = await HttpService.get(HttpService.cryptoTypes, {});
    _cryptoTypes = List.from(response.data)
        .map<CryptoType>((e) => CryptoType.from(e)).toList();
  }

  fetchAgents() async {
    AppHttpResponse response = await HttpService.get(HttpService.users, { 'user_type': 'agent' });
    if (response.error || response.data == null) return;

    _agents = List.from(response.data)
        .map<AgentData>((e) => AgentData.fromJson(e)).toList();
  }

  fetchGiftcards() async {
    AppHttpResponse response = await HttpService.get(HttpService.giftcards, {});
    if (response.error || response.data == null) return;

    _giftcardTypes = List.from(response.data)
        .map<GiftCardType>((e) => GiftCardType.from(e)).toList();
    List<GiftCardType> copy = [..._giftcardTypes];
    copy.shuffle();
    _shuffledGiftcards = copy.take(3).toList();
  }

  Future<String?> saveGiftcardChanges(GiftCardType type) async {
    AppHttpResponse response = await HttpService.patch(HttpService.giftcards + "/${type.id}", type.toMap());
    if (response.error || response.data == null) return response.message;
    return null;
  }

  Future<String?> deleteGiftcard(GiftCardType type) async {
    AppHttpResponse response = await HttpService.delete(HttpService.giftcards + "/${type.id}", {});
    if (response.error || response.data == null) return response.message;
    return null;
  }

  Future<bool> updateCrypto(CryptoType cryptoType) async {
    AppHttpResponse response = await HttpService.patch(HttpService.cryptoTypes + "/${cryptoType.id}", {
      'rate': cryptoType.rate.map((e) => e.toMap()).toList(),
    });
    if (response.error || response.data == null) return false;
    return true;
  }

  updateTransaction(UserTransactions transaction, List<String> status) async {
    AppHttpResponse response = await HttpService.patch(HttpService.transactions + "/${transaction.id}", {
      'status': status[0],
      ...((status[0] == 'approved' && status[1].isNotEmpty) ? {
        'amount': num.parse(status[1]),
        'description': 'Amount updated from ${transaction.amount} to ${status[1]}',
      } : {}),
      ...((status[0] == 'failed' && status[1].isNotEmpty) ? {'description': status[1] } : {})
    });
    if (response.error || response.data == null) return;
  }

  payCustomer(UserTransactions transaction) async {
    AppHttpResponse response = await HttpService.patch(HttpService.transactions + "/${transaction.id}/pay", {});
    if (response.error || response.data == null) return;
  }

  createAgent(
      String firstName,
      String lastName,
      String email,
      String password,
      String phoneNumber,
      ) async {
    Map<String, dynamic> data = {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'password': password,
      'accept_terms_and_conditions': true,
      'fcm_token': '',
      'status': 'active',
      'user_type': 'agent',
    };
    AppHttpResponse response = await HttpService.post(HttpService.users, data);
    if (response.error == true) throw ErrorDescription(response.message);

    _agents.add(AgentData.fromJson(response.data));
  }

  Future<String?> updateAgent(
      String id,
      String firstName,
      String lastName,
      String email,
      String password,
      String phoneNumber,
      String status,
      ) async {
    Map<String, dynamic> data = {
      'email': email,
      'first_name': firstName,
      'last_name': lastName,
      'phone_number': phoneNumber,
      'status': status,
    };
    if (password.isNotEmpty) data['access_code'] = password;
    AppHttpResponse response = await HttpService.patch('${HttpService.users}/$id', data);
    if (response.error == true) return response.message;
    return null;
  }

  Future<String?> blockAgent(AgentData data) async {
    Map<String, dynamic> payload = {
      'status': 'blocked',
    };
    AppHttpResponse response = await HttpService.patch('${HttpService.users}/${data.id}', payload);
    if (response.error == true) return response.message;
    return null;
  }

  fetchHomeFeeds() async {
    AppHttpResponse response = await HttpService.get(HttpService.cryptoUpdates, {});
    if (response.error || response.data == null) return;

    _homeFeeds = List.from(response.data)
        .map<HomeFeedData>((e) => HomeFeedData.from(e)).toList();
  }

  Future<bool> createHomeFeeds(HomeFeedData feed) async {
    AppHttpResponse response = await HttpService.post(HttpService.cryptoUpdates, feed.toMap());
    if (response.error || response.data == null) return false;
    return true;
  }

  Future<bool> deleteHomeFeeds(HomeFeedData feed) async {
    AppHttpResponse response = await HttpService.delete(HttpService.cryptoUpdates + "/${feed.id}", {});
    if (response.error || response.data == null) return false;
    return true;
  }
}