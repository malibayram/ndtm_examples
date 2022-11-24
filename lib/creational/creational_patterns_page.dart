import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class CreationalPatternsPage extends StatelessWidget {
  const CreationalPatternsPage({super.key, this.title = "Creational Patterns"});

  final String title;

  final patterns = const [
    "singleton",
    "prototype",
    "builder",
    "factory-method",
    "abstract-factory",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: ListView(
        children: [
          for (final pattern in patterns)
            Card(
              child: ListTile(
                title: Text(pattern),
                onTap: () => context.push("/creational/$pattern"),
              ),
            ),
        ],
      ),
    );
  }
}
