import 'package:go_router/go_router.dart';
import 'package:notificaciones_flutter/presentation/screens/detail_screen.dart';
import 'package:notificaciones_flutter/presentation/screens/home_screen.dart';

final appRouter = GoRouter(
    routes: [
      GoRoute(
          path: '/',
        builder: (context, state) => const HomeScreen()
      ),

      GoRoute(
          path: '/push-details/:messageId',
        builder: (context, state) {
            return DetailScreen(pushMessageId: state.pathParameters['messageId'] ?? '');
        }
      )
    ]
);