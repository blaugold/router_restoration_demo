import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

import 'app_routing.dart';

class AppRouteInformationParser extends RouteInformationParser<AppRouting> {
  const AppRouteInformationParser();

  @override
  Future<AppRouting> parseRouteInformation(
    RouteInformation routeInformation,
  ) =>
      SynchronousFuture(AppRouting.fromRouteInformation(
        routeInformation,
        source: RoutingStateSource.navigation,
      ));

  @override
  RouteInformation? restoreRouteInformation(AppRouting configuration) =>
      configuration.toRouteInformation();
}
