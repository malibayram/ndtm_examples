import 'package:faker/faker.dart';

class Customer {
  late final String id;
  late final String name;
  CustomerDetails? details;

  Customer() {
    id = faker.guid.guid();
    name = faker.person.name();
  }
}

class CustomerDetails {
  final String customerId;
  final String email;
  final String hobby;
  final String position;

  const CustomerDetails(
    this.customerId,
    this.email,
    this.hobby,
    this.position,
  );
}

abstract class ICustomerDetailsService {
  Future<CustomerDetails> getCustomerDetails(String id);
}

class CustomerDetailsService implements ICustomerDetailsService {
  @override
  Future<CustomerDetails> getCustomerDetails(String id) async {
    return Future.delayed(
      const Duration(seconds: 2),
      () {
        final email = faker.internet.email();
        final hobby = faker.sport.name();
        final position = faker.job.title();

        return CustomerDetails(id, email, hobby, position);
      },
    );
  }
}

class CustomerDetailsServiceProxy implements ICustomerDetailsService {
  final ICustomerDetailsService service;
  final Map<String, CustomerDetails> customerDetailsCache = {};

  CustomerDetailsServiceProxy(this.service);

  @override
  Future<CustomerDetails> getCustomerDetails(String id) async {
    if (customerDetailsCache.containsKey(id)) {
      return customerDetailsCache[id]!;
    }

    final customerDetails = await service.getCustomerDetails(id);
    customerDetailsCache[id] = customerDetails;

    return customerDetails;
  }
}
