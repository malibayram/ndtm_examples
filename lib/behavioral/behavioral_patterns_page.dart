import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class BehavioralPatternsPage extends StatelessWidget {
  const BehavioralPatternsPage({super.key, this.title = "Behavioral Patterns"});

  final String title;

  final patterns = const [
    "chain-of-responsibility",
    "command",
    "iterator",
    "memento",
    "observer",
    "strategy",
    "state",
    "template-method",
    "visitor",
    "mediator",
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
                onTap: () => context.push("/behavioral/$pattern"),
              ),
            ),
        ],
      ),
    );
  }
}
