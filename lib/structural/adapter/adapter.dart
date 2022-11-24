import 'dart:convert';

import 'package:xml/xml.dart';

class Contact {
  final String fullName;
  final String email;
  final bool favourite;

  const Contact({
    required this.fullName,
    required this.email,
    required this.favourite,
  });
}

class JsonContactsApi {
  final _contactsJson = '''
  {
    "contacts": [
      {
        "fullName": "John Doe (JSON)",
        "email": "johndoe@json.com",
        "favourite": true
      },
      {
        "fullName": "Emma Doe (JSON)",
        "email": "emmadoe@json.com",
        "favourite": false
      },
      {
        "fullName": "Michael Roe (JSON)",
        "email": "michaelroe@json.com",
        "favourite": false
      }
    ]
  }
  ''';

  String getContactsJson() {
    return _contactsJson;
  }
}

class XmlContactsApi {
  final _contactsXml = '''
  <?xml version="1.0"?>
  <contacts>
    <contact>
      <fullname>John Doe (XML)</fullname>
      <email>johndoe@xml.com</email>
      <favourite>false</favourite>
    </contact>
    <contact>
      <fullname>Emma Doe (XML)</fullname>
      <email>emmadoe@xml.com</email>
      <favourite>true</favourite>
    </contact>
    <contact>
      <fullname>Michael Roe (XML)</fullname>
      <email>michaelroe@xml.com</email>
      <favourite>true</favourite>
    </contact>
  </contacts>
  ''';

  String getContactsXml() {
    return _contactsXml;
  }
}

abstract class IContactsAdapter {
  List<Contact> getContacts();
}

class JsonContactsAdapter implements IContactsAdapter {
  final JsonContactsApi _api = JsonContactsApi();

  @override
  List<Contact> getContacts() {
    final contactsJson = _api.getContactsJson();
    final contactsList = _parseContactsJson(contactsJson);

    return contactsList;
  }

  List<Contact> _parseContactsJson(String contactsJson) {
    final contactsMap = json.decode(contactsJson) as Map<String, dynamic>;
    final contactsJsonList = contactsMap['contacts'] as List;
    final contactsList = contactsJsonList.map((json) {
      final contactJson = json as Map<String, dynamic>;

      return Contact(
        fullName: contactJson['fullName'] as String,
        email: contactJson['email'] as String,
        favourite: contactJson['favourite'] as bool,
      );
    }).toList();

    return contactsList;
  }
}

class XmlContactsAdapter implements IContactsAdapter {
  final XmlContactsApi _api = XmlContactsApi();

  @override
  List<Contact> getContacts() {
    final contactsXml = _api.getContactsXml();
    final contactsList = _parseContactsXml(contactsXml);

    return contactsList;
  }

  List<Contact> _parseContactsXml(String contactsXml) {
    final xmlDocument = XmlDocument.parse(contactsXml);
    final contactsList = <Contact>[];

    for (final xmlElement in xmlDocument.findAllElements('contact')) {
      final fullName = xmlElement.findElements('fullname').single.text;
      final email = xmlElement.findElements('email').single.text;
      final favouriteString = xmlElement.findElements('favourite').single.text;
      final favourite = favouriteString.toLowerCase() == 'true';

      contactsList.add(
        Contact(
          fullName: fullName,
          email: email,
          favourite: favourite,
        ),
      );
    }

    return contactsList;
  }
}
