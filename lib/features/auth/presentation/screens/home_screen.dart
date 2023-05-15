import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/auth_state_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Consumer(
        builder: (context, ref, child) {
          return Center(
            child: ElevatedButton(
              onPressed: ref.read(authStateProvider.notifier).logout,
              child: const Text('Logout'),
            ),
          );
        },
      ),
    );
  }
}
