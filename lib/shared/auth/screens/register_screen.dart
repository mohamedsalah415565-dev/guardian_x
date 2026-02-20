import 'package:flutter/material.dart';
import 'package:guardian_x/shared/auth/screens/add_profile_screen.dart';
import 'package:guardian_x/shared/auth/screens/login_screen.dart';
import 'package:guardian_x/shared/widgets/register_form.dart';
import 'package:guardian_x/shared/colors/app_theme.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  // Route name used for navigation
  static const String routeName = '/RegisterScreen';

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Controllers to read user input
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  // Form key for validation
  final formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // IMPORTANT: Always dispose controllers to prevent memory leaks
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  /// Called when registration succeeds
  void onRegisterSuccess() {
    // OPTIONAL SAFETY: check if widget still mounted
    if (!mounted) return;

    // Navigate to AddProfileScreen
    // pushReplacement removes RegisterScreen from stack
    Navigator.pushReplacementNamed(context, AddProfileScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.background,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),

          child: Column(
            children: [
              const SizedBox(height: 10),

              /// Top illustration image
              /// Make sure this exists in pubspec.yaml
              Image.asset(
                'assets/images/login_image.png',
                height: screenHeight * 0.22,
                fit: BoxFit.contain,
              ),

              const SizedBox(height: 10),

              /// Title
              Text("Create Account", style: theme.textTheme.headlineMedium),

              const SizedBox(height: 10),

              /// Register form widget
              /// This handles validation + calling AuthService.register()
              RegisterForm(
                emailController: emailController,
                passwordController: passwordController,
                confirmPasswordController: confirmPasswordController,
                formKey: formKey,

                // This function is called when registration succeeds
                onRegister: onRegisterSuccess,
              ),

              const SizedBox(height: 10),

              /// Navigate to login screen
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: theme.textTheme.bodyMedium,
                  ),

                  TextButton(
                    /// Navigate to LoginScreen
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                      );
                    },

                    child: const Text(
                      "Login",
                      style: TextStyle(
                        color: AppTheme.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
