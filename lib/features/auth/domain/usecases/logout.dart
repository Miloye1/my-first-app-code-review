import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/auth_repository.dart';

class Logout {
  final IAuthRepository _repository;

  Logout(this._repository);

  Future<Option<Failure>> call() => _repository.logout();
}
