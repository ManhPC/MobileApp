import 'package:flutter/cupertino.dart';
import 'package:nvs_trading/presentation/view/order/trading_view.dart';

class BieuDo extends StatefulWidget {
  BieuDo({
    super.key,
    required this.symbol,
  });
  String symbol;

  @override
  State<BieuDo> createState() => _BieuDoState();
}

class _BieuDoState extends State<BieuDo> {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: TradingView(symbol: widget.symbol),
    );
  }
}
