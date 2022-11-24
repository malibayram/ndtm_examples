import 'package:flutter/material.dart';

import 'strategy.dart';

class StrategyExample extends StatefulWidget {
  const StrategyExample({super.key});

  @override
  State createState() => _StrategyExampleState();
}

class _StrategyExampleState extends State<StrategyExample> {
  final List<IShippingCostsStrategy> _shippingCostsStrategyList = [
    InStorePickupStrategy(),
    ParcelTerminalShippingStrategy(),
    PriorityShippingStrategy(),
  ];

  int _selectedStrategyIndex = 0;
  Order _order = Order();

  void _addToOrder() {
    setState(() {});

    _order.addOrderItem(OrderItem.random());
  }

  void _clearOrder() {
    setState(() {});

    _order = Order();
  }

  void _setSelectedStrategyIndex(int? index) {
    setState(() {});

    _selectedStrategyIndex = index!;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Row(
                children: [
                  Expanded(
                    child: DropdownButton<int>(
                      value: _selectedStrategyIndex,
                      items: _shippingCostsStrategyList
                          .asMap()
                          .entries
                          .map(
                            (entry) => DropdownMenuItem<int>(
                              value: entry.key,
                              child: Text(entry.value.label),
                            ),
                          )
                          .toList(),
                      onChanged: _setSelectedStrategyIndex,
                    ),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: _addToOrder,
                    child: const Text("Add to order"),
                  ),
                  const SizedBox(width: 16.0),
                  ElevatedButton(
                    onPressed: _clearOrder,
                    child: const Text("Clear order"),
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              Stack(
                children: <Widget>[
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _order.items.isEmpty ? 1.0 : 0.0,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Your order is empty',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                  ),
                  AnimatedOpacity(
                    duration: const Duration(milliseconds: 500),
                    opacity: _order.items.isEmpty ? 0.0 : 1.0,
                    child: Column(
                      children: <Widget>[
                        for (final item in _order.items)
                          ListTile(
                            title: Text(item.title),
                            trailing: Text(
                              '\$${item.price.toStringAsFixed(2)}',
                              style: Theme.of(context).textTheme.headline6,
                            ),
                          ),
                        const SizedBox(height: 24.0),
                        Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Total',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Text(
                                  '\$${_order.price.toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Shipping',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Text(
                                  '\$${_shippingCostsStrategyList[_selectedStrategyIndex].calculate(_order).toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24.0),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Text(
                                  'Total with shipping',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                                Text(
                                  '\$${(_order.price + _shippingCostsStrategyList[_selectedStrategyIndex].calculate(_order)).toStringAsFixed(2)}',
                                  style: Theme.of(context).textTheme.headline6,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ), /* 
                        ShippingOptions(
                          selectedIndex: _selectedStrategyIndex,
                          shippingOptions: _shippingCostsStrategyList,
                          onChanged: _setSelectedStrategyIndex,
                        ),
                        OrderSummary(
                          shippingCostsStrategy:
                              _shippingCostsStrategyList[_selectedStrategyIndex],
                          order: _order,
                        ), */
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
