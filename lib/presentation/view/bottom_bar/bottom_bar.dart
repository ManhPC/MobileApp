// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:nvs_trading/presentation/view/order/add_command.dart';
import 'package:nvs_trading/presentation/view/asset_page/asset_page.dart';
import 'package:nvs_trading/presentation/view/expand/expand_page.dart';
import 'package:nvs_trading/presentation/view/homepage/homepage.dart';
import 'package:nvs_trading/presentation/view/market_page/market_page.dart';
import 'package:nvs_trading/presentation/view/order_book/order_book.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class BottomBar extends StatefulWidget {
  BottomBar({
    super.key,
    this.current,
    this.symbol,
    this.khoiluong,
  });

  int? current;
  String? symbol;
  String? khoiluong;

  @override
  State<BottomBar> createState() => _BottomBarState();
}

class _BottomBarState extends State<BottomBar> {
  List<Widget> _screen = [];
  late int currentIndexHome;

  @override
  void initState() {
    super.initState();
    currentIndexHome = widget.current ?? 0;
    _screen = [
      const HomePage(),
      const MarketPage(),
      AddCommand(
        symbol: widget.symbol,
        khoiluong: widget.khoiluong,
      ),
      const AssetPage(),
      const OrderBook(),
      const ExtendPage(),
    ];
  }

  @override
  void didUpdateWidget(covariant BottomBar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.current != null) {
      setState(() {
        currentIndexHome = widget.current!;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    var appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: _screen[currentIndexHome],
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 20,
        type: BottomNavigationBarType.fixed,
        backgroundColor:
            Theme.of(context).bottomNavigationBarTheme.backgroundColor,
        selectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.selectedItemColor,
        unselectedItemColor:
            Theme.of(context).bottomNavigationBarTheme.unselectedItemColor,
        currentIndex: currentIndexHome,
        onTap: (index) {
          setState(() {
            currentIndexHome = index;
            _screen = [
              const HomePage(),
              const MarketPage(),
              AddCommand(),
              const AssetPage(),
              const OrderBook(),
              const ExtendPage(),
            ];
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const ImageIcon(
              AssetImage("assets/icons/Icon.png"),
              size: 28,
            ),
            label: appLocalizations.bottombarForm('home'),
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(
              AssetImage("assets/icons/Icon-1.png"),
              size: 28,
            ),
            label: appLocalizations.bottombarForm('market'),
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(
              AssetImage("assets/icons/Icon-2.png"),
              size: 28,
            ),
            label: appLocalizations.bottombarForm('order'),
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(
              AssetImage("assets/icons/Icon-3.png"),
              size: 28,
            ),
            label: appLocalizations.bottombarForm('asset'),
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(
              AssetImage("assets/icons/Icon-4.png"),
              size: 28,
            ),
            label: appLocalizations.bottombarForm('orderbook'),
          ),
          BottomNavigationBarItem(
            icon: const ImageIcon(
              AssetImage("assets/icons/Icon-5.png"),
              size: 28,
            ),
            label: appLocalizations.bottombarForm('expand'),
          ),
        ],
      ),
    );
  }
}
