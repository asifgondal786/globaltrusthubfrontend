import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:global_trust_hub/core/theme/light_theme.dart';
import 'package:global_trust_hub/core/theme/dark_theme.dart';
import 'package:global_trust_hub/core/config/app_config.dart';

// Providers
import 'package:global_trust_hub/state_management/auth_provider.dart';
import 'package:global_trust_hub/state_management/user_provider.dart';
import 'package:global_trust_hub/state_management/trust_score_provider.dart';
import 'package:global_trust_hub/state_management/journey_provider.dart';
import 'package:global_trust_hub/state_management/theme_provider.dart';
import 'package:global_trust_hub/state_management/services_provider.dart';
import 'package:global_trust_hub/state_management/reviews_provider.dart';
import 'package:global_trust_hub/state_management/chat_provider.dart';
import 'package:global_trust_hub/state_management/news_provider.dart';
import 'package:global_trust_hub/state_management/job_provider.dart';

// Routing
import 'package:global_trust_hub/routing/app_router.dart';

class GlobalTrustHubApp extends StatelessWidget {
  const GlobalTrustHubApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()..initialize()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => TrustScoreProvider()),
        ChangeNotifierProvider(create: (_) => JourneyProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => ServicesProvider()),
        ChangeNotifierProvider(create: (_) => ReviewsProvider()),
        ChangeNotifierProvider(create: (_) => ChatProvider()),
        ChangeNotifierProvider(create: (_) => NewsProvider()),
        ChangeNotifierProvider(create: (_) => JobProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp.router(
            title: AppConfig.appName,
            debugShowCheckedModeBanner: false,
            theme: lightTheme,
            darkTheme: darkTheme,
            themeMode: themeProvider.themeMode,
            routerConfig: appRouter,
          );
        },
      ),
    );
  }
}
