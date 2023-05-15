import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_state_provider.dart';

final credentialsProvider = Provider.autoDispose<Credentials?>((ref) {
  final credentials = ref.watch(
    authStateProvider.select((provider) => provider.credentials),
  );

  return credentials;
});
