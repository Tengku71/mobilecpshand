import 'package:get/get.dart';
import 'package:mobile/app/data/models/user.dart';
import 'package:mobile/app/data/services/auth_services.dart';
import 'package:mobile/app/routes/app_pages.dart';

class ProfileController extends GetxController {
  final AuthService _authService;
  ProfileController({required AuthService authService})
      : _authService = authService;

  void logout() async {
    final result = await _authService.logout();

    if (result['success']) {
      Get.snackbar('Berhasil', 'Login berhasil');
      Get.offAllNamed(Routes.LOGIN);
    } else {
      Get.snackbar('Gagal', result['message']);
    }
  }

  var user = UserModel(
          name: "Loading...",
          profileImage: "",
          level: 0,
          history: [],
          leaderboardScore: 0,
          email: "",
          kelas: "",
          points: 0)
      .obs;

  @override
  void onInit() {
    fetchUser();
    super.onInit();
  }

  void fetchUser() async {
    // Simulating a delay, replace this with your actual DB call
    await Future.delayed(Duration(seconds: 1));
    user.value = UserModel(
      name: "Rayhan",
      profileImage: "https://picsum.photos/200",
      level: 5,
      history: ["Level 1", "Level 2", "Level 3", "Level 4", "Level 5"],
      leaderboardScore: 420,
      email: "@gmail.com",
      kelas: "",
      points: 0,
    );
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
