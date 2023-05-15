import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gather_team/core/errors/failures.dart';
import 'package:gather_team/core/util/extensions/option_extension.dart';
import 'package:gather_team/features/auth/domain/repositories/auth_repository.dart';
import 'package:gather_team/features/auth/domain/usecases/logout.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthRepository extends Mock implements IAuthRepository {}

void main() {
  late Logout sut;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    sut = Logout(mockAuthRepository);
  });

  group('logout', () {
    test(
      'should call mockAuthRepository',
      () async {
        when(mockAuthRepository.logout).thenAnswer((_) async => const None());

        await sut();

        verify(mockAuthRepository.logout).called(1);
        verifyNoMoreInteractions(mockAuthRepository);
      },
    );

    test(
      'should return an [ServerFailure] if an exception occurs ',
      () async {
        when(mockAuthRepository.logout)
            .thenAnswer((_) async => const Some(UnexpectedFailure()));

        final result = await mockAuthRepository.logout();
        final actual = result.getSome();

        expect(actual, isA<UnexpectedFailure>());
      },
    );
  });
}
