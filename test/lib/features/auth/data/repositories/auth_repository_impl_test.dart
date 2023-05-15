import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:gather_team/core/errors/exceptions.dart';
import 'package:gather_team/core/errors/failures.dart';
import 'package:gather_team/core/util/extensions/either_extension.dart';
import 'package:gather_team/core/util/extensions/option_extension.dart';
import 'package:gather_team/features/auth/data/datasources/auth_datasource.dart';
import 'package:gather_team/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:mocktail/mocktail.dart';

class MockAuthDataSource extends Mock implements IAuthDataSource {}

void main() {
  late AuthRepository sut;
  late MockAuthDataSource mockAuthDataSource;

  setUp(() {
    mockAuthDataSource = MockAuthDataSource();
    sut = AuthRepository(mockAuthDataSource);
  });

  const user = UserProfile(sub: 'test sub');

  final tCredentials = Credentials(
    idToken: 'test id',
    accessToken: 'test access',
    expiresAt: DateTime.now(),
    user: user,
    tokenType: 'test type',
  );

  group('login', () {
    test(
      'should call mockAuthDataSource',
      () async {
        when(mockAuthDataSource.login).thenAnswer((_) async => tCredentials);

        await sut.login();

        verify(mockAuthDataSource.login).called(1);
        verifyNoMoreInteractions(mockAuthDataSource);
      },
    );

    test(
      'should return [Credentials] if login was successful',
      () async {
        when(mockAuthDataSource.login).thenAnswer((_) async => tCredentials);

        final result = await sut.login();
        final actual = result.getRight();

        expect(actual, same(tCredentials));
      },
    );

    test(
      'should return an [UnexpectedFailure] if an error occurs',
      () async {
        when(mockAuthDataSource.login).thenThrow(UnexpectedException());

        final result = await sut.login();
        final actual = result.getLeft();

        expect(actual, isA<UnexpectedFailure>());
      },
    );
  });

  group('logout', () {
    test(
      'should call mockAuthDataSource',
      () async {
        when(mockAuthDataSource.logout).thenAnswer((_) async {});

        await sut.logout();

        verify(mockAuthDataSource.logout).called(1);
        verifyNoMoreInteractions(mockAuthDataSource);
      },
    );

    test(
      'should return a [UnexpectedFailure] if an error occurs',
      () async {
        when(mockAuthDataSource.logout).thenThrow(UnexpectedException());

        final result = await sut.logout();
        final actual = result.getSome();

        expect(actual, isA<UnexpectedFailure>());
      },
    );
  });

  group('getCredentials', () {
    test(
      'should call mockAuthDataSource',
      () async {
        when(mockAuthDataSource.getCredentials)
            .thenAnswer((_) async => tCredentials);

        await sut.getCredentials();

        verify(mockAuthDataSource.getCredentials).called(1);
        verifyNoMoreInteractions(mockAuthDataSource);
      },
    );

    test(
      'should return [Credentials] if getCredentials was successful',
      () async {
        when(mockAuthDataSource.getCredentials)
            .thenAnswer((_) async => tCredentials);

        final result = await sut.getCredentials();
        final actual = result.getRight();

        expect(actual, tCredentials);
      },
    );

    test(
      'should return [UnexpectedFailure] if an error occurs',
      () async {
        when(mockAuthDataSource.getCredentials)
            .thenThrow(UnexpectedException());

        final result = await sut.getCredentials();
        final actual = result.getLeft();

        expect(actual, isA<UnexpectedFailure>());
      },
    );
  });

  group('is user logged in', () {
    test(
      'should should call mockAuthDataSource ',
      () async {
        when(mockAuthDataSource.isUserLoggedIn).thenAnswer((_) async => true);

        await sut.isUserLoggedIn();

        verify(mockAuthDataSource.isUserLoggedIn).called(1);
        verifyNoMoreInteractions(mockAuthDataSource);
      },
    );

    test(
      'should return [bool] if isUserLoggedIn was successful',
      () async {
        when(mockAuthDataSource.isUserLoggedIn).thenAnswer((_) async => true);

        final result = await sut.isUserLoggedIn();
        final actual = result.getRight();

        expect(actual, equals(true));
      },
    );

    test(
      'should return [UnexpectedFailure] if an error occurs',
      () async {
        when(mockAuthDataSource.isUserLoggedIn)
            .thenThrow(UnexpectedException());

        final result = await sut.isUserLoggedIn();
        final actual = result.getLeft();

        expect(actual, isA<UnexpectedFailure>());
      },
    );
  });
}
