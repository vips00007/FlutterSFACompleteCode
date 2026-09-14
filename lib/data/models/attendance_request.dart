class AttendanceRequest {
  final String selfie;
  final double latitude;
  final double longitude;
  final double accuracyMeters;
  final String capturedAt;

  AttendanceRequest({
    required this.selfie,
    required this.latitude,
    required this.longitude,
    required this.accuracyMeters,
    required this.capturedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'selfie': selfie,
      'latitude': latitude,
      'longitude': longitude,
      'accuracyMeters': accuracyMeters.round(),
      'capturedAt': capturedAt,
    };
  }
}
