import 'package:flutter/material.dart';

import 'bridge.dart';

class BridgeExample extends StatefulWidget {
  const BridgeExample({super.key});

  @override
  State createState() => _BridgeExampleState();
}

class _BridgeExampleState extends State<BridgeExample> {
  final _storages = [SqlStorage(), FileStorage()];

  late IRepository _customersRepository;
  late IRepository _ordersRepository;

  late List<Customer> _customers;
  late List<Order> _orders;

  int _selectedCustomerStorageIndex = 0;
  int _selectedOrderStorageIndex = 0;

  void _onSelectedCustomerStorageIndexChanged(int? index) {
    setState(() {
      _selectedCustomerStorageIndex = index!;
      _customersRepository = CustomersRepository(_storages[index]);
      _customers = _customersRepository.getAll() as List<Customer>;
    });
  }

  void _onSelectedOrderStorageIndexChanged(int? index) {
    setState(() {
      _selectedOrderStorageIndex = index!;
      _ordersRepository = OrdersRepository(_storages[index]);
      _orders = _ordersRepository.getAll() as List<Order>;
    });
  }

  void _addCustomer() {
    _customersRepository.save(Customer());

    setState(() {
      _customers = _customersRepository.getAll() as List<Customer>;
    });
  }

  void _addOrder() {
    _ordersRepository.save(Order());

    setState(() {
      _orders = _ordersRepository.getAll() as List<Order>;
    });
  }

  @override
  void initState() {
    super.initState();

    _customersRepository =
        CustomersRepository(_storages[_selectedCustomerStorageIndex]);
    _customers = _customersRepository.getAll() as List<Customer>;

    _ordersRepository = OrdersRepository(_storages[_selectedOrderStorageIndex]);
    _orders = _ordersRepository.getAll() as List<Order>;
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
                    'Select customers storage:',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              DropdownButton<int>(
                value: _selectedCustomerStorageIndex,
                items: _storages
                    .map(
                      (storage) => DropdownMenuItem<int>(
                        value: _storages.indexOf(storage),
                        child: Text(storage.getTitle()),
                      ),
                    )
                    .toList(),
                onChanged: _onSelectedCustomerStorageIndexChanged,
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: _addCustomer,
                child: const Text('Add'),
              ),
              const SizedBox(height: 16.0),
              if (_customers.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Customers:',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(height: 16.0),
                    ..._customers
                        .map(
                          (customer) => Text(
                            customer.toString(),
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        )
                        .toList(),
                  ],
                ),
              if (_customers.isEmpty)
                Text(
                  '0 customers found',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
              const Divider(),
              Row(
                children: <Widget>[
                  Text(
                    'Select orders storage:',
                    style: Theme.of(context).textTheme.headline6,
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              DropdownButton<int>(
                value: _selectedOrderStorageIndex,
                items: _storages
                    .map(
                      (storage) => DropdownMenuItem<int>(
                        value: _storages.indexOf(storage),
                        child: Text(storage.getTitle()),
                      ),
                    )
                    .toList(),
                onChanged: _onSelectedOrderStorageIndexChanged,
              ),
              const SizedBox(height: 16.0),
              TextButton(
                onPressed: _addOrder,
                child: const Text('Add'),
              ),
              const SizedBox(height: 16.0),
              if (_orders.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Orders:',
                      style: Theme.of(context).textTheme.headline6,
                    ),
                    const SizedBox(height: 16.0),
                    ..._orders
                        .map(
                          (order) => Text(
                            order.toString(),
                            style: Theme.of(context).textTheme.bodyText2,
                          ),
                        )
                        .toList(),
                  ],
                ),
              if (_orders.isEmpty)
                Text(
                  '0 orders found',
                  style: Theme.of(context).textTheme.subtitle2,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
