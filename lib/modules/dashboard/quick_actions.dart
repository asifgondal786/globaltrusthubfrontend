import 'package:flutter/material.dart';
import 'package:global_trust_hub/shared_widgets/custom_button.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CustomButton(text: 'Scan Document', onPressed: () {}, isOutlined: true),
        const SizedBox(height: 8),
        CustomButton(text: 'Verify Identity', onPressed: () {}),
      ],
    );
  }
}
