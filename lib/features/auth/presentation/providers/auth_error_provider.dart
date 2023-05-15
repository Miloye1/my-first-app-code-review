import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/errors/failures.dart';
import 'auth_state_provider.dart';

final authErrorProvider = Provider.autoDispose<Failure?>((ref) {
  final error = ref.watch(
    authStateProvider.select((provider) => provider.error),
  );

  return error;
});
