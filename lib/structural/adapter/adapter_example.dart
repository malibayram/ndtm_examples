import 'package:flutter/material.dart';

import 'adapter.dart';

class AdapterExample extends StatelessWidget {
  const AdapterExample({super.key});

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
              ContactsSection(
                adapter: JsonContactsAdapter(),
                headerText: 'Contacts from JSON API:',
              ),
              const SizedBox(height: 32.0),
              ContactsSection(
                adapter: XmlContactsAdapter(),
                headerText: 'Contacts from XML API:',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ContactsSection extends StatefulWidget {
  final IContactsAdapter adapter;
  final String headerText;

  const ContactsSection({
    super.key,
    required this.adapter,
    required this.headerText,
  });

  @override
  State createState() => _ContactsSectionState();
}

class _ContactsSectionState extends State<ContactsSection> {
  final List<Contact> contacts = [];

  void _getContacts() {
    contacts.addAll(widget.adapter.getContacts());

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.headerText),
        const SizedBox(height: 32.0),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _ContactsSectionContent(
            contacts: contacts,
            onPressed: _getContacts,
          ),
        ),
      ],
    );
  }
}

class _ContactsSectionContent extends StatelessWidget {
  final List<Contact> contacts;
  final VoidCallback onPressed;

  const _ContactsSectionContent({
    required this.contacts,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return contacts.isEmpty
        ? TextButton(
            onPressed: onPressed,
            child: const Text('Get contacts'),
          )
        : Column(
            children: <Widget>[
              for (var contact in contacts)
                Card(
                  child: ListTile(
                    title: Text(contact.fullName),
                    subtitle: Text(contact.email),
                    trailing: Icon(
                      contact.favourite ? Icons.star : Icons.star_border,
                    ),
                  ),
                ),
            ],
          );
  }
}
