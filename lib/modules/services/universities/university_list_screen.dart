import 'package:flutter/material.dart';

class UniversityListScreen extends StatelessWidget {
  const UniversityListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Universities')),
      body: const Center(child: Text('University Listings')),
    );
  }
}
