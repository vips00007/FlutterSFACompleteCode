class LoginRequest {
  final String username;
  final String password;
  final String channel;

  LoginRequest({
    required this.username,
    required this.password,
    this.channel = "SFA_MOBILE",
  });

  Map<String, dynamic> toJson() {
    return {'username': username, 'password': password, 'channel': channel};
  }
}
