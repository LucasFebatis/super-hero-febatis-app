import 'package:flutter/material.dart';

class ErrorDialog extends StatelessWidget {
  const ErrorDialog({Key? key, this.error, required this.listener}) : super(key: key);

  final Function listener;
  final Object? error;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('AlertDialog Title'),
      content: SingleChildScrollView(
        child: ListBody(
          children: const <Widget>[
            Text('Ops! Houve um erro'),
            Text("Tente novamente mais tarde"),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('Tentar novamente'),
          onPressed: () {
            Navigator.of(context).pop();
            listener();
          },
        ),
      ],
    );
  }
}
