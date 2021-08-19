import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:yoloapp/models/trackerApiResponse.dart';
import 'package:yoloapp/models/userStatsResponse.dart';

class TrackerApiClient extends http.BaseClient {
  late final http.Client _client;
  final String _apiKeyHeader = 'TRN-Api-Key';
  late String _key;
  late String _searchApi;
  late String _userApi;
  TrackerApiClient() {
    _client = http.Client();
    _key = dotenv.get('API_KEY');
    _searchApi = dotenv.get('SEARCH_API');
    _userApi = dotenv.get('USER_API');
  }

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    return _client.send(request);
  }

  Map<String, String> _getAuthHeaders() {
    return {_apiKeyHeader: _key};
  }

  /// Searches the Tracker.gg API for a given user. Will return a single (?) person for some reason.
  Future<List<TrackerApiResponse>> search<T>(String query) async {
    var uri = Uri.parse(_searchApi.replaceAll('{query}', query));

    var response = await get(uri, headers: _getAuthHeaders());

    if (response.statusCode == 200) {
      // Use `compute` to not block the UI thread
      var result = await compute(_parseApiListResults, response.body);

      return result;
    }
    throw Exception('oh noesss something went horribly wrong!');
  }

  /// Get a single user's details from the Tracker.gg API
  Future<UserStatsResponse> getUser<T>(String userId, String platform) async {
    // There is a sprintf package that does this type of string formatting a bit nicer
    // but /shrug for now.
    _userApi = _userApi.replaceAll('{platform}', platform);
    _userApi = _userApi.replaceAll('{platformUserIdentifier}', userId);

    var uri = Uri.parse(_userApi);
    var response = await get(uri, headers: _getAuthHeaders());

    if (response.statusCode == 200) {
      // Use `compute` to not block the UI thread
      var result = await compute(_parseApiResult, await response.body);

      return result;
    }
    throw Exception('oh noesss something went horribly wrong!');
  }

  List<TrackerApiResponse> _parseApiListResults<T>(String responseBody) {
    final parsed = jsonDecode(responseBody)['data'];
    return parsed
        .map<TrackerApiResponse>((json) => TrackerApiResponse.fromJson(json))
        .toList();
  }

  UserStatsResponse _parseApiResult<T>(String responseBody) {
    final parsed = jsonDecode(responseBody)['data'];
    return UserStatsResponse.fromJson(parsed);
  }
}
