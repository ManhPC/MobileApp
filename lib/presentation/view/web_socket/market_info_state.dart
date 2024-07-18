// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:ui';

import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import 'package:nvs_trading/data/model/market_index.dart';
import 'package:nvs_trading/data/model/market_info.dart';

@immutable
class MarketInfoState extends Equatable {
  final List<String> symbols;
  final Map<String, MarketInfo> marketInfo;
  final Map<String, MarketIndex> marketIndex;
  final AppLifecycleState appState;
  const MarketInfoState(
      {this.symbols = const [],
      this.marketInfo = const {},
      this.marketIndex = const {},
      this.appState = AppLifecycleState.resumed});

  @override
  List<Object> get props => [symbols, marketInfo, marketIndex];

  MarketInfoState copyWith({
    List<String>? symbols,
    Map<String, MarketInfo>? marketInfo,
    Map<String, MarketIndex>? marketIndex,
    AppLifecycleState? appState,
  }) {
    return MarketInfoState(
      symbols: symbols ?? this.symbols,
      marketInfo: marketInfo ?? this.marketInfo,
      marketIndex: marketIndex ?? this.marketIndex,
      appState: appState ?? this.appState,
    );
  }
}
