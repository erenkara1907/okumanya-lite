/// LoginResponse class represents the response received after a successful login.
class LoginResponse {
  /// Creates an instance of [LoginResponse].
  LoginResponse({
    required this.token,
  });

  /// Creates a [LoginResponse] instance from a JSON map.
  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      token: json['token'] as String,
    );
  }

  /// The authentication token received upon successful login.
  final String token;

  /// Converts the [LoginResponse] instance to a JSON map.
  Map<String, dynamic> toJson() {
    return {
      'token': token,
    };
  }
}
