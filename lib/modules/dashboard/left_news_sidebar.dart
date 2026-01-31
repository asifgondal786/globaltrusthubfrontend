import 'package:flutter/material.dart';
import 'package:global_trust_hub/core/constants/typography.dart';

class LeftNewsSidebar extends StatelessWidget {
  const LeftNewsSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.grey.shade100,
      padding: const EdgeInsets.all(16),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Latest Updates', style: AppTypography.h6),
          SizedBox(height: 16),
          Text('• Visa policy changes affecting students...'),
          SizedBox(height: 8),
          Text('• New scholarships available for 2026...'),
        ],
      ),
    );
  }
}
