import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routing/app_route_information_parser.dart';
import 'routing/app_router_delegate.dart';
import 'routing/app_routing.dart';
import 'theme.dart';

class RouterRestorationDemo extends StatefulWidget {
  @override
  _RouterRestorationDemoState createState() => _RouterRestorationDemoState();
}

class _RouterRestorationDemoState extends State<RouterRestorationDemo> {
  final appRouting = AppRouting();

  late final routerDelegate = AppRouterDelegate(appRouting);

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      restorationScopeId: 'root',
      routerDelegate: routerDelegate,
      routeInformationParser: const AppRouteInformationParser(),
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      builder: (context, child) => ListenableProvider.value(
        value: appRouting,
        child: AppRoutingRestoration(
          restorationId: 'appRouting',
          appRouting: appRouting,
          child: child!,
        ),
      ),
    );
  }
}
