import 'dart:convert';

import 'package:educarte/Ui/components/bntAzulLoad.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:http/http.dart' as http;
import 'package:page_transition/page_transition.dart';

import '../components/bntAzul.dart';
import '../components/input.dart';
import '../components/inputPassword.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';
import '../global/global.dart' as globals;

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool verSenha = true;
  TextEditingController email = TextEditingController();
  TextEditingController senha = TextEditingController();
  bool carregando = false;

  void Logar()async{
    setState(() {
      carregando = true;
    });
    Map corpo = {
      "email": email.text,
      "password": senha.text
    };
    
    var response = await http.post(Uri.parse("http://64.225.53.11:5000/Auth"),
      body: jsonEncode(corpo),
      headers: {
        "Content-Type": "application/json"
      }
    );
    print(response.statusCode);
    print(response.body);
    
    if(response.statusCode == 200){
      Map<String,dynamic> jsonData = jsonDecode(response.body);
      Map<String, dynamic> decodedToken = JwtDecoder.decode(jsonData["token"]);
      setState(() {
        globals.nome = decodedToken["name"];
        globals.token = jsonData["token"];
      });
      var snackBar = SnackBar(
        backgroundColor: const Color(0xff547B9A),
          content: Center(
        child: Text("Seja bem Vindo!",style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w400,
          color: Colors.white
        ),),
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      context.go("/home");

    }else{
      setState(() {
        carregando = false;
      });
      var snackBar = SnackBar(
          backgroundColor: const Color(0xff547B9A),
          content: Center(
        child: Text("Credenciais Inválidas!",style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: Colors.white
        ),),
      ));
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
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
            flex: focusInput ?1 : 4,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const SizedBox(height: 60,),

                  if(!focusInput)
                  Center(child: Image.asset("assets/logo.png")),

                  SizedBox(
                    height: 62,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text("Aqui começa a",style: GoogleFonts.poppins(
                            fontSize: 19,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xffF5F5F5),
                          ),),
                          Text("SUA HISTÓRIA",style: GoogleFonts.poppins(
                              fontSize: 48,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xffF5F5F5),
                            height: 0.8
                          ),),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Expanded(
              flex: focusInput ?4 : 3,
              child: Container(
                width: MediaQuery.of(context).size.width,
                decoration: const BoxDecoration(
                  borderRadius: BorderRadius.only(topRight: Radius.circular(16),topLeft: Radius.circular(16)),
                  color: Colors.white,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      const SizedBox(height: 48,),
                      Input(name: "E-mail", obscureText: false,onChange: email,),
                      const SizedBox(height: 16,),
                      InputPassword(onChange: senha,name: "Senha",),
                      // lascar os inputs
                      SizedBox(
                        width: MediaQuery.of(context).size.width,
                        height: 50,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            TextButton(onPressed: (){
                             context.pushReplacement("/esqueciSenha");
                            }, child: Text("Esqueceu a senha?",style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xff474C51)
                            ),))
                          ],
                        ),
                      ),
                      const SizedBox(height: 48,),
                      if(carregando == false)
                      BotaoAzul(text: "Entrar",onPressed: ()=> Logar(),),
                      if(carregando == true)
                      BotaoAzulLoad()
                    ],
                  ),
                ),
              ))
        ],
      ),
    );
  }
}
