import 'dart:convert';

import 'package:educarte/Interector/enum/persistence_enum.dart';
import 'package:educarte/Services/config/api_config.dart';
import 'package:educarte/Services/config/repositories/persistence_repository.dart';
import 'package:educarte/Ui/components/search_by_voice.dart';
import 'package:educarte/Ui/global/global.dart' as globals;
import 'package:educarte/Ui/screens/auth/recover_password/email_code_screen.dart';
import 'package:educarte/Ui/screens/auth/recover_password/forgot_password_screen.dart';
import 'package:educarte/Ui/screens/entryAndExit/entry_and_exit_page.dart';
import 'package:educarte/Ui/screens/home/home_screen.dart';
import 'package:educarte/Ui/screens/auth/login_screen.dart';
import 'package:educarte/Ui/screens/messages/messages_screen.dart';
import 'package:educarte/Ui/screens/auth/recover_password/redefine_password_screen.dart';
import 'package:educarte/Ui/screens/time_control/time_control_page.dart';
import 'package:educarte/Ui/shell/educarte_shell.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';

import 'styles/transitions/fade_transition.dart';

class Routes {
  static final GoRouter router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: '/login',
    // initialLocation: '/login',
    redirect: (context, state) async {
      PersistenceRepository persistenceRepository = PersistenceRepository();

      String? path;
      globals.token = await persistenceRepository.read(key: SecureKey.token);

      if (globals.token != null) {
        try {
          var response =
              await http.post(Uri.parse("$baseUrl/Auth/refresh"), headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${globals.token}",
          });

          if (response.statusCode == 200) {
            await persistenceRepository.update(
                key: SecureKey.token,
                value: jsonDecode(response.body)["token"]);
            Map<String, dynamic> decodedToken =
                JwtDecoder.decode(jsonDecode(response.body)["token"]);
            globals.token = jsonDecode(response.body)["token"];
            globals.id = decodedToken["sub"];
            globals.checkUserType(profileType: decodedToken["profile"]);
            bool firstAccess =
                bool.parse(decodedToken["isFirstAccess"].toLowerCase());
            globals.firstAccess = firstAccess;

            if (globals.nome == null) {
              // currentIndex = 2;
              path = globals.routerPath(firstAccess: firstAccess);
            }
          } else if (response.statusCode == 401) {
            await persistenceRepository.delete(key: SecureKey.token);
            globals.token = null;
            globals.firstAccess = false;

            path = '/login';
          }
        } catch (e) {
          await persistenceRepository.delete(key: SecureKey.token);
          globals.token = null;
          globals.firstAccess = false;

          path = '/login';
        }
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
            pageBuilder: (context, state) =>
                FadeTransitionPage(child: const EntryAndExitPage()),
          )
        ],
      ),
    ],
  );
}
