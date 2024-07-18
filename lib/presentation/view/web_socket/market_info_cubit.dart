import 'dart:ui';

import 'package:bloc/bloc.dart';
import 'package:nvs_trading/data/model/market_index.dart';
import 'package:nvs_trading/data/model/market_info.dart';

import 'market_info_state.dart';

class MarketInfoCubit extends Cubit<MarketInfoState> {
  MarketInfoCubit() : super(const MarketInfoState());

  updateMarketInfo(MarketInfo marketInfo) {
    MarketInfo dataUpdate = marketInfo;
    if (state.marketInfo[marketInfo.symbol] != null) {
      final marketInfoExisted = state.marketInfo[marketInfo.symbol]!.toJson();
      final newMarketInfo = marketInfo.toJson();
      marketInfoExisted.removeWhere((_, value) => value == null);
      newMarketInfo.removeWhere((_, value) => value == null);
      dataUpdate =
          MarketInfo.fromJson({...marketInfoExisted, ...newMarketInfo});
    }
    emit(state.copyWith(
        marketInfo: {...state.marketInfo, '${dataUpdate.symbol}': dataUpdate}));
  }

  updateMarketIndex(MarketIndex marketIndex) {
    MarketIndex dataUpdate = marketIndex;
    if (state.marketIndex[marketIndex.symbol] != null) {
      final marketIndexExisted =
          state.marketIndex[marketIndex.symbol]!.toJson();
      final newMarketIndex = marketIndex.toJson();
      marketIndexExisted.removeWhere((_, value) => value == null);
      newMarketIndex.removeWhere((_, value) => value == null);
      dataUpdate =
          MarketIndex.fromJson({...marketIndexExisted, ...newMarketIndex});
    }
    emit(state.copyWith(marketIndex: {
      ...state.marketIndex,
      '${dataUpdate.symbol}': dataUpdate
    }));
  }

  updateSymbolSubRealtime(String symbol) {
    final newSymbols = [...state.symbols];
    newSymbols.add(symbol);
    emit(state.copyWith(symbols: newSymbols.toSet().toList()));
  }

  updateSingleSymbolSubRealtime(String symbol) {
    final newSymbols = [symbol];
    emit(state.copyWith(symbols: newSymbols.toSet().toList()));
  }

  updateSymbolsRealtime(List<String> symbols) {
    final newSymbols = [...state.symbols];
    newSymbols.addAll(symbols);
    emit(state.copyWith(symbols: newSymbols.toSet().toList()));
  }

  removeSymbolSubRealtime(String symbol) {
    final newSymbols = [...state.symbols];
    newSymbols.remove(symbol);
    emit(state.copyWith(symbols: newSymbols.toSet().toList()));
  }

  updateAppState(AppLifecycleState appState) {
    emit(state.copyWith(appState: appState));
  }
}
