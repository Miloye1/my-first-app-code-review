import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../data/auth_data_module.dart';
import '../data/datasources/auth_datasource.dart';
import '../data/repositories/auth_repository_impl.dart';
import 'repositories/auth_repository.dart';
import 'usecases/get_credentials.dart';
import 'usecases/is_user_logged_in.dart';
import 'usecases/login.dart';
import 'usecases/logout.dart';

final authRepositoryProvider = Provider<IAuthRepository>((ref) {
  final IAuthDataSource dataSource = ref.watch(authDataSourceProvider);

  return AuthRepository(dataSource);
});

final getCredentialsUseCaseProvider = Provider<GetCredentials>((ref) {
  final IAuthRepository repository = ref.watch(authRepositoryProvider);

  return GetCredentials(repository);
});

final loginUseCaseProvider = Provider<Login>((ref) {
  final IAuthRepository repository = ref.watch(authRepositoryProvider);

  return Login(repository);
});

final logoutUseCaseProvider = Provider<Logout>((ref) {
  final IAuthRepository repository = ref.watch(authRepositoryProvider);

  return Logout(repository);
});

final isUserLoggedInUseCaseProvider = Provider<IsUserLoggedIn>((ref) {
  final IAuthRepository repository = ref.watch(authRepositoryProvider);

  return IsUserLoggedIn(repository);
});
