import 'dart:convert';

import 'package:faker/faker.dart';

abstract class EntityBase {
  late String id;

  EntityBase() {
    id = faker.guid.guid();
  }

  EntityBase.fromJson(Map<String, dynamic> json) : id = json['id'] as String;

  Map<String, dynamic> toJson() => <String, dynamic>{'id': id};
}

class Customer extends EntityBase {
  late String name;
  late String email;

  Customer() {
    name = faker.person.name();
    email = faker.internet.email();
  }

  @override
  Customer.fromJson(Map<String, dynamic> json)
      : name = json['name'] as String,
        email = json['email'] as String,
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
      };

  @override
  String toString() => "Customer(name: $name, email: $email)";
}

class Order extends EntityBase {
  late List<String> dishes;
  late double total;

  Order() {
    dishes = List.generate(random.integer(3, min: 1), (_) => faker.food.dish());
    total = random.decimal(scale: 20, min: 5);
  }

  @override
  Order.fromJson(Map<String, dynamic> json)
      : dishes = List.from(json['dishes'] as List),
        total = json['total'] as double,
        super.fromJson(json);

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'dishes': dishes,
        'total': total,
      };

  @override
  String toString() =>
      "Order(total: ${total.toStringAsFixed(2)}, dishes: $dishes)";
}

class JsonHelper {
  const JsonHelper._();

  static String serialiseObject(EntityBase entityBase) {
    return jsonEncode(entityBase.toJson());
  }

  static T deserialiseObject<T extends EntityBase>(String jsonString) {
    final json = jsonDecode(jsonString)! as Map<String, dynamic>;

    switch (T) {
      case Customer:
        return Customer.fromJson(json) as T;
      case Order:
        return Order.fromJson(json) as T;
      default:
        throw Exception("Type of '$T' is not supported.");
    }
  }
}

abstract class IRepository {
  List<EntityBase> getAll();
  void save(EntityBase entityBase);
}

class CustomersRepository implements IRepository {
  final IStorage storage;

  const CustomersRepository(this.storage);

  @override
  List<EntityBase> getAll() {
    return storage.fetchAll<Customer>();
  }

  @override
  void save(EntityBase entityBase) {
    storage.store<Customer>(entityBase as Customer);
  }
}

class OrdersRepository implements IRepository {
  final IStorage storage;

  const OrdersRepository(this.storage);

  @override
  List<EntityBase> getAll() {
    return storage.fetchAll<Order>();
  }

  @override
  void save(EntityBase entityBase) {
    storage.store<Order>(entityBase as Order);
  }
}

abstract class IStorage {
  String getTitle();
  List<T> fetchAll<T extends EntityBase>();
  void store<T extends EntityBase>(T entityBase);
}

class FileStorage implements IStorage {
  final Map<Type, List<String>> fileStorage = {};

  @override
  String getTitle() {
    return 'File Storage';
  }

  @override
  List<T> fetchAll<T extends EntityBase>() {
    if (fileStorage.containsKey(T)) {
      final files = fileStorage[T]!;

      return files.map<T>((f) => JsonHelper.deserialiseObject<T>(f)).toList();
    }

    return [];
  }

  @override
  void store<T extends EntityBase>(T entityBase) {
    if (!fileStorage.containsKey(T)) {
      fileStorage[T] = [];
    }

    fileStorage[T]!.add(JsonHelper.serialiseObject(entityBase));
  }
}

class SqlStorage implements IStorage {
  final Map<Type, List<EntityBase>> sqlStorage = {};

  @override
  String getTitle() {
    return 'SQL Storage';
  }

  @override
  List<T> fetchAll<T extends EntityBase>() {
    return sqlStorage.containsKey(T) ? sqlStorage[T]! as List<T> : [];
  }

  @override
  void store<T extends EntityBase>(T entityBase) {
    if (!sqlStorage.containsKey(T)) {
      sqlStorage[T] = <T>[];
    }

    sqlStorage[T]!.add(entityBase);
  }
}
