import 'package:flutter/material.dart';
import 'package:global_trust_hub/core/constants/colors.dart';
import 'package:global_trust_hub/core/constants/typography.dart';
import 'package:global_trust_hub/shared_widgets/custom_button.dart';

class ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorView({
    super.key,
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 60, color: AppColors.error),
            const SizedBox(height: 16),
            const Text(
              'Oops!',
              style: AppTypography.h6,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTypography.body1.copyWith(color: AppColors.textSecondary),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            CustomButton(text: 'Retry', onPressed: onRetry),
          ],
        ),
      ),
    );
  }
}
