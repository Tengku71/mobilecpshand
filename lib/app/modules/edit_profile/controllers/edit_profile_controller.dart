import 'package:get/get.dart';
import 'package:mobile/app/data/models/user.dart';

class EditProfileController extends GetxController {
  var user = UserModel(
    name: '',
    profileImage: '',
    level: 0,
    history: [],
    leaderboardScore: 0,
    email: '',
    kelas: '',
    points: 0,
  ).obs;

  void updateUser(String name, String email, String imageUrl) {
    user.update((val) {
      if (val != null) {
        val.name = name;
        val.email = email;
        val.profileImage = imageUrl;
      }
    });
  }
}
