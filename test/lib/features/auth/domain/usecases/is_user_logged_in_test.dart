import 'package:dartz/dartz.dart';
import 'package:gather_team/core/errors/failures.dart';
import 'package:gather_team/core/util/extensions/either_extension.dart';
import 'package:gather_team/features/auth/domain/repositories/auth_repository.dart';
import 'package:gather_team/features/auth/domain/usecases/is_user_logged_in.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late IsUserLoggedIn sut;
  late MockAuthRepository authRepository;

  setUp(() {
    authRepository = MockAuthRepository();
    sut = IsUserLoggedIn(authRepository);
  });

  group('is user logged in', () {
    test(
      'should call authRepository',
      () async {
        when(authRepository.isUserLoggedIn)
            .thenAnswer((_) async => const Right(true));

        sut();

        verify(authRepository.isUserLoggedIn).called(1);
        verifyNoMoreInteractions(authRepository);
      },
    );

    test(
      'should return [bool] after isUserLoggedIn method was successfully called',
      () async {
        when(authRepository.isUserLoggedIn)
            .thenAnswer((_) async => const Right(true));

        final result = await sut();
        final actual = result.getRight();

        expect(actual, equals(true));
      },
    );

    test(
      'should return [UnexpectedFailure] when an error occurs',
      () async {
        when(authRepository.isUserLoggedIn)
            .thenAnswer((_) async => const Left(UnexpectedFailure()));

        final result = await sut();
        final actual = result.getLeft();

        expect(actual, isA<UnexpectedFailure>());
      },
    );
  });
}
