import 'package:educarte/Ui/screens/email_code_screen.dart';
import 'package:educarte/Ui/screens/forgot_password_screen.dart';
import 'package:educarte/Ui/screens/home_screen.dart';
import 'package:educarte/Ui/screens/login_screen.dart';
import 'package:educarte/Ui/screens/messages_screen.dart';
import 'package:educarte/Ui/screens/redefine_password_screen.dart';
import 'package:educarte/Ui/shell/educarte_shell.dart';
import 'package:go_router/go_router.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'styles/transitions/fade_transition.dart';


class Routes {
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/login',
    routes: [
      GoRoute(
        path: "/login",
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: "/esqueciSenha",
        builder: (context, state) => const ForgotPasswordScreen(),
      ),
      GoRoute(
        path: "/verifiqueEmail",
        builder: (context, state) => EmailCode(),
      ),
      GoRoute(
        path: "/redefinirSenha",
        builder: (context, state) => const RedefinePassword(),
      ),
      GoRoute(
        path: "/recados",
        builder: (context, state) => const MessagesScreen(),
      ),
      ShellRoute(
        builder: (context, state, child) {
          return EducarteShell(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: "/home",
            pageBuilder: (context, state) =>
                FadeTransitionPage(child: const HomeScreen()),
          ),
        ],
      ),
    ],
  );
}
