import 'package:flutter/material.dart';

import 'template_method.dart';

class TemplateMethodExample extends StatelessWidget {
  const TemplateMethodExample({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              StudentsSection(
                bmiCalculator: StudentsXmlBmiCalculator(),
                headerText: 'Students from XML data source:',
              ),
              const SizedBox(height: 32.0),
              StudentsSection(
                bmiCalculator: StudentsJsonBmiCalculator(),
                headerText: 'Students from JSON data source:',
              ),
              const SizedBox(height: 32.0),
              StudentsSection(
                bmiCalculator: TeenageStudentsJsonBmiCalculator(),
                headerText: 'Students from JSON data source (teenagers only):',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StudentsSection extends StatefulWidget {
  final StudentsBmiCalculator bmiCalculator;
  final String headerText;

  const StudentsSection({
    super.key,
    required this.bmiCalculator,
    required this.headerText,
  });

  @override
  State createState() => _StudentsSectionState();
}

class _StudentsSectionState extends State<StudentsSection> {
  final List<Student> students = [];

  void _calculateBmiAndGetStudentsData() {
    setState(() {
      students.addAll(widget.bmiCalculator.calculateBmiAndReturnStudentList());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(widget.headerText),
        const SizedBox(height: 24.0),
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 500),
          child: _StudentsSectionContent(
            students: students,
            onPressed: _calculateBmiAndGetStudentsData,
          ),
        ),
      ],
    );
  }
}

class _StudentsSectionContent extends StatelessWidget {
  final List<Student> students;
  final VoidCallback onPressed;

  const _StudentsSectionContent({
    required this.students,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return students.isEmpty
        ? TextButton(
            onPressed: onPressed,
            child: const Text("Calculate BMI and get students' data"),
          )
        : Column(
            children: [
              for (final student in students)
                ListTile(
                  title: Text(
                    '${student.fullName} (${student.age} years old) has a BMI of ${student.bmi.toStringAsFixed(2)}',
                  ),
                  subtitle: Text(
                    'Height: ${student.height} cm, weight: ${student.weight} kg',
                  ),
                ),
            ],
          );
  }
}
