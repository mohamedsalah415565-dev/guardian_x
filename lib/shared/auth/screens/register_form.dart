import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:guardian_x/shared/widgets/custom_elevated_button.dart';
import 'package:guardian_x/shared/widgets/custome_text_form_feild.dart';
import 'package:guardian_x/shared/colors/app_theme.dart';

class RegisterForm extends StatefulWidget {
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final GlobalKey<FormState> formKey;
  final VoidCallback? onRegister;

  const RegisterForm({
    super.key,
    required this.nameController,
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.formKey,
    this.onRegister,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  bool obscurePassword = true;
  bool obscureConfirmPassword = true;
  bool _isLoading = false;

  String? validateName(String? value) {
    if (value == null || value.isEmpty) return "Enter your name";
    return null;
  }

  String? validateEmail(String? value) {
    if (value == null || value.isEmpty) return "Enter your email";
    final regex = RegExp(
      r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9-]+(?:\.[a-zA-Z0-9-]+)*$",
    );
    if (!regex.hasMatch(value)) return "Enter a valid email";
    return null;
  }

  String? validatePassword(String? value) {
    if (value == null || value.isEmpty) return "Enter your password";
    if (value.length < 6) return "Password must be at least 6 characters";
    return null;
  }

  String? validateConfirmPassword(String? value) {
    if (value != widget.passwordController.text) {
      return "Passwords do not match";
    }

    return null;
  }

  Future<void> _register() async {
    if (!widget.formKey.currentState!.validate()) return;
    setState(() => _isLoading = true);

    try {
      final email = widget.emailController.text.trim();
      final password = widget.passwordController.text;
      final name = widget.nameController.text.trim();

      // Firebase registration
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Optionally update display name
      await FirebaseAuth.instance.currentUser?.updateDisplayName(name);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Registration Successful!"),
          backgroundColor: AppTheme.primary,
        ),
      );

      // Call optional callback
      widget.onRegister?.call();
    } on FirebaseAuthException catch (e) {
      String message = "Registration failed";
      if (e.code == 'email-already-in-use') {
        message = "Email already registered";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email";
      } else if (e.code == 'weak-password') {
        message = "Password too weak";
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(message), backgroundColor: AppTheme.red),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Form(
      key: widget.formKey,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Name
          Text("Name", style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          CustomTextField(
            controller: widget.nameController,
            hint: "Enter your name",
            prefixIcon: const Icon(Icons.person),
            validator: validateName,
          ),
          const SizedBox(height: 15),

          // Email
          Text("Email", style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          CustomTextField(
            controller: widget.emailController,
            hint: "Enter your email",
            prefixIcon: const Icon(Icons.email),
            validator: validateEmail,
          ),
          const SizedBox(height: 15),

          // Password
          Text("Password", style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          CustomTextField(
            controller: widget.passwordController,
            hint: "Enter your password",
            obscure: obscurePassword,
            prefixIcon: const Icon(Icons.lock),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
                color: AppTheme.gray,
              ),
              onPressed: () =>
                  setState(() => obscurePassword = !obscurePassword),
            ),
            validator: validatePassword,
          ),
          const SizedBox(height: 15),

          // Confirm Password
          Text("Confirm Password", style: theme.textTheme.titleMedium),
          const SizedBox(height: 10),
          CustomTextField(
            controller: widget.confirmPasswordController,
            hint: "Confirm your password",
            obscure: obscureConfirmPassword,
            prefixIcon: const Icon(Icons.lock_outline),
            suffixIcon: IconButton(
              icon: Icon(
                obscureConfirmPassword
                    ? Icons.visibility_off
                    : Icons.visibility,
                color: AppTheme.gray,
              ),
              onPressed: () => setState(
                () => obscureConfirmPassword = !obscureConfirmPassword,
              ),
            ),
            validator: validateConfirmPassword,
          ),

          _isLoading
              ? Center(child: CircularProgressIndicator())
              : CustomButton(text: "Register", onPressed: _register),
        ],
      ),
    );
  }
}
