import 'package:auth0_flutter/auth0_flutter.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gather_team/core/errors/failures.dart';
import 'package:gather_team/features/auth/domain/auth_domain_module.dart';
import 'package:gather_team/features/auth/domain/usecases/get_credentials.dart';
import 'package:gather_team/features/auth/domain/usecases/is_user_logged_in.dart';
import 'package:gather_team/features/auth/domain/usecases/login.dart';
import 'package:gather_team/features/auth/domain/usecases/logout.dart';
import 'package:gather_team/features/auth/presentation/providers/auth_state_provider.dart';
import 'package:gather_team/features/auth/presentation/providers/state/auth_state.dart';
import 'package:mocktail/mocktail.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../core/util/helpers.dart';

class MockLogin extends Mock implements Login {}

class MockLogout extends Mock implements Logout {}

class MockGetCredentials extends Mock implements GetCredentials {}

class MockIsUserLoggedIn extends Mock implements IsUserLoggedIn {}

void main() {
  late ProviderContainer providerContainer;
  late MockLogin mockLogin;
  late MockLogout mockLogout;
  late MockGetCredentials mockGetCredentials;
  late MockIsUserLoggedIn mockIsUserLoggedIn;
  late Listener<AuthState> listener;

  setUp(() {
    mockLogin = MockLogin();
    mockLogout = MockLogout();
    mockGetCredentials = MockGetCredentials();
    mockIsUserLoggedIn = MockIsUserLoggedIn();

    providerContainer = makeTestProviderContainer(
      [
        loginUseCaseProvider.overrideWithValue(mockLogin),
        logoutUseCaseProvider.overrideWithValue(mockLogout),
        getCredentialsUseCaseProvider.overrideWithValue(mockGetCredentials),
        isUserLoggedInUseCaseProvider.overrideWithValue(mockIsUserLoggedIn),
      ],
    );

    listener = Listener<AuthState>();

    providerContainer.listen(
      authStateProvider,
      listener,
      fireImmediately: true,
    );
  });

  group('login', () {
    tearDown(() {
      verifyZeroInteractions(mockLogout);
      verifyZeroInteractions(mockIsUserLoggedIn);
      verifyZeroInteractions(mockGetCredentials);
    });

    test(
      'state should be set to initial',
      () async {
        verify(() => listener(null, const AuthState.initial()));
        expect(
          providerContainer.read(authStateProvider),
          equals(const AuthState.initial()),
        );
        verifyNoMoreInteractions(listener);
      },
    );

    test(
      'should call login use case',
      () async {
        const tUser = UserProfile(sub: 'test sub');

        final tCredentials = Credentials(
          idToken: 'test id',
          accessToken: 'test access',
          expiresAt: DateTime.now(),
          user: tUser,
          tokenType: 'test type',
        );

        when(mockLogin.call).thenAnswer((_) async => Right(tCredentials));

        await providerContainer.read(authStateProvider.notifier).login();

        verify(mockLogin).called(1);
        verifyNoMoreInteractions(mockLogin);
      },
    );

    test(
      'state should be set to logged in with credentials',
      () async {
        const tUser = UserProfile(sub: 'test sub');

        final tCredentials = Credentials(
          idToken: 'test id',
          accessToken: 'test access',
          expiresAt: DateTime.now(),
          user: tUser,
          tokenType: 'test type',
        );

        when(mockLogin.call).thenAnswer((_) async => Right(tCredentials));

        expect(
          providerContainer.read(authStateProvider),
          equals(const AuthState.initial()),
        );

        await providerContainer.read(authStateProvider.notifier).login();

        expect(
          providerContainer.read(authStateProvider),
          equals(
            const AuthState.initial().copyWith(
              isLoading: false,
              isUserLoggedIn: true,
              credentials: tCredentials,
            ),
          ),
        );

        verifyInOrder([
          () => listener(null, const AuthState.initial()),
          () => listener(const AuthState.initial(), const AuthState.initial()),
          () => listener(
                const AuthState.initial(),
                const AuthState.initial().copyWith(
                  isLoading: false,
                  isUserLoggedIn: true,
                  credentials: tCredentials,
                ),
              ),
        ]);

        verifyNoMoreInteractions(listener);
      },
    );

    test(
      'state should be set to failure',
      () async {
        const tFailure = UnexpectedFailure(message: 'Test message');

        when(mockLogin.call).thenAnswer((_) async => const Left(tFailure));

        expect(
          providerContainer.read(authStateProvider),
          equals(const AuthState.initial()),
        );

        await providerContainer.read(authStateProvider.notifier).login();

        expect(
          providerContainer.read(authStateProvider),
          equals(
            const AuthState.initial().copyWith(
              isLoading: false,
              error: tFailure,
            ),
          ),
        );

        verifyInOrder([
          () => listener(null, const AuthState.initial()),
          () => listener(const AuthState.initial(), const AuthState.initial()),
          () => listener(
                const AuthState.initial(),
                const AuthState.initial().copyWith(
                  isLoading: false,
                  error: tFailure,
                ),
              ),
        ]);

        verifyNoMoreInteractions(listener);
      },
    );
  });

  group('isUserLoggedIn', () {
    tearDown(() {
      verifyZeroInteractions(mockLogout);
      verifyZeroInteractions(mockLogin);
      verifyZeroInteractions(mockGetCredentials);
    });

    test(
      'state should be initial',
      () async {
        verify(() => listener(null, const AuthState.initial()));
        expect(
          providerContainer.read(authStateProvider),
          equals(const AuthState.initial()),
        );
        verifyNoMoreInteractions(listener);
      },
    );

    test(
      'should call isUserLoggedIn use case',
      () async {
        when(mockIsUserLoggedIn.call)
            .thenAnswer((_) async => const Right(true));

        await providerContainer
            .read(authStateProvider.notifier)
            .isUserLoggedIn();

        verify(mockIsUserLoggedIn).called(1);
        verifyNoMoreInteractions(mockIsUserLoggedIn);
      },
    );

    test(
      'state should be set to logged in',
      () async {
        when(mockIsUserLoggedIn.call)
            .thenAnswer((_) async => const Right(true));

        expect(
          providerContainer.read(authStateProvider),
          equals(const AuthState.initial()),
        );

        await providerContainer
            .read(authStateProvider.notifier)
            .isUserLoggedIn();

        expect(
          providerContainer.read(authStateProvider),
          equals(const AuthState.initial().copyWith(
            isLoading: false,
            isUserLoggedIn: true,
          )),
        );

        verifyInOrder([
          () => listener(
                null,
                const AuthState.initial(),
              ),
          () => listener(
                const AuthState.initial(),
                const AuthState.initial().copyWith(
                  isLoading: false,
                  isUserLoggedIn: true,
                ),
              ),
        ]);

        verifyNoMoreInteractions(listener);
      },
    );

    test(
      'state should be set to failure',
      () async {
        const tFailure = UnexpectedFailure(message: 'Test message');

        when(mockIsUserLoggedIn.call)
            .thenAnswer((_) async => const Left(tFailure));

        expect(
          providerContainer.read(authStateProvider),
          equals(
            const AuthState.initial(),
          ),
        );

        await providerContainer
            .read(authStateProvider.notifier)
            .isUserLoggedIn();

        expect(
          providerContainer.read(authStateProvider),
          equals(
            const AuthState.initial().copyWith(
              isLoading: false,
              error: tFailure,
            ),
          ),
        );

        verifyInOrder([
          () => listener(null, const AuthState.initial()),
          () => listener(
                const AuthState.initial(),
                const AuthState.initial().copyWith(
                  isLoading: false,
                  error: tFailure,
                ),
              ),
        ]);

        verifyNoMoreInteractions(listener);
      },
    );
  });

  group('logout', () {
    tearDown(() {
      verifyZeroInteractions(mockLogin);
      verifyZeroInteractions(mockIsUserLoggedIn);
      verifyZeroInteractions(mockGetCredentials);
    });

    test(
      'state should be set to initial',
      () async {
        verify(
          () => listener(null, const AuthState.initial()),
        );
        expect(
          providerContainer.read(authStateProvider),
          equals(
            const AuthState.initial(),
          ),
        );
        verifyNoMoreInteractions(listener);
      },
    );

    test(
      'should call logout use case',
      () async {
        when(mockLogout.call).thenAnswer((_) async => const None());

        await providerContainer.read(authStateProvider.notifier).logout();

        verify(mockLogout).called(1);
        verifyNoMoreInteractions(mockLogout);
      },
    );

    test(
      'state should be set to logged out',
      () async {
        when(mockLogout.call).thenAnswer((_) async => const None());

        expect(
          providerContainer.read(authStateProvider),
          equals(
            const AuthState.initial(),
          ),
        );

        await providerContainer.read(authStateProvider.notifier).logout();

        expect(
          providerContainer.read(authStateProvider),
          equals(
            const AuthState.initial().copyWith(isLoading: false),
          ),
        );

        verifyInOrder([
          () => listener(null, const AuthState.initial()),
          () => listener(const AuthState.initial(), const AuthState.initial()),
          () => listener(
                const AuthState.initial(),
                const AuthState.initial().copyWith(isLoading: false),
              ),
        ]);

        verifyNoMoreInteractions(listener);
      },
    );

    test(
      'state should be set to failure',
      () async {
        const tFailure = UnexpectedFailure(message: 'Test message');

        when(mockLogout.call).thenAnswer((_) async => const Some(tFailure));

        expect(
          providerContainer.read(authStateProvider),
          equals(
            const AuthState.initial(),
          ),
        );

        await providerContainer.read(authStateProvider.notifier).logout();

        expect(
          providerContainer.read(authStateProvider),
          equals(
            const AuthState.initial().copyWith(
              isLoading: false,
              error: tFailure,
            ),
          ),
        );

        verifyInOrder([
          () => listener(null, const AuthState.initial()),
          () => listener(const AuthState.initial(), const AuthState.initial()),
          () => listener(
                const AuthState.initial(),
                const AuthState.initial().copyWith(
                  isLoading: false,
                  error: tFailure,
                ),
              ),
        ]);

        verifyNoMoreInteractions(listener);
      },
    );
  });

  //TODO: add test to check the return statement of getCredentials use case
  group('getCredentials', () {
    tearDown(() {
      verifyZeroInteractions(mockLogout);
      verifyZeroInteractions(mockIsUserLoggedIn);
      verifyZeroInteractions(mockLogin);
    });

    test(
      'state should be set to initial',
      () async {
        expect(
          providerContainer.read(authStateProvider),
          equals(
            const AuthState.initial(),
          ),
        );
        verify(() => listener(null, const AuthState.initial()));
        verifyNoMoreInteractions(listener);
      },
    );

    test(
      'should call getCredentials use case',
      () async {
        const tUser = UserProfile(sub: 'test sub');

        final tCredentials = Credentials(
          idToken: 'test id',
          accessToken: 'test access',
          expiresAt: DateTime.now(),
          user: tUser,
          tokenType: 'test type',
        );

        when(mockGetCredentials.call)
            .thenAnswer((_) async => Right(tCredentials));

        await providerContainer
            .read(authStateProvider.notifier)
            .getCredentials();

        verify(mockGetCredentials).called(1);
        verifyNoMoreInteractions(mockGetCredentials);
      },
    );

    test(
      'state should be set to credentials',
      () async {
        const tUser = UserProfile(sub: 'test sub');

        final tCredentials = Credentials(
          idToken: 'test id',
          accessToken: 'test access',
          expiresAt: DateTime.now(),
          user: tUser,
          tokenType: 'test type',
        );

        when(mockGetCredentials.call)
            .thenAnswer((_) async => Right(tCredentials));

        expect(
          providerContainer.read(authStateProvider),
          equals(
            const AuthState.initial(),
          ),
        );

        await providerContainer
            .read(authStateProvider.notifier)
            .getCredentials();

        expect(
          providerContainer.read(authStateProvider),
          equals(
            const AuthState.initial().copyWith(
              isLoading: false,
              credentials: tCredentials,
            ),
          ),
        );

        verifyInOrder([
          () => listener(null, const AuthState.initial()),
          () => listener(const AuthState.initial(), const AuthState.initial()),
          () => listener(
                const AuthState.initial(),
                const AuthState.initial().copyWith(
                  isLoading: false,
                  credentials: tCredentials,
                ),
              ),
        ]);

        verifyNoMoreInteractions(listener);
      },
    );

    test(
      'state should be set to failure',
      () async {
        const tFailure = UnexpectedFailure(message: 'Test message');

        when(mockGetCredentials.call)
            .thenAnswer((_) async => const Left(tFailure));

        expect(
          providerContainer.read(authStateProvider),
          equals(
            const AuthState.initial(),
          ),
        );

        await providerContainer
            .read(authStateProvider.notifier)
            .getCredentials();

        expect(
          providerContainer.read(authStateProvider),
          equals(
            const AuthState.initial().copyWith(
              isLoading: false,
              error: tFailure,
            ),
          ),
        );

        verifyInOrder([
          () => listener(null, const AuthState.initial()),
          () => listener(const AuthState.initial(), const AuthState.initial()),
          () => listener(
                const AuthState.initial(),
                const AuthState.initial().copyWith(
                  isLoading: false,
                  error: tFailure,
                ),
              ),
        ]);

        verifyNoMoreInteractions(listener);
      },
    );

    group('reset state', () {
      test(
        'error state should be reset after calling clearError method',
        () async {
          const tFailure = UnexpectedFailure(message: 'Test message');

          when(mockGetCredentials.call)
              .thenAnswer((_) async => const Left(tFailure));

          expect(
            providerContainer.read(authStateProvider),
            equals(
              const AuthState.initial(),
            ),
          );

          await providerContainer
              .read(authStateProvider.notifier)
              .getCredentials();

          expect(
            providerContainer.read(authStateProvider),
            equals(
              const AuthState.initial().copyWith(
                isLoading: false,
                error: tFailure,
              ),
            ),
          );

          providerContainer.read(authStateProvider.notifier).clearError();

          expect(
            providerContainer.read(authStateProvider),
            equals(
              const AuthState.initial().copyWith(isLoading: false),
            ),
          );

          verifyInOrder([
            () => listener(null, const AuthState.initial()),
            () =>
                listener(const AuthState.initial(), const AuthState.initial()),
            () => listener(
                  const AuthState.initial(),
                  const AuthState.initial().copyWith(
                    isLoading: false,
                    error: tFailure,
                  ),
                ),
            () => listener(
                  const AuthState.initial().copyWith(
                    isLoading: false,
                    error: tFailure,
                  ),
                  const AuthState.initial().copyWith(isLoading: false),
                ),
          ]);

          verifyNoMoreInteractions(listener);
        },
      );
    });
  });
}
