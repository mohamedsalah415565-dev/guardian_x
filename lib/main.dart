import 'package:flutter/material.dart';
import 'package:guardian_x/shared/splash/splach_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool completed = prefs.getBool('onboarding_completed') ?? false;
  await Firebase.initializeApp();

  runApp(MyApp(onboardingCompleted: completed));
}

class MyApp extends StatelessWidget {
  final bool onboardingCompleted;
  const MyApp({super.key, required this.onboardingCompleted});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(goToHomeDirectly: onboardingCompleted),
    );
  }
}
