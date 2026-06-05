import 'package:hooks_riverpod/hooks_riverpod.dart';

extension AsyncValueValueOrNull<T> on AsyncValue<T> {
  T? get valueOrNull => unwrapPrevious().value;
}
