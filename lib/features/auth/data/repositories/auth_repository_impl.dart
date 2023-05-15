import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/exceptions.dart';
import '../../../../core/errors/failures.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_datasource.dart';

class AuthRepository implements IAuthRepository {
  final IAuthDataSource _dataSource;

  AuthRepository(this._dataSource);

  @override
  Future<Either<Failure, Credentials>> getCredentials() async {
    try {
      final result = await _dataSource.getCredentials();
      return Right(result);
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, Credentials>> login() async {
    try {
      final result = await _dataSource.login();
      return Right(result);
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(message: e.message));
    }
  }

  @override
  Future<Option<Failure>> logout() async {
    try {
      await _dataSource.logout();
      return const None();
    } on UnexpectedException catch (e) {
      return Some(UnexpectedFailure(message: e.message));
    }
  }

  @override
  Future<Either<Failure, bool>> isUserLoggedIn() async {
    try {
      final result = await _dataSource.isUserLoggedIn();
      return Right(result);
    } on UnexpectedException catch (e) {
      return Left(UnexpectedFailure(message: e.message));
    }
  }
}
