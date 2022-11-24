import 'package:flutter/material.dart';

import 'proxy.dart';

class ProxyExample extends StatelessWidget {
  const ProxyExample({super.key});

  @override
  Widget build(BuildContext context) {
    final customerDetailsServiceProxy =
        CustomerDetailsServiceProxy(CustomerDetailsService());

    final customerList = List.generate(10, (_) => Customer());

    return Scaffold(
      body: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: <Widget>[
              Text(
                'Press on the list tile to see more information about the customer',
                style: Theme.of(context).textTheme.subtitle1,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 32.0),
              for (var customer in customerList)
                Card(
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.grey,
                      child: Text(
                        customer.name[0],
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    trailing: const Icon(Icons.info_outline),
                    title: Text(customer.name),
                    onTap: () {
                      showDialog<void>(
                        context: context,
                        barrierDismissible: false,
                        builder: (_) {
                          return AlertDialog(
                            title: Text("${customer.name}'s Details"),
                            content: FutureBuilder<CustomerDetails>(
                              future: customerDetailsServiceProxy
                                  .getCustomerDetails(customer.id),
                              builder: (_, snapshot) {
                                if (snapshot.hasData) {
                                  final details = snapshot.data!;
                                  return Column(
                                    mainAxisSize: MainAxisSize.min,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text("Email: ${details.email}"),
                                      Text("Hobby: ${details.hobby}"),
                                      Text("Position: ${details.position}"),
                                    ],
                                  );
                                } else if (snapshot.hasError) {
                                  return Text("Error: ${snapshot.error}");
                                } else {
                                  return const SizedBox(
                                    height: 64.0,
                                    child: Center(
                                        child: CircularProgressIndicator()),
                                  );
                                }
                              },
                            ),
                            actions: [
                              TextButton(
                                child: const Text("Close"),
                                onPressed: () => Navigator.of(context).pop(),
                              ),
                            ],
                          );
                        },
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
