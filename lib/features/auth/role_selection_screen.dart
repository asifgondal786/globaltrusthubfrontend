import 'package:flutter/material.dart';
import 'package:global_trust_hub/core/theme/app_colors.dart';
import 'package:global_trust_hub/core/theme/app_typography.dart';
import 'package:global_trust_hub/models/models.dart';
import 'package:global_trust_hub/widgets/widgets.dart';
import 'package:go_router/go_router.dart';

/// Role selection screen - Premium Design matching HomeScreen layout
class RoleSelectionScreen extends StatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  State<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends State<RoleSelectionScreen> {
  // Mock journey for demonstration
  final Journey _mockJourney = JourneyTemplates.studyAbroadTemplate('Canada');

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: const Color(0xFFE8EDF4),
      body: Stack(
        children: [
          Column(
            children: [
              // 1. Premium Header
              _buildHeader(isDesktop),

              // 2. Main Content Area (3-Column Layout)
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    left: 24,
                    right: 24,
                    top: 24,
                    bottom: isDesktop ? 80 : 24,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Sidebar - News
                      if (screenWidth > 1050)
                        SizedBox(
                          width: 220,
                          child: _buildNewsSidebar(),
                        ),

                      if (screenWidth > 1050) const SizedBox(width: 24),

                      // Center Dashboard
                      Expanded(
                        child: _buildDashboardContent(),
                      ),

                      if (screenWidth > 1050) const SizedBox(width: 24),

                      // Right Sidebar - Highlights
                      if (screenWidth > 1050)
                        SizedBox(
                          width: 280,
                          child: _buildHighlightsSidebar(),
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // 3. Sticky Desktop Action Bar (Bottom)
          if (isDesktop)
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildDesktopActionBar(),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDesktop) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        gradient: AppColors.heroGradient,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            offset: const Offset(0, 4),
            blurRadius: 12,
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            // Logo Section
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: const Icon(Icons.public_rounded, size: 28, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'GlobalTrustHub',
                  style: AppTypography.h4.copyWith(color: Colors.white, height: 1),
                ),
                Text(
                  'Verified & Secure',
                  style: AppTypography.caption.copyWith(color: Colors.white70),
                ),
              ],
            ),

            const Spacer(),

            // Desktop Navigation
            if (isDesktop) ...[
              _HeaderNavItem(title: 'Home', isActive: true, onTap: () => context.go('/dashboard')),
              _HeaderNavItem(title: 'Find Jobs', onTap: () => context.push('/jobs')),
              _HeaderNavItem(title: 'Study Abroad', onTap: () => context.push('/study-abroad')),
              _HeaderNavItem(title: 'Financial Aid', onTap: () => context.push('/financial-aid')),
              _HeaderNavItem(title: 'Support', onTap: () => context.push('/support')),
              const SizedBox(width: 16),

              // Notification Bell
              Stack(
                children: [
                  IconButton(
                    onPressed: () => context.push('/notifications'),
                    icon: const Icon(Icons.notifications_outlined, color: Colors.white, size: 24),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  Positioned(
                    right: 0,
                    top: 0,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: const BoxDecoration(
                        color: AppColors.error,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
            ],

            // User Profile Pill
            InkWell(
              onTap: () => context.push('/profile-registration'),
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 18,
                      child: Text(
                        'A',
                        style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Ahmed Khan',
                      style: AppTypography.labelMedium.copyWith(color: Colors.white),
                    ),
                    const SizedBox(width: 4),
                    const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
                    const SizedBox(width: 4),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Welcome Banner Card with Quick Actions
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Welcome, Ahmed!',
                        style: AppTypography.h3.copyWith(color: AppColors.textPrimary),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Your Trusted Pathway to Global Opportunities',
                        style: AppTypography.bodyLarge.copyWith(color: AppColors.textSecondary),
                      ),
                    ],
                  ),
                  // Three dots menu
                  Row(
                    children: [
                      _DecorativeDot(),
                      const SizedBox(width: 4),
                      _DecorativeDot(),
                      const SizedBox(width: 4),
                      _DecorativeDot(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),
              // 4 Static Quick Action Cards
              Row(
                children: [
                  Expanded(
                    child: _StaticActionCard(
                      icon: Icons.school_rounded,
                      label: 'Find Universities',
                      iconColor: const Color(0xFF1E40AF),
                      bgColor: const Color(0xFFDBEAFE),
                      onTap: () => context.push('/universities'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StaticActionCard(
                      icon: Icons.search_rounded,
                      label: 'Search Jobs',
                      iconColor: const Color(0xFF1E40AF),
                      bgColor: const Color(0xFFDBEAFE),
                      onTap: () => context.push('/jobs'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StaticActionCard(
                      icon: Icons.location_on_rounded,
                      label: 'Trusted Agents',
                      iconColor: const Color(0xFFDC2626),
                      bgColor: const Color(0xFFFEE2E2),
                      onTap: () => context.push('/agents'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _StaticActionCard(
                      icon: Icons.account_balance_wallet_rounded,
                      label: 'Financial Aid',
                      iconColor: const Color(0xFF059669),
                      bgColor: const Color(0xFFD1FAE5),
                      onTap: () => context.push('/financial-aid'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Journey Progress Section
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Your Journey Progress', style: AppTypography.h5),
                  Row(
                    children: [
                      _DecorativeDot(),
                      const SizedBox(width: 4),
                      _DecorativeDot(),
                      const SizedBox(width: 4),
                      _DecorativeDot(),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 12),
              const Divider(height: 1, color: AppColors.divider),
              const SizedBox(height: 24),

              JourneyProgressWidget(
                journey: _mockJourney,
                onMilestoneTap: (milestone) {},
              ),
              const SizedBox(height: 32),

              // Action Buttons
              Row(
                children: [
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Row(
                      children: [
                        Text('View Applications', style: TextStyle(fontWeight: FontWeight.w600)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      ],
                    ),
                  ),
                  const Spacer(),
                  FilledButton.tonal(
                    onPressed: () {},
                    style: FilledButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      backgroundColor: const Color(0xFFDBEAFE),
                      foregroundColor: const Color(0xFF1E3A8A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Row(
                      children: [
                        Text('Pre-Departure Guide', style: TextStyle(fontWeight: FontWeight.w600)),
                        SizedBox(width: 8),
                        Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),

        // Quick Tips Section
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
            gradient: const LinearGradient(
              colors: [Colors.white, Color(0xFFEBF8FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.lightbulb_outline_rounded, color: Colors.white, size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: RichText(
                  text: TextSpan(
                    style: AppTypography.bodyMedium.copyWith(color: AppColors.textPrimary),
                    children: [
                      TextSpan(
                        text: 'Quick Tips ',
                        style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                      ),
                      const TextSpan(text: 'for Success:  Budget Wisely • Work Legally • Stay Safe'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildNewsSidebar() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 20,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppColors.divider)),
            ),
            child: Row(
              children: [
                Container(
                  width: 4,
                  height: 24,
                  decoration: BoxDecoration(
                    color: AppColors.primary,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 12),
                Text('Latest News', style: AppTypography.h5),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const _SimpleNewsItem(
            title: 'UK Updates Work Visa Rules',
            time: '2h ago',
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          const _SimpleNewsItem(
            title: 'Canada Increases Student Work Hours',
            time: '4h ago',
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          const _SimpleNewsItem(
            title: 'Australia Eases Travel Restrictions',
            time: '6h ago',
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.primary,
                side: const BorderSide(color: AppColors.primary),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('View More >'),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHighlightsSidebar() {
    return Column(
      children: [
        // Top Rated This Month Section
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                decoration: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Top Rated This Month',
                  style: AppTypography.labelLarge.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Ali Travel Consultants
              _TopRatedCard(
                name: 'Ali Travel Consultants',
                rating: 4.8,
                avatarColor: const Color(0xFF1E3A8A),
                initial: 'A',
                onTap: () {},
              ),
              const SizedBox(height: 16),

              // Harvard University
              _TopRatedCard(
                name: 'Harvard University',
                rating: 4.9,
                avatarColor: const Color(0xFFA51C30),
                initial: 'H',
                onTap: () {},
              ),
              const SizedBox(height: 16),

              // Tech Innovate Inc.
              _TopRatedCard(
                name: 'Tech Innovate Inc.',
                rating: 4.7,
                avatarColor: const Color(0xFF059669),
                initial: 'T',
                onTap: () {},
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),

        // Featured Services Section
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Featured Services',
                style: AppTypography.h6.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: _FeaturedServiceImageCard(
                      title: 'IELTS\nCoaching',
                      icon: Icons.school_rounded,
                      gradientColors: const [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FeaturedServiceImageCard(
                      title: 'Student\nHousing',
                      icon: Icons.home_rounded,
                      gradientColors: const [Color(0xFF059669), Color(0xFF10B981)],
                      onTap: () {},
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: _FeaturedServiceImageCard(
                      title: 'Money\nTransfer',
                      icon: Icons.currency_exchange_rounded,
                      gradientColors: const [Color(0xFFDC2626), Color(0xFFF87171)],
                      onTap: () {},
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

  Widget _buildDesktopActionBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFE8EDF4),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          // Mentor Connect Button (Blue)
          _DesktopActionButton(
            icon: Icons.chat_bubble_rounded,
            label: 'Mentor Connect',
            backgroundColor: AppColors.primary,
            textColor: Colors.white,
            onTap: () => context.push('/chat'),
          ),
          const SizedBox(width: 16),

          // Safety Alert Button (Red)
          _DesktopActionButton(
            icon: Icons.shield_rounded,
            label: 'Safety Alert',
            backgroundColor: AppColors.error,
            textColor: Colors.white,
            onTap: () => _showSafetyAlertDialog(context),
          ),
          const SizedBox(width: 16),

          // Help & Support Button (Outlined)
          _DesktopActionButton(
            icon: Icons.help_outline_rounded,
            label: 'Help & Support',
            backgroundColor: Colors.transparent,
            textColor: AppColors.textSecondary,
            isOutlined: true,
            onTap: () => context.push('/support'),
          ),
        ],
      ),
    );
  }

  void _showSafetyAlertDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.shield_rounded, color: AppColors.error),
            ),
            const SizedBox(width: 12),
            const Text('Safety Alert'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Report a safety concern or suspicious activity',
              style: AppTypography.bodyMedium,
            ),
            const SizedBox(height: 16),
            TextField(
              maxLines: 4,
              decoration: InputDecoration(
                hintText: 'Describe your concern...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Your report has been submitted. Our safety team will review it.'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Submit Report'),
          ),
        ],
      ),
    );
  }
}

// --- Helper Widgets ---

class _HeaderNavItem extends StatelessWidget {
  final String title;
  final bool isActive;
  final VoidCallback onTap;

  const _HeaderNavItem({required this.title, this.isActive = false, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: GestureDetector(
        onTap: onTap,
        child: Column(
          children: [
            Text(
              title,
              style: AppTypography.labelMedium.copyWith(
                color: Colors.white.withValues(alpha: isActive ? 1.0 : 0.8),
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            if (isActive)
              Container(
                margin: const EdgeInsets.only(top: 4),
                width: 20,
                height: 2,
                color: Colors.white,
              ),
          ],
        ),
      ),
    );
  }
}

class _DecorativeDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.3),
        shape: BoxShape.circle,
      ),
    );
  }
}

class _StaticActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color iconColor;
  final Color bgColor;
  final VoidCallback onTap;

  const _StaticActionCard({
    required this.icon,
    required this.label,
    required this.iconColor,
    required this.bgColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 12),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: iconColor.withValues(alpha: 0.2)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, size: 28, color: iconColor),
            ),
            const SizedBox(height: 12),
            Text(
              label,
              textAlign: TextAlign.center,
              style: AppTypography.labelMedium.copyWith(
                fontWeight: FontWeight.w600,
                color: iconColor,
                height: 1.2,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SimpleNewsItem extends StatelessWidget {
  final String title;
  final String time;

  const _SimpleNewsItem({required this.title, required this.time});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: AppTypography.labelMedium.copyWith(
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1E3A8A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          time,
          style: AppTypography.bodySmall,
        ),
      ],
    );
  }
}

class _TopRatedCard extends StatelessWidget {
  final String name;
  final double rating;
  final Color avatarColor;
  final String initial;
  final VoidCallback onTap;

  const _TopRatedCard({
    required this.name,
    required this.rating,
    required this.avatarColor,
    required this.initial,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: avatarColor,
            radius: 24,
            child: Text(
              initial,
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTypography.labelMedium.copyWith(fontWeight: FontWeight.w600)),
                const SizedBox(height: 4),
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (index) => Icon(
                        Icons.star_rounded,
                        size: 14,
                        color: index < rating.floor() ? const Color(0xFFF59E0B) : Colors.grey[300],
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(rating.toString(), style: AppTypography.caption),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FeaturedServiceImageCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final List<Color> gradientColors;
  final VoidCallback onTap;

  const _FeaturedServiceImageCard({
    required this.title,
    required this.icon,
    required this.gradientColors,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          Container(
            height: 80,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Icon(icon, color: Colors.white, size: 32),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(4),
            ),
            child: Text(
              'View Details',
              style: AppTypography.caption.copyWith(
                color: Colors.white,
                fontSize: 9,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DesktopActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final VoidCallback onTap;
  final bool isOutlined;

  const _DesktopActionButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.onTap,
    this.isOutlined = false,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: isOutlined ? Colors.white : backgroundColor,
            borderRadius: BorderRadius.circular(24),
            border: isOutlined
                ? Border.all(color: AppColors.divider)
                : null,
            boxShadow: isOutlined
                ? null
                : [
                    BoxShadow(
                      color: backgroundColor.withValues(alpha: 0.3),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: 18, color: isOutlined ? textColor : textColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: isOutlined ? textColor : textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
