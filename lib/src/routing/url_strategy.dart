import 'url_strategy_stub.dart' if (dart.library.js) 'url_strategy_web.dart'
    as url_strategy;

void setupUrlStrategy() {
  url_strategy.setupUrlStrategy();
}
