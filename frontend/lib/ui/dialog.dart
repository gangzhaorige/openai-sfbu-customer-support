import 'package:flutter/material.dart';

class MyEmail extends StatelessWidget {
  const MyEmail({super.key, required this.email});

  final String email;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: AlertDialog(
        title: const Text('Generated Email'),
        content: SizedBox(
          width: 800,
          child: Text(
            email
          ),
        ),
        actions: <Widget>[
          TextButton(
            style: TextButton.styleFrom(
              textStyle: Theme.of(context).textTheme.labelLarge,
            ),
            child: const Text('OK'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }
}