import 'package:flutter/material.dart';

import 'decorator.dart';

class DecoratorExample extends StatefulWidget {
  const DecoratorExample({super.key});

  @override
  State createState() => _DecoratorExampleState();
}

class _DecoratorExampleState extends State<DecoratorExample> {
  final pizzaMenu = PizzaMenu();

  late final Map<int, PizzaToppingData> _pizzaToppingsDataMap;
  late Pizza _pizza;
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _pizzaToppingsDataMap = pizzaMenu.getPizzaToppingsDataMap();
    _pizza = pizzaMenu.getPizza(0, _pizzaToppingsDataMap);
  }

  void _onSelectedIndexChanged(int? index) {
    _setSelectedIndex(index!);
    _setSelectedPizza(index);
  }

  void _setSelectedIndex(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onCustomPizzaChipSelected(int index, bool? selected) {
    _setChipSelected(index, selected!);
    _setSelectedPizza(_selectedIndex);
  }

  void _setChipSelected(int index, bool selected) {
    setState(() {
      _pizzaToppingsDataMap[index]!.setSelected(isSelected: selected);
    });
  }

  void _setSelectedPizza(int index) {
    setState(() {
      _pizza = pizzaMenu.getPizza(index, _pizzaToppingsDataMap);
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
              Row(
                children: <Widget>[
                  Text(
                    'Select your pizza:',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  Expanded(
                    child: DropdownButton<int>(
                      value: _selectedIndex,
                      items: const [
                        DropdownMenuItem<int>(
                          value: 0,
                          child: Text('Margherita'),
                        ),
                        DropdownMenuItem<int>(
                          value: 1,
                          child: Text('Marinara'),
                        ),
                        DropdownMenuItem<int>(
                          value: 2,
                          child: Text('Quattro Stagioni'),
                        ),
                        DropdownMenuItem<int>(
                          value: 3,
                          child: Text('Quattro Formaggi'),
                        ),
                        DropdownMenuItem<int>(
                          value: 4,
                          child: Text('Napoletana'),
                        ),
                        DropdownMenuItem<int>(
                          value: 5,
                          child: Text('Carbonara'),
                        ),
                      ],
                      onChanged: _onSelectedIndexChanged,
                    ),
                  ),
                ],
              ),
              if (_selectedIndex == 2)
                Column(
                  children: <Widget>[
                    const SizedBox(height: 16.0),
                    Row(
                      children: <Widget>[
                        Text(
                          'Customize your pizza:',
                          style: Theme.of(context).textTheme.headline6,
                        ),
                      ],
                    ),
                    const SizedBox(height: 16.0),
                    Wrap(
                      spacing: 8.0,
                      runSpacing: 8.0,
                      children: pizzaMenu
                          .getPizzaToppingsDataMap()
                          .keys
                          .map(
                            (index) => FilterChip(
                              label: Text(
                                pizzaMenu
                                    .getPizzaToppingsDataMap()[index]!
                                    .label,
                              ),
                              selected: _pizzaToppingsDataMap[index]!.selected,
                              onSelected: (selected) =>
                                  _onCustomPizzaChipSelected(index, selected),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ),
              const SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  Text(
                    'Your pizza: ',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Expanded(
                    child: Text(
                      _pizza.getDescription(),
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: <Widget>[
                  Text(
                    'Price: ',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                  Expanded(
                    child: Text(
                      '\$${_pizza.getPrice()}',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
