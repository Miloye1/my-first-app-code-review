import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthErrorScreen extends ConsumerWidget {
  final String? message;

  const AuthErrorScreen({
    this.message,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Error'),
      ),
      body: Center(
        child: Column(
          children: [
            const Text(
              'An error occurred while authenticating. Please try again',
            ),
            Text(message ?? 'An error occurred')
          ],
        ),
      ),
    );
  }
}
