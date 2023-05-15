import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gather_team/core/errors/failures.dart';
import 'package:gather_team/core/util/extensions/either_extension.dart';
import 'package:gather_team/features/auth/domain/repositories/auth_repository.dart';
import 'package:gather_team/features/auth/domain/usecases/get_credentials.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late GetCredentials sut;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    sut = GetCredentials(mockAuthRepository);
  });

  const user = UserProfile(sub: 'test sub');

  final tCredentials = Credentials(
    idToken: 'test id',
    accessToken: 'test access',
    expiresAt: DateTime.now(),
    user: user,
    tokenType: 'test type',
  );

  group('get credentials', () {
    test(
      'should call mockAuthRepository',
      () async {
        when(mockAuthRepository.getCredentials)
            .thenAnswer((_) async => Right(tCredentials));

        await sut();

        verify(mockAuthRepository.getCredentials).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return [Credentials] if getCredentials was successful ',
      () async {
        when(mockAuthRepository.getCredentials)
            .thenAnswer((_) async => Right(tCredentials));

        final result = await sut();
        final actual = result.getRight();

        expect(actual, same(tCredentials));
      },
    );

    test(
      'should return an [ServerFailure] if an exception occurs',
      () async {
        when(mockAuthRepository.getCredentials)
            .thenAnswer((_) async => const Left(UnexpectedFailure()));

        final result = await sut();
        final actual = result.getLeft();

        expect(actual, isA<UnexpectedFailure>());
      },
    );
  });
}
