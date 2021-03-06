class TrackerApiResponse {
  final int platformId;
  final String platformSlug;
  final String platformUserIdentifier;
  final String platformUserId;
  final String platformUserHandle;
  final String avatarUrl;
  final String? status;
  final Object? additionalParameters;

  TrackerApiResponse(
      {required this.platformId,
      required this.platformSlug,
      required this.platformUserIdentifier,
      required this.platformUserId,
      required this.platformUserHandle,
      required this.avatarUrl,
      required this.status,
      required this.additionalParameters});

  factory TrackerApiResponse.fromJson(Map<String, dynamic> json) {
    return TrackerApiResponse(
        platformId: json['platformId'] as int,
        platformSlug: json['platformSlug'],
        platformUserIdentifier: json['platformUserIdentifier'],
        platformUserId: json['platformUserId'],
        platformUserHandle: json['platformUserHandle'],
        avatarUrl: json['avatarUrl'],
        status: json['status'],
        additionalParameters: json['additionalParameters']);
  }
}
