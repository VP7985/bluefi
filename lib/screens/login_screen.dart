import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/login_controller.dart';
import '../widgets/custom_text_field.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final LoginController controller = Get.put(LoginController());

    return Scaffold(
      body: Center(
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'BlueFi Login',
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: controller.usernameController,
                  label: 'Username',
                ),
                const SizedBox(height: 16),
                CustomTextField(
                  controller: controller.passwordController,
                  label: 'Password',
                  obscureText: true,
                ),
                const SizedBox(height: 16),
                Obx(() => controller.errorMessage.isNotEmpty
                    ? Text(
                        controller.errorMessage.value,
                        style: const TextStyle(color: Colors.red),
                      )
                    : const SizedBox.shrink()),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: controller.login,
                  style: FilledButton.styleFrom(
                    minimumSize: const Size(double.infinity, 48),
                  ),
                  child: const Text('Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}