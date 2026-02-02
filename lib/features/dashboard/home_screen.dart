import 'package:flutter/material.dart';
import 'dart:async';
import 'package:provider/provider.dart';
import 'package:global_trust_hub/core/theme/app_colors.dart';
import 'package:global_trust_hub/core/theme/app_typography.dart';
import 'package:global_trust_hub/models/models.dart';
import 'package:global_trust_hub/widgets/widgets.dart';
import 'package:global_trust_hub/state_management/theme_provider.dart';
import 'package:global_trust_hub/state_management/user_provider.dart';
import 'package:global_trust_hub/state_management/services_provider.dart';
import 'package:global_trust_hub/state_management/news_provider.dart';
import 'package:go_router/go_router.dart';

/// Main home screen with sidebars and dashboard
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;
  
  // Carousel controller and timer for auto-scroll
  late ScrollController _scrollController;
  Timer? _carouselTimer;

  // Mock journey (will be replaced with real data later)
  final Journey _mockJourney = JourneyTemplates.studyAbroadTemplate('Canada');
  
  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    
    // Fetch user data and services on init
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<UserProvider>().fetchCurrentUser();
      context.read<ServicesProvider>().loadFeatured();
      context.read<ServicesProvider>().loadCategories();
      _startMarquee();
    });
  }

  @override
  void dispose() {
    _carouselTimer?.cancel();
    _scrollController.dispose();
    super.dispose();
  }

  void _startMarquee() {
    const double speed = 20.0; // pixels per second
    const Duration tickDuration = Duration(milliseconds: 50); // smoother updates

    _carouselTimer?.cancel();
    _carouselTimer = Timer.periodic(tickDuration, (timer) {
      if (_scrollController.hasClients) {

        double currentScroll = _scrollController.offset;
        
        // Calculate pixels to move in this tick
        double moveBy = speed * (tickDuration.inMilliseconds / 1000);
        
        double target = currentScroll + moveBy;
        
        // If we reach the end (or near it), reset to keep illusion of infinity
        // Note: For true infinity with ListView.builder, we rely on a large item count
        // but to prevent running out, we can reset to a middle point if list is large enough.
        // Or simply keep scrolling. 
        // A simpler approach for "marquee" is just animateTo.
        
        _scrollController.animateTo(
          target,
          duration: tickDuration,
          curve: Curves.linear,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 900;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final colorScheme = Theme.of(context).colorScheme;
    
    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBackground : const Color(0xFFF0F2F5), // Theme-aware background
      body: Stack(
        children: [
          Column(
            children: [
              // 1. Premium Header (GlobalTrustHub Blue Gradient)
              _buildHeader(),

              // 2. Main Content Area (3-Column Layout)
              Expanded(
                child: SingleChildScrollView(
                  padding: EdgeInsets.only(
                    // Responsive padding: 12px for phones, 16px for small tablets, 24px for larger screens
                    left: MediaQuery.of(context).size.width < 360 ? 12 : (MediaQuery.of(context).size.width < 600 ? 16 : 24),
                    right: MediaQuery.of(context).size.width < 360 ? 12 : (MediaQuery.of(context).size.width < 600 ? 16 : 24),
                    top: MediaQuery.of(context).size.width < 360 ? 12 : (MediaQuery.of(context).size.width < 600 ? 16 : 24),
                    bottom: isDesktop ? 80 : (MediaQuery.of(context).size.width < 360 ? 12 : 24), // Extra padding for desktop action bar
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Sidebar - News (Visible on Desktop)
                      if (MediaQuery.of(context).size.width > 1050)
                        SizedBox(
                          width: 200,
                          child: _buildNewsSidebar(),
                        ),
                      
                      if (MediaQuery.of(context).size.width > 1050)
                        const SizedBox(width: 16),

                      // Center Dashboard (Flexible)
                      Expanded(
                        child: _buildDashboardContent(),
                      ),

                      if (MediaQuery.of(context).size.width > 1050)
                        const SizedBox(width: 16),

                      // Right Sidebar - Highlights (Visible on Desktop)
                      if (MediaQuery.of(context).size.width > 1050)
                        SizedBox(
                          width: 260,
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
      // Mobile/Tablet Bottom Navigation
      bottomNavigationBar: !isDesktop ? _buildBottomNav() : null,
    );
  }

  Widget _buildHeader() {
    final screenWidth = MediaQuery.of(context).size.width;
    // Responsive padding: 12px for very small phones, 16px for phones, 24px for tablets, 32px for desktop
    final horizontalPadding = screenWidth < 360 ? 12.0 : (screenWidth < 600 ? 16.0 : (screenWidth < 900 ? 24.0 : 32.0));
    final verticalPadding = screenWidth < 360 ? 10.0 : 16.0;
    
    return Container(
      padding: EdgeInsets.symmetric(horizontal: horizontalPadding, vertical: verticalPadding),
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
                Builder(
                  builder: (context) {
                    final width = MediaQuery.of(context).size.width;
                    return Text(
                      'GlobalTrustHub',
                      style: (width < 400 ? AppTypography.h5 : AppTypography.h4).copyWith(color: Colors.white, height: 1),
                    );
                  },
                ),
                Text(
                  'Verified & Secure',
                  style: AppTypography.caption.copyWith(color: Colors.white70),
                ),
              ],
            ),
            
            const Spacer(),

            // Desktop Navigation (Simple)
            if (MediaQuery.of(context).size.width > 900) ...[
              _HeaderNavItem(title: 'Home', isActive: true, onTap: () => context.go('/dashboard')),
              _HeaderNavItem(title: 'Find Jobs', onTap: () => context.go('/jobs')),
              _HeaderNavItem(title: 'Study Abroad', onTap: () => context.go('/study-abroad')),
              _HeaderNavItem(title: 'Financial Aid', onTap: () => context.go('/financial-aid')),
              _HeaderNavItem(title: 'Support', onTap: () => context.go('/support')),
              _HeaderNavItem(
                title: 'Admin', 
                onTap: () => context.go('/admin'),
                isSpecial: true, // Special styling for admin button
              ),
              const SizedBox(width: 16),
              
              // Notification Bell with Badge
              Stack(
                children: [
                  IconButton(
                    onPressed: () => context.go('/notifications'),
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
              const SizedBox(width: 12),
              
              // Theme Toggle Button
              Consumer<ThemeProvider>(
                builder: (context, themeProvider, child) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      onPressed: () => themeProvider.toggleTheme(),
                      icon: Icon(
                        themeProvider.isDarkMode 
                          ? Icons.light_mode_rounded 
                          : Icons.dark_mode_rounded,
                        color: Colors.white,
                        size: 22,
                      ),
                      tooltip: themeProvider.isDarkMode ? 'Switch to Light Mode' : 'Switch to Dark Mode',
                      padding: const EdgeInsets.all(8),
                      constraints: const BoxConstraints(),
                    ),
                  );
                },
              ),
              const SizedBox(width: 16),
            ],

            // User Profile Pill with Dropdown Menu
            Consumer<UserProvider>(
              builder: (context, userProvider, child) {
                final userName = userProvider.userName;
                return PopupMenuButton<String>(
                  offset: const Offset(0, 50),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  onSelected: (value) {
                    switch (value) {
                      case 'student':
                        context.go('/register/student');
                        break;
                      case 'job-seeker':
                        context.go('/register/job-seeker');
                        break;
                      case 'agent':
                        context.go('/register/agent');
                        break;
                      case 'service-provider':
                        context.go('/register/service-provider');
                        break;
                      case 'login':
                        context.go('/login');
                        break;
                    }
                  },
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      enabled: false,
                      child: Text('Register As', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[600])),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'student',
                      child: Row(
                        children: [
                          Icon(Icons.school_outlined, color: Colors.blue, size: 20),
                          SizedBox(width: 12),
                          Text('Student'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'job-seeker',
                      child: Row(
                        children: [
                          Icon(Icons.work_outline, color: Colors.green, size: 20),
                          SizedBox(width: 12),
                          Text('Job Seeker'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'agent',
                      child: Row(
                        children: [
                          Icon(Icons.support_agent, color: Colors.orange, size: 20),
                          SizedBox(width: 12),
                          Text('Agent'),
                        ],
                      ),
                    ),
                    const PopupMenuItem(
                      value: 'service-provider',
                      child: Row(
                        children: [
                          Icon(Icons.business, color: Colors.purple, size: 20),
                          SizedBox(width: 12),
                          Text('Service Provider'),
                        ],
                      ),
                    ),
                    const PopupMenuDivider(),
                    const PopupMenuItem(
                      value: 'login',
                      child: Row(
                        children: [
                          Icon(Icons.login, color: Colors.grey, size: 20),
                          SizedBox(width: 12),
                          Text('Login'),
                        ],
                      ),
                    ),
                  ],
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
                            userName.isNotEmpty ? userName[0].toUpperCase() : 'G',
                            style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                          ),
                        ),
                        const SizedBox(width: 10),
                        Text(
                          userName,
                          style: AppTypography.labelMedium.copyWith(color: Colors.white),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_drop_down, color: Colors.white, size: 20),
                        const SizedBox(width: 4),
                      ],
                    ),
                  ),
                );
              },
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
        Builder(builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final screenWidth = MediaQuery.of(context).size.width;
          final bannerPadding = screenWidth < 360 ? 16.0 : (screenWidth < 600 ? 20.0 : 24.0);
          return Container(
          width: double.infinity,
          padding: EdgeInsets.all(bannerPadding),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Builder(
                builder: (context) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Consumer<UserProvider>(
                              builder: (context, userProvider, child) {
                                final firstName = userProvider.userName.split(' ').first;
                                // Responsive typography: smaller on mobile
                                final titleStyle = screenWidth < 360 
                                    ? AppTypography.h5 
                                    : (screenWidth < 600 ? AppTypography.h4 : AppTypography.h3);
                                return Text(
                                  'Welcome, $firstName!',
                                  style: titleStyle.copyWith(color: isDark ? Colors.white : AppColors.textPrimary),
                                );
                              },
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Your Trusted Pathway to Global Opportunities',
                              style: (screenWidth < 360 ? AppTypography.bodySmall : AppTypography.bodyLarge).copyWith(
                                color: isDark ? Colors.grey[400] : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
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
                  );
                },
              ),
              const SizedBox(height: 24),
              // 4 Static Quick Action Cards in a Row
              // 4 Action Cards in a Responsive Grid
              _buildResponsiveGrid(context, [
                _StaticActionCard(
                  icon: Icons.school_rounded,
                  label: 'Find Universities',
                  iconColor: const Color(0xFF1E40AF),
                  bgColor: const Color(0xFFDBEAFE),
                  onTap: () => context.go('/universities'),
                ),
                _StaticActionCard(
                  icon: Icons.search_rounded,
                  label: 'Search Jobs',
                  iconColor: const Color(0xFF1E40AF),
                  bgColor: const Color(0xFFDBEAFE),
                  onTap: () => context.go('/jobs'),
                ),
                _StaticActionCard(
                  icon: Icons.location_on_rounded,
                  label: 'Trusted Agents',
                  iconColor: const Color(0xFFDC2626),
                  bgColor: const Color(0xFFFEE2E2),
                  onTap: () => context.go('/agents'),
                ),
                _StaticActionCard(
                  icon: Icons.payment_rounded,
                  label: 'Payment Methods',
                  iconColor: const Color(0xFF7C3AED),
                  bgColor: const Color(0xFFEDE9FE),
                  onTap: () => context.go('/payments'),
                ),
              ]),
              const SizedBox(height: 16), // Spacing between grid blocks if needed, grid handles its own rows
              _buildResponsiveGrid(context, [
                _StaticActionCard(
                  icon: Icons.account_balance_wallet_rounded,
                  label: 'Financial Aid',
                  iconColor: const Color(0xFF059669),
                  bgColor: const Color(0xFFD1FAE5),
                  onTap: () => context.go('/financial-aid'),
                ),
                _StaticActionCard(
                  icon: Icons.newspaper_rounded,
                  label: 'Latest News',
                  iconColor: const Color(0xFFEA580C),
                  bgColor: const Color(0xFFFED7AA),
                  onTap: () => context.go('/news'),
                ),
                _StaticActionCard(
                  icon: Icons.support_agent_rounded,
                  label: 'Get Support',
                  iconColor: const Color(0xFF0891B2),
                  bgColor: const Color(0xFFCFFAFE),
                  onTap: () => context.go('/support'),
                ),
                _StaticActionCard(
                  icon: Icons.notifications_rounded,
                  label: 'Notifications',
                  iconColor: const Color(0xFFDB2777),
                  bgColor: const Color(0xFFFCE7F3),
                  onTap: () => context.go('/notifications'),
                ),
              ]),
            ],
          ),
        );
        },),
        const SizedBox(height: 24),


        // Journey Progress Section
        Builder(builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final screenWidth = MediaQuery.of(context).size.width;
          final sectionPadding = screenWidth < 360 ? 16.0 : (screenWidth < 600 ? 20.0 : 24.0);
          return Container(
          padding: EdgeInsets.all(sectionPadding),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with dots
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Your Journey Progress', style: AppTypography.h5),
                  // Three dots decorative
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
              
              // Action Buttons - Responsive: Stack on mobile, Row on tablet+
              Builder(
                builder: (context) {
                  final screenWidth = MediaQuery.of(context).size.width;
                  final isNarrow = screenWidth < 500;
                  final buttonPadding = screenWidth < 360 
                      ? const EdgeInsets.symmetric(horizontal: 12, vertical: 10)
                      : const EdgeInsets.symmetric(horizontal: 24, vertical: 16);
                  
                  final viewAppButton = ElevatedButton(
                    onPressed: () => context.go('/journey'),
                    style: ElevatedButton.styleFrom(
                      padding: buttonPadding,
                      backgroundColor: const Color(0xFF1E3A8A),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          screenWidth < 360 ? 'Applications' : 'View Applications',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: screenWidth < 360 ? 12 : 14),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      ],
                    ),
                  );
                  
                  final guideButton = FilledButton.tonal(
                    onPressed: () => context.go('/study-abroad'),
                    style: FilledButton.styleFrom(
                      padding: buttonPadding,
                      backgroundColor: const Color(0xFFDBEAFE),
                      foregroundColor: const Color(0xFF1E3A8A),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          screenWidth < 360 ? 'Guide' : 'Pre-Departure Guide',
                          style: TextStyle(fontWeight: FontWeight.w600, fontSize: screenWidth < 360 ? 12 : 14),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_ios_rounded, size: 14),
                      ],
                    ),
                  );
                  
                  if (isNarrow) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        viewAppButton,
                        const SizedBox(height: 12),
                        guideButton,
                      ],
                    );
                  }
                  
                  return Row(
                    children: [
                      Expanded(child: viewAppButton),
                      const SizedBox(width: 12),
                      Expanded(child: guideButton),
                    ],
                  );
                },
              ),
            ],
          ),
        );
        },),
        const SizedBox(height: 24),

        // Quick Tips Section
        Builder(builder: (context) {
          final isDark = Theme.of(context).brightness == Brightness.dark;
          final screenWidth = MediaQuery.of(context).size.width;
          final isVerySmall = screenWidth < 360;
          final padding = isVerySmall ? 12.0 : 20.0;
          final iconSize = isVerySmall ? 20.0 : 24.0;
          final iconPadding = isVerySmall ? 10.0 : 12.0;
          
          return Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: isDark ? AppColors.darkSurface : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                blurRadius: 15,
                offset: const Offset(0, 4),
              ),
            ],
            gradient: isDark ? null : const LinearGradient(
              colors: [Colors.white, Color(0xFFEBF8FF)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Styled Lightbulb Icon
              Container(
                padding: EdgeInsets.all(iconPadding),
                decoration: const BoxDecoration(
                  color: AppColors.primary,
                  shape: BoxShape.circle,
                ),
                child: Icon(Icons.lightbulb_outline_rounded, color: Colors.white, size: iconSize),
              ),
              SizedBox(width: isVerySmall ? 10 : 16),
              Expanded(
                child: isVerySmall 
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Quick Tips:',
                          style: AppTypography.labelMedium.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Budget Wisely • Work Legally • Stay Safe',
                          style: AppTypography.bodySmall.copyWith(color: isDark ? Colors.white : AppColors.textPrimary),
                        ),
                      ],
                    )
                  : RichText(
                      text: TextSpan(
                        style: AppTypography.bodyMedium.copyWith(color: isDark ? Colors.white : AppColors.textPrimary),
                        children: [
                          TextSpan(
                            text: 'Quick Tips for Success: ',
                            style: AppTypography.labelLarge.copyWith(color: AppColors.primary),
                          ),
                          const TextSpan(text: 'Budget Wisely • Work Legally • Stay Safe'),
                        ],
                      ),
                    ),
              ),
            ],
          ),
        );
        },),
      ],
    );
  }

  Widget _buildNewsSidebar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<NewsProvider>(
      builder: (context, newsProvider, child) {
        // Load news if not already loaded
        if (newsProvider.status == NewsStatus.initial) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            newsProvider.loadNews(limit: 3);
          });
        }
        
        // Use API data or fallback to static data
        final newsItems = newsProvider.news.isNotEmpty
            ? newsProvider.news
            : null;
        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
                    blurRadius: 20,
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
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
                  // Loading state
                  if (newsProvider.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  // Display news from API or fallback
                  else
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: newsItems?.length ?? 3,
                      separatorBuilder: (_, __) => const Divider(height: 32),
                      itemBuilder: (context, index) {
                        if (newsItems != null && index < newsItems.length) {
                          return _SimpleNewsItem(
                            title: newsItems[index].title,
                            time: newsItems[index].timeAgo,
                          );
                        }
                        // Fallback static data
                        return _SimpleNewsItem(
                          title: [
                            'UK Updates Work Visa Rules',
                            'Canada Increases Student Work Hours',
                            'Australia Eases Travel Restrictions',
                          ][index],
                          time: ['2h ago', '4h ago', '6h ago'][index],
                        );
                      },
                    ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () => context.go('/news'),
                      child: const Text('View More >'),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildHighlightsSidebar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Consumer<ServicesProvider>(
      builder: (context, servicesProvider, child) {
        final featured = servicesProvider.featured;
        final agentOfMonth = featured?.agentOfMonth;
        final universityOfMonth = featured?.universityOfMonth;
        final employerOfMonth = featured?.employerOfMonth;
        
        return Column(
          children: [
            // Top Rated This Month Section
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
                    blurRadius: 15,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Header with primary color
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
                  
                  // Loading state
                  if (servicesProvider.isLoading)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(strokeWidth: 2),
                      ),
                    )
                  else ...[
                    // Ali Travel Consultants
                    _TopRatedCard(
                      name: agentOfMonth?['name'] ?? 'Ali Travel Consultants',
                      rating: (agentOfMonth?['rating'] ?? 4.8).toDouble(),
                      avatarColor: const Color(0xFF1E3A8A),
                      initial: 'A',
                      onTap: () => context.go('/agents'),
                    ),
                    const SizedBox(height: 16),
                    
                    // Harvard University
                    _TopRatedCard(
                      name: universityOfMonth?['name'] ?? 'Harvard University',
                      rating: (universityOfMonth?['rating'] ?? 4.9).toDouble(),
                      avatarColor: const Color(0xFFA51C30),
                      initial: 'H',
                      onTap: () => context.go('/universities'),
                    ),
                    const SizedBox(height: 16),
                    
                    // Tech Innovate Inc.
                    _TopRatedCard(
                      name: employerOfMonth?['name'] ?? 'Tech Innovate Inc.',
                      rating: (employerOfMonth?['rating'] ?? 4.7).toDouble(),
                      avatarColor: const Color(0xFF059669),
                      initial: 'T',
                      onTap: () => context.go('/jobs'),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            // Featured Services Section with Images
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: isDark ? AppColors.darkSurface : Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
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
                  LayoutBuilder(
                    builder: (context, constraints) {
                      if (constraints.maxWidth < 400) {
                        return Column(
                          children: [
                            _FeaturedServiceImageCard(
                              title: 'IELTS\nCoaching',
                              icon: Icons.school_rounded,
                              gradientColors: const [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                              onTap: () => context.go('/services'),
                            ),
                            const SizedBox(height: 12),
                            _FeaturedServiceImageCard(
                              title: 'Student\nHousing',
                              icon: Icons.home_rounded,
                              gradientColors: const [Color(0xFF059669), Color(0xFF10B981)],
                              onTap: () => context.go('/services'),
                            ),
                            const SizedBox(height: 12),
                            _FeaturedServiceImageCard(
                              title: 'Money\nTransfer',
                              icon: Icons.currency_exchange_rounded,
                              gradientColors: const [Color(0xFFDC2626), Color(0xFFF87171)],
                              onTap: () => context.go('/services'),
                            ),
                          ],
                        );
                      }
                      return Row(
                        children: [
                          Expanded(
                            child: _FeaturedServiceImageCard(
                              title: 'IELTS\nCoaching',
                              icon: Icons.school_rounded,
                              gradientColors: const [Color(0xFF1E40AF), Color(0xFF3B82F6)],
                              onTap: () => context.go('/services'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _FeaturedServiceImageCard(
                              title: 'Student\nHousing',
                              icon: Icons.home_rounded,
                              gradientColors: const [Color(0xFF059669), Color(0xFF10B981)],
                              onTap: () => context.go('/services'),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: _FeaturedServiceImageCard(
                              title: 'Money\nTransfer',
                              icon: Icons.currency_exchange_rounded,
                              gradientColors: const [Color(0xFFDC2626), Color(0xFFF87171)],
                              onTap: () => context.go('/services'),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }


   Widget _buildBottomNav() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() => _currentIndex = index);
          // Navigate to the corresponding page
          switch (index) {
            case 0:
              context.go('/dashboard');
              break;
            case 1:
              context.go('/journey');
              break;
            case 2:
              context.go('/chat');
              break;
            case 3:
              context.go('/profile');
              break;
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.route_outlined),
            activeIcon: Icon(Icons.route_rounded),
            label: 'Journey',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble_rounded),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person_outline),
            activeIcon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  /// Desktop sticky action bar with quick access buttons
  Widget _buildDesktopActionBar() {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceElevated : const Color(0xFFE8EDF4), // Theme-aware
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.3 : 0.08),
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
            onTap: () => context.go('/chat'),
          ),
          const SizedBox(width: 16),
          
          // Safety Alert Button (Red)
          _DesktopActionButton(
            icon: Icons.shield_rounded,
            label: 'Safety Alert',
            backgroundColor: AppColors.error,
            textColor: Colors.white,
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Safety Alert feature coming soon!'),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
          ),
          const SizedBox(width: 16),
          
          // Help & Support Button (Outlined)
          _DesktopActionButton(
            icon: Icons.help_outline_rounded,
            label: 'Help & Support',
            backgroundColor: Colors.transparent,
            textColor: AppColors.textSecondary,
            isOutlined: true,
            onTap: () => context.go('/support'),
          ),
        ],
      ),
    );
  }
}

// --- Helper Widgets matching the New Design ---

class _HeaderNavItem extends StatefulWidget {
  final String title;
  final bool isActive;
  final bool isSpecial;
  final VoidCallback onTap;

  const _HeaderNavItem({
    required this.title, 
    this.isActive = false, 
    this.isSpecial = false,
    required this.onTap,
  });

  @override
  State<_HeaderNavItem> createState() => _HeaderNavItemState();
}

class _HeaderNavItemState extends State<_HeaderNavItem> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    // Special styling for Admin button
    if (widget.isSpecial) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: _isHovered ? Colors.white : Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Colors.white.withValues(alpha: 0.3)),
                boxShadow: _isHovered 
                  ? [BoxShadow(color: Colors.white.withValues(alpha: 0.2), blurRadius: 8)]
                  : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.admin_panel_settings, 
                    size: 16, 
                    color: _isHovered ? AppColors.primary : Colors.white,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    widget.title,
                    style: AppTypography.labelMedium.copyWith(
                      color: _isHovered ? AppColors.primary : Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    
    // Regular nav item with hover effect
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedScale(
            scale: _isHovered ? 1.05 : 1.0,
            duration: const Duration(milliseconds: 150),
            child: Column(
              children: [
                Text(
                  widget.title,
                  style: AppTypography.labelMedium.copyWith(
                    color: Colors.white.withOpacity(widget.isActive || _isHovered ? 1.0 : 0.8),
                    fontWeight: widget.isActive || _isHovered ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
                if (widget.isActive)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    width: 20,
                    height: 2,
                    color: Colors.white,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Helper method to build a responsive grid of widgets
/// On mobile (<600px): 2 columns
/// On desktop (>=600px): All in one row (4 columns)
Widget _buildResponsiveGrid(BuildContext context, List<Widget> children) {
  final width = MediaQuery.of(context).size.width;
  
  // Desktop/Tablet: Single Row of 4
  if (width >= 800) {
    return Row(
      children: [
        Expanded(child: children[0]),
        const SizedBox(width: 16),
        Expanded(child: children[1]),
        const SizedBox(width: 16),
        Expanded(child: children[2]),
        const SizedBox(width: 16),
        Expanded(child: children[3]),
      ],
    );
  }

  // Small Mobile (< 400px): 1 Column (Vertical Stack)
  if (width < 400) {
    return Column(
      children: [
        children[0],
        const SizedBox(height: 12),
        children[1],
        const SizedBox(height: 12),
        children[2],
        const SizedBox(height: 12),
        children[3],
      ],
    );
  }
  
  // Tablet / Standard Mobile: Column of 2 Rows (2x2)
  return Column(
    children: [
      Row(
        children: [
          Expanded(child: children[0]),
          const SizedBox(width: 16),
          Expanded(child: children[1]),
        ],
      ),
      const SizedBox(height: 16),
      Row(
        children: [
          Expanded(child: children[2]),
          const SizedBox(width: 16),
          Expanded(child: children[3]),
        ],
      ),
    ],
  );
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final bool isImage;

  const _QuickActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
    this.isImage = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        decoration: BoxDecoration(
          color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Stack(
          children: [
            // Background decorative shape
            Positioned(
              top: -10,
              right: -10,
              child: Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: 0.08),
                  shape: BoxShape.circle,
                ),
              ),
            ),
            // Main content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: color.withValues(alpha: 0.2),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(icon, size: 30, color: color),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    label,
                    textAlign: TextAlign.center,
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w700,
                      color: isDark ? Colors.white : AppColors.textPrimary,
                      height: 1.2,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}





/// Top Rated Card with avatar and star rating matching target design
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        child: Row(
          children: [
            // Avatar with initial
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                color: avatarColor,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: avatarColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  initial,
                  style: AppTypography.h5.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Name and rating
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: AppTypography.labelMedium.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textPrimary,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      ...List.generate(5, (index) => Icon(
                        Icons.star_rounded,
                        size: 16,
                        color: index < rating.floor() 
                            ? const Color(0xFFF59E0B) 
                            : Colors.grey.shade300,
                      ),),
                      const SizedBox(width: 6),
                      Text(
                        rating.toString(),
                        style: AppTypography.labelSmall.copyWith(
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFFF59E0B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Featured Service Image Card with gradient and View Details button
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          // Image/gradient container
          Container(
            height: 70,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: gradientColors[0].withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Icon(icon, color: Colors.white, size: 32),
            ),
          ),
          const SizedBox(height: 8),
          // Title
          Text(
            title,
            textAlign: TextAlign.center,
            style: AppTypography.caption.copyWith(
              color: Theme.of(context).brightness == Brightness.dark ? Colors.white : AppColors.textPrimary,
              fontSize: 11,
              fontWeight: FontWeight.bold,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 6),
          // View Details button
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
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

/// Desktop action bar button widget
class _DesktopActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final bool isOutlined;
  final VoidCallback onTap;

  const _DesktopActionButton({
    required this.icon,
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    this.isOutlined = false,
    required this.onTap,
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
                ? Border.all(color: AppColors.divider, width: 1.5) 
                : null,
            boxShadow: isOutlined ? null : [
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
              Icon(icon, color: isOutlined ? textColor : textColor, size: 18),
              const SizedBox(width: 8),
              Text(
                label,
                style: AppTypography.labelMedium.copyWith(
                  color: isOutlined ? textColor : textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Carousel action card for horizontal scrolling quick actions
class _CarouselActionCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;
  final double? width;

  const _CarouselActionCard({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          width: width ?? 130,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                color.withValues(alpha: 0.15),
                color.withValues(alpha: 0.05),
              ],
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: color.withValues(alpha: 0.3),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.15),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: color,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: color.withValues(alpha: 0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Icon(icon, size: 26, color: Colors.white),
              ),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: AppTypography.labelMedium.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Static action card for the 4-column grid in the welcome banner
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
    final isDark = Theme.of(context).brightness == Brightness.dark;
    
    // Use LayoutBuilder to make card fully responsive
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine sizing based on available width
        final isCompact = constraints.maxWidth < 140;
        final isVeryCompact = constraints.maxWidth < 100;
        
        final cardHeight = isVeryCompact ? 100.0 : (isCompact ? 120.0 : 140.0);
        final cardPadding = isVeryCompact ? 8.0 : (isCompact ? 12.0 : 16.0);
        final iconSize = isVeryCompact ? 20.0 : (isCompact ? 24.0 : 28.0);
        final iconPadding = isVeryCompact ? 8.0 : (isCompact ? 10.0 : 12.0);
        final textSpacing = isVeryCompact ? 6.0 : (isCompact ? 8.0 : 12.0);
        
        return InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(isCompact ? 12 : 16),
          child: Container(
            height: cardHeight,
            padding: EdgeInsets.all(cardPadding),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurfaceElevated : Colors.white,
              borderRadius: BorderRadius.circular(isCompact ? 12 : 16),
              border: Border.all(color: AppColors.divider.withValues(alpha: 0.5)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.3 : 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: EdgeInsets.all(iconPadding),
                  decoration: BoxDecoration(
                    color: bgColor,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, color: iconColor, size: iconSize),
                ),
                SizedBox(height: textSpacing),
                Text(
                  label,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: (isVeryCompact ? AppTypography.caption : AppTypography.labelMedium).copyWith(
                    fontWeight: FontWeight.w600,
                    color: isDark ? Colors.white : AppColors.textPrimary,
                    height: 1.2,
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}


class _DecorativeDot extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: 0.785, // 45 degrees
      child: Container(
        width: 8,
        height: 8,
        decoration: BoxDecoration(
          color: AppColors.divider,
          borderRadius: BorderRadius.circular(2),
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
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 4,
            height: 4,
            margin: const EdgeInsets.only(top: 8, right: 12),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.bodyMedium.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  time,
                  style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
