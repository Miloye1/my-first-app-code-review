import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

class Listener<T> extends Mock {
  void call(T? previous, T? next);
}

ProviderContainer makeTestProviderContainer(List<Override> overrides) {
  final container = ProviderContainer(
    overrides: overrides,
    // observers: [LogObserver()],
  );

  addTearDown(container.dispose);

  return container;
}
