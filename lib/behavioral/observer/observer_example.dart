import 'dart:async';

import 'package:flutter/material.dart';

import 'observer.dart';

class ObserverExample extends StatefulWidget {
  const ObserverExample({super.key});

  @override
  State createState() => _ObserverExampleState();
}

class _ObserverExampleState extends State<ObserverExample> {
  final _stockSubscriberList = <StockSubscriber>[
    DefaultStockSubscriber(),
    GrowingStockSubscriber(),
  ];
  final _stockTickers = <StockTickerModel>[
    StockTickerModel(stockTicker: GameStopStockTicker()),
    StockTickerModel(stockTicker: GoogleStockTicker()),
    StockTickerModel(stockTicker: TeslaStockTicker()),
  ];
  final _stockEntries = <Stock>[];

  StreamSubscription<Stock>? _stockStreamSubscription;
  StockSubscriber _subscriber = DefaultStockSubscriber();
  int _selectedSubscriberIndex = 0;

  @override
  void initState() {
    super.initState();

    _stockStreamSubscription = _subscriber.stockStream.listen(_onStockChange);
  }

  @override
  void dispose() {
    for (final ticker in _stockTickers) {
      ticker.stockTicker.stopTicker();
    }

    _stockStreamSubscription?.cancel();

    super.dispose();
  }

  void _onStockChange(Stock stock) {
    setState(() {
      _stockEntries.add(stock);
    });
  }

  void _setSelectedSubscriberIndex(int? index) {
    for (final ticker in _stockTickers) {
      if (ticker.subscribed) {
        ticker.toggleSubscribed();
        ticker.stockTicker.unsubscribe(_subscriber);
      }
    }

    _stockStreamSubscription?.cancel();

    setState(() {
      _stockEntries.clear();
      _selectedSubscriberIndex = index!;
      _subscriber = _stockSubscriberList[_selectedSubscriberIndex];
      _stockStreamSubscription = _subscriber.stockStream.listen(_onStockChange);
    });
  }

  void _toggleStockTickerSelection(int index) {
    final stockTickerModel = _stockTickers[index];
    final stockTicker = stockTickerModel.stockTicker;

    if (stockTickerModel.subscribed) {
      stockTicker.unsubscribe(_subscriber);
    } else {
      stockTicker.subscribe(_subscriber);
    }

    setState(() {
      stockTickerModel.toggleSubscribed();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: <Widget>[
              Column(
                children: [
                  const Text('Select a subscriber:'),
                  DropdownButton<int>(
                    value: _selectedSubscriberIndex,
                    items: _stockSubscriberList
                        .map((subscriber) => DropdownMenuItem<int>(
                              value: _stockSubscriberList.indexOf(subscriber),
                              child: Text(subscriber.title),
                            ))
                        .toList(),
                    onChanged: _setSelectedSubscriberIndex,
                  ),
                ],
              ),
              const SizedBox(height: 32.0),
              Column(
                children: [
                  const Text('Select a stock ticker:'),
                  ..._stockTickers
                      .map((stockTickerModel) => CheckboxListTile(
                            title: Text(stockTickerModel.stockTicker.title),
                            value: stockTickerModel.subscribed,
                            onChanged: (value) {
                              _toggleStockTickerSelection(
                                  _stockTickers.indexOf(stockTickerModel));
                            },
                          ))
                      .toList(),
                ],
              ),
              Row(
                children: [
                  Expanded(
                    child: Text(
                      'Stocks',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _stockEntries.clear();
                      });
                    },
                    child: const Text('Clear'),
                  ),
                ],
              ),
              Column(
                children: [
                  for (final stock in _stockEntries.reversed)
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: Text(
                            stock.symbol.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        Text(
                          stock.price.toStringAsFixed(2),
                          style: TextStyle(
                            color: stock.changeDirection ==
                                    StockChangeDirection.growing
                                ? Colors.green
                                : Colors.red,
                          ),
                        ),
                      ],
                    ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
