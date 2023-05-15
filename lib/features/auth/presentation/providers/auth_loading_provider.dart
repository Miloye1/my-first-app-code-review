import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'auth_state_provider.dart';

final authLoadingProvider = Provider.autoDispose<bool>((ref) {
  final loading = ref.watch(
    authStateProvider.select((provider) => provider.isLoading),
  );

  return loading;
});
