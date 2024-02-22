import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../components/bntAzul.dart';
import '../components/input.dart';
import 'email_code_screen.dart';
import 'login_screen.dart';

class RedefinePassword extends StatefulWidget {
  const RedefinePassword({super.key});

  @override
  State<RedefinePassword> createState() => _RedefinePasswordState();
}

class _RedefinePasswordState extends State<RedefinePassword> {
  TextEditingController novaSenha = TextEditingController();
  TextEditingController confirmarSenha = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF5F5F5),
      appBar: AppBar(
        leading: IconButton(onPressed: (){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> const LoginScreen()));
        }, icon: const Icon(Symbols.close,color: Color(0xff474C51),)),
        backgroundColor: const Color(0xffF5F5F5),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(
              height: 132,
            ),
            Icon(Symbols.password,color: const Color(0xff547B9A).withOpacity(0.7),size: 95,),
            const SizedBox(height: 48,),
            Text("Esquecia a Senha",style: GoogleFonts.poppins(
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
            Input(name: "Nova Senha", obscureText: true,onChange: novaSenha,),
            const SizedBox(height: 24,),
            Input(name: "Confirmar nova senha", obscureText: true,onChange: confirmarSenha,),
            const SizedBox(height: 85,),
            BotaoAzul(text: "Continuar",onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> const LoginScreen())),),
          ],
        ),
      ),
    );
  }
}
