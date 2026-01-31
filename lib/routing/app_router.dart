import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:global_trust_hub/routing/route_names.dart';
import 'package:global_trust_hub/modules/authentication/login_screen.dart';
import 'package:global_trust_hub/features/dashboard/home_screen.dart';
import 'package:global_trust_hub/features/auth/role_selection_screen.dart';
import 'package:global_trust_hub/features/auth/register_screen.dart';
import 'package:global_trust_hub/features/auth/profile_registration_screen.dart';
import 'package:global_trust_hub/features/jobs/find_jobs_screen.dart';
import 'package:global_trust_hub/features/study_abroad/study_abroad_screen.dart';
import 'package:global_trust_hub/features/financial_aid/financial_aid_screen.dart';
import 'package:global_trust_hub/features/support/support_screen.dart';
import 'package:global_trust_hub/features/notifications/notifications_screen.dart';
import 'package:global_trust_hub/features/chat/chat_screen.dart';
import 'package:global_trust_hub/features/admin/admin_dashboard_screen.dart';
import 'package:global_trust_hub/features/admin/admin_auth_screen.dart';
import 'package:global_trust_hub/features/auth/service_provider_registration_screen.dart';
import 'package:global_trust_hub/core/storage/secure_storage.dart';
// New registration forms
import 'package:global_trust_hub/modules/authentication/signup_forms/student_signup_form.dart';
import 'package:global_trust_hub/modules/authentication/signup_forms/job_seeker_signup_form.dart';
import 'package:global_trust_hub/modules/authentication/signup_forms/agent_signup_form.dart';
import 'package:global_trust_hub/modules/authentication/signup_forms/service_provider_signup_form.dart';
import 'package:global_trust_hub/modules/authentication/verification_status_screen.dart';
import 'package:global_trust_hub/features/news/news_screen.dart';
import 'package:global_trust_hub/features/payments/payment_methods_screen.dart';

// Placeholder widgets for routes that don't exist yet
class PlaceholderScreen extends StatelessWidget {
  final String title;
  const PlaceholderScreen({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(child: Text('Placeholder for $title')),
    );
  }
}

final GoRouter appRouter = GoRouter(
  initialLocation: '/dashboard',
  redirect: (context, state) async {
    final storage = SecureStorageService();
    final isLoggedIn = await storage.isLoggedIn();
    final currentPath = state.matchedLocation;
    
    // Define public routes that don't require authentication
    final publicRoutes = [
      '/login',
      '/register',
      '/role-selection',
      '/profile-registration',
      '/forgot-password',
      '/dashboard',
      '/home',
      '/jobs',
      '/study-abroad',
      '/financial-aid',
      '/support',
      '/notifications',
      '/chat',
      '/profile',
      '/services',
      '/universities',
      '/agents',
      '/news',
      '/journey',
      '/admin',
      '/admin-login',
      '/service-provider-registration',
      // New registration forms
      '/register/student',
      '/register/job-seeker',
      '/register/agent',
      '/register/service-provider',
      '/verification-status',
    ];
    
    // Check if current route is public
    final isPublicRoute = publicRoutes.contains(currentPath);

    // If logged in and going to login, redirect to dashboard
    if (isLoggedIn && currentPath == '/login') {
      return '/dashboard';
    }

    // Allow public routes without login
    if (isPublicRoute) {
      return null;
    }

    // For protected routes, check login status
    if (!isLoggedIn) {
      return '/login';
    }

    return null; // No redirect needed
  },
  routes: [
    GoRoute(
      path: '/login',
      name: RouteNames.login,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      name: RouteNames.dashboard,
      builder: (context, state) => const HomeScreen(),
    ),
    // Alias for /home to support login redirect
    GoRoute(
      path: '/home',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/signup',
      name: RouteNames.signup,
      builder: (context, state) => const PlaceholderScreen(title: 'Signup'),
    ),
    GoRoute(
      path: '/profile',
      name: RouteNames.profile,
      builder: (context, state) => const ProfileRegistrationScreen(),
    ),
    GoRoute(
      path: '/profile-registration',
      builder: (context, state) => const ProfileRegistrationScreen(),
    ),
    GoRoute(
      path: '/role-selection',
      builder: (context, state) => const RoleSelectionScreen(),
    ),
    GoRoute(
      path: '/register',
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: '/forgot-password',
      builder: (context, state) => const PlaceholderScreen(title: 'Forgot Password'),
    ),
    GoRoute(
      path: '/services',
      builder: (context, state) => const PlaceholderScreen(title: 'Services'),
    ),
    GoRoute(
      path: '/reviews',
      builder: (context, state) => const PlaceholderScreen(title: 'Reviews'),
    ),
    GoRoute(
      path: '/chat',
      builder: (context, state) => const ChatScreen(),
    ),
    GoRoute(
      path: '/jobs',
      builder: (context, state) => const FindJobsScreen(),
    ),
    GoRoute(
      path: '/study-abroad',
      builder: (context, state) => const StudyAbroadScreen(),
    ),
    GoRoute(
      path: '/financial-aid',
      builder: (context, state) => const FinancialAidScreen(),
    ),
    GoRoute(
      path: '/support',
      builder: (context, state) => const SupportScreen(),
    ),
    GoRoute(
      path: '/universities',
      builder: (context, state) => const StudyAbroadScreen(),
    ),
    GoRoute(
      path: '/agents',
      builder: (context, state) => const PlaceholderScreen(title: 'Trusted Agents'),
    ),
    GoRoute(
      path: '/news',
      builder: (context, state) => const NewsScreen(),
    ),
    GoRoute(
      path: '/journey',
      builder: (context, state) => const PlaceholderScreen(title: 'My Journey'),
    ),
    GoRoute(
      path: '/payments',
      builder: (context, state) => const PaymentMethodsScreen(),
    ),
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
    GoRoute(
      path: '/admin',
      builder: (context, state) => const AdminDashboardScreen(),
    ),
    GoRoute(
      path: '/admin-login',
      builder: (context, state) => const AdminAuthScreen(),
    ),
    GoRoute(
      path: '/service-provider-registration',
      builder: (context, state) => const ServiceProviderRegistrationScreen(),
    ),
    // New Registration Forms with Google Maps
    GoRoute(
      path: '/register/student',
      builder: (context, state) => const StudentSignupForm(),
    ),
    GoRoute(
      path: '/register/job-seeker',
      builder: (context, state) => const JobSeekerSignupForm(),
    ),
    GoRoute(
      path: '/register/agent',
      builder: (context, state) => const AgentSignupForm(),
    ),
    GoRoute(
      path: '/register/service-provider',
      builder: (context, state) => const ServiceProviderSignupForm(),
    ),
    GoRoute(
      path: '/verification-status',
      builder: (context, state) => const VerificationStatusScreen(),
    ),
  ],
);
