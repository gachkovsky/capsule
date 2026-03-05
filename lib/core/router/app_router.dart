import 'package:go_router/go_router.dart';
import '../../features/capsules/presentation/capsules_screen.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const CapsulesScreen(),
      ),
    ],
  );
}