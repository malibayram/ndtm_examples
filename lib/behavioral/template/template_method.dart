import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:xml/xml.dart';

abstract class StudentsBmiCalculator {
  // Template method
  List<Student> calculateBmiAndReturnStudentList() {
    var studentList = getStudentsData();
    studentList = doStudentsFiltering(studentList);
    _calculateStudentsBmi(studentList);
    return studentList;
  }

  void _calculateStudentsBmi(List<Student> studentList) {
    for (final student in studentList) {
      student.bmi = _calculateBmi(student.height, student.weight);
    }
  }

  double _calculateBmi(double height, int weight) {
    return weight / math.pow(height, 2);
  }

  // Hook methods
  @protected
  List<Student> doStudentsFiltering(List<Student> studentList) {
    return studentList;
  }

  // Abstract methods
  @protected
  List<Student> getStudentsData();
}

class StudentsXmlBmiCalculator extends StudentsBmiCalculator {
  final XmlStudentsApi _api = XmlStudentsApi();

  @override
  @protected
  List<Student> getStudentsData() {
    final studentsXml = _api.getStudentsXml();
    final xmlDocument = XmlDocument.parse(studentsXml);
    final studentsList = <Student>[];

    for (final xmlElement in xmlDocument.findAllElements('student')) {
      final fullName = xmlElement.findElements('fullname').single.text;
      final age = int.parse(xmlElement.findElements('age').single.text);
      final height =
          double.parse(xmlElement.findElements('height').single.text);
      final weight = int.parse(xmlElement.findElements('weight').single.text);

      studentsList.add(
        Student(
          fullName: fullName,
          age: age,
          height: height,
          weight: weight,
        ),
      );
    }

    return studentsList;
  }
}

class StudentsJsonBmiCalculator extends StudentsBmiCalculator {
  final JsonStudentsApi _api = JsonStudentsApi();

  @override
  @protected
  List<Student> getStudentsData() {
    final studentsJson = _api.getStudentsJson();
    final studentsMap = json.decode(studentsJson) as Map<String, dynamic>;
    final studentsJsonList = studentsMap['students'] as List;
    final studentsList = studentsJsonList.map((json) {
      final studentJson = json as Map<String, dynamic>;

      return Student(
        fullName: studentJson['fullName'] as String,
        age: studentJson['age'] as int,
        height: studentJson['height'] as double,
        weight: studentJson['weight'] as int,
      );
    }).toList();

    return studentsList;
  }
}

class TeenageStudentsJsonBmiCalculator extends StudentsBmiCalculator {
  final JsonStudentsApi _api = JsonStudentsApi();

  @override
  @protected
  List<Student> getStudentsData() {
    final studentsJson = _api.getStudentsJson();
    final studentsMap = json.decode(studentsJson) as Map<String, dynamic>;
    final studentsJsonList = studentsMap['students'] as List;
    final studentsList = studentsJsonList.map((json) {
      final studentJson = json as Map<String, dynamic>;

      return Student(
        fullName: studentJson['fullName'] as String,
        age: studentJson['age'] as int,
        height: studentJson['height'] as double,
        weight: studentJson['weight'] as int,
      );
    }).toList();

    return studentsList;
  }

  @override
  @protected
  List<Student> doStudentsFiltering(List<Student> studentList) {
    return studentList
        .where((student) => student.age > 12 && student.age < 20)
        .toList();
  }
}

class Student {
  final String fullName;
  final int age;
  final double height;
  final int weight;
  late final double bmi;

  Student({
    required this.fullName,
    required this.age,
    required this.height,
    required this.weight,
  });
}

class JsonStudentsApi {
  final String _studentsJson = '''
  {
    "students": [
      {
        "fullName": "John Doe (JSON)",
        "age": 12,
        "height": 1.62,
        "weight": 53
      },
      {
        "fullName": "Emma Doe (JSON)",
        "age": 15,
        "height": 1.55,
        "weight": 50
      },
      {
        "fullName": "Michael Roe (JSON)",
        "age": 18,
        "height": 1.85,
        "weight": 89
      },
      {
        "fullName": "Emma Roe (JSON)",
        "age": 20,
        "height": 1.66,
        "weight": 79
      }
    ]
  }
  ''';

  String getStudentsJson() {
    return _studentsJson;
  }
}

class XmlStudentsApi {
  final String _studentsXml = '''
  <?xml version="1.0"?>
  <students>
    <student>
      <fullname>John Doe (XML)</fullname>
      <age>12</age>
      <height>1.62</height>
      <weight>53</weight>
    </student>
    <student>
      <fullname>Emma Doe (XML)</fullname>
      <age>15</age>
      <height>1.55</height>
      <weight>50</weight>
    </student>
    <student>
      <fullname>Michael Roe (XML)</fullname>
      <age>18</age>
      <height>1.85</height>
      <weight>89</weight>
    </student>
    <student>
      <fullname>Emma Roe (XML)</fullname>
      <age>20</age>
      <height>1.66</height>
      <weight>79</weight>
    </student>
  </students>
  ''';

  String getStudentsXml() {
    return _studentsXml;
  }
}
