import 'package:flutter/material.dart';

class PanicButton extends StatelessWidget {
  const PanicButton({super.key});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.red,
      onPressed: () {
        // Trigger emergency protocol
      },
      child: const Icon(Icons.emergency),
    );
  }
}
