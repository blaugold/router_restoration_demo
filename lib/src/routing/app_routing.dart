import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import '../pages/home_page.dart';
import '../pages/messages_page.dart';
import '../pages/photos_page.dart';
import '../utils/lang.dart';

/// The sources of the routing state.
enum RoutingStateSource {
  navigation,
  restoration,
}

/// The main navigation routes.
enum MainNavigation {
  content,
  settings,
  profile,
}

/// The sub routes of the [MainNavigation.content] route.
enum SelectedContent {
  photos,
  messages,
}

/// The routing logic of the app.
class AppRouting extends ChangeNotifier {
  AppRouting({
    MainNavigation mainNavigation = MainNavigation.content,
    SelectedContent? selectedContent,
    RoutingStateSource? source,
  })  : _mainNavigation = mainNavigation,
        _selectedContent = selectedContent,
        _source = source;

  /// The source of the current routing state, or null if there is no single
  /// source.
  RoutingStateSource? get source => _source;
  RoutingStateSource? _source;

  /// The current main navigation route.
  MainNavigation get mainNavigation => _mainNavigation;
  MainNavigation _mainNavigation;

  set mainNavigation(MainNavigation mainNavigation) {
    _setPartialState(() {
      if (mainNavigation != MainNavigation.content) {
        _selectedContent = null;
      }

      _mainNavigation = mainNavigation;
    });
  }

  SelectedContent? _selectedContent;

  SelectedContent? get selectedContent => _selectedContent;

  /// The current sub route of [MainNavigation.content].
  ///
  /// Can only be non-null if [mainNavigation] is [MainNavigation.content].
  set selectedContent(SelectedContent? selectedContent) {
    assert(mainNavigation == MainNavigation.content);

    _setPartialState(() {
      _selectedContent = selectedContent;
    });
  }

  /// Used to wrap the code which makes partial changes to the routing state.
  void _setPartialState(void Function() fn) {
    fn();
    _source = null;
    notifyListeners();
  }

  /// Absorbs the current state of [other] into this instance.
  void absorb(AppRouting other) {
    if (this == other) return;

    _source = other._source;
    _mainNavigation = other.mainNavigation;
    _selectedContent = other.selectedContent;

    notifyListeners();
  }

  /// Updates the routing state so that [buildPages], when called the next time,
  /// returns a list without the top page.
  ///
  /// Returns `true` if the current routing state allowed a page to be popped,
  /// otherwise returns `false`.
  bool popPage() {
    if (selectedContent != null) {
      selectedContent = null;
      return true;
    }

    return false;
  }

  /// Builds the apps [Page]s according to the current routing state.
  List<Page> buildPages(BuildContext context) {
    final pages = <Page>[
      RestorableMaterialPage<void>(
        restorationId: 'home',
        child: HomePage(),
      ),
    ];

    switch (selectedContent) {
      case SelectedContent.photos:
        pages.add(RestorableMaterialPage<void>(
          restorationId: 'photos',
          child: PhotosPage(),
        ));
        break;
      case SelectedContent.messages:
        pages.add(RestorableMaterialPage<void>(
          restorationId: 'messages',
          child: MessagesPage(),
        ));
        break;
      default:
    }

    return pages;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AppRouting &&
          runtimeType == other.runtimeType &&
          source == other.source &&
          mainNavigation == other.mainNavigation &&
          selectedContent == other.selectedContent;

  @override
  int get hashCode =>
      super.hashCode ^
      source.hashCode ^
      mainNavigation.hashCode ^
      selectedContent.hashCode;

  @override
  String toString() => 'AppRouting('
      'source: $source, '
      'mainNavigation: $mainNavigation, '
      'selectedContent: $selectedContent'
      ')';

  /// Creates the app routing state from [RouteInformation].
  factory AppRouting.fromRouteInformation(
    RouteInformation routeInformation, {
    required RoutingStateSource source,
  }) {
    final url = Uri.parse(routeInformation.location!);
    final pathSegments = url.pathSegments.toList();

    final mainNavigation = pathSegments.isNotEmpty
        ? pathSegments.removeAt(0).parseAsEnum(MainNavigation.values)
        : MainNavigation.content;

    final selectedContent = pathSegments.isNotEmpty
        ? pathSegments.removeAt(0).parseAsEnum(SelectedContent.values)
        : null;

    return AppRouting(
      mainNavigation: mainNavigation,
      selectedContent: selectedContent,
      source: source,
    );
  }

  /// Serializes the app routing state into [RouteInformation].
  RouteInformation toRouteInformation() {
    var location = '/${describeEnum(mainNavigation)}';

    if (selectedContent != null) {
      location += '/${describeEnum(selectedContent!)}';
    }

    return RouteInformation(
      location: location,
    );
  }
}

/// An extension of [MaterialPage] which exposes the [restorationId] field.
class RestorableMaterialPage<T> extends MaterialPage<T> {
  RestorableMaterialPage({
    required Widget child,
    bool maintainState = true,
    bool fullscreenDialog = false,
    LocalKey? key,
    String? name,
    Object? arguments,
    this.restorationId,
  }) : super(
          child: child,
          maintainState: maintainState,
          fullscreenDialog: fullscreenDialog,
          key: key,
          name: name,
          arguments: arguments,
        );

  @override
  final String? restorationId;
}

/// A [RestorableProperty] which makes an [AppRouting] instance restorable.
class RestorableAppRouting extends RestorableProperty<AppRouting> {
  RestorableAppRouting(this.appRouting) {
    appRouting.addListener(notifyListeners);
  }

  final AppRouting appRouting;

  @override
  void dispose() {
    appRouting.removeListener(notifyListeners);
    super.dispose();
  }

  @override
  AppRouting createDefaultValue() => appRouting;

  @override
  void initWithValue(AppRouting value) => appRouting.absorb(value);

  @override
  AppRouting fromPrimitives(Object? data) => AppRouting.fromRouteInformation(
        RouteInformation(location: data as String),
        source: RoutingStateSource.restoration,
      );

  @override
  Object? toPrimitives() => appRouting.toRouteInformation().location;
}
