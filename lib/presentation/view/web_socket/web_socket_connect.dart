import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:lzstring/lzstring.dart';
import 'package:nvs_trading/data/model/market_index.dart';
import 'package:nvs_trading/data/model/market_info.dart';
import 'package:nvs_trading/data/model/message_market.dart';
import 'package:nvs_trading/presentation/view/provider/dataIndustries.dart';
import 'package:nvs_trading/presentation/view/provider/datasegments.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_cubit.dart';
import 'package:nvs_trading/presentation/view/web_socket/market_info_state.dart';
import 'package:nvs_trading/presentation/widget/singleton_realtime_widget.dart';
import 'package:provider/provider.dart';
import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:nvs_trading/common/configs/locator.dart';

class WebSocketConnect extends StatefulWidget {
  const WebSocketConnect({
    super.key,
    required this.child,
  });
  final Widget child;

  @override
  State<WebSocketConnect> createState() => _WebSocketConnectState();
}

class _WebSocketConnectState extends State<WebSocketConnect>
    with WidgetsBindingObserver {
  late WebSocketChannel channel;

  Map<String, dynamic> dataSegments = {};
  List<dynamic> dataIndustries = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    if (kDebugMode) {
      print('init websocket');
    }

    _connectWebSocket();
  }

  void _connectWebSocket() async {
    setState(() {
      channel =
          WebSocketChannel.connect(Uri.parse('wss://api.apsi.vn:5003/ws'));
    });
    await channel.ready;
    channel.sink.add('{"msgType": 4}');
    channel.sink.add('{"msgType": 2}');
    channel.sink.add('{"msgType": 3}');
    channel.stream.listen((event) {
      print(event);
      // LZString.decompressFromBase64(event).then((value) {
      //   final parsedData = json.decode(value!);
      //   if (parsedData != null) {
      //     parseMessageByType(MessageMarket.fromJson(parsedData));
      //   }
      // });
      handleMessage(event);
    }, onDone: () {});
    _sendMessage();
  }

  void _sendMessage() {
    final symbols = dI<MarketInfoCubit>().state.symbols;
    channel.sink.add('{"msgType": 2, "Message": ${jsonEncode(symbols)}}');
  }

  void _disconnectWebSocket() {
    channel.sink.close();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _disconnectWebSocket();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        dI<MarketInfoCubit>().updateAppState(AppLifecycleState.resumed);
        _connectWebSocket();
        break;
      case AppLifecycleState.inactive:
        dI<MarketInfoCubit>().updateAppState(AppLifecycleState.inactive);
        _disconnectWebSocket();
        break;
      case AppLifecycleState.paused:
        dI<MarketInfoCubit>().updateAppState(AppLifecycleState.paused);
        _connectWebSocket();
        break;
      case AppLifecycleState.detached:
        dI<MarketInfoCubit>().updateAppState(AppLifecycleState.detached);
        _connectWebSocket();
        break;
      case AppLifecycleState.hidden:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MarketInfoCubit, MarketInfoState>(
      listenWhen: (previous, current) {
        if (previous.symbols.length != current.symbols.length) {
          return true;
        } else if (previous.appState != current.appState) {
          return false;
        } else {
          return false;
        }
      },
      listener: (context, state) {
        _sendMessage();
      },
      child: BlocBuilder<MarketInfoCubit, MarketInfoState>(
        builder: (context, state) {
          return SingletonRealtimeWidget(
            id: 'realtime_id',
            stream: channel.stream,
            onValue: handleMessage,
            child: widget.child,
          );
        },
      ),
    );
  }

  void handleMessage(value) {
    try {
      if (value != null) {
        LZString.decompressFromBase64(value).then((value) {
          if (value != null) {
            parseMessageByType(MessageMarket.fromJson(json.decode(value)));
          }
        });
      }
    } catch (e) {
      print(e.toString());
    }
  }

  List<String> parseValue(String value) => value.split('*');

  parseMessageByType(MessageMarket messageMarket) {
    try {
      if (messageMarket.msgType == 4 || messageMarket.msgType == 2) {
        if (messageMarket.message.contains('\$')) {
          // print(messageMarket.message);
          final symbols = messageMarket.message.split('\$');
          for (var symbol in symbols) {
            insertMarketInfo(symbol);
          }
        } else {
          insertMarketInfo(messageMarket.message);
        }
      }
      if (messageMarket.msgType == 3 || messageMarket.msgType == 5) {
        if (messageMarket.message.contains('\$')) {
          // print(messageMarket.message);
          final symbols = messageMarket.message.split('\$');
          for (var symbol in symbols) {
            insertMarketIndex(symbol);
          }
        } else {
          insertMarketIndex(messageMarket.message);
        }
      }
      if (messageMarket.msgType == 9) {
        final types = messageMarket.message.split('|');
        for (var type in types) {
          insertMarketType(type);
        }
        //print("Types: $types");
      }
      if (messageMarket.msgType == 11) {
        final industries = messageMarket.message;
        dataIndustries = json.decode(industries);
        fetchIndustries();
        //print("AAB : $dataIndustries");
      }
    } catch (e) {
      print(e.toString());
    }
  }

  Map<String, dynamic> getDataFields(String data) {
    try {
      final symbolInfo = data.split('|');
      Map<String, dynamic> dataField = {};
      for (var i in symbolInfo) {
        final field = parseValue(i);
        if (symbolInfo.indexOf(i) == 0) {
          dataField = {...dataField, 'symbol': field[0]};
        } else {
          dataField = {
            ...dataField,
            field[0]: field[1],
            if (field.length == 3) 'color${field[0]}': field[2]
          };
        }
      }
      return dataField;
    } catch (e) {
      print(e.toString());
      return {};
    }
  }

  void insertMarketInfo(String symbol) {
    try {
      final dataFields = getDataFields(symbol);
      final symbolMarketInfo = MarketInfo.fromJson(dataFields);
      dI<MarketInfoCubit>().updateMarketInfo(symbolMarketInfo);
    } catch (e) {
      print(e.toString());
    }
  }

  void insertMarketIndex(String symbol) {
    try {
      final dataFields = getDataFields(symbol);
      final symbolMarketInfo = MarketIndex.fromJson(dataFields);
      dI<MarketInfoCubit>().updateMarketIndex(symbolMarketInfo);
    } catch (e) {
      print(e.toString());
    }
  }

  void insertMarketType(String type) {
    try {
      final segments = type.split('*');

      dataSegments[segments[0]] = segments[1].split(',');
      //print(dataSegments);
      fetchSegments();
    } catch (e) {
      print(e.toString());
    }
  }

  void fetchSegments() {
    // Fetch dataSegments ở đây
    // Sau khi lấy được dataSegments, cập nhật provider
    final provider = Provider.of<DataSegmentsProvider>(context, listen: false);
    provider.updateDataSegments(dataSegments);
  }

  void fetchIndustries() {
    final provider =
        Provider.of<DataIndustriesProvider>(context, listen: false);
    provider.updateDataIndustries(dataIndustries);
  }
}
