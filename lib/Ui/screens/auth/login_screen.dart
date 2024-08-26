// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:educarte/Ui/components/atoms/custom_button.dart';
import 'package:educarte/core/base/store.dart';
import 'package:educarte/core/enum/persistence_enum.dart';
import 'package:educarte/Services/config/repositories/persistence_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:http/http.dart' as http;

import '../../../core/enum/input_type.dart';
import '../../components/atoms/input.dart';
import '../../global/global.dart' as globals;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool verSenha = true;
  TextEditingController email = TextEditingController(text: "isticplaystore@gmail.com");
  TextEditingController senha = TextEditingController(text: "ukgOAeYuR4pOHAf");
  PersistenceRepository persistenceRepository = PersistenceRepository();
  bool carregando = false;

  void logar() async {
    setState(() {
      carregando = true;
    });
    Map corpo = {"email": email.text, "password": senha.text};

    var response = await http.post(
      Uri.parse("http://64.225.53.11:5000/Auth"),
      body: jsonEncode(corpo),
      headers: {
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> jsonData = jsonDecode(response.body);
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jsonData["token"]);

      await persistenceRepository.update(
          key: SecureKey.token, value: jsonData["token"]);

      setState(() {
        globals.nome = decodedToken["name"];
        globals.token = jsonData["token"];
        globals.id = decodedToken["sub"];

        globals.checkUserType(profileType: decodedToken["profile"]);
      });
      bool firstAccess =
          bool.parse(decodedToken["isFirstAccess"].toString().toLowerCase());

      String path = globals.routerPath(firstAccess: firstAccess);

      if (firstAccess) {
        globals.firstAccess = firstAccess;
        
        return context.go(path);
      }
      if (path == "/home") {}

      return context.go(path);
    } else {
      setState(() {
        carregando = false;
      });
      Store().showErrorMessage(context, "Credenciais Inválidas!");
    }
  }

  @override
  Widget build(BuildContext context) {
    bool focusInput = MediaQuery.of(context).viewInsets.bottom > 0;
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
                  if (!focusInput)
                    Center(child: Image.asset("assets/logo.png")),
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
                                height: 0.8),
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
                      topLeft: Radius.circular(16)),
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
                        onChange: email,
                      ),
                      const SizedBox(
                        height: 16,
                      ),
                      Input(
                        onChange: senha,
                        name: "Senha", 
                        inputType: InputType.password,
                        obscureText: true,
                      ),
                      // lascar os inputs
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
                        loading: carregando,
                        onPressed: () => logar()
                      ),
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
