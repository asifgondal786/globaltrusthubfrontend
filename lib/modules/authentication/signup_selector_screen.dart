import 'package:flutter/material.dart';
import 'package:global_trust_hub/core/constants/typography.dart';
import 'package:global_trust_hub/shared_widgets/custom_button.dart';

class SignupSelectorScreen extends StatelessWidget {
  const SignupSelectorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Join GlobalTrustHub')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text('I am a...', style: AppTypography.h5),
            const SizedBox(height: 24),
            CustomButton(text: 'Student', onPressed: () {}),
            const SizedBox(height: 16),
            CustomButton(text: 'University/Institution', onPressed: () {}),
            const SizedBox(height: 16),
            CustomButton(text: 'Service Provider', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
