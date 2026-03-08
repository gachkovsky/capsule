import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../features/capsules/presentation/capsules_screen.dart';
import '../../features/capsules/presentation/create_capsule_screen.dart';
import '../../features/capsules/presentation/capsule_detail_screen.dart';
import '../../features/capsules/domain/capsule.dart';
import '../../features/auth/presentation/auth_screen.dart';

class AppRouter {
  static late GoRouter router;

  static void init() {
    final notifier = _AuthNotifier();

    router = GoRouter(
      initialLocation: '/',
      refreshListenable: notifier,
      redirect: (context, state) {
        final user = Supabase.instance.client.auth.currentUser;
        final isAuthRoute = state.uri.path == '/auth';
        if (user == null && !isAuthRoute) return '/auth';
        if (user != null && isAuthRoute) return '/';
        return null;
      },
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const CapsulesScreen(),
        ),
        GoRoute(
          path: '/auth',
          builder: (context, state) => const AuthScreen(),
        ),
        GoRoute(
          path: '/create',
          builder: (context, state) => const CreateCapsuleScreen(),
        ),
        GoRoute(
          path: '/capsule/:id',
          builder: (context, state) {
            final capsule = state.extra as Capsule;
            return CapsuleDetailScreen(capsule: capsule);
          },
        ),
      ],
    );
  }
}

class _AuthNotifier extends ChangeNotifier {
  _AuthNotifier() {
    _sub = Supabase.instance.client.auth.onAuthStateChange.listen((_) {
      notifyListeners();
    });
  }

  late final StreamSubscription<AuthState> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}
