import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:global_trust_hub/app.dart';
import 'package:global_trust_hub/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase initialization with proper options
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("Firebase initialized successfully!");
  } catch (e) {
    debugPrint("Firebase failed to initialize: $e");
  }

  runApp(const GlobalTrustHubApp());
}

