import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import '../routes/app_routes.dart';

class LoginController extends GetxController {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  final errorMessage = ''.obs;

  void login() {
    const validUsername = 'admin';
    const validPassword = '123456';

    if (usernameController.text == validUsername &&
        passwordController.text == validPassword) {
      errorMessage.value = '';
      Get.offNamed(AppRoutes.bluetooth); // Replaces login screen
    } else {
      errorMessage.value = 'Invalid username or password';
    }
  }

  @override
  void onClose() {
    usernameController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}