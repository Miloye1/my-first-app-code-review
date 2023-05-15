import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/presentation/providers/auth_state_provider.dart';

class TokenInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final provider = ProviderContainer();
    final credentials =
        await provider.read(authStateProvider.notifier).getCredentials();

    if (credentials != null) {
      options.headers[HttpHeaders.authorizationHeader] =
          'Bearer ${credentials.accessToken}';
    }

    handler.next(options);
  }
}
