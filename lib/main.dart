import 'package:flutter/material.dart';
import 'package:guardian_x/home_screen.dart';
import 'package:guardian_x/shared/auth/screens/register_screen.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

import 'package:guardian_x/shared/colors/app_theme.dart';
import 'package:guardian_x/shared/splash/splach_screen.dart';
import 'package:guardian_x/shared/auth/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  /// Initialize Firebase
  await Firebase.initializeApp();

  /// Check onboarding status from SharedPreferences
  final prefs = await SharedPreferences.getInstance();
  final bool onboardingCompleted =
      prefs.getBool('onboarding_completed') ?? false;

  /// Run app
  runApp(MyApp(onboardingCompleted: onboardingCompleted));
}

class MyApp extends StatelessWidget {
  final bool onboardingCompleted;

  const MyApp({super.key, required this.onboardingCompleted});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,

      /// App theme
      theme: AppTheme.lightTheme,

      /// First screen
      home: SplashScreen(goToHomeDirectly: onboardingCompleted),

      /// App routes
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/home': (context) => HomeScreen(),
      },
    );
  }
}
