import 'package:go_router/go_router.dart';
import 'package:notificaciones_flutter/presentation/home_screen.dart';

final appRouter = GoRouter(
    routes: [
      GoRoute(
          path: '/',
        builder: (context, state) => const HomeScreen()
      )
    ]
);