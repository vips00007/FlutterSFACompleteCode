class User {
  final String userUuid;
  final String username;
  final String displayName;
  final String companyUuid;
  final String companyCode;
  final List<String> roles;
  final String accessToken;
  final String tokenType;
  final int expiresIn;
  final String expiresAt;
  final bool mustChangePassword;
  final String sessionMode;
  final String channel;

  User({
    required this.userUuid,
    required this.username,
    required this.displayName,
    required this.companyUuid,
    required this.companyCode,
    required this.roles,
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.expiresAt,
    required this.mustChangePassword,
    required this.sessionMode,
    required this.channel,
  });
}
