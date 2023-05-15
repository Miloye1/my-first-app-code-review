import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_state_provider.dart';

final isUserLoggedInProvider = Provider.autoDispose<bool>((ref) {
  final loggedIn = ref.watch(
    authStateProvider.select((provider) => provider.isUserLoggedIn),
  );

  return loggedIn;
});
