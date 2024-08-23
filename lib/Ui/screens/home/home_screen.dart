import 'dart:convert';

import 'package:educarte/core/base/constants.dart';
import 'package:educarte/core/enum/persistence_enum.dart';
import 'package:educarte/Interector/models/students_model.dart';
import 'package:educarte/Services/config/repositories/persistence_repository.dart';
import 'package:educarte/Ui/components/input.dart';
import 'package:educarte/Ui/components/result_not_found.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../Interector/models/api_diaries.dart';
import '../../../Interector/models/document.dart';
import '../../../Interector/validations/convertter.dart';
import '../../../Services/helpers/file_management_helper.dart';
import '../../components/bnt_azul.dart';
import '../../components/bnt_branco.dart';
import '../../global/global.dart' as globals;
import 'package:http/http.dart' as http;

import '../../global/global.dart';

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
  String id = "";
  List<ApiDiaries> listDiaries = [];
  List<ApiDiaries> listDiariesFiltro = [];
  String dataEntrada = "00/00/0000";
  String horaEntrada = "00";
  String minEntrada = "00";
  String horaSaida = "00";
  String minSaida = "00";
  List<String> listData = [];
  bool carregando = false;
  bool loadingDownload = false;

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

      setState(() {
        List<String> groupNames = jsonData["name"].toString().split(" ");
        globals.nome = groupNames.first;
        nome.text = jsonData["name"];
        email.text = jsonData["email"];
        if(jsonData["cellphone"] != null){
          telefone?.text = jsonData["cellphone"];
        }
      });
    }
  }

  Student student = Student();
  void getStudentId() async{
    setState(() {
      listDiaries.clear();
      globals.currentStudent.value.listDiaries!.clear();
    });
    try{
      var response = await http.get(Uri.parse("http://64.225.53.11:5000/Students/${globals.currentStudent.value.id}"),
          headers: {
            "Authorization": "Bearer ${globals.token}"
          }
      );
      if(response.statusCode == 200){
        var decodeJson = jsonDecode(response.body);

        if(decodeJson["diaries"] != null){
          (decodeJson["diaries"] as List).where((diary) {
            listDiaries.add(ApiDiaries.fromJson(diary));
            return true;
          }).toList();
        }
        setState(() {
          listDiariesFiltro = listDiaries;
          listDiaries = listDiariesFiltro.where((element) => DateFormat.yMd().format(DateTime.parse(element.time.toString())) == DateFormat.yMd().format(DateTime.now())).toList();
          List accessControls = decodeJson["accessControls"] ?? [];
          globals.currentStudent.value.listDiaries = listDiaries;
          if(accessControls.length == 1){
            globals.currentStudent.value.horaEntrada = decodeJson["accessControls"][0]["time"].toString();
          }
          else if(accessControls.length == 2){
            globals.currentStudent.value.horaEntrada = decodeJson["accessControls"][0]["time"].toString();
            globals.currentStudent.value.horaSaida = decodeJson["accessControls"][1]["time"].toString();
          }
        });
        if(decodeJson["currentMenu"] != null){
          listData = await Convertter.getCurrentDate(isDe: true, data: decodeJson["currentMenu"]["startDate"]);
        }

        setState(() => updateHomeScreen = false);
        
        setLoading(load: false);
      }
    }catch (e){
      return;
    }
  }

  void studentGet()async{
    var response = await http.get(Uri.parse("http://64.225.53.11:5000/Students?LegalGuardianId=${globals.id}"),
      headers: {
        "Authorization": "Bearer ${globals.token}"
      }
    );
    if(response.statusCode == 200){
      Map<String,dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        if(globals.currentStudent.value.isEmpty) globals.currentStudent.value = Student.fromJson(jsonData["items"][0]);
        id = globals.currentStudent.value.id!;
        globals.nomeAluno = globals.currentStudent.value.name;

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

      if(response.statusCode == 200){
        Future.delayed(const Duration(seconds: 1)).then((value) {
          meusDados();
          getStudentId();
        });
        setState(() {
          carregando = false;
        });
      }else{
        setState(() {
          carregando = false;
        });
      }
    }catch(e){
      setState(() {
        carregando = false;
      });
    }
  }

  Document document = Document.empty();
  void getMenu()async{
    var response = await http.get(Uri.parse("http://64.225.53.11:5000/Menus"),
        headers: {
          "Authorization": "Bearer ${globals.token}"
        }
    );

    if(response.statusCode == 200){
      Map<String,dynamic> decodeJson = jsonDecode(response.body);
      setState(() {
        document = Document(id: decodeJson["items"][0]["id"].toString(),name: decodeJson["items"][0]["name"].toString(),fileUri: decodeJson["items"][0]["uri"].toString());
      });
    }

  }
  String dateConverteData(String date){
    DateTime dateTime = DateTime.parse(date);


    String formattedDate = DateFormat('HH', 'pt_BR').format(dateTime);
    String formattedTime = DateFormat('mm', 'pt_BR').format(dateTime);

    // Concatenando a data formatada
    String result = '${formattedDate}h. ${formattedTime}min';

    // Output
    return result; // Saída: 18h. 08 Min

  }

  Future<void> logout()async{
    PersistenceRepository persistenceRepository = PersistenceRepository();

    await persistenceRepository.delete(key: SecureKey.token);
    setState(() {
      globals.currentStudent.value = Student.empty();
      globals.id = "";
      globals.nomeAluno = "";
      globals.idStudent = "";
      globals.nomeSala = "";
      globals.token = "";
    });
    if(context.mounted){
      context.go("/login");
    }
  }

  @override
  void initState() {
    super.initState();
    meusDados();
    studentGet();
    getMenu();
  }

  @override
  Widget build(BuildContext context) {
    TextStyle diaryStyle = GoogleFonts.poppins(
        fontSize: 14,
        color: colorScheme(context).surface,
        fontWeight: FontWeight.w400
    );

    bool focusInput = MediaQuery.of(context).viewInsets.bottom > 0;
    if (loading) {
      return const Center(
          child: CircularProgressIndicator());
    } else {
      return ValueListenableBuilder(
        valueListenable: globals.currentStudent,
        builder: (_, __, ___){
          return Scaffold(
            resizeToAvoidBottomInset: false ,
            backgroundColor: colorScheme(context).background,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  Expanded(
                    flex: 0,
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
                        IconButton(
                          onPressed: () {
                            showModalBottomSheet(
                              useRootNavigator: true,
                              isScrollControlled: true,
                              isDismissible: false,
                              context: context,
                              backgroundColor: Colors.black.withOpacity(0.3),
                              builder: (BuildContext context) {
                                return Container(
                                  width: screenWidth(context),
                                  height: focusInput? 900 : 449,
                                  decoration: BoxDecoration(
                                    color: colorScheme(context).onBackground,
                                    borderRadius: const BorderRadius.only(
                                      topRight: Radius.circular(8),
                                      topLeft: Radius.circular(8)
                                    )
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 16),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            IconButton(
                                              onPressed: () {
                                                Navigator.pop(context);
                                              },
                                              icon: Icon(
                                                Symbols.close,
                                                color: colorScheme(context).surface
                                              )
                                            ),
                                            Text("Meus dados",
                                              style: GoogleFonts.poppins(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w600,
                                                color: colorScheme(context).surface
                                              )
                                            )
                                          ]
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
                                        BotaoAzul(text: "Atualizar informações",
                                          onPressed: () {
                                            putDados();
                                            Navigator.pop(context);
                                          },
                                          loading: carregando,
                                        ),
                                        const SizedBox(height: 16,),
                                        BotaoBranco(text: "Sair do aplicativo",
                                          onPressed: () async{
                                            logout();
                                          }
                                        )
                                      ],
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                          icon: const Icon(
                            Symbols.account_circle,
                            size: 30
                          )
                        )
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: screenWidth(context),
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
                          if(globals.currentStudent.value.listDiaries != null)
                          Expanded(
                            child: globals.currentStudent.value.listDiaries!.isEmpty ?
                            const ResultNotFound(
                              description: "O dia passou tranquilo por aqui, sem recados. Mas agradecemos por lembrar de nós!",
                              iconData: Symbols.diagnosis
                            ) :
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 12),
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: ListView.builder(
                                  padding: const EdgeInsets.only(top: 10),
                                  itemCount: globals.currentStudent.value.listDiaries!.length,
                                  itemBuilder: (BuildContext context, int index) {
                                    return Container(
                                      width: screenWidth(context),
                                      margin: const EdgeInsets.only(bottom: 12),
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
                                              Text(
                                                  "Para: ",
                                                style: diaryStyle.copyWith(
                                                  fontWeight: FontWeight.w500
                                                )
                                              ),
                                              switch(globals.currentStudent.value.listDiaries![index].diaryType){
                                                0 => Text(
                                                    globals.currentStudent.value.name!,
                                                    style: diaryStyle
                                                ),
                                                1 =>  Text(
                                                  globals.nomeSala.toString(),
                                                  style: diaryStyle
                                                ),
                                                _ => Text(
                                                    "Escola",
                                                    style: diaryStyle
                                                )
                                              }
                                            ],
                                          ),
                                          const SizedBox(height: 6,),
                                          Text(
                                            globals.currentStudent.value.listDiaries![index].description!,
                                            style: diaryStyle.copyWith(
                                                fontWeight: FontWeight.w300
                                            ),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,),
                                          const SizedBox(height: 12),
                                        ],
                                      ),
                                    );
                                  },
          
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Expanded(
                    flex: 0,
                    child: Row(
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
                              SizedBox(
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
                                          if(globals.currentStudent.value.horaEntrada != null)
                                          Text(DateFormat('yMd', 'pt_BR').format(DateTime.parse(globals.currentStudent.value.horaEntrada!)) ,
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w500,
                                                fontSize: 14,
                                                color: colorScheme(context)
                                                    .onSurface
                                            ),),
                                          if(globals.currentStudent.value.horaEntrada == null)
                                            Text("00/00/00",
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: colorScheme(context)
                                                      .onSurface
                                              ),),
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
                                          if(globals.currentStudent.value.horaEntrada != null)
                                          Text(dateConverteData(globals.currentStudent.value.horaEntrada!),
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: colorScheme(context)
                                                    .onSurface
                                            ),),
                                          if(globals.currentStudent.value.horaEntrada == null)
                                            Text("00h 00min",
                                              style: GoogleFonts.poppins(
                                                  fontWeight: FontWeight.w400,
                                                  fontSize: 14,
                                                  color: colorScheme(context)
                                                      .onSurface
                                              ),),
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
                                          if(globals.currentStudent.value.horaSaida == null)
                                          Text("00h 00min",
                                            style: GoogleFonts.poppins(
                                                fontWeight: FontWeight.w400,
                                                fontSize: 14,
                                                color: colorScheme(context)
                                                    .onSurface
                                            ),),
                                          if(globals.currentStudent.value.horaSaida != null)
                                            Text(dateConverteData(globals.currentStudent.value.horaSaida!),
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
                                return StatefulBuilder(builder: (context,setstate){
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
                                          BotaoAzul(text: "Visualizar", onPressed: () {
                                            if(loadingDownload == false){
                                              FileManagement.launchUri(link: document.fileUri
                                                  .toString(), context: context);
                                            }
                                          },),
                                          const SizedBox(height: 16,),
                                          BotaoBranco(text: "Baixar", onPressed: () {
                                            setstate((){
                                              loadingDownload = true;
                                            });
                                            FileManagement.download(url: document.fileUri
                                                .toString(), fileName: "Cardápio");
                                            Future.delayed(const Duration(seconds: 2)).then((value) {
                                              setstate((){
                                                loadingDownload = false;
                                              });
                                            });
                                          },
                                            loading: loadingDownload,
                                          ),
                                          const SizedBox(height: 16,),
                                          BotaoBranco(text: "Compartilhar", onPressed:  () {
                                            if(loadingDownload == false){
                                              FileManagement.share(url: document.fileUri.toString(),
                                                  document: document);
                                            }
                                          },

                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                });
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
                                SizedBox(
                                  width: screenWidth(context),
                                  height: 91,
                                  child: listData.length < 3 ?
                                    Center(
                                      child: Text(
                                        "Sem atualizações!",
                                        style: GoogleFonts.poppins(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 14,
                                          color: colorScheme(context).outline
                                        ),
                                      ),
                                    )
                                  : Padding(
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
                    ),
                  )
                ],
              ),
            ),
          );
        }
      );
    }
  }
}
