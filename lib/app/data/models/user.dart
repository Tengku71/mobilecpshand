class UserModel {
  String name;
  String profileImage;
  int level;
  List<String> history;
  int leaderboardScore;
  String email;
  String kelas;
  int points;

  UserModel({
    required this.name,
    required this.profileImage,
    required this.level,
    required this.history,
    required this.leaderboardScore,
    required this.email,
    required this.kelas,
    required this.points,
  });

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      name: map['name'] ?? '',
      profileImage: map['profileImage'] ?? '',
      level: map['level'] ?? 0,
      history: List<String>.from(map['history'] ?? []),
      leaderboardScore: map['leaderboardScore'] ?? 0,
      email: map['email'] ?? '',
      kelas: map['kelas'] ?? '',
      points: map['points'] ?? 0,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'profileImage': profileImage,
      'level': level,
      'history': history,
      'leaderboardScore': leaderboardScore,
      'email': email,
      'kelas': kelas,
      'points': points,
    };
  }
}
