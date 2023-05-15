import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class Login {
  final IAuthRepository _repository;

  Login(this._repository);

  Future<Either<Failure, Credentials>> call() => _repository.login();
}
