import 'package:educarte/Ui/screens/redefine_password_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../components/bntAzul.dart';
import 'login_screen.dart';

class EmailCode extends StatefulWidget {
  const EmailCode({super.key});

  @override
  State<EmailCode> createState() => _EmailCodeState();
}

class _EmailCodeState extends State<EmailCode> {
  String _code = "";
  bool existError = false;
  bool loading = false;
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
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(
                height: 132,
              ),
              Icon(Symbols.mark_email_unread,color: const Color(0xff547B9A).withOpacity(0.7),size: 95,),
              const SizedBox(height: 48,),
              Text("Verifique seu e-mail",style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize:24,
                  color: const Color(0xff474C51),
                  height: 1.5
              ),),
              RichText(text: TextSpan(
                  children: [
                    TextSpan(
                      text: "Digite o código de 4 dígitos enviados para o e-mail ",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w400,
                          fontSize:14,
                          color: const Color(0xff474C51)
                      ),
                    ),
                    TextSpan(
                      text: "username@email.com",
                      style: GoogleFonts.poppins(
                          fontWeight: FontWeight.bold,
                          fontSize:14,
                          color: const Color(0xff474C51)
                      ),
                    )
                  ]
              )),
              const SizedBox(height: 24,),
              SizedBox(
                width: MediaQuery.of(context).size.height,
                child: PinCodeTextField(
                  keyboardType: TextInputType.number,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  animationType: AnimationType.scale,
                  autoDismissKeyboard: true,
                  textStyle: GoogleFonts.quicksand(textStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 35,color: Color(0xffCBCDD1)
                  )),
                  cursorColor: const Color(0xff547B9A),
                  pinTheme: PinTheme(
                    disabledBorderWidth: 0.5,
                    selectedColor: const Color(0xff547B9A),
                    selectedFillColor: Colors.white,
                    fieldOuterPadding: const EdgeInsets.symmetric(horizontal: 17),
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(5),
                    activeFillColor: const Color(0xff547B9A),
                    fieldHeight: 68,
                    fieldWidth: 55,
                    borderWidth: 0.2,
                    errorBorderColor: Colors.red,
                    inactiveColor: const Color(0xffA0A4A8),
                    activeColor: const Color(0xff547B9A),
                  ),
                  length: 4,
                  appContext: context,
                  onChanged: loading ? null : (code) {
                    setState(() {
                      existError = true;
                    });
                    _code = code;
                  },
                  // onCompleted: (value) async => await widget.loginStore.validateResetePasswordCode(code: _code, context: context, loginStore: widget.loginStore),
                ),
              ),
              const SizedBox(height: 120,),
              BotaoAzul(text: "Continuar",onPressed: ()=> Navigator.pushReplacement(context, MaterialPageRoute(builder: (BuildContext context)=> RedefinePassword())),),
              const SizedBox(height: 8,),
              Align(
                alignment: Alignment.center,
                child: TextButton(onPressed: (){
          
                }, child: Text("Reenviar Código",style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xff474C51)
                ),)),
              )
            ],
          ),
        ),
      ),
    );
  }
}
