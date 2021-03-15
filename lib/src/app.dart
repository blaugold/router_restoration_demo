import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'theme.dart';
import 'routing/app_route_information_parser.dart';
import 'routing/app_router_delegate.dart';
import 'routing/app_routing.dart';

class RouterRestorationDemo extends StatelessWidget {
  @override
  Widget build(BuildContext context) => RootRestorationScope(
        restorationId: 'root',
        child: _App(),
      );
}

class _App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<_App> with RestorationMixin {
  final appRouting = AppRouting();

  late final routerDelegate = AppRouterDelegate(appRouting);

  late final restorableAppRouting = RestorableAppRouting(appRouting);

  @override
  final restorationId = 'app';

  @override
  void restoreState(RestorationBucket? oldBucket, bool initialRestore) {
    registerForRestoration(restorableAppRouting, 'appRouting');
  }

  @override
  Widget build(BuildContext context) {
    return ListenableProvider.value(
      value: appRouting,
      child: MaterialApp.router(
        debugShowCheckedModeBanner: false,
        routerDelegate: routerDelegate,
        routeInformationParser: const AppRouteInformationParser(),
        theme: AppTheme.light,
        darkTheme: AppTheme.dark,
      ),
    );
  }
}
