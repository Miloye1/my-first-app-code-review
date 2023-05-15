import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class GetCredentials {
  final IAuthRepository _repository;

  GetCredentials(this._repository);

  Future<Either<Failure, Credentials>> call() => _repository.getCredentials();
}
