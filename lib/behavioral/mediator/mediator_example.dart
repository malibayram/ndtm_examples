import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

import 'mediator.dart';

class MediatorExample extends StatefulWidget {
  const MediatorExample({super.key});

  @override
  State createState() => _MediatorExampleState();
}

class _MediatorExampleState extends State<MediatorExample> {
  late final NotificationHub _notificationHub;
  final _admin = Admin(name: 'God');

  @override
  void initState() {
    super.initState();

    final members = [
      _admin,
      Developer(name: 'Sea Sharp'),
      Developer(name: 'Jan Assembler'),
      Developer(name: 'Dove Dart'),
      Tester(name: 'Cori Debugger'),
      Tester(name: 'Tania Mocha'),
    ];
    _notificationHub = TeamNotificationHub(members: members);
  }

  void _sendToAll() {
    setState(() {
      _admin.send('Hello');
    });
  }

  void _sendToQa() {
    setState(() {
      _admin.sendTo<Tester>('BUG!');
    });
  }

  void _sendToDevelopers() {
    setState(() {
      _admin.sendTo<Developer>('Hello, World!');
    });
  }

  void _addTeamMember() {
    final name = '${faker.person.firstName()} ${faker.person.lastName()}';
    final teamMember = faker.randomGenerator.boolean()
        ? Tester(name: name)
        : Developer(name: name);

    setState(() {
      _notificationHub.register(teamMember);
    });
  }

  void _sendFromMember(TeamMember member) {
    setState(() {
      member.send('Hello from ${member.name}');
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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              TextButton(
                onPressed: _sendToAll,
                child: const Text("Admin: Send 'Hello' to all"),
              ),
              TextButton(
                onPressed: _sendToQa,
                child: const Text("Admin: Send 'BUG!' to QA"),
              ),
              TextButton(
                onPressed: _sendToDevelopers,
                child: const Text("Admin: Send 'Hello, World!' to Developers"),
              ),
              const Divider(),
              TextButton(
                onPressed: _addTeamMember,
                child: const Text("Add team member"),
              ),
              const SizedBox(height: 32.0),
              Column(
                children: [
                  for (final member in _notificationHub.getTeamMembers())
                    ListTile(
                      title: Text(member.name),
                      subtitle: Text(member.lastNotification ?? ''),
                      onTap: () => _sendFromMember(member),
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
