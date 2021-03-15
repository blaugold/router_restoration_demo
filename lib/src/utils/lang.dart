import 'package:flutter/foundation.dart';

extension AnyExt<T> on T {
  R let<R>(R Function(T) fn) => fn(this);
}

extension ParseEnumExt on String {
  T parseAsEnum<T extends Object>(List<T> values) =>
      values.firstWhere((it) => describeEnum(it) == this);
}
