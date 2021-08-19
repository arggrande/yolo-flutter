class UserStatsResponse {
  final PlatformInfoResponse platform;
  UserStatsResponse(this.platform);

  factory UserStatsResponse.fromJson(Map<String, dynamic> json) {
    return UserStatsResponse(
        PlatformInfoResponse.fromJson(json['platformInfo']));
  }
}

class PlatformInfoResponse {
  final String platformSlug;
  final String platformUserIdentifier;
  final String platformUserId;
  final String platformUserHandle;
  final String avatarUrl;
  final Object? additionalParameters;

  PlatformInfoResponse(
      {required this.platformSlug,
      required this.platformUserIdentifier,
      required this.platformUserId,
      required this.platformUserHandle,
      required this.avatarUrl,
      required this.additionalParameters});

  factory PlatformInfoResponse.fromJson(Map<String, dynamic> json) {
    return PlatformInfoResponse(
        platformSlug: json['platformSlug'],
        platformUserIdentifier: json['platformUserIdentifier'],
        platformUserId: json['platformUserId'],
        platformUserHandle: json['platformUserHandle'],
        avatarUrl: json['avatarUrl'],
        additionalParameters: json['additionalParameters']);
  }
}
