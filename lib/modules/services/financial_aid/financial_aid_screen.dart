import 'package:flutter/material.dart';

class FinancialAidScreen extends StatelessWidget {
  const FinancialAidScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Financial Aid')),
      body: const Center(child: Text('Financial Aid Options')),
    );
  }
}
