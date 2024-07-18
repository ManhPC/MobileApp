import 'package:flutter/material.dart';

class DataIndustriesProvider extends ChangeNotifier {
  List<dynamic> _dataIndustries = [];

  List<dynamic> get dataIndustries => _dataIndustries;

  void updateDataIndustries(List<dynamic> segments) {
    _dataIndustries = segments;
    notifyListeners();
  }
}
