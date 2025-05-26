import 'package:get/get.dart';
import 'package:mobile/app/data/models/user.dart';

class HomeController extends GetxController {
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

  var selectedIndex = 0.obs;

  @override
  void onInit() {
    fetchUser();
    print("home");
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
      email: "",
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
