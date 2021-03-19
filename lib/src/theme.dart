import 'package:animations/animations.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'utils/lang.dart';

class AppTheme {
  static final light = ThemeData.from(
    colorScheme: ColorScheme.light(),
  ).let(_customizeTheme);

  static final dark = ThemeData.from(
    colorScheme: ColorScheme.dark(),
  ).let(_customizeTheme);

  static final _textButtonTheme = TextButtonThemeData(
    style: TextButton.styleFrom(
      // On desktop the default vertical padding is canceled out by
      // `VisualDensity.compact`. We double the vertical padding, everywhere.
      padding: EdgeInsets.symmetric(
        vertical: 8,
        horizontal: 16,
      ),
    ),
  );

  static final _appBarTheme = AppBarTheme(
    backwardsCompatibility: false,
    systemOverlayStyle: SystemUiOverlayStyle.light,
  );

  static final _pageTransitionTheme = PageTransitionsTheme(
    builders: TargetPlatform.values
        .map((e) => MapEntry(e, FadeThroughPageTransitionsBuilder()))
        .let((it) => Map.fromEntries(it)),
  );

  static ThemeData _customizeTheme(ThemeData theme) => theme.copyWith(
        appBarTheme: _appBarTheme,
        textButtonTheme: _textButtonTheme,
        pageTransitionsTheme: _pageTransitionTheme,
      );
}
