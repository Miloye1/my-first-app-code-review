import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LogObserver extends ProviderObserver {
  @override
  void didAddProvider(
    ProviderBase<Object?> provider,
    Object? value,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      print('''
        {
          "provider": "${provider.name ?? provider.runtimeType}",
          "value": "$value",
        }
      ''');
    }
  }

  @override
  void didUpdateProvider(
    ProviderBase<Object?> provider,
    Object? previousValue,
    Object? newValue,
    ProviderContainer container,
  ) {
    if (kDebugMode) {
      print('''
        {
          "provider": "${provider.name ?? provider.runtimeType}",
          "newValue": "$newValue",
          "previousValue": "$previousValue"
        }
      ''');
    }
  }

  @override
  void didDisposeProvider(ProviderBase provider, ProviderContainer container) {
    if (kDebugMode) {
      print('''
        {
          "provider": "${provider.name ?? provider.runtimeType}",
          "newValue": "disposed"
        }
      ''');
    }

    super.didDisposeProvider(provider, container);
  }
}
