class RegularizationRequest {
  final String date;
  final String reason;
  final String correctLogin;
  final String correctLogout;
  final String? note;

  RegularizationRequest({
    required this.date,
    required this.reason,
    required this.correctLogin,
    required this.correctLogout,
    this.note,
  });

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'reason': reason,
      'correctLogin': correctLogin,
      'correctLogout': correctLogout,
      'note': note,
    };
  }
}
