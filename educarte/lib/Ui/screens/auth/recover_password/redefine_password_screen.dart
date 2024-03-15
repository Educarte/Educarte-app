import 'dart:convert';

import 'package:educarte/Ui/components/bnt_azul_load.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
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

  void updatePasssword()async{
    setState(() {
      carregando = true;
    });
    Map corpo = {
      "code": globals.code,
      "newPassword": novaSenha.text,
      "confirmPassword": confirmarSenha.text
    };

    var response = await http.post(Uri.parse("http://64.225.53.11:5000/Users/UpdateForgotPassword"),
      body: jsonEncode(corpo),
      headers: {
        "Content-Type":"application/json"
      }
    );
    if(response.statusCode == 200){
      context.go("/login");
      var snackBar = SnackBar(
          backgroundColor: const Color(0xff547B9A),
          content: Center(
            child: Text("Senha redefinida com sucesso!",style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white
            ),),
          ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }else{
      setState(() {
        carregando = false;
      });
      var snackBar = SnackBar(
          backgroundColor: const Color(0xff547B9A),
          content: Center(
            child: Text("Erro ao tentar redefinir senha!",style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white
            ),),
          ));
          
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  @override
  Widget build(BuildContext context) {
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
              const SizedBox(
                height: 132,
              ),
              Icon(Symbols.password,color: const Color(0xff547B9A).withOpacity(0.7),size: 95,),
              const SizedBox(height: 48,),
              Text("REDEFINIR SENHA",style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize:24,
                  color: const Color(0xff474C51),
                  height: 1.5
              ),),
              RichText(text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Insira e confirme a sua nova senha",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize:14,
                          color: const Color(0xff474C51)
                      ),
                    ),
                  ]
              )),
              const SizedBox(height: 45,),
              Input(name: "Nova Senha", obscureText: true,onChange: novaSenha,),
              const SizedBox(height: 24,),
              Input(name: "Confirmar nova senha", obscureText: true,onChange: confirmarSenha,),
              const SizedBox(height: 85,),
              if(carregando == false)
              BotaoAzul(text: "Continuar",onPressed: () => updatePasssword()),
              if(carregando == true)
                BotaoAzulLoad()
            ],
          ),
        ),
      ),
    );
  }
}
