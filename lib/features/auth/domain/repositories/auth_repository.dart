import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';

abstract class IAuthRepository {
  /// Logs the user in using the web authentication by calling the login method from the AuthRepository
  ///
  /// Returns either [Credentials] or [UnexpectedFailure]
  Future<Either<Failure, Credentials>> login();

  /// Logs the user out using the web authentication by calling the logout method from the AuthRepository
  ///
  /// Returns [UnexpectedFailure] if an exception occurred
  Future<Option<Failure>> logout();

  /// Gets the user credentials by calling the getCredentials method from the AuthRepository
  ///
  /// Return either [Credentials] or [UnexpectedFailure]
  Future<Either<Failure, Credentials>> getCredentials();

  /// Checks if the user logged in by calling the isUserLoggedIn method from the AuthRepository
  ///
  /// Return either [bool] or [UnexpectedFailure]
  Future<Either<Failure, bool>> isUserLoggedIn();
}
