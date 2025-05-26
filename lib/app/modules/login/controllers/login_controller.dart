import 'package:get/get.dart';
import 'package:mobile/app/data/services/auth_services.dart';
import 'package:mobile/app/routes/app_pages.dart';

class LoginController extends GetxController {
  var email = ''.obs;
  var password = ''.obs;

  final AuthService _authService;

  // Inject AuthService via constructor
  LoginController({required AuthService authService})
      : _authService = authService;

  void updateEmail(String value) => email.value = value;
  void updatePassword(String value) => password.value = value;

  /// Email & Password Login
  void login() async {
    if (email.value.isEmpty || password.value.isEmpty) {
      Get.snackbar('Error', 'Email dan password tidak boleh kosong');
      return;
    }

    final result = await _authService.login(email.value, password.value);

    if (result['success']) {
      Get.snackbar('Berhasil', 'Logout berhasil');
      Get.offAllNamed(Routes.HOME);
    } else {
      Get.snackbar('Gagal', result['message']);
    }
  }

  /// Google Sign-In Login
  void loginWithGoogle() async {
    final result = await _authService.loginWithGoogle();

    if (result['success']) {
      Get.snackbar('Berhasil', 'Login Google berhasil');
      Get.offAllNamed(Routes.HOME);
    } else {
      // print(result);
      Get.snackbar('Gagal', result['message']);
    }
  }
}
