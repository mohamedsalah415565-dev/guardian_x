import 'package:flutter/material.dart';
import 'package:guardian_x/shared/auth/screens/login_screen.dart';

import 'package:guardian_x/shared/on_boarding/onboarding_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key, required bool goToHomeDirectly});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;
  late Animation<double> fadeLogo;
  late Animation<double> fadeVersion;
  late Animation<Offset> moveLogo;
  late Animation<double> fadeText;
  late Animation<Offset> moveText;
  late Animation<double> zoomIn;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    );

    fadeLogo = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.0, 0.2, curve: Curves.easeOut),
      ),
    );

    moveLogo = Tween(begin: Offset.zero, end: const Offset(0.7, 0)).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.25, 0.5, curve: Curves.easeInOut),
      ),
    );

    fadeText = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.45, 0.7, curve: Curves.easeOut),
      ),
    );

    moveText = Tween(begin: const Offset(-1.5, 0), end: Offset.zero).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.45, 0.7, curve: Curves.easeOut),
      ),
    );

    zoomIn = Tween(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(
        parent: controller,
        curve: const Interval(0.75, 0.95, curve: Curves.easeIn),
      ),
    );

    controller.forward();
    controller.addStatusListener((status) async {
      if (status == AnimationStatus.completed) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        bool completed = prefs.getBool('onboarding_completed') ?? false;

        if (!mounted) return;

        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (_) => completed ? LoginScreen() : const OnBording(),
            ),
          );
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Stack(
            children: [
              Center(
                child: Transform.scale(
                  scale: zoomIn.value,
                  child: Opacity(
                    opacity: controller.value > 0.9
                        ? (1.0 - ((controller.value - 0.9) / 0.1))
                        : 1.0,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        SlideTransition(
                          position: moveLogo,
                          child: FadeTransition(
                            opacity: fadeLogo,
                            child: Opacity(
                              opacity: fadeLogo.value > 0 ? 1.0 : 0.0,
                              child: Image.asset(
                                "assets/icons/short logo 1.png",
                                width: 180,
                                height: 180,
                              ),
                            ),
                          ),
                        ),

                        Positioned(
                          left: -80,
                          child: SlideTransition(
                            position: moveText,
                            child: FadeTransition(
                              opacity: fadeText,
                              child: Image.asset(
                                "assets/images/Text.jpg",
                                height: 250,
                                width: 250,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }
}
