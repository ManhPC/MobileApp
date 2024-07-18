import 'package:flutter/cupertino.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

class ChangeAcctno extends ChangeNotifier {
  String _acctno = HydratedBloc.storage.read('acctno') ?? '';
  String get acctno => _acctno;

  void updateAcctno(String newAcctno) {
    _acctno = newAcctno;
    HydratedBloc.storage.write('acctno', newAcctno);
    notifyListeners();
  }
}
