import 'package:flutter/material.dart';

class CustomDialog extends StatelessWidget {
  final String title;
  final String content;
  final VoidCallback callback;
  final String actionText;

  CustomDialog(this.title, this.content, this.callback,
      [this.actionText = "Reset"]);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
      content: Text(content),
      actions: <Widget>[
        TextButton(
          onPressed: () {
            callback(); // Call the callback function
            Navigator.pop(context); // Close the dialog after action
          },
          child: Text(actionText, style: TextStyle(color: Colors.blue)),
        ),
      ],
    );
  }
}
