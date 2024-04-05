import 'package:educarte/Ui/components/search_by_voice.dart';
import 'package:educarte/Ui/screens/auth/recover_password/email_code_screen.dart';
import 'package:educarte/Ui/screens/auth/recover_password/forgot_password_screen.dart';
import 'package:educarte/Ui/screens/home/home_screen.dart';
import 'package:educarte/Ui/screens/auth/login_screen.dart';
import 'package:educarte/Ui/screens/Messagens/messages_screen.dart';
import 'package:educarte/Ui/screens/auth/recover_password/redefine_password_screen.dart';
import 'package:educarte/Ui/screens/time_control/time_control_page.dart';
import 'package:educarte/Ui/shell/educarte_shell.dart';
import 'package:go_router/go_router.dart';
import 'styles/transitions/fade_transition.dart';


class Routes {
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/login',
    // initialLocation: '/login',
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
        builder: (context, state) => const EmailCode(),
      ),
      GoRoute(
        path: "/redefinirSenha",
        builder: (context, state) => const RedefinePassword(),
      ),
      GoRoute(
        path: "/timeControl",
        builder: (context, state) => const TimeControlPage(),
      ),
      GoRoute(
        path: "/searchByVoice",
        builder: (context, state) => SearchByVoicePage(
          controller: (state.extra as Map)["controller"], 
          context: context
        ),
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
          GoRoute(
            path: "/recados",
            pageBuilder: (context, state) =>
                FadeTransitionPage(child: MessagesScreen()),
          ),
        ],
      ),
    ],
  );
}
