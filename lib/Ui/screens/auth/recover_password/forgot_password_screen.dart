import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:http/http.dart' as http;
import '../../../../core/base/store.dart';
import '../../../global/global.dart' as globals;

import '../../../components/bnt_azul.dart';
import '../../../components/input.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  TextEditingController email = TextEditingController();
  bool carregando = false;
  
  void enviarCodigo()async{
    setState(() {
      carregando = true;
    });
    Map corpo ={
      "email": email.text
    };
    var response = await http.post(Uri.parse("http://64.225.53.11:5000/Users/MobileRequestResetPassword"),
      body: jsonEncode(corpo),
      headers: {
        "Content-Type":"application/json",
      }
    );

    if(response.statusCode == 200){
      context.pushReplacement("/verifiqueEmail");
      setState(() {
        globals.emailEsqueciSenha = email.text.toString();
      });

    }else{
      setState(() {
        carregando = false;
      });
     Store().showErrorMessage(context, "E-mail Inválido!");
    }
  }
  
  @override
  Widget build(BuildContext context) {
    bool focusInput = MediaQuery.of(context).viewInsets.bottom > 0;
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          context.pushReplacement("/login");
        }, icon: const Icon(Symbols.close,color: Color(0xff474C51),)),
        backgroundColor: const Color(0xffF5F5F5),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: focusInput? 10 : 132,
              ),
              Icon(Symbols.password,color: const Color(0xff547B9A).withOpacity(0.7),size: 95,),
              const SizedBox(height: 48,),
              Text("ESQUECI A SENHA",style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                fontSize:24,
                color: const Color(0xff474C51),
                height: 1.5
              ),),
              RichText(text: TextSpan(
                children: [
                  TextSpan(
                    text: "Por favor insira o endereço de e-mail associado a sua conta do ",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w400,
                        fontSize:14,
                        color: const Color(0xff474C51)
                    ),
                  ),
                  TextSpan(
                    text: "Educarte",
                    style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        fontSize:14,
                        color: const Color(0xff474C51)
          
                    ),
                  )
                ]
              )),
              const SizedBox(height: 24,),
              Input(name: "E-mail", obscureText: false, onChange: email,),
              const SizedBox(height: 165,),
              BotaoAzul(text: "Continuar",onPressed: () => enviarCodigo(),loading: carregando,),
            ],
          ),
        ),
      ),
    );
  }
}
