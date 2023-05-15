import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class IsUserLoggedIn {
  final IAuthRepository _repository;

  IsUserLoggedIn(this._repository);

  Future<Either<Failure, bool>> call() => _repository.isUserLoggedIn();
}
