import 'package:educarte/Interactor/providers/auth_provider.dart';
import 'package:educarte/Ui/components/atoms/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../core/enum/input_type.dart';
import '../../components/atoms/input.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final authProvider = GetIt.instance.get<AuthProvider>(); 
  
  TextEditingController emailController = TextEditingController(text: "");
  TextEditingController passwordController = TextEditingController(text: "");

  @override
  Widget build(BuildContext context) {
    bool focusInput = MediaQuery.of(context).viewInsets.bottom > 0;

    return ListenableBuilder(
      listenable: authProvider,
      builder: (_, __) {
        return Scaffold(
          resizeToAvoidBottomInset: false,
          backgroundColor: const Color(0xff547B9A),
          body: Column(
            children: [
              Expanded(
                flex: focusInput ? 1 : 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const SizedBox(
                        height: 60,
                      ),
                      if (!focusInput)...[
                        Center(child: Image.asset("assets/logo.png"))
                      ],
                      SizedBox(
                        height: 62,
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Text(
                                "Aqui começa a",
                                style: GoogleFonts.poppins(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xffF5F5F5),
                                ),
                              ),
                              Text(
                                "SUA HISTÓRIA",
                                style: GoogleFonts.poppins(
                                  fontSize: 48,
                                  fontWeight: FontWeight.w800,
                                  color: const Color(0xffF5F5F5),
                                  height: 0.8
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: focusInput ? 4 : 3,
                child: Container(
                  width: MediaQuery.of(context).size.width,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(16),
                      topLeft: Radius.circular(16)
                    ),
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(
                          height: 48,
                        ),
                        Input(
                          name: "E-mail",
                          onChange: emailController,
                        ),
                        const SizedBox(
                          height: 16,
                        ),
                        Input(
                          onChange: passwordController,
                          name: "Senha", 
                          inputType: InputType.password,
                          obscureText: true,
                        ),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          height: 50,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              TextButton(
                                onPressed: () => context.pushReplacement("/esqueciSenha"),
                                child: Text(
                                  "Esqueceu a senha?",
                                  style: GoogleFonts.poppins(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xff474C51)
                                  ),
                                )
                              )
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 48,
                        ),
                        CustomButton(
                          title: "Entrar",
                          loading: authProvider.loading,
                          onPressed: () => authProvider.login(
                            context: context, 
                            emailController: emailController,
                            passwordController: passwordController
                          )
                        ),
                      ],
                    ),
                  ),
                )
              )
            ],
          ),
        );
      }
    );
  }
}
