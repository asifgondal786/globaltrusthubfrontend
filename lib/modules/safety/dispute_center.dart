import 'package:flutter/material.dart';

class DisputeCenter extends StatelessWidget {
  const DisputeCenter({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dispute Center')),
      body: const Center(child: Text('Dispute Resolution')),
    );
  }
}
