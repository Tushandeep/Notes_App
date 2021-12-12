import 'package:flutter/material.dart';

class NoteDelete extends StatelessWidget {
  const NoteDelete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Delete'),
      content: const Text('Are you sure?'),
      actions: [
        ElevatedButton(
          child: const Text('No'),
          onPressed: () {
            Navigator.pop(context, false);
          },
        ),
        ElevatedButton(
          child: const Text('Yes'),
          onPressed: () {
            Navigator.pop(context, true);
          },
        ),
      ],
    );
  }
}
