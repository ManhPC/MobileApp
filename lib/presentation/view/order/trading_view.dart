// ignore_for_file: file_names, depend_on_referenced_packages, must_be_immutable

import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class TradingView extends StatefulWidget {
  TradingView({super.key, required this.symbol});
  String symbol;

  @override
  State<TradingView> createState() => _TradingViewState();
}

class _TradingViewState extends State<TradingView> {
  late final WebViewController controller;
  @override
  void initState() {
    super.initState();
    print(widget.symbol);
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(const Color(0x00000000))
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
        ),
      )
      ..enableZoom(true)
      // ..loadRequest(Uri.parse("https://api.apsi.vn:5003/chart/ACB"));
      ..loadRequest(Uri.parse(
          "https://iboard.ssi.com.vn/tradingview/?symbol=${widget.symbol}&amp;language=vi&amp;interval=D&amp;theme=classic&amp;target=tradingViewStockDetail&amp;autoSave=1&amp;forceTVChart=1&amp;timescaleMarks=1"));
  }

  @override
  Widget build(BuildContext context) {
    return WebViewWidget(controller: controller);
  }
}
