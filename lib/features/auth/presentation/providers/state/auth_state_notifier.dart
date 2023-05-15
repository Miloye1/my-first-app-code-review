import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../domain/usecases/get_credentials.dart';
import '../../../domain/usecases/is_user_logged_in.dart';
import '../../../domain/usecases/login.dart';
import '../../../domain/usecases/logout.dart';
import 'auth_state.dart';

class AuthStateNotifier extends StateNotifier<AuthState> {
  final Login _loginUseCase;
  final Logout _logoutUseCase;
  final IsUserLoggedIn _isUserLoggedInUseCase;
  final GetCredentials _getCredentialsUseCase;

  AuthStateNotifier({
    required loginUseCase,
    required logoutUseCase,
    required isUserLoggedInUseCase,
    required getCredentialsUseCase,
  })  : _loginUseCase = loginUseCase,
        _logoutUseCase = logoutUseCase,
        _isUserLoggedInUseCase = isUserLoggedInUseCase,
        _getCredentialsUseCase = getCredentialsUseCase,
        super(const AuthState.initial());

  Future<void> isUserLoggedIn() async {
    final result = await _isUserLoggedInUseCase();

    state = result.fold(
      (error) => state.copyWith(
        isLoading: false,
        error: error,
      ),
      (response) => state.copyWith(
        isLoading: false,
        isUserLoggedIn: response,
      ),
    );
  }

  //TODO: pressing back on auth0 page breaks the state, check what is going on
  Future<void> login() async {
    state = state.setLoading(true);
    final result = await _loginUseCase();

    state = result.fold(
      (error) => state.copyWith(
        isLoading: false,
        error: error,
      ),
      (response) => state.copyWith(
        isLoading: false,
        credentials: response,
        isUserLoggedIn: true,
      ),
    );
  }

  Future<void> logout() async {
    state = state.setLoading(true);
    final result = await _logoutUseCase();

    state = result.fold(
      () => state.copyWith(
        isLoading: false,
        credentials: null,
        isUserLoggedIn: false,
      ),
      (error) => state.copyWith(
        isLoading: false,
        error: error,
      ),
    );
  }

  Future<Credentials?> getCredentials() async {
    state = state.setLoading(true);
    final result = await _getCredentialsUseCase();

    state = result.fold(
      (error) => state.copyWith(
        isLoading: false,
        error: error,
      ),
      (response) => state.copyWith(
        isLoading: false,
        credentials: response,
      ),
    );

    if (state.error != null) {
      return null;
    }

    return state.credentials;
  }

  void clearError() {
    state = state.resetError();
  }
}
