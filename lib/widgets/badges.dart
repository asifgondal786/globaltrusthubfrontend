import 'package:flutter/material.dart';
import 'package:global_trust_hub/core/theme/app_colors.dart';
import 'package:global_trust_hub/core/theme/app_typography.dart';
import 'package:global_trust_hub/models/enums.dart';

/// Verification status badge
class VerificationBadge extends StatelessWidget {
  final VerificationStatus status;
  final bool showLabel;

  const VerificationBadge({
    super.key,
    required this.status,
    this.showLabel = true,
  });

  Color get statusColor {
    switch (status) {
      case VerificationStatus.verified:
        return AppColors.verified;
      case VerificationStatus.pending:
        return AppColors.pending;
      case VerificationStatus.rejected:
        return AppColors.rejected;
      case VerificationStatus.expired:
        return AppColors.textMuted;
    }
  }

  IconData get statusIcon {
    switch (status) {
      case VerificationStatus.verified:
        return Icons.check_circle_rounded;
      case VerificationStatus.pending:
        return Icons.schedule_rounded;
      case VerificationStatus.rejected:
        return Icons.cancel_rounded;
      case VerificationStatus.expired:
        return Icons.timer_off_rounded;
    }
  }

  String get statusLabel {
    switch (status) {
      case VerificationStatus.verified:
        return 'Verified';
      case VerificationStatus.pending:
        return 'Pending';
      case VerificationStatus.rejected:
        return 'Rejected';
      case VerificationStatus.expired:
        return 'Expired';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: showLabel ? 10 : 6,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: statusColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            statusIcon,
            size: 16,
            color: statusColor,
          ),
          if (showLabel) ...[
            const SizedBox(width: 4),
            Text(
              statusLabel,
              style: AppTypography.labelSmall.copyWith(
                color: statusColor,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// Role badge showing user type
class RoleBadge extends StatelessWidget {
  final UserRole role;

  const RoleBadge({super.key, required this.role});

  Color get roleColor {
    switch (role) {
      case UserRole.student:
        return AppColors.roleStudent;
      case UserRole.agent:
        return AppColors.roleAgent;
      case UserRole.institution:
        return AppColors.roleInstitution;
      case UserRole.provider:
        return AppColors.roleProvider;
    }
  }

  IconData get roleIcon {
    switch (role) {
      case UserRole.student:
        return Icons.school_rounded;
      case UserRole.agent:
        return Icons.support_agent_rounded;
      case UserRole.institution:
        return Icons.account_balance_rounded;
      case UserRole.provider:
        return Icons.business_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: roleColor.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: roleColor.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(roleIcon, size: 16, color: roleColor),
          const SizedBox(width: 6),
          Text(
            role.displayName,
            style: AppTypography.labelSmall.copyWith(
              color: roleColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

/// Document type chip
class DocumentTypeChip extends StatelessWidget {
  final DocumentType type;
  final VerificationStatus status;
  final VoidCallback? onTap;

  const DocumentTypeChip({
    super.key,
    required this.type,
    required this.status,
    this.onTap,
  });

  String get typeLabel {
    switch (type) {
      case DocumentType.cnic:
        return 'CNIC';
      case DocumentType.passport:
        return 'Passport';
      case DocumentType.drivingLicense:
        return 'Driving License';
      case DocumentType.domicile:
        return 'Domicile';
      case DocumentType.businessLicense:
        return 'Business License';
      case DocumentType.address:
        return 'Address Proof';
      case DocumentType.criminalRecord:
        return 'Criminal Record';
    }
  }

  IconData get typeIcon {
    switch (type) {
      case DocumentType.cnic:
        return Icons.badge_rounded;
      case DocumentType.passport:
        return Icons.flight_takeoff_rounded;
      case DocumentType.drivingLicense:
        return Icons.directions_car_rounded;
      case DocumentType.domicile:
        return Icons.home_rounded;
      case DocumentType.businessLicense:
        return Icons.business_center_rounded;
      case DocumentType.address:
        return Icons.location_on_rounded;
      case DocumentType.criminalRecord:
        return Icons.gavel_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.divider),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(typeIcon, size: 20, color: AppColors.textSecondary),
            const SizedBox(width: 8),
            Text(
              typeLabel,
              style: AppTypography.labelMedium,
            ),
            const SizedBox(width: 8),
            VerificationBadge(status: status, showLabel: false),
          ],
        ),
      ),
    );
  }
}
