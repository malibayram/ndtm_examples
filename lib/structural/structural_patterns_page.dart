import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StructuralPatternsPage extends StatelessWidget {
  const StructuralPatternsPage({super.key, this.title = "Structural Patterns"});

  final String title;

  final patterns = const [
    "proxy",
    "flyweight",
    "facade",
    "decorator",
    "composite",
    "bridge",
    "adapter",
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
                onTap: () => context.push("/structural/$pattern"),
              ),
            ),
        ],
      ),
    );
  }
}
