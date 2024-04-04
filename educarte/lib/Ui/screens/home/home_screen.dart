import 'dart:convert';

import 'package:educarte/Interector/base/constants.dart';
import 'package:educarte/Ui/components/input.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../Interector/models/api_diaries.dart';
import '../../../Interector/validations/convertter.dart';
import '../../components/bnt_azul.dart';
import '../../components/bnt_azul_load.dart';
import '../../components/bnt_branco.dart';
import '../../global/global.dart' as globals;
import 'package:http/http.dart' as http;

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  TextEditingController nome = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController? telefone = TextEditingController();
  bool loading = false;

  void setLoading({required bool load}){
    setState(() {
      loading = load;
    });
  }

  void meusDados()async{
    setLoading(load: true);
    var response = await http.get(Uri.parse("http://64.225.53.11:5000/Users/Me"),
      headers: {
        "Authorization": "Bearer ${globals.token.toString()}",
      }
    );
    if(response.statusCode == 200){
      Map<String,dynamic> jsonData = jsonDecode(response.body);
      print(jsonData);

      setState(() {
        globals.nome = jsonData["name"];
        nome.text = jsonData["name"];
        email.text = jsonData["email"];
        if(jsonData["cellphone"] != null){
          telefone?.text = jsonData["cellphone"];
        }
      });
    }
  }
  String id = "";
  List<ApiDiaries> listDiaries = [];
  String dataEntrada = "00/00/0000";
  String horaEntrada = "00";
  String minEntrada = "00";
  String horaSaida = "00";
  String minSaida = "00";
  List<String> listData = [];
  var jsonStudent;
  bool carregando = false;


  void getStudentId()async{
    setState(() {
      listDiaries = [];
    });
    try{
      var response = await http.get(Uri.parse("http://64.225.53.11:5000/Students/$id"),
          headers: {
            "Authorization": "Bearer ${globals.token}"
          }
      );
      print(response.statusCode );
      if(response.statusCode == 200){
        var decodeJson = jsonDecode(response.body);
        (decodeJson["diaries"] as List).where((diary) {
          listDiaries.add(ApiDiaries.fromJson(diary));
          return true;
        }).toList();
        print(listDiaries);
        setState(() {
          if(decodeJson["accessControls"].length == 1){
            horaEntrada = DateFormat.H().format(DateTime.parse(decodeJson["accessControls"][0]["time"].toString()));
            dataEntrada = DateFormat.yMd("pt-BR").format(DateTime.parse(decodeJson["accessControls"][0]["time"].toString()));
            minEntrada = DateFormat.m().format(DateTime.parse(decodeJson["accessControls"][0]["time"].toString()));
          }
          else if(decodeJson["accessControls"].length == 2){
            dataEntrada = DateFormat.yMd("pt-BR").format(DateTime.parse(decodeJson["accessControls"][0]["time"].toString()));
            horaEntrada = DateFormat.H().format(DateTime.parse(decodeJson["accessControls"][0]["time"].toString()));
            minEntrada = DateFormat.m().format(DateTime.parse(decodeJson["accessControls"][0]["time"].toString()));
            horaSaida = DateFormat.H().format(DateTime.parse(decodeJson["accessControls"][1]["time"].toString()));
            minSaida = DateFormat.m().format(DateTime.parse(decodeJson["accessControls"][1]["time"].toString()));
          }
        });
        listData = await Convertter.getCurrentDate(isDe: true, data: decodeJson["currentMenu"]["startDate"]);
        setLoading(load: false);

      }
    }catch (e){
      print("erro -----------");
      print(e);
    }
  }

  void student()async{
    var response = await http.get(Uri.parse("http://64.225.53.11:5000/Students?LegalGuardianId=${globals.id}"),
      headers: {
        "Authorization": "Bearer ${globals.token}"
      }
    );

    if(response.statusCode == 200){
      Map<String,dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        id = jsonData["items"][0]["id"];
      });
      getStudentId();
    }

  }

  void putDados()async{
    setState(() {
      carregando = true;
    });
    try{
      Map corpo = {
        "name": nome.text,
        "email": email.text,
        "cellphone": telefone?.text
      };
      var response = await http.put(Uri.parse("http://64.225.53.11:5000/Users/${globals.id}"),
          body: jsonEncode(corpo),
          headers: {
            "Authorization": "Bearer ${globals.token}",
            "Content-Type":"application/json"
          }
      );
      print(response.body);
      if(response.statusCode == 200){
        Future.delayed(Duration(seconds: 1)).then((value) {
          meusDados();
          getStudentId();
        });
        setState(() {
          carregando = false;
        });
      }
    }catch(e){
      print(e);
      setState(() {
        carregando = false;
      });
    }

  }


  @override
  void initState() {
    super.initState();
    meusDados();
    student();
    getStudentId();
  }
  @override
  Widget build(BuildContext context) {
    bool focusInput = MediaQuery.of(context).viewInsets.bottom > 0;
    if (loading) {
      return const Center(
          child: CircularProgressIndicator());
    } else {
      return Scaffold(
        backgroundColor: colorScheme(context).background,
        body: SizedBox(
          width: screenWidth(context),
          height: screenHeight(context),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 50,),
                  SizedBox(
                    width: screenWidth(context),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Olá,", style: GoogleFonts.poppins(
                              color: colorScheme(context).surface,
                              fontWeight: FontWeight.w400,
                              fontSize: 16,
                            ),),
                            Text(globals.nome.toString(),
                              style: GoogleFonts.poppins(
                                color: colorScheme(context).primary,
                                fontWeight: FontWeight.w800,
                                fontSize: 25,
                              ),),
                          ],
                        ),
                        IconButton(onPressed: () {
                          showModalBottomSheet(
                            useRootNavigator: true,
                            isScrollControlled: true,
                            isDismissible: false,
                            context: context,
                            backgroundColor: Colors.black.withOpacity(0.3),
                            builder: (BuildContext context) {
                              return Container(
                                width: screenWidth(context),
                                height: focusInput? 700: 449 ,
                                decoration: BoxDecoration(
                                    color: colorScheme(context).onBackground,
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        topLeft: Radius.circular(8))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(onPressed: () {
                                            Navigator.pop(context);
                                          },
                                              icon: Icon(Symbols.close,
                                                color: colorScheme(context)
                                                    .surface,)),
                                          Text("Meus dados",
                                            style: GoogleFonts.poppins(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600,
                                                color: colorScheme(context)
                                                    .surface
                                            ),)
                                        ],
                                      ),
                                      const SizedBox(height: 32,),
                                      Input(name: "Nome",
                                          obscureText: false,
                                          onChange: nome,
                                      ),
                                      const SizedBox(height: 16,),
                                      Input(name: "E-mail",
                                          obscureText: false,
                                          onChange: email),
                                      const SizedBox(height: 16,),
                                      Input(name: "Telefone",
                                          obscureText: false,
                                          onChange: telefone!),
                                      const SizedBox(height: 32,),
                                      if(carregando == false)
                                      BotaoAzul(text: "Atualizar informações",onPressed: (){putDados();Navigator.pop(context);},),
                                      if(carregando == true)
                                        BotaoAzulLoad(),
                                      const SizedBox(height: 16,),
                                      BotaoBranco(text: "Sair do aplicativo",
                                        onPressed: () => context.go("/login"),)
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }, icon: const Icon(Symbols.account_circle, size: 30,))
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
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
                          offset: const Offset(
                              0, 4), // changes position of shadow
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
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  topRight: Radius.circular(8))
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
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        mainAxisAlignment: MainAxisAlignment
                                            .end,
                                        children: [
                                          Text("Recados de",
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w400,
                                              color: const Color(0xffF5F5F5),
                                            ),),
                                          Text(
                                            "HOJE", style: GoogleFonts.poppins(
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
                          alignment: Alignment.topCenter,
                          child: listDiaries == [] ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Symbols.diagnosis, size: 40,),
                              const SizedBox(height: 12,),
                              SizedBox(
                                width: 279,
                                child: Text(
                                  "O dia passou tranquilo por aqui, sem recados. Mas agradecemos por lembrar de nós!",
                                  style: GoogleFonts.poppins(
                                      fontWeight: FontWeight.w400,
                                      fontSize: 14,
                                      color: colorScheme(context).onSurface
                                  ), textAlign: TextAlign.center,),
                              ),
                            ],
                          ) :
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12),
                            child: Container(
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: ListView.builder(
                                  padding: EdgeInsets.only(top: 10),
                                  itemCount: listDiaries.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      width: screenWidth(context),
                                      margin: EdgeInsets.only(bottom: 12),
                                      decoration: BoxDecoration(
                                          border: Border(
                                              bottom: BorderSide(
                                                  color: colorScheme(
                                                      context).outline.withOpacity(0.5),),
                                          ),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              Text("Para: ",
                                                style: GoogleFonts.poppins(
                                                    fontSize: 14,
                                                    color: colorScheme(
                                                        context).surface,
                                                    fontWeight: FontWeight
                                                        .w500
                                                ),),
                                              if(listDiaries[index].diaryType == 0)
                                                Text(globals.nomeAluno
                                                    .toString(),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      color: colorScheme(context).surface,
                                                      fontWeight: FontWeight.w400
                                                  ),),
                                              if(listDiaries[index].diaryType == 1)
                                                Text(
                                                  globals.nomeSala.toString(),
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      color: colorScheme(context).surface,
                                                      fontWeight: FontWeight.w400
                                                  ),),
                                              if(listDiaries[index].diaryType == 2)
                                                Text("Escola",
                                                  style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      color: colorScheme(context).surface,
                                                      fontWeight: FontWeight.w400
                                                  ),),
                                            ],
                                          ),
                                          const SizedBox(height: 6,),
                                          Text(
                                            listDiaries[index].description.toString(),
                                            style: GoogleFonts.poppins(
                                              fontSize: 14,
                                              color: colorScheme(context).surface,
                                              fontWeight: FontWeight.w300,
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,),
                                          const SizedBox(height: 12,),
                                        ],
                                      ),
                                    );
                                  },

                                ),
                              ),
                            ),
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
                        width: screenWidth(context) / 2 - 24,
                        height: 166,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: colorScheme(context).onBackground,
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.3),
                              spreadRadius: 0,
                              blurRadius: 4,
                              offset: const Offset(
                                  0, 4), // changes position of shadow
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
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8))
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
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        children: [
                                          Text("Entrada",
                                            style: GoogleFonts.poppins(
                                              fontSize: 20,
                                              fontWeight: FontWeight.w500,
                                              color: const Color(0xffF5F5F5),
                                            ),),
                                          Text("e saída",
                                            style: GoogleFonts.poppins(
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8, vertical: 12),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          "Data: ", style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: colorScheme(context)
                                                .onSurface
                                        ),),
                                        Text(dataEntrada,
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: colorScheme(context)
                                                  .onSurface
                                          ),)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Entrada: ",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 14,
                                              color: colorScheme(context)
                                                  .onSurface
                                          ),),
                                        Text("${horaEntrada}h ${minEntrada}min",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: colorScheme(context)
                                                  .onSurface
                                          ),)
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text(
                                          "Saída: ", style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize: 14,
                                            color: colorScheme(context)
                                                .onSurface
                                        ),),
                                        Text("${horaSaida}h ${minSaida}min",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w400,
                                              fontSize: 14,
                                              color: colorScheme(context)
                                                  .onSurface
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
                      GestureDetector(
                        onTap: () {
                          showModalBottomSheet(
                            isDismissible: false,
                            useRootNavigator: true,
                            context: context,
                            backgroundColor: Colors.black.withOpacity(0.3),
                            builder: (BuildContext context) {
                              return Container(
                                width: screenWidth(context),
                                height: 277,
                                decoration: BoxDecoration(
                                    color: colorScheme(context).onBackground,
                                    borderRadius: const BorderRadius.only(
                                        topRight: Radius.circular(8),
                                        topLeft: Radius.circular(8))
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                  child: Column(
                                    children: [
                                      Row(
                                        children: [
                                          IconButton(onPressed: () {
                                            Navigator.pop(context);
                                          },
                                              icon: Icon(Symbols.close,
                                                color: colorScheme(context)
                                                    .surface,)),
                                          Text("Cardápio em PDF",
                                            style: GoogleFonts.poppins(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600,
                                                color: colorScheme(context)
                                                    .surface
                                            ),)
                                        ],
                                      ),
                                      const SizedBox(height: 32,),
                                      BotaoAzul(text: "Visualizar"),
                                      const SizedBox(height: 16,),
                                      BotaoBranco(text: "Baixar"),
                                      const SizedBox(height: 16,),
                                      BotaoBranco(text: "Compartilhar"),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: Container(
                          width: screenWidth(context) / 2 - 24,
                          height: 166,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(8),
                            color: colorScheme(context).onBackground,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                spreadRadius: 0,
                                blurRadius: 4,
                                offset: const Offset(
                                    0, 4), // changes position of shadow
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
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8))
                                ),
                                child: Stack(
                                  children: [
                                    Align(
                                        alignment: Alignment.bottomRight,
                                        child: Image.asset(
                                            "assets/imgAtualizacao.png")
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 8),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: SizedBox(
                                          width: screenWidth(context),
                                          child: RichText(text: TextSpan(
                                              children: [
                                                TextSpan(
                                                  text: "Atualização\ndo ",
                                                  style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight
                                                          .w400,
                                                      fontSize: 20,
                                                      color: colorScheme(
                                                          context).onPrimary
                                                  ),
                                                ),
                                                TextSpan(
                                                  text: "CARDÁPIO",
                                                  style: GoogleFonts.poppins(
                                                      fontWeight: FontWeight
                                                          .bold,
                                                      fontSize: 20,
                                                      color: colorScheme(
                                                          context).onPrimary
                                                  ),
                                                )
                                              ]
                                          )),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8, vertical: 10),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment
                                        .spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment
                                        .center,
                                    children: [
                                      Text(
                                        listData[0], style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 16,
                                          color: colorScheme(context).onSurface
                                      ),),
                                      Text(listData[1].trim(),
                                        style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                            color: colorScheme(context)
                                                .onSurface
                                        ),),
                                      Text(
                                        listData[2], style: GoogleFonts.poppins(
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
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      );
    }
  }
}
