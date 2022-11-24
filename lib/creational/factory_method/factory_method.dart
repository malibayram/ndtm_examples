import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

abstract class CustomDialog {
  String getTitle();
  Widget create(BuildContext context);

  Future<void> show(BuildContext context) async {
    final dialog = create(context);

    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) {
        return dialog;
      },
    );
  }
}

class AndroidAlertDialog extends CustomDialog {
  @override
  String getTitle() {
    return 'Android Alert Dialog';
  }

  @override
  Widget create(BuildContext context) {
    return AlertDialog(
      title: Text(getTitle()),
      content: const Text('This is the material-style alert dialog!'),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}

class IosAlertDialog extends CustomDialog {
  @override
  String getTitle() {
    return 'iOS Alert Dialog';
  }

  @override
  Widget create(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text(getTitle()),
      content: const Text('This is the cupertino-style alert dialog!'),
      actions: <Widget>[
        CupertinoButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text('Close'),
        ),
      ],
    );
  }
}
