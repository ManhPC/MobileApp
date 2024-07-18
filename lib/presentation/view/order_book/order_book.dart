// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:nvs_trading/presentation/view/order_book/view/Order_history.dart';

import 'package:nvs_trading/presentation/widget/chooseAcctno.dart';
import 'package:nvs_trading/presentation/widget/style/style_appbar.dart';
import 'package:nvs_trading/presentation/view/order_book/view/Conditional_order.dart';
import 'package:nvs_trading/presentation/view/order_book/view/Trading_in_day.dart';

class OrderBook extends StatefulWidget {
  const OrderBook({super.key});

  @override
  State<OrderBook> createState() => _OrderBookState();
}

class _OrderBookState extends State<OrderBook> {
  int selectedCommand = 1;
  final PageController _pageController = PageController();

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: false,
          title: customTextStyleAppbar(
            text: "Sổ lệnh cơ sở",
          ),
          automaticallyImplyLeading: false,
          actions: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              child: Container(
                height: 24,
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(3),
                ),
                child: const ChooseAcctno(),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              Container(
                height: 36,
                decoration:
                    BoxDecoration(borderRadius: BorderRadius.circular(8)),
                child: TabBar(
                    labelPadding: const EdgeInsets.symmetric(horizontal: 0),
                    indicatorSize: TabBarIndicatorSize.tab,
                    indicator: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(8)),
                    labelColor: Theme.of(context).primaryColor,
                    unselectedLabelColor:
                        Theme.of(context).textTheme.titleSmall!.color,
                    dividerHeight: 0,
                    tabs: const <Widget>[
                      Tab(text: 'Lệnh trong ngày'),
                      Tab(text: 'Lệnh điều kiện'),
                      Tab(text: 'Lịch sử đặt lệnh'),
                    ]),
              ),
              const Expanded(
                child: TabBarView(
                  children: <Widget>[
                    TradingInDay(),
                    ConditionalOrder(),
                    OrderHistory()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
