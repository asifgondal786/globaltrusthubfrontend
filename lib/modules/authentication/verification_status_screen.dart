import 'package:flutter/material.dart';
import 'package:global_trust_hub/core/constants/typography.dart';
import 'package:global_trust_hub/shared_widgets/trust_badge.dart';

class VerificationStatusScreen extends StatelessWidget {
  const VerificationStatusScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Verification Status')),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.check_circle_outline, size: 80, color: Colors.green),
            SizedBox(height: 24),
            Text('Verification Pending', style: AppTypography.h5),
            SizedBox(height: 16),
            TrustBadge(score: 650, isLarge: true),
            SizedBox(height: 24),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 48.0),
              child: Text(
                'Your documents are being reviewed. Expected completion: 24-48 hours.',
                textAlign: TextAlign.center,
                style: AppTypography.body1,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
