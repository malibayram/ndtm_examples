import 'package:flutter/material.dart';

import 'builder.dart';

class BuilderExample extends StatefulWidget {
  const BuilderExample({super.key});

  @override
  State createState() => _BuilderExampleState();
}

class _BuilderExampleState extends State<BuilderExample> {
  final BurgerMaker _burgerMaker = BurgerMaker(HamburgerBuilder());
  final List<BurgerMenuItem> _burgerMenuItems = [];

  late BurgerMenuItem _selectedBurgerMenuItem;
  late Burger _selectedBurger;

  @override
  void initState() {
    super.initState();

    _burgerMenuItems.addAll([
      BurgerMenuItem(
        label: 'Hamburger',
        burgerBuilder: HamburgerBuilder(),
      ),
      BurgerMenuItem(
        label: 'Cheeseburger',
        burgerBuilder: CheeseburgerBuilder(),
      ),
      BurgerMenuItem(
        label: 'Big Mac\u00AE',
        burgerBuilder: BigMacBuilder(),
      ),
      BurgerMenuItem(
        label: 'McChicken\u00AE',
        burgerBuilder: McChickenBuilder(),
      )
    ]);

    _selectedBurgerMenuItem = _burgerMenuItems[0];
    _selectedBurger = _prepareSelectedBurger();
  }

  Burger _prepareSelectedBurger() {
    _burgerMaker.prepareBurger();

    return _burgerMaker.getBurger();
  }

  void _onBurgerMenuItemChanged(BurgerMenuItem? selectedItem) {
    setState(() {
      _selectedBurgerMenuItem = selectedItem!;
      _burgerMaker.changeBurgerBuilder(selectedItem.burgerBuilder);
      _selectedBurger = _prepareSelectedBurger();
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
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    'Select menu item:',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              DropdownButton(
                value: _selectedBurgerMenuItem,
                items: _burgerMenuItems
                    .map<DropdownMenuItem<BurgerMenuItem>>(
                      (BurgerMenuItem item) => DropdownMenuItem(
                        value: item,
                        child: Text(item.label),
                      ),
                    )
                    .toList(),
                onChanged: _onBurgerMenuItemChanged,
              ),
              const SizedBox(height: 32.0),
              Row(
                children: <Widget>[
                  Text(
                    'Information:',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              const SizedBox(height: 24.0),
              BurgerInformationColumn(burger: _selectedBurger),
            ],
          ),
        ),
      ),
    );
  }
}

class BurgerInformationColumn extends StatelessWidget {
  const BurgerInformationColumn({super.key, required this.burger});

  final Burger burger;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Text(
              'Burger price: ',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Text(
              burger.getFormattedPrice(),
              style: Theme.of(context).textTheme.subtitle1,
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: <Widget>[
            Text(
              'Burger ingredients: ',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Expanded(
              child: Text(
                burger.getFormattedIngredients(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8.0),
        Row(
          children: <Widget>[
            Text(
              'Burger allergens: ',
              style: Theme.of(context).textTheme.subtitle1,
            ),
            Expanded(
              child: Text(
                burger.getFormattedAllergens(),
                style: Theme.of(context).textTheme.subtitle1,
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class BurgerMenuItem extends StatelessWidget {
  const BurgerMenuItem({
    super.key,
    required this.label,
    required this.burgerBuilder,
  });

  final String label;
  final BurgerBuilderBase burgerBuilder;

  @override
  Widget build(BuildContext context) {
    return Text(label);
  }
}
