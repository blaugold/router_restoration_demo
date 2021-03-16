import 'package:flutter/material.dart';

import 'src/router_restoration_demo.dart';
import 'src/routing/url_strategy.dart';

void main() {
  setupUrlStrategy();

  runApp(RouterRestorationDemo());
}
