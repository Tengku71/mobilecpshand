import 'package:get/get.dart';

class ForgotController extends GetxController {
  var email = ''.obs;

  void submitForgotPassword() {
    if (email.value.isEmpty) {
      Get.snackbar('Error', 'Email harus diisi!');
    } else if (!GetUtils.isEmail(email.value)) {
      Get.snackbar('Error', 'Format email tidak valid!');
    } else {
      Get.snackbar(
          'Sukses', 'Instruksi reset password telah dikirim ke ${email.value}');
      // Tambah logika seperti kirim email atau navigasi ke halaman lain di sini
    }
  }

  // Fungsi untuk update nilai email
  void updateEmail(String value) {
    email.value = value;
  }

  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
