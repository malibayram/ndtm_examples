import 'dart:async';

import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

abstract class StockTicker {
  late final String title;
  late final Timer stockTimer;

  @protected
  Stock? stock;

  final _subscribers = <StockSubscriber>[];

  void subscribe(StockSubscriber subscriber) => _subscribers.add(subscriber);

  void unsubscribe(StockSubscriber subscriber) =>
      _subscribers.removeWhere((s) => s.id == subscriber.id);

  void notifySubscribers() {
    for (final subscriber in _subscribers) {
      subscriber.update(stock!);
    }
  }

  void setStock(StockTickerSymbol stockTickerSymbol, int min, int max) {
    final lastStock = stock;
    final price = faker.randomGenerator.integer(max, min: min) / 100;
    final changeAmount = lastStock != null ? price - lastStock.price : 0.0;

    stock = Stock(
      changeAmount: changeAmount.abs(),
      changeDirection: changeAmount > 0
          ? StockChangeDirection.growing
          : StockChangeDirection.falling,
      price: price,
      symbol: stockTickerSymbol,
    );
  }

  void stopTicker() {
    stockTimer.cancel();
  }
}

class GameStopStockTicker extends StockTicker {
  GameStopStockTicker() {
    title = StockTickerSymbol.GME.toShortString();
    stockTimer = Timer.periodic(
      const Duration(seconds: 2),
      (_) {
        setStock(StockTickerSymbol.GME, 16000, 22000);
        notifySubscribers();
      },
    );
  }
}

class GoogleStockTicker extends StockTicker {
  GoogleStockTicker() {
    title = StockTickerSymbol.GOOGL.toShortString();
    stockTimer = Timer.periodic(
      const Duration(seconds: 5),
      (_) {
        setStock(StockTickerSymbol.GOOGL, 200000, 204000);
        notifySubscribers();
      },
    );
  }
}

class TeslaStockTicker extends StockTicker {
  TeslaStockTicker() {
    title = StockTickerSymbol.TSLA.toShortString();
    stockTimer = Timer.periodic(
      const Duration(seconds: 3),
      (_) {
        setStock(StockTickerSymbol.TSLA, 60000, 65000);
        notifySubscribers();
      },
    );
  }
}

class Stock {
  final StockTickerSymbol symbol;
  final StockChangeDirection changeDirection;
  final double price;
  final double changeAmount;

  const Stock({
    required this.symbol,
    required this.changeDirection,
    required this.price,
    required this.changeAmount,
  });
}

enum StockTickerSymbol {
  GME,
  GOOGL,
  TSLA,
}

extension StockTickerSymbolExtension on StockTickerSymbol {
  String toShortString() => toString().split('.').last;
}

enum StockChangeDirection {
  falling,
  growing,
}

abstract class StockSubscriber {
  late final String title;

  final id = faker.guid.guid();

  @protected
  final StreamController<Stock> stockStreamController =
      StreamController.broadcast();

  Stream<Stock> get stockStream => stockStreamController.stream;

  void update(Stock stock);
}

class DefaultStockSubscriber extends StockSubscriber {
  DefaultStockSubscriber() {
    title = 'All stocks';
  }

  @override
  void update(Stock stock) {
    stockStreamController.add(stock);
  }
}

class GrowingStockSubscriber extends StockSubscriber {
  GrowingStockSubscriber() {
    title = 'Growing stocks';
  }

  @override
  void update(Stock stock) {
    if (stock.changeDirection == StockChangeDirection.growing) {
      stockStreamController.add(stock);
    }
  }
}

class StockTickerModel extends ChangeNotifier {
  final StockTicker stockTicker;

  StockTickerModel({required this.stockTicker});

  final List<StockSubscriber> _stockSubscribers = [
    DefaultStockSubscriber(),
    GrowingStockSubscriber(),
  ];

  List<StockSubscriber> get stockSubscribers => _stockSubscribers;

  bool get subscribed => stockTicker._subscribers.isNotEmpty;

  void toggleSubscribed() {
    if (subscribed) {
      for (final subscriber in _stockSubscribers) {
        stockTicker.unsubscribe(subscriber);
      }
    } else {
      for (final subscriber in _stockSubscribers) {
        stockTicker.subscribe(subscriber);
      }
    }
    notifyListeners();
  }

  void subscribe(StockSubscriber subscriber) {
    _stockSubscribers.add(subscriber);
    notifyListeners();
  }

  void unsubscribe(StockSubscriber subscriber) {
    _stockSubscribers.removeWhere((s) => s.id == subscriber.id);
    notifyListeners();
  }

  void stopTicker(StockTicker stockTicker) {
    stockTicker.stopTicker();
    notifyListeners();
  }
}
