import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/providers/auth/auth0_provider.dart';
import 'datasources/auth_datasource.dart';
import 'datasources/auth_datasource_impl.dart';

final authDataSourceProvider = Provider<IAuthDataSource>((ref) {
  final Auth0 auth0 = ref.watch(auth0Provider);

  return AuthDataSource(auth0);
});
