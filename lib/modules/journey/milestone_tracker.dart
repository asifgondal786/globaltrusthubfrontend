import 'package:flutter/material.dart';
import 'package:global_trust_hub/core/constants/colors.dart';
import 'package:global_trust_hub/core/constants/typography.dart';

class MilestoneTracker extends StatelessWidget {
  final String title;
  final bool isCompleted;
  final bool isActive;
  final String date;

  const MilestoneTracker({
    super.key,
    required this.title,
    this.isCompleted = false,
    this.isActive = false,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? Colors.green
                    : isActive
                        ? AppColors.primary
                        : Colors.grey.shade300,
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),
            Container(
              width: 2,
              height: 50,
              color: Colors.grey.shade300,
            ),
          ],
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: isActive
                    ? AppTypography.subtitle1.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)
                    : isCompleted
                        ? AppTypography.subtitle1.copyWith(color: Colors.black87)
                        : AppTypography.subtitle1.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                date,
                style: AppTypography.caption,
              ),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ],
    );
  }
}
