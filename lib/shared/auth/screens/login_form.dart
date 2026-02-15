import 'package:flutter/material.dart';
import 'package:guardian_x/shared/widgets/custome_text_form_feild.dart';

class LoginForm extends StatefulWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final GlobalKey<FormState> formKey;

  const LoginForm({
    super.key,
    required this.emailController,
    required this.passwordController,
    required this.formKey,
  });

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  bool obscurePassword = true;

  void _showForgotPasswordDialog() {
    final TextEditingController resetEmailController = TextEditingController(
      text: widget.emailController.text,
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Reset Password"),
        content: TextFormField(
          controller: resetEmailController,
          decoration: const InputDecoration(
            hintText: "Enter your email",
            prefixIcon: Icon(Icons.email_outlined),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () {
              // TODO: Add password reset logic

              Navigator.pop(context);
            },
            child: const Text("Send"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Email",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: widget.emailController,
            hint: "Enter your email",
            prefixIcon: const Icon(Icons.email_outlined, size: 26),
            validator: (value) => (value == null || !value.contains('@'))
                ? "Enter a valid email"
                : null,
          ),
          const SizedBox(height: 5),
          const Text(
            "Password",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          const SizedBox(height: 10),
          CustomTextField(
            controller: widget.passwordController,
            hint: "Enter your password",
            obscure: obscurePassword,
            prefixIcon: const Icon(Icons.lock_outline, size: 26),
            suffixIcon: IconButton(
              icon: Icon(
                obscurePassword ? Icons.visibility_off : Icons.visibility,
              ),
              onPressed: () =>
                  setState(() => obscurePassword = !obscurePassword),
            ),
            validator: (value) => (value == null || value.length < 6)
                ? "Password too short"
                : null,
          ),

          /// Forgot Password
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: _showForgotPasswordDialog,
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
