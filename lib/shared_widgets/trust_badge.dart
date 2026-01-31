import 'package:flutter/material.dart';
import 'package:global_trust_hub/core/constants/typography.dart';

class TrustBadge extends StatelessWidget {
  final int score;
  final bool isLarge;

  const TrustBadge({
    super.key,
    required this.score,
    this.isLarge = false,
  });

  Color _getScoreColor() {
    if (score >= 800) return Colors.green;
    if (score >= 600) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isLarge ? 16 : 8,
        vertical: isLarge ? 8 : 4,
      ),
      decoration: BoxDecoration(
        color: _getScoreColor().withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _getScoreColor()),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.shield_outlined,
            color: _getScoreColor(),
            size: isLarge ? 24 : 16,
          ),
          const SizedBox(width: 4),
          Text(
            score.toString(),
            style: isLarge
                ? AppTypography.h6.copyWith(color: _getScoreColor())
                : AppTypography.subtitle2.copyWith(color: _getScoreColor()),
          ),
        ],
      ),
    );
  }
}
