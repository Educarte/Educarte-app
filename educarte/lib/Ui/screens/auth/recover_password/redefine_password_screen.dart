import 'dart:convert';
import 'package:educarte/Ui/screens/auth/login_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:http/http.dart' as http;

import '../../../global/global.dart' as globals;
import '../../../components/bnt_azul.dart';
import '../../../components/input.dart';

class RedefinePassword extends StatefulWidget {
  const RedefinePassword({
    super.key,
    this.firstAccess = false
  });
  final bool firstAccess;

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
    print(response.statusCode);
    if(response.statusCode == 200 && mounted){
      if(widget.firstAccess == true){
        context.go("/home");
      }else{
        context.go("/login");
      }


      var snackBar = SnackBar(
        backgroundColor: const Color(0xff547B9A),
        content: Center(
          child: Text("Senha redefinida com sucesso!",style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white
          ),),
        )
      );
      
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
  void updatePasswordFirstAcess()async{
    print("oi");
    setState(() {
      carregando = true;
    });
    Map corpo = {
      "userId": globals.id.toString(),
      "newPassword": novaSenha.text,
      "confirmPassword": confirmarSenha.text
    };

    var response = await http.post(Uri.parse("http://64.225.53.11:5000/Users/${globals.id}/ResetPassword"),
        body: jsonEncode(corpo),
        headers: {
          "Content-Type":"application/json"
        }
    );
    print(response.statusCode);
    if(response.statusCode == 200 && mounted){
      context.go("/home");

      var snackBar = SnackBar(
          backgroundColor: const Color(0xff547B9A),
          content: Center(
            child: Text("Senha redefinida com sucesso!",style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: Colors.white
            ),),
          )
      );

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
  void initState() {
    // TODO: implement initState
    super.initState();
    print("primeiro acesso esta ${widget.firstAccess}");
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        leading: widget.firstAccess ? IconButton(onPressed: (){
          if(widget.firstAccess == false)
          context.pushReplacement("/login");
        }, icon:  const Icon(Symbols.close,color:Color(0xff474C51),)):
            null,
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
              BotaoAzul(text: "Continuar",onPressed: () {
                //Navigator.push(context, MaterialPageRoute(builder: (context)=> const LoginScreen()));
              },loading: carregando,),
            ],
          ),
        ),
      ),
    );
  }
}
