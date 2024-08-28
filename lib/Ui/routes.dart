import 'package:educarte/Interactor/providers/auth_provider.dart';
import 'package:educarte/core/enum/persistence_enum.dart';
import 'package:educarte/Services/repositories/persistence_repository.dart';
import 'package:educarte/Ui/screens/auth/recover_password/email_code_screen.dart';
import 'package:educarte/Ui/screens/auth/recover_password/forgot_password_screen.dart';
import 'package:educarte/Ui/screens/entry_and_exit/entry_and_exit_page.dart';
import 'package:educarte/Ui/screens/home/home_screen.dart';
import 'package:educarte/Ui/screens/auth/login_screen.dart';
import 'package:educarte/Ui/screens/messages/messages_screen.dart';
import 'package:educarte/Ui/screens/auth/recover_password/redefine_password_screen.dart';
import 'package:educarte/Ui/screens/time_control/time_control_page.dart';
import 'package:educarte/Ui/shell/educarte_shell.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';

import '../Ui/components/atoms/search_by_voice.dart';
import 'styles/transitions/fade_transition.dart';

class Routes {
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/login',
    // initialLocation: '/login',
    redirect: (context, state) async {
      PersistenceRepository persistenceRepository = PersistenceRepository();

      String? path;
      String? token = await persistenceRepository.read(key: SecureKey.token);

      if (token != null) {
        final authProvider = GetIt.instance.get<AuthProvider>();

        path = await authProvider.refreshToken(
          context: context, 
          token: token, 
          persistenceRepository: persistenceRepository
        );
      }

      return path;
    },
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
            controller: (state.extra as Map)["controller"], context: context),
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
                FadeTransitionPage(child: const MessagesScreen()),
          ),
          GoRoute(
            path: "/entryAndExit",
            pageBuilder: (context, state) => FadeTransitionPage(child: const EntryAndExitPage()),
          )
        ],
      ),
    ],
  );
}
