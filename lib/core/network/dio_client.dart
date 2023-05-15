import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'interceptors/token_interceptor.dart';

final dioProvider = Provider.autoDispose<Dio>((ref) {
  Dio dio = Dio();

  dio.interceptors.add(TokenInterceptor());

  ref.onDispose(() => dio.close());

  return dio;
});
