import 'package:flutter/material.dart';
import 'package:global_trust_hub/core/theme/app_colors.dart';
import 'package:global_trust_hub/core/theme/app_typography.dart';
import 'package:global_trust_hub/models/journey.dart';

/// Journey progress timeline widget (Horizontal Stepper)
class JourneyProgressWidget extends StatelessWidget {
  final Journey journey;
  final Function(JourneyMilestone)? onMilestoneTap;

  const JourneyProgressWidget({
    super.key,
    required this.journey,
    this.onMilestoneTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Stepper Row
        LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: journey.milestones.asMap().entries.map((entry) {
                final index = entry.key;
                final milestone = entry.value;
                final isLast = index == journey.milestones.length - 1;
                
                // Determine styling based on status
                final isCompleted = milestone.isComplete;
                final isCurrent = milestone.isInProgress;
                final isPending = !isCompleted && !isCurrent;
                
                // Color logic: Completed/Current = Blue/Accent, Pending = Grey/Red if specified
                // Using primary color for active states
                final color = (isCompleted || isCurrent) ? AppColors.primary : AppColors.divider;
                
                return Expanded(
                  child: Column(
                    children: [
                      // Icon + Line Row
                      Row(
                        children: [
                          // Left Line (except first item)
                          Expanded(
                            child: index == 0 
                                ? const SizedBox.shrink() 
                                : Container(
                                    height: 4,
                                    color: isCompleted || isCurrent ? AppColors.primary : AppColors.divider,
                                  ),
                          ),
                          // Circle Icon
                          Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isCompleted || isCurrent ? AppColors.primary : Colors.white,
                              border: Border.all(
                                color: isCompleted || isCurrent ? AppColors.primary : AppColors.divider,
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.check,
                              size: 18,
                              color: isCompleted || isCurrent ? Colors.white : Colors.transparent,
                            ),
                          ),
                          // Right Line (except last item)
                          Expanded(
                            child: isLast 
                                ? const SizedBox.shrink() 
                                : Container(
                                    height: 4,
                                    // If this step is completed, the line to next should be colored? 
                                    // Usually strictly previous -> current is colored.
                                    // We'll color it if *next* is also completed/current, OR if *this* is completed.
                                    // Let's stick to: line is colored if *this* step is completed.
                                    color: isCompleted ? AppColors.primary : AppColors.divider,
                                  ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      // Label
                      Text(
                        milestone.title,
                        textAlign: TextAlign.center,
                        style: AppTypography.labelMedium.copyWith(
                          color: (isCompleted || isCurrent)
                              ? (Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textPrimary)
                              : (Theme.of(context).brightness == Brightness.dark ? Colors.grey[400] : AppColors.textSecondary),
                          fontWeight: (isCompleted || isCurrent) ? FontWeight.bold : FontWeight.normal,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }
}

/// Compact journey card for dashboard
class JourneyCard extends StatelessWidget {
  final Journey journey;
  final VoidCallback? onTap;

  const JourneyCard({
    super.key,
    required this.journey,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.flight_takeoff_rounded,
                      color: AppColors.accent,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(journey.title, style: AppTypography.h6),
                        if (journey.targetCountry != null)
                          Text(
                            journey.targetCountry!,
                            style: AppTypography.bodySmall,
                          ),
                      ],
                    ),
                  ),
                  Text(
                    '${journey.progressPercentage.toInt()}%',
                    style: AppTypography.h4.copyWith(color: AppColors.accent),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: journey.progressPercentage / 100,
                  backgroundColor: AppColors.divider,
                  valueColor: const AlwaysStoppedAnimation(AppColors.accent),
                  minHeight: 6,
                ),
              ),
              if (journey.currentMilestone != null) ...[
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.location_on_rounded,
                        size: 14,
                        color: AppColors.accent,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        journey.currentMilestone!.title,
                        style: AppTypography.labelSmall.copyWith(
                          color: AppColors.accent,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
