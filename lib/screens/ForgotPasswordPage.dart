import 'package:chatappproject/providers/forgot_password_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ForgotPasswordPage extends ConsumerWidget {
  final TextEditingController _emailController = TextEditingController();

  ForgotPasswordPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final forgotPasswordState = ref.watch(forgotPasswordProvider);
    final isLoading = forgotPasswordState.isLoading;
    final isEmailSent = forgotPasswordState.isEmailSent;
    final errorMessage = forgotPasswordState.errorMessage;

    void _sendPasswordResetEmail() {
      final email = _emailController.text.trim();
      if (email.isNotEmpty) {
        ref.read(forgotPasswordProvider.notifier).sendPasswordResetEmail(email);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Please enter your email")),
        );
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: Text("Forgot Password"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "Email",
                hintText: "Enter your email",
                
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 30),
            if (isLoading)
              CircularProgressIndicator()
            else
              CupertinoButton(
                onPressed: _sendPasswordResetEmail,
                    color:  Theme.of(context).colorScheme.primary,
                    borderRadius: BorderRadius.circular(20),
                    child: Text("Send Password Reset Email"),


              ),
            if (isEmailSent)
              Text(
                "A password reset email has been sent.",
                style: TextStyle(color: Colors.green),
              ),
            if (errorMessage != null)
              Text(
                errorMessage,
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
