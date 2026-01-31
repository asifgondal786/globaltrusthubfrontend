import 'package:flutter/material.dart';

class HousingListScreen extends StatelessWidget {
  const HousingListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Housing')),
      body: const Center(child: Text('Housing Listings')),
    );
  }
}
