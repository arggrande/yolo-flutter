import 'package:flutter/material.dart';

import 'models/trackerApiResponse.dart';
import 'screens/search.dart';
import 'screens/searchResults.dart';

// ignore: todo
// TODO Try this later: Map<String, dynamic> _routes = {'/': Search, '/results': SearchResults};

Route<dynamic>? generateRoutes(RouteSettings settings) {
  switch (settings.name) {
    case Search.routeName:
      return MaterialPageRoute(builder: (context) {
        return Search();
      });

    case SearchResults.routeName:
      final args = settings.arguments as List<TrackerApiResponse>;
      return MaterialPageRoute(builder: (context) {
        return SearchResults(results: args);
      });
    default:
      {
        assert(false, 'Need to implement ${settings.name} route');
        return null;
      }
  }
}
