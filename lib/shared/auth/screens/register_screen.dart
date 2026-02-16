import 'package:flutter/material.dart';
import 'package:guardian_x/shared/colors/app_theme.dart';
import 'package:guardian_x/shared/widgets/custom_elevated_button.dart';
import 'package:guardian_x/shared/widgets/google_login_button.dart';
import 'package:guardian_x/shared/widgets/custome_text_form_feild.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final nameController = TextEditingController();
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
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 24),
                  child: Image.asset(
                    'assets/images/login_image.png',
                    height: screenHeight * 0.20,
                    fit: BoxFit.contain,
                  ),
                ),
                Center(
                  child: Text(
                    'Create Acount',
                    style: theme.textTheme.headlineMedium,
                  ),
                ),
                SizedBox(height: 10),
                _buildLabel('Full Name'),
                CustomTextField(
                  controller: nameController,
                  hint: 'Enter your name',
                  prefixIcon: Icon(Icons.person_outline, size: 26),
                ),
                SizedBox(height: 10),
                _buildLabel('Email'),
                CustomTextField(
                  controller: emailController,
                  hint: 'Enter your email',
                  prefixIcon: Icon(Icons.email_outlined, size: 26),
                ),
                SizedBox(height: 10),
                _buildLabel('Password'),
                CustomTextField(
                  controller: passwordController,
                  hint: '••••••••',
                  obscure: true,
                  prefixIcon: Icon(Icons.lock_outline, size: 26),
                ),
                SizedBox(height: 20),
                _isLoading
                    ? CircularProgressIndicator(color: AppTheme.primary)
                    : CustomButton(
                        text: 'Register',
                        onPressed: () => setState(() => _isLoading = true),
                      ),

                SizedBox(height: 20),

                _buildFooter(
                  context,
                  "Already have an account? ",
                  'Login',
                  () => Navigator.pop(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) => Padding(
    padding: EdgeInsets.only(bottom: 10),
    child: Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
    ),
  );

  Widget _buildDivider(ThemeData theme) => Row(
    children: [
      Expanded(child: Divider(thickness: 1.2)),
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 12),
        child: Text('OR', style: theme.textTheme.bodyMedium),
      ),
      Expanded(child: Divider(thickness: 1.2)),
    ],
  );

  Widget _buildFooter(
    BuildContext context,
    String text,
    String link,
    VoidCallback onTap,
  ) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Text(text, style: Theme.of(context).textTheme.bodyMedium),
      TextButton(
        onPressed: onTap,
        child: Text(
          link,
          style: TextStyle(color: AppTheme.red, fontWeight: FontWeight.bold),
        ),
      ),
    ],
  );
}
