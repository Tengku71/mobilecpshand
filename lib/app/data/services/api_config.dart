class ApiConfig {
  static const String baseUrl =
      'https://7f2d-2404-8000-1013-36-4083-f18b-6d61-da00.ngrok-free.app';

  // You can add more endpoints if needed
  static String loginUrl() => '$baseUrl/login_u';
  static String registerUrl() => '$baseUrl/register';
  static String logout() => '$baseUrl/logout_u';
  static String googleLoginUrl() => '$baseUrl/api/login-google';
  // etc.
}
