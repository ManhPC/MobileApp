import 'package:flutter/material.dart';

class DataSegmentsProvider extends ChangeNotifier {
  Map<String, dynamic> _dataSegments = {};

  Map<String, dynamic> get dataSegments => _dataSegments;

  void updateDataSegments(Map<String, dynamic> segments) {
    _dataSegments = segments;
    notifyListeners();
  }
}
