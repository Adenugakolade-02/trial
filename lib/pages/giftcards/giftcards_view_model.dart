import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:web_admin/pages/base_model.dart';

import '../../enums/states.dart';
import '../../models/gift_card_type.dart';
import '../../models/transactions.dart';
import '../../repositories/app_repository.dart';
import '../../service_locator.dart';
import '../../services/http_service.dart';
import '../../services/snackbar_service.dart';

class GiftcardsViewModel extends BaseModel {
  final AppRepository _appRepository = serviceLocator<AppRepository>();
  List<GiftCardType> get giftcardTypes => _appRepository.giftcardTypes;
  List<GiftCardType> get shuffledGiftcards => _appRepository.shuffledGiftcards;
  List<UserTransactions> get giftcardTransactions => _appRepository.giftcardTransactions;
  List<UserTransactions> get completedGiftcardTransactions => _appRepository.completedGiftcardTransactions;
  List<UserTransactions> get approvedGiftcardTransactions => _appRepository.approvedGiftcardTransactions;
  final List<GiftCardType> shuffled = [];

  loadData({int? page}) async {
    progressText = 'Loading data...';
    setState(AppState.busy);
    await Future.wait<dynamic>([
      _appRepository.fetchTransactions(TransactionCategory.giftcard, 'pending',
        skip: page != null ? page * _appRepository.giftcardTransactions.length : 0,
      ),
      _appRepository.fetchTransactions(TransactionCategory.giftcard, 'completed',
        skip: page != null ? page * _appRepository.completedGiftcardTransactions.length : 0,
      ),
      ...(userData?.userType == 'admin' ? [
        _appRepository.fetchTransactions(TransactionCategory.giftcard, 'approved',
          skip: page != null ? page * _appRepository.approvedGiftcardTransactions.length : 0,
        )
      ] : []),
      _appRepository.fetchGiftcards(),
    ]);
    setState(AppState.idle);
  }

  GiftcardInfo extractInfo(GiftCardType type) {
    String brand = type.brand ?? '';
    num totalCountries = type.countries.length;
    Set<String> infoTypes = {};
    for (var c in type.countries) {
      for (var cit in c.cardInfoTypes) {
        infoTypes.add(cit.cardType!);
      }
    }
    return GiftcardInfo(brand, totalCountries, infoTypes.toList());
  }

  saveCard(GiftCardType type) async {
    progressText = 'Saving changes to cloud...';
    setState(AppState.busy);
    String? res = await _appRepository.saveGiftcardChanges(type);
    serviceLocator<SnackBarService>().showSnackBar(
      message: res != null ? 'An error occurred while saving changes. Ensure you fill all sections required' : 'Changes successfully saved',
      isError: res != null,
    );
    setState(AppState.idle);
  }

  Future<bool> createBrand(String brandName, String contentType, Uint8List file, String filename) async {
    progressText = 'Initiating upload...';
    setState(AppState.busy);

    AppHttpResponse response = await HttpService.post(HttpService.uploadUrl, {
      'content_type': contentType,
      'path': 'assets',
      'file_name': filename,
    });

    setState(AppState.idle);

    if (response.error) {
      serviceLocator<SnackBarService>().showSnackBar(
        message: response.message,
      );
      return false;
    }

    String url = response.data['url'];
    String path = response.data['path'];

    progressText = 'Uploading image...';
    setState(AppState.busy);

    AppHttpResponse uploadResponse = await HttpService.uploadImage(url, file, contentType);
    if (uploadResponse.error) {
      serviceLocator<SnackBarService>().showSnackBar(
        message: 'Failed to upload image. Please try again.',
      );
      return false;
    }

    progressText = 'Creating new brand...';
    setState(AppState.busy);

    // Create new brand
    AppHttpResponse createResponse = await HttpService.post(HttpService.giftcards, {
      'brand': brandName,
      'logo': path,
    });

    if (createResponse.error) {
      serviceLocator<SnackBarService>().showSnackBar(
        message: 'Failed to create new brand. Please try again.',
      );
      return false;
    }

    return true;
  }

  Future<bool> deleteCard(GiftCardType type) async {
    progressText = 'Deleting card...';
    setState(AppState.busy);
    String? res = await _appRepository.deleteGiftcard(type);
    serviceLocator<SnackBarService>().showSnackBar(
      message: res != null ? 'An error occurred while deleting card. Please try again' : 'Card successfully deleted',
      isError: res != null,
    );
    setState(AppState.idle);
    return res == null;
  }
}