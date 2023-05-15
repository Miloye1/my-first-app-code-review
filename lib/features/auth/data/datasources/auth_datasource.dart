import 'package:auth0_flutter/auth0_flutter.dart';

import '../../../../core/errors/exceptions.dart';

abstract class IAuthDataSource {
  /// Logs the user in using the web authentication by calling the login method from the Auth0 package
  ///
  /// Returns [Credentials] after a successful operation, throws an [UnexpectedException] if an error occurs
  Future<Credentials> login();

  /// Logs the user out using the web authentication by calling the logout method from the Auth0 package
  ///
  /// Throws an [UnexpectedException] if an error occurs
  Future<void> logout();

  /// Gets the user credentials by calling the credentials method from the Auth0 package
  ///
  /// Returns [Credentials] after a successful operation, throws an [UnexpectedException] if an error occurs
  Future<Credentials> getCredentials();

  /// Checks if the user is logged by calling the hasValidCredentials method from the Auth0 package
  ///
  /// Returns [bool] after a successful operation, throws an [UnexpectedException] if an error occurs
  Future<bool> isUserLoggedIn();
}
