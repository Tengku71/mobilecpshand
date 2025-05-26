import 'package:get/get.dart';

class RegisterController extends GetxController {
  // Variabel observable untuk setiap field
  var name = ''.obs; // Nama
  var birthDate = Rxn<DateTime>(); // TTL (nullable DateTime)
  var gender = ''.obs; // Jenis Kelamin
  var email = ''.obs; // Email
  var address = ''.obs; // Alamat
  var password = ''.obs; // Password

  // Fungsi untuk update nilai
  void updateName(String value) {
    name.value = value;
  }

  void updateBirthDate(DateTime? date) {
    birthDate.value = date;
  }

  void updateGender(String value) {
    gender.value = value;
  }

  void updateEmail(String value) {
    email.value = value;
  }

  void updateAddress(String value) {
    address.value = value;
  }

  void updatePassword(String value) {
    password.value = value;
  }

  // Fungsi untuk proses registrasi
  void register() {
    if (name.value.isEmpty ||
        birthDate.value == null ||
        gender.value.isEmpty ||
        email.value.isEmpty ||
        address.value.isEmpty ||
        password.value.isEmpty) {
      Get.snackbar('Error', 'Semua field harus diisi!');
    } else if (!GetUtils.isEmail(email.value)) {
      Get.snackbar('Error', 'Email tidak valid!');
    } else {
      Get.snackbar('Sukses', 'Registrasi berhasil untuk ${name.value}');
      // Tambah logika seperti simpan ke database atau navigasi di sini
    }
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
