import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'app_routing.dart';

class AppRouterDelegate extends RouterDelegate<AppRouting>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  AppRouterDelegate(this.appRouting) {
    appRouting.addListener(notifyListeners);
  }

  final AppRouting appRouting;

  @override
  AppRouting get currentConfiguration => appRouting;

  @override
  Future<void> setInitialRoutePath(AppRouting configuration) {
    // The routing state from state restoration takes precedence over
    // the routing state from the navigation system.
    if (appRouting.source != RoutingStateSource.restoration) {
      return setNewRoutePath(configuration);
    }

    return SynchronousFuture(null);
  }

  @override
  Future<void> setNewRoutePath(configuration) {
    appRouting.absorb(configuration);
    return SynchronousFuture(null);
  }

  @override
  void dispose() {
    appRouting.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  final navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) => Navigator(
        restorationScopeId: 'rootNavigator',
        pages: appRouting.buildPages(context),
        onPopPage: (route, dynamic result) {
          if (!route.didPop(result)) {
            return false;
          }

          return appRouting.popPage();
        },
      );
}
