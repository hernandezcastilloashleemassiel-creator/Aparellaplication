class LoginResponse {
  final String token;
  final String userName;
  final List<String> roles;

  LoginResponse({
    required this.token,
    required this.userName,
    required this.roles,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
      userName: json['userName'] as String,
      roles: List<String>.from(json['roles'] ?? []),
    );
  }
}