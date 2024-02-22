import 'package:educarte/Interector/base/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: colorScheme(context).background,

      body: Container(
        width: screenWidth(context),
        height: screenHeight(context),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: [
              const SizedBox(height: 54,),
              SizedBox(
                width: screenWidth(context),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Olá,",style: GoogleFonts.poppins(
                          color: colorScheme(context).surface,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                        ),),
                        Text("Antônio",style: GoogleFonts.poppins(
                          color: colorScheme(context).primary,
                          fontWeight: FontWeight.w800,
                          fontSize: 25,
                        ),),
                      ],
                    ),
                    IconButton(onPressed: (){}, icon: Icon(Symbols.account_circle,size: 30,))
                  ],
                ),
              ),
              const SizedBox(height: 24,),
              Container(
                width: screenWidth(context),
                height: 400,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: colorScheme(context).onBackground,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.3),
                      spreadRadius: 0,
                      blurRadius: 4,
                      offset: Offset(0, 4), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Container(
                      width: screenWidth(context),
                      height: 103,
                      decoration: BoxDecoration(
                        color: colorScheme(context).primary,
                        borderRadius:const BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8))
                      ),
                      child: Stack(
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(right: 10),
                            child: Align(
                              alignment: Alignment.bottomRight,
                              child: SizedBox(
                                height: 80,
                                child: SingleChildScrollView(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text("Recados de",style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xffF5F5F5),
                                      ),),
                                      Text("HOJE",style: GoogleFonts.poppins(
                                          fontSize: 71,
                                          fontWeight: FontWeight.w800,
                                          color: const Color(0xffF5F5F5),
                                          height: 0.8
                                      ),),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Image.asset("assets/imgRecados.png"),
                        ],
                      ),
                    ),
                    Container(
                      width: screenWidth(context),
                      height: 297,
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Symbols.diagnosis,size: 40,),
                          const SizedBox(height: 12,),
                          SizedBox(
                            width: 279,
                              child: Text("O dia passou tranquilo por aqui, sem recados. Mas agradecemos por lembrar de nós!",style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 14,
                                color: colorScheme(context).onSurface
                              ),textAlign: TextAlign.center,),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12,),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 165,
                    height: 165,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: colorScheme(context).onBackground,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(0, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: screenWidth(context),
                          height: 74,
                          decoration: BoxDecoration(
                              color: colorScheme(context).secondary,
                              borderRadius:const BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8))
                          ),
                          child: Stack(
                            children: [
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Image.asset("assets/imgEntSd.png")
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text("Entrada",style: GoogleFonts.poppins(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xffF5F5F5),
                                      ),),
                                      Text("e saída",style: GoogleFonts.poppins(
                                          fontSize: 20,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xffF5F5F5),
                                      ),),
                                    ],
                                  ),
                                ),
                              ),

                            ],
                          ),
                        ),
                        Container(
                          width: screenWidth(context),
                          height: 91,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 12),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Row(
                                  children: [
                                    Text("Data: ",style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                        color: colorScheme(context).onSurface
                                    ),),
                                    Text("00 / 00 / 0000",style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14,
                                        color: colorScheme(context).onSurface
                                    ),)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Entrada: ",style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                        color: colorScheme(context).onSurface
                                    ),),
                                    Text("07h 10min",style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: colorScheme(context).onSurface
                                    ),)
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("Saída: ",style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                        color: colorScheme(context).onSurface
                                    ),),
                                    Text("19h 49min",style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w400,
                                        fontSize: 14,
                                        color: colorScheme(context).onSurface
                                    ),)
                                  ],
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: 165,
                    height: 165,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: colorScheme(context).onBackground,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          spreadRadius: 0,
                          blurRadius: 4,
                          offset: Offset(0, 4), // changes position of shadow
                        ),
                      ],
                    ),
                    child: Column(
                      children: [
                        Container(
                          width: screenWidth(context),
                          height: 74,
                          decoration: BoxDecoration(
                              color: colorScheme(context).onSecondary,
                              borderRadius:const BorderRadius.only(topLeft: Radius.circular(8),topRight: Radius.circular(8))
                          ),
                          child: Stack(
                            children: [
                              Align(
                                  alignment: Alignment.bottomRight,
                                  child: Image.asset("assets/imgAtualizacao.png")
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: Align(
                                  alignment: Alignment.centerLeft,
                                  child: RichText(text: TextSpan(
                                      children: [
                                        TextSpan(
                                          text: "Atualização do",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize:19,
                                              color: colorScheme(context).onPrimary
                                          ),
                                        ),
                                        TextSpan(
                                          text: "CARDÁPIO",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.bold,
                                              fontSize:20,
                                              color: colorScheme(context).onPrimary
                                          ),
                                        )
                                      ]
                                  )),
                                ),
                              ),

                            ],
                          ),
                        ),
                        Container(
                          width: screenWidth(context),
                          height: 91,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8,vertical: 10),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("29 de",style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w300,
                                    fontSize: 16,
                                    color: colorScheme(context).onSurface
                                ),),
                                Text("Janeiro",style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 20,
                                    color: colorScheme(context).onSurface
                                ),),
                                Text("2024",style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12,
                                    color: colorScheme(context).onSurface
                                ),),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
