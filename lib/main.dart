import 'package:flutter/material.dart';

import 'src/app.dart';
import 'src/routing/url_strategy.dart';

void main() {
  setupUrlStrategy();

  runApp(RouterRestorationDemo());
}
