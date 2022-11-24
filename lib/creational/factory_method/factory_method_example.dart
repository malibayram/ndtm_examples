import 'package:flutter/material.dart';

import 'factory_method.dart';

class FactoryMethodExample extends StatefulWidget {
  const FactoryMethodExample({super.key});

  @override
  State createState() => _FactoryMethodExampleState();
}

class _FactoryMethodExampleState extends State<FactoryMethodExample> {
  final customDialogList = [AndroidAlertDialog(), IosAlertDialog()];

  int _selectedDialogIndex = 0;

  Future<void> _showCustomDialog(BuildContext context) async {
    final selectedDialog = customDialogList[_selectedDialogIndex];

    await selectedDialog.show(context);
  }

  void _setSelectedDialogIndex(int? index) {
    _selectedDialogIndex = index!;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScrollConfiguration(
        behavior: const ScrollBehavior(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32.0),
          child: Column(
            children: <Widget>[
              DialogSelection(
                customDialogList: customDialogList,
                selectedIndex: _selectedDialogIndex,
                onChanged: _setSelectedDialogIndex,
              ),
              // Dialog selection section

              const SizedBox(height: 32.0),
              TextButton(
                onPressed: () => _showCustomDialog(context),
                child: const Text('Show Dialog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class DialogSelection extends StatelessWidget {
  const DialogSelection({
    super.key,
    required this.customDialogList,
    required this.selectedIndex,
    required this.onChanged,
  });

  final List<CustomDialog> customDialogList;
  final int selectedIndex;
  final ValueChanged<int?> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        const Text('Select a dialog to show:'),
        const SizedBox(height: 16.0),
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            for (var i = 0; i < customDialogList.length; i++)
              RadioListTile<int>(
                title: Text(customDialogList[i].getTitle()),
                value: i,
                groupValue: selectedIndex,
                onChanged: onChanged,
              ),
          ],
        ),
      ],
    );
  }
}
