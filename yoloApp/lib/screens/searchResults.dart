import 'package:flutter/material.dart';
import 'package:yoloapp/models/trackerApiResponse.dart';

class SearchResults extends StatelessWidget {
  SearchResults({Key? key, required this.results});
  late final List<TrackerApiResponse> results;

  static const String routeName = '/results';

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [Text('hello')],
    );
  }
}
