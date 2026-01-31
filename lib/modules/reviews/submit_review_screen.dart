import 'package:flutter/material.dart';
import 'package:global_trust_hub/shared_widgets/custom_button.dart';
import 'package:global_trust_hub/shared_widgets/custom_input.dart';

class SubmitReviewScreen extends StatelessWidget {
  const SubmitReviewScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Write a Review')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            CustomInput(hintText: 'Title', controller: TextEditingController()),
            const SizedBox(height: 16),
            CustomInput(
              hintText: 'Your Review',
              controller: TextEditingController(),
            ),
            const SizedBox(height: 24),
            CustomButton(text: 'Submit', onPressed: () {}),
          ],
        ),
      ),
    );
  }
}
