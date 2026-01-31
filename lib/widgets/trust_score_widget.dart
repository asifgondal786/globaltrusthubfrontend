import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'package:global_trust_hub/core/theme/app_colors.dart';
import 'package:global_trust_hub/core/theme/app_typography.dart';
import 'package:global_trust_hub/models/enums.dart';

/// Trust score display widget with animated circular progress
class TrustScoreWidget extends StatelessWidget {
  final double score;
  final double size;
  final bool showLabel;
  final bool showBreakdown;

  const TrustScoreWidget({
    super.key,
    required this.score,
    this.size = 120,
    this.showLabel = true,
    this.showBreakdown = false,
  });

  Color get scoreColor {
    if (score >= 80) return AppColors.trustHigh;
    if (score >= 60) return AppColors.trustMedium;
    if (score >= 30) return const Color(0xFFED8936);
    return AppColors.trustLow;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: size,
          height: size,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Background circle
              SizedBox(
                width: size,
                height: size,
                child: const CircularProgressIndicator(
                  value: 1,
                  strokeWidth: 8,
                  backgroundColor: AppColors.divider,
                  valueColor: AlwaysStoppedAnimation(AppColors.divider),
                ),
              ),
              // Score progress
              SizedBox(
                width: size,
                height: size,
                child: TweenAnimationBuilder<double>(
                  tween: Tween(begin: 0, end: score / 100),
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, child) {
                    return CustomPaint(
                      painter: _TrustScorePainter(
                        progress: value,
                        color: scoreColor,
                        strokeWidth: 8,
                      ),
                    );
                  },
                ),
              ),
              // Center content
              Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TweenAnimationBuilder<double>(
                    tween: Tween(begin: 0, end: score),
                    duration: const Duration(milliseconds: 1000),
                    curve: Curves.easeOutCubic,
                    builder: (context, value, child) {
                      return Text(
                        value.toInt().toString(),
                        style: AppTypography.trustScore.copyWith(
                          fontSize: size * 0.3,
                          color: scoreColor,
                        ),
                      );
                    },
                  ),
                  if (showLabel)
                    Text(
                      TrustLevelExtension.fromScore(score).displayName,
                      style: AppTypography.labelSmall.copyWith(
                        color: scoreColor,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TrustScorePainter extends CustomPainter {
  final double progress;
  final Color color;
  final double strokeWidth;

  _TrustScorePainter({
    required this.progress,
    required this.color,
    required this.strokeWidth,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width - strokeWidth) / 2;
    
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = 2 * math.pi * progress;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _TrustScorePainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

/// Compact trust score badge for lists and cards
class TrustScoreBadge extends StatelessWidget {
  final double score;
  final bool showValue;

  const TrustScoreBadge({
    super.key,
    required this.score,
    this.showValue = true,
  });

  Color get scoreColor {
    if (score >= 80) return AppColors.trustHigh;
    if (score >= 60) return AppColors.trustMedium;
    if (score >= 30) return const Color(0xFFED8936);
    return AppColors.trustLow;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: scoreColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: scoreColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            Icons.verified_rounded,
            size: 14,
            color: scoreColor,
          ),
          if (showValue) ...[
            const SizedBox(width: 4),
            Text(
              score.toInt().toString(),
              style: AppTypography.labelSmall.copyWith(
                color: scoreColor,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
