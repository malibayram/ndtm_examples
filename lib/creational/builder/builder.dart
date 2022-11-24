import 'package:flutter/material.dart';

abstract class Ingredient {
  @protected
  late List<String> allergens;
  @protected
  late String name;

  List<String> getAllergens() {
    return allergens;
  }

  String getName() {
    return name;
  }
}

class BigMacBun extends Ingredient {
  BigMacBun() {
    name = 'Big Mac Bun';
    allergens = ['Wheat'];
  }
}

class RegularBun extends Ingredient {
  RegularBun() {
    name = 'Regular Bun';
    allergens = ['Wheat'];
  }
}

class Cheese extends Ingredient {
  Cheese() {
    name = 'Cheese';
    allergens = ['Milk', 'Soy'];
  }
}

class GrillSeasoning extends Ingredient {
  GrillSeasoning() {
    name = 'Grill Seasoning';
    allergens = [];
  }
}

class BeefPatty extends Ingredient {
  BeefPatty() {
    name = 'Beef Patty';
    allergens = [];
  }
}

class McChickenPatty extends Ingredient {
  McChickenPatty() {
    name = 'McChicken Patty';
    allergens = [
      'Wheat',
      'Cooked in the same fryer that we use for Buttermilk Crispy Chicken which contains a milk allergen'
    ];
  }
}

class BigMacSauce extends Ingredient {
  BigMacSauce() {
    name = 'Big Mac Sauce';
    allergens = ['Egg', 'Soy', 'Wheat'];
  }
}

class Ketchup extends Ingredient {
  Ketchup() {
    name = 'Ketchup';
    allergens = [];
  }
}

class Mayonnaise extends Ingredient {
  Mayonnaise() {
    name = 'Mayonnaise';
    allergens = ['Egg'];
  }
}

class Mustard extends Ingredient {
  Mustard() {
    name = 'Mustard';
    allergens = [];
  }
}

class Onions extends Ingredient {
  Onions() {
    name = 'Onions';
    allergens = [];
  }
}

class PickleSlices extends Ingredient {
  PickleSlices() {
    name = 'Pickle Slices';
    allergens = [];
  }
}

class ShreddedLettuce extends Ingredient {
  ShreddedLettuce() {
    name = 'Shredded Lettuce';
    allergens = [];
  }
}

class Burger {
  final _ingredients = <Ingredient>[];
  late double _price;

  void addIngredient(Ingredient ingredient) {
    _ingredients.add(ingredient);
  }

  String getFormattedIngredients() {
    return _ingredients.map((x) => x.getName()).join(', ');
  }

  String getFormattedAllergens() {
    final allergens = <String>{};

    for (final ingredient in _ingredients) {
      allergens.addAll(ingredient.getAllergens());
    }

    return allergens.join(', ');
  }

  String getFormattedPrice() {
    return '\$${_price.toStringAsFixed(2)}';
  }

  // ignore: use_setters_to_change_properties
  void setPrice(double price) {
    _price = price;
  }
}

abstract class BurgerBuilderBase {
  @protected
  late Burger burger;
  @protected
  late double price;

  void createBurger() {
    burger = Burger();
  }

  Burger getBurger() {
    return burger;
  }

  void setBurgerPrice() {
    burger.setPrice(price);
  }

  void addBuns();
  void addCheese();
  void addPatties();
  void addSauces();
  void addSeasoning();
  void addVegetables();
}

class BigMacBuilder extends BurgerBuilderBase {
  BigMacBuilder() {
    price = 3.99;
  }

  @override
  void addBuns() {
    burger.addIngredient(BigMacBun());
  }

  @override
  void addCheese() {
    burger.addIngredient(Cheese());
  }

  @override
  void addPatties() {
    burger.addIngredient(BeefPatty());
  }

  @override
  void addSauces() {
    burger.addIngredient(BigMacSauce());
  }

  @override
  void addSeasoning() {
    burger.addIngredient(GrillSeasoning());
  }

  @override
  void addVegetables() {
    burger.addIngredient(Onions());
    burger.addIngredient(PickleSlices());
    burger.addIngredient(ShreddedLettuce());
  }
}

class CheeseburgerBuilder extends BurgerBuilderBase {
  CheeseburgerBuilder() {
    price = 1.09;
  }

  @override
  void addBuns() {
    burger.addIngredient(RegularBun());
  }

  @override
  void addCheese() {
    burger.addIngredient(Cheese());
  }

  @override
  void addPatties() {
    burger.addIngredient(BeefPatty());
  }

  @override
  void addSauces() {
    burger.addIngredient(Ketchup());
    burger.addIngredient(Mustard());
  }

  @override
  void addSeasoning() {
    burger.addIngredient(GrillSeasoning());
  }

  @override
  void addVegetables() {
    burger.addIngredient(Onions());
    burger.addIngredient(PickleSlices());
  }
}

class HamburgerBuilder extends BurgerBuilderBase {
  HamburgerBuilder() {
    price = 1.0;
  }

  @override
  void addBuns() {
    burger.addIngredient(RegularBun());
  }

  @override
  void addCheese() {
    // Not needed
  }

  @override
  void addPatties() {
    burger.addIngredient(BeefPatty());
  }

  @override
  void addSauces() {
    burger.addIngredient(Ketchup());
    burger.addIngredient(Mustard());
  }

  @override
  void addSeasoning() {
    burger.addIngredient(GrillSeasoning());
  }

  @override
  void addVegetables() {
    burger.addIngredient(Onions());
    burger.addIngredient(PickleSlices());
  }
}

class McChickenBuilder extends BurgerBuilderBase {
  McChickenBuilder() {
    price = 1.29;
  }

  @override
  void addBuns() {
    burger.addIngredient(RegularBun());
  }

  @override
  void addCheese() {
    // Not needed
  }

  @override
  void addPatties() {
    burger.addIngredient(McChickenPatty());
  }

  @override
  void addSauces() {
    burger.addIngredient(Mayonnaise());
  }

  @override
  void addSeasoning() {
    // Not needed
  }

  @override
  void addVegetables() {
    burger.addIngredient(ShreddedLettuce());
  }
}

class BurgerMaker {
  BurgerBuilderBase burgerBuilder;

  BurgerMaker(this.burgerBuilder);

  // ignore: use_setters_to_change_properties
  void changeBurgerBuilder(BurgerBuilderBase burgerBuilder) {
    this.burgerBuilder = burgerBuilder;
  }

  Burger getBurger() {
    return burgerBuilder.getBurger();
  }

  void prepareBurger() {
    burgerBuilder.createBurger();
    burgerBuilder.setBurgerPrice();

    burgerBuilder.addBuns();
    burgerBuilder.addCheese();
    burgerBuilder.addPatties();
    burgerBuilder.addSauces();
    burgerBuilder.addSeasoning();
    burgerBuilder.addVegetables();
  }
}
