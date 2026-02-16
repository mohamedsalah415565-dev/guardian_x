import 'package:flutter/material.dart';
import 'package:guardian_x/shared/auth/screens/login_form.dart';
import 'package:guardian_x/shared/auth/screens/register_screen.dart';
import 'package:guardian_x/shared/colors/app_theme.dart';
import 'package:guardian_x/shared/widgets/custom_elevated_button.dart';
import 'package:guardian_x/shared/widgets/google_login_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: AppTheme.background,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              // 1. Top Illustration
              Padding(
                padding: EdgeInsets.symmetric(vertical: 22),
                child: Image.asset(
                  'assets/images/login_image.png',
                  height: screenHeight * 0.25,
                  fit: BoxFit.contain,
                ),
              ),

              // 2. The Input Form (Email & Password)
              LoginForm(
                emailController: emailController,
                passwordController: passwordController,
                formKey: formKey,
              ),
              SizedBox(height: 16),

              // 3. Primary Login Button
              _isLoading
                  ? CircularProgressIndicator(color: AppTheme.primary)
                  : CustomButton(
                      text: 'Login',
                      onPressed: () {
                        if (formKey.currentState!.validate()) {
                          setState(() => _isLoading = true);
                          Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/home',
                            (route) => false,
                          );

                          // Firebase login logic here
                        }
                      },
                    ),
              SizedBox(height: 22),

              // 4. Social Divider
              Row(
                children: [
                  Expanded(child: Divider(thickness: 1.2)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: Text('OR', style: theme.textTheme.bodyMedium),
                  ),
                  Expanded(child: Divider(thickness: 1.2)),
                ],
              ),

              SizedBox(height: 16),

              // 5. Google Login Button
              LoginGoogleButton(onTap: () {}),

              SizedBox(height: 20),

              // 6. Footer: Register Link
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: theme.textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.normal,
                    ),
                  ),
                  TextButton(
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => RegisterScreen()),
                    ),
                    child: Text(
                      'Register',
                      style: theme.textTheme.bodyMedium!.copyWith(
                        color: AppTheme.red,
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
