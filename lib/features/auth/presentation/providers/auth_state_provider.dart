import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/auth_domain_module.dart';
import '../../domain/usecases/get_credentials.dart';
import '../../domain/usecases/is_user_logged_in.dart';
import '../../domain/usecases/login.dart';
import '../../domain/usecases/logout.dart';
import 'state/auth_state.dart';
import 'state/auth_state_notifier.dart';

final authStateProvider =
    StateNotifierProvider<AuthStateNotifier, AuthState>((ref) {
  final Login login = ref.watch(loginUseCaseProvider);
  final Logout logout = ref.watch(logoutUseCaseProvider);
  final GetCredentials getCredentials =
      ref.watch(getCredentialsUseCaseProvider);
  final IsUserLoggedIn isUserLoggedIn =
      ref.watch(isUserLoggedInUseCaseProvider);

  return AuthStateNotifier(
    loginUseCase: login,
    logoutUseCase: logout,
    isUserLoggedInUseCase: isUserLoggedIn,
    getCredentialsUseCase: getCredentials,
  );
});
