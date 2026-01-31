import 'package:flutter/material.dart';
import 'package:global_trust_hub/shared_widgets/trust_badge.dart';
import 'package:global_trust_hub/core/constants/typography.dart';

class RightTrustSidebar extends StatelessWidget {
  const RightTrustSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      padding: const EdgeInsets.all(16),
      child: const Column(
        children: [
          Text('Your Trust Status', style: AppTypography.h6),
          SizedBox(height: 16),
          TrustBadge(score: 750, isLarge: true),
          SizedBox(height: 16),
          LinearProgressIndicator(value: 0.75),
          Text('75% to next level', style: AppTypography.caption),
        ],
      ),
    );
  }
}
