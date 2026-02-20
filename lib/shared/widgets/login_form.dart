import 'package:flutter/material.dart';
import 'package:guardian_x/shared/auth/services/auth_service.dart';
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
          const SizedBox(height: 10),

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

          /// Forgot password button
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () async {
                  if (widget.emailController.text.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Enter your email first")),
                    );
                    return;
                  }

                  try {
                    // الـ Async Gap بتبدأ هنا
                    await AuthService.resetPassword(
                      widget.emailController.text.trim(),
                    );

                    // التشيك السليم على الـ context
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text("Reset email sent")),
                    );
                  } catch (e) {
                    if (!context.mounted) return;

                    ScaffoldMessenger.of(
                      context,
                    ).showSnackBar(SnackBar(content: Text(e.toString())));
                  }
                },
                child: const Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
