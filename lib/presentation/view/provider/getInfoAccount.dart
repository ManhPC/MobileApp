import 'package:flutter/material.dart';
import 'package:nvs_trading/data/model/account_info.dart';

class GetInfoAccount extends ChangeNotifier {
  late Future<List<AccountInfoModel>> _getInfoAccount;

  Future<List<AccountInfoModel>> get getInfoAccount => _getInfoAccount;

  set getInfoAccount(Future<List<AccountInfoModel>> value) {
    _getInfoAccount = value;
    notifyListeners();
  }
}
