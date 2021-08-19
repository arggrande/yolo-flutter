import 'package:flutter/material.dart';

import 'models/trackerApiResponse.dart';
import 'screens/details.dart';
import 'screens/search.dart';
import 'screens/searchResults.dart';

// [ITS DRAGONS TIME!]: Try and change the below to use a Map<String, dynamic> to store our routes and associated types, and then
// have `generateRoutes` grab our desired route from here and pop the args (if any) through.

Route<dynamic>? handleRoutes(RouteSettings settings) {
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
    case Details.routeName:
      final args = settings.arguments as DetailsArguments;
      return MaterialPageRoute(builder: (context) {
        return Details(details: args);
      });
    default:
      {
        assert(false, 'Error: need to implement ${settings.name} route');
        return null;
      }
  }
}
