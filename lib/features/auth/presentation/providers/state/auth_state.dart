import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';

import '../../../../../core/errors/failures.dart';

@immutable
class AuthState extends Equatable {
  final Credentials? credentials;
  final bool isUserLoggedIn;
  final Failure? error;
  final bool isLoading;

  const AuthState({
    required this.isUserLoggedIn,
    required this.credentials,
    required this.isLoading,
    required this.error,
  });

  const AuthState.initial()
      : credentials = null,
        isUserLoggedIn = false,
        isLoading = true,
        error = null;

  AuthState copyWith({
    bool? isUserLoggedIn,
    Credentials? credentials,
    Failure? error,
    bool? isLoading,
  }) =>
      AuthState(
        isUserLoggedIn: isUserLoggedIn ?? this.isUserLoggedIn,
        credentials: credentials ?? this.credentials,
        error: error ?? this.error,
        isLoading: isLoading ?? this.isLoading,
      );

  AuthState setLoading(bool loading) => AuthState(
        isUserLoggedIn: isUserLoggedIn,
        credentials: credentials,
        isLoading: loading,
        error: error,
      );

  AuthState resetError() => AuthState(
        isUserLoggedIn: isUserLoggedIn,
        credentials: credentials,
        isLoading: isLoading,
        error: null,
      );

  AuthState resetCredentials() => AuthState(
        isUserLoggedIn: isUserLoggedIn,
        credentials: null,
        isLoading: isLoading,
        error: error,
      );

  @override
  List<Object?> get props => [isUserLoggedIn, credentials, isLoading, error];

  @override
  String toString() {
    return 'isUserLoggedIn: $isUserLoggedIn, credentials: $credentials, isLoading: $isLoading, error: $error';
  }
}
