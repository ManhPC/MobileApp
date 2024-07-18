import 'dart:async';

import 'package:flutter/cupertino.dart';

class _SubscriptionStatistics {
  final StreamSubscription subscription;
  int numOfStreams;

  // ignore: unused_element
  _SubscriptionStatistics({required this.subscription, this.numOfStreams = 1});
}

final Map<String, _SubscriptionStatistics> _streamSubscriptions = {};

class SingletonRealtimeWidget<T> extends StatefulWidget {
  final Widget child;
  final String id;
  final Stream<T> stream;
  final ValueChanged<T> onValue;

  const SingletonRealtimeWidget({
    super.key,
    required this.id,
    required this.stream,
    required this.onValue,
    required this.child,
  }) : assert(id != '', 'Id phải là 1 chuỗi ký tự đại diện cho stream');

  @override
  State<SingletonRealtimeWidget> createState() =>
      _RealtimeWidgetState<T>(onValue);
}

class _RealtimeWidgetState<T> extends State<SingletonRealtimeWidget> {
  final ValueChanged<T> onValue;

  _RealtimeWidgetState(this.onValue);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _handleSubcribe(widget.id);
  }

  @override
  void didUpdateWidget(SingletonRealtimeWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.id != oldWidget.id || widget.stream != oldWidget.stream) {
      _cancel(oldWidget.id);
      _handleSubcribe(widget.id);
    }
  }

  _handleSubcribe(String id) {
    try {
      if (_streamSubscriptions.containsKey(id)) {
        _streamSubscriptions[id]!.numOfStreams++;
      } else {
        _streamSubscriptions[id] = _SubscriptionStatistics(
          subscription: (widget.stream as Stream<T>).listen(
            (event) {
              onValue(event);
            },
            onDone: () {},
            onError: (err) {},
          ),
        );
      }
    } catch (e) {
      Future.error(e);
    }
  }

  _cancel(String id) {
    final statistic = _streamSubscriptions[id];
    if (statistic == null) return;
    statistic.numOfStreams--;
    if (statistic.numOfStreams <= 0) {
      statistic.subscription.cancel();
      _streamSubscriptions.remove(id);
    }
  }

  @override
  void dispose() {
    _cancel(widget.id);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }

  void _listener(T event) {
    try {
      onValue(event);
    } catch (e) {
      print(e.toString());
    }
  }
}
