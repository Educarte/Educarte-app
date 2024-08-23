import 'dart:convert';
import 'package:educarte/core/base/store.dart';
import 'package:educarte/Interector/validations/validator.dart';
import 'package:educarte/Services/config/api_config.dart';
import 'package:educarte/core/enum/input_type.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:http/http.dart' as http;

import '../../../global/global.dart' as globals;
import '../../../components/bnt_azul.dart';
import '../../../components/input.dart';

class RedefinePassword extends StatefulWidget {
  const RedefinePassword({super.key});

  @override
  State<RedefinePassword> createState() => _RedefinePasswordState();
}

class _RedefinePasswordState extends State<RedefinePassword> {
  TextEditingController novaSenha = TextEditingController();
  TextEditingController confirmarSenha = TextEditingController();
  bool carregando = false;
  bool firstAccess = globals.firstAccess;

  void updatePasssword() async {
    setState(() {
      carregando = true;
    });
    Map corpo = {
      "code": globals.code.toString(),
      "newPassword": novaSenha.text,
      "confirmPassword": confirmarSenha.text
    };

    var response = await http.post(
        Uri.parse("$baseUrl/Users/UpdateForgotPassword"),
        body: jsonEncode(corpo),
        headers: {"Content-Type": "application/json"});

    if (response.statusCode == 200 && mounted) {
      context.go("/login");

      Store().showSuccessMessage(context, "Senha redefinida com sucesso!");
    } else {
      setState(() {
        carregando = false;
      });
      
      
      Store().showErrorMessage(context, "Erro ao tentar redefinir senha!");
    }
  }

  void updatePasswordFirstAcess() async {
    setState(() {
      carregando = true;
    });
    Map corpo = {
      "newPassword": novaSenha.text,
      "confirmPassword": confirmarSenha.text
    };

    var response = await http.patch(
        Uri.parse("$baseUrl/Users/${globals.id}/ResetPassword"),
        body: jsonEncode(corpo),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${globals.token}"
        });

    if (response.statusCode == 200 && mounted) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(globals.token!);
      int profile = globals.checkUserType(profileType: decodedToken["profile"]);
      if (profile == 1) {
        context.go("/home");
      } else {
        context.go("/timeControl");
      }

      Store().showSuccessMessage(context, "Senha redefinida com sucesso!");
    } else {
      setState(() {
        carregando = false;
      });

      Store().showErrorMessage(context, "Erro ao tentar redefinir senha!");
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        leading: firstAccess
            ? null
            : IconButton(
                onPressed: () {
                  if (!firstAccess) context.pushReplacement("/login");
                },
                icon: const Icon(
                  Symbols.close,
                  color: Color(0xff474C51),
                )),
        backgroundColor: const Color(0xffF5F5F5),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 132,
              ),
              Icon(
                Symbols.password,
                color: const Color(0xff547B9A).withOpacity(0.7),
                size: 95,
              ),
              const SizedBox(
                height: 48,
              ),
              Text(
                "REDEFINIR SENHA",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                    color: const Color(0xff474C51),
                    height: 1.5),
              ),
              RichText(
                  text: TextSpan(children: [
                TextSpan(
                  text: "Insira e confirme a sua nova senha",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                      color: const Color(0xff474C51)),
                ),
              ])),
              const SizedBox(
                height: 45,
              ),
              Input(
                name: "Nova Senha",
                inputType: InputType.password,
                obscureText: true,
                onChange: novaSenha,
              ),
              const SizedBox(
                height: 24,
              ),
              Input(
                name: "Confirmar nova senha",
                inputType: InputType.password,
                obscureText: true,
                onChange: confirmarSenha,
              ),
              const SizedBox(
                height: 85,
              ),
              BotaoAzul(
                text: "Continuar",
                onPressed: () {
                  String validate = ValidatorDataSent.validateConfirmPassword(
                      password: novaSenha.text,
                      confirmPassword: confirmarSenha.text);
                  if (validate.isEmpty) {
                    if (firstAccess) {
                      return updatePasswordFirstAcess();
                    }

                    return updatePasssword();
                  } else {
                    Store().showErrorMessage(context, validate);
                  }
                },
                loading: carregando,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
