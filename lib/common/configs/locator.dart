import 'package:get_it/get_it.dart';

import 'package:nvs_trading/presentation/view/web_socket/market_info_cubit.dart';

final dI = GetIt.instance;

Future<void> initDI({bool isMock = false}) async {
  //register repository

  //register usecase

  dI.registerLazySingleton<MarketInfoCubit>(() => MarketInfoCubit());
  //register service
}
