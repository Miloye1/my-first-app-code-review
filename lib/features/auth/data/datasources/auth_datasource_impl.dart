import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import '../../../../core/constants/messages.dart';
import '../../../../core/errors/exceptions.dart';
import 'auth_datasource.dart';

class AuthDataSource implements IAuthDataSource {
  final Auth0 auth0;

  AuthDataSource(this.auth0);

  @override
  Future<Credentials> getCredentials() {
    try {
      return auth0.credentialsManager.credentials();
    } catch (e) {
      throw UnexpectedException(
          message:
              '${Messages.UNEXPECTED_EXCEPTION} while getting user credentials');
    }
  }

  @override
  Future<Credentials> login() {
    try {
      return auth0
          .webAuthentication(scheme: dotenv.env['AUTH0_SCHEME']!)
          .login(audience: dotenv.env['AUTH0_AUDIENCE']!);
    } catch (e) {
      throw UnexpectedException(
          message: '${Messages.UNEXPECTED_EXCEPTION} during login');
    }
  }

  @override
  Future<void> logout() {
    try {
      return auth0
          .webAuthentication(scheme: dotenv.env['AUTH0_SCHEME']!)
          .logout();
    } catch (e) {
      throw UnexpectedException(
          message: '${Messages.UNEXPECTED_EXCEPTION} during logout');
    }
  }

  @override
  Future<bool> isUserLoggedIn() {
    try {
      return auth0.credentialsManager.hasValidCredentials();
    } catch (e) {
      throw UnexpectedException(
          message:
              '${Messages.UNEXPECTED_EXCEPTION} while checking if the user is logged in');
    }
  }
}
