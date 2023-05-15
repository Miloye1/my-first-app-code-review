import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../features/auth/presentation/providers/auth_error_provider.dart';
import '../../features/auth/presentation/providers/auth_loading_provider.dart';
import '../../features/auth/presentation/providers/auth_state_provider.dart';
import '../../features/auth/presentation/providers/is_user_logged_in_provider.dart';
import '../../features/auth/presentation/screens/auth_error_screen.dart';
import '../../features/auth/presentation/screens/home_screen.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import 'app_loading_widget.dart';

class Main extends ConsumerStatefulWidget {
  const Main({
    super.key,
  });

  @override
  ConsumerState<Main> createState() => _MainState();
}

class _MainState extends ConsumerState<Main> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(
      (_) => ref.read(authStateProvider.notifier).isUserLoggedIn(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isUserLoggedIn = ref.watch(isUserLoggedInProvider);
    final loading = ref.watch(authLoadingProvider);
    final error = ref.watch(authErrorProvider);

    if (error != null) {
      return AuthErrorScreen(message: error.message);
    }

    if (loading) {
      return const AppLoadingWidget();
    } else {
      if (isUserLoggedIn) {
        return const HomeScreen();
      } else {
        return const LoginScreen();
      }
    }
  }
}
