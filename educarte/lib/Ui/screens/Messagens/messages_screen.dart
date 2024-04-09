import 'dart:convert';

import 'package:educarte/Interector/base/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../Interector/models/api_diaries.dart';
import '../../../Services/config/api_config.dart';
import '../../components/bnt_azul.dart';
import '../../components/bnt_branco.dart';
import '../../components/result_not_found.dart';
import '../../components/table_calendar.dart';
import 'package:http/http.dart' as http;
import '../../global/global.dart' as globals;

class MessagesScreen extends StatefulWidget {
  const MessagesScreen({
    super.key, 
    this.idStudent
  });
  final String? idStudent;
  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}
enum Loadings {none,initial,list}

class _MessagesScreenState extends State<MessagesScreen> {
  DateTime today = DateTime.now();
  String id = "";
  List<ApiDiaries> listDiaries = [];
  Loadings loading = Loadings.none;

  void setLoading({required Loadings load}){
    setState(() {
      loading = load;
    });
  }

  void student()async{
    setLoading(load: Loadings.initial);
    var response = await http.get(Uri.parse("http://64.225.53.11:5000/Students?LegalGuardianId=${globals.id}"),
        headers: {
          "Authorization": "Bearer ${globals.token}"
        },

    );

    if(response.statusCode == 200){
      Map<String,dynamic> jsonData = jsonDecode(response.body);
      setState(() {
        id = jsonData["items"][0]["id"];
      });
      getStudentId();
    }

  }

  void diaryId(String? startDate)async{
    setLoading(load: Loadings.list);
    var params = {
      'StudentId': id,
      "StartDate": startDate
    };
    var response = await http.get(Uri.parse("$baseUrl/Diary").replace(queryParameters: params),
        headers: {
          "Authorization": "Bearer ${globals.token}"
        }
    );
    if(response.statusCode == 200){
      var decodeJson = jsonDecode(response.body);
      (decodeJson["diaries"] as List).where((diary) {
        listDiaries.add(ApiDiaries.fromJson(diary));
        return true;
      }).toList();
    }
    setLoading(load: Loadings.none);
  }


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
      if(response.statusCode == 200){
        var decodeJson = jsonDecode(response.body);

        if(decodeJson["diaries"] != null){
          (decodeJson["diaries"] as List).where((diary) {
            listDiaries.add(ApiDiaries.fromJson(diary));
            return true;
          }).toList();
        }

        setLoading(load: Loadings.none);
      }
    }catch (e){
      print("erro -----------");
      print(e);
    }
  }
  @override
  void initState() {
    super.initState();
    student();
    Future.delayed(const Duration(seconds: 1)).then((value) {
      getStudentId();
    });
  }
  @override
  Widget build(BuildContext context) {
    if (loading == Loadings.initial) {
      return const Center(
        child: CircularProgressIndicator()
      );
    } else {
      return Scaffold(
        body: Container(
          width: screenWidth(context),
          height: screenHeight(context),
          color: colorScheme(context).background,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            child: Column(
              children: [
                const SizedBox(height: 20,),
                CustomTableCalendar(
                  callback: (DateTime? startDate, DateTime? endDate) {
                    if (endDate != null) {
                      if (startDate != null && startDate.isAfter(endDate)) {
                        DateTime temp = startDate;
                        startDate = endDate;
                        endDate = temp;
                      }
                    }
                    diaryId(DateFormat.yMd().format(startDate!));
                  },),
                if(loading == Loadings.list)
                const Expanded(
                  child: Center(
                  child: CircularProgressIndicator()),
                )
                else
                Expanded(
                  child: listDiaries.isEmpty ? const ResultNotFound(
                    description: "O dia passou tranquilo por aqui, sem recados. Mas agradecemos por lembrar de nós!", 
                    iconData: Symbols.diagnosis
                  ) : ListView.builder(
                    padding: const EdgeInsets.only(top: 10),
                    shrinkWrap: true,
                    itemCount: listDiaries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: screenWidth(context),
                        height: 385,
                        margin: const EdgeInsets.only(bottom: 16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8),
                          color: colorScheme(context).onPrimary,
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
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            if(listDiaries[index].diaryType == 2)
                            Container(
                              width: screenWidth(context),
                              height: 120,
                              decoration: BoxDecoration(
                                  color: colorScheme(context).onSecondary,
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(8),
                                      topRight: Radius.circular(8))
                              ),
                              alignment: Alignment.center,
                              child: Row(
                                children: [
                                  Align(
                                      alignment: Alignment.bottomRight,
                                      child: Image.asset(
                                          "assets/imgRecados1.png")
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 32),
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Text("Para:",style: GoogleFonts.poppins(
                                              fontWeight: FontWeight
                                                  .w200,
                                              fontSize: 20,
                                              color: colorScheme(
                                                  context).onPrimary
                                          ),),
                                          SizedBox(
                                            width: 175,
                                            child: Text("ESCOLA",style: GoogleFonts.poppins(
                                              textStyle: const TextStyle(
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                              fontWeight: FontWeight
                                                  .w800,
                                              fontSize: 20,
                                              color: colorScheme(
                                                  context).onPrimary,
                                            ),),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            if(listDiaries[index].diaryType == 1)
                              Container(
                                width: screenWidth(context),
                                height: 120,
                                decoration: BoxDecoration(
                                    color: colorScheme(context).primary,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8))
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 11),
                                      child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Image.asset(
                                              "assets/imgRecados2.png")
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 32),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Para:",style: GoogleFonts.poppins(
                                                fontWeight: FontWeight
                                                    .w200,
                                                fontSize: 20,
                                                color: colorScheme(
                                                    context).onPrimary
                                            ),),
                                            SizedBox(
                                              width: 175,
                                              child: Text(globals.nomeSala.toString().toUpperCase(),style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                fontWeight: FontWeight
                                                    .w800,
                                                fontSize: 20,
                                                color: colorScheme(
                                                    context).onPrimary,
                                              ),),
                                            ),
                                          ],
                                        )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            if(listDiaries[index].diaryType == 0)
                              Container(
                                width: screenWidth(context),
                                height: 120,
                                decoration: BoxDecoration(
                                    color: colorScheme(context).secondary,
                                    borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(8),
                                        topRight: Radius.circular(8))
                                ),
                                alignment: Alignment.center,
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 11),
                                      child: Align(
                                          alignment: Alignment.bottomRight,
                                          child: Image.asset(
                                              "assets/imgRecados3.png")
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(left: 32),
                                      child: Align(
                                        alignment: Alignment.center,
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Text("Para:",style: GoogleFonts.poppins(
                                                fontWeight: FontWeight
                                                    .w200,
                                                fontSize: 20,
                                                color: colorScheme(
                                                    context).onPrimary
                                            ),),
                                            SizedBox(
                                              width: 170,
                                              child: Text(globals.nomeAluno.toString().toUpperCase(),style: GoogleFonts.poppins(
                                                textStyle: const TextStyle(
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                                fontWeight: FontWeight
                                                    .w800,
                                                fontSize: 20,
                                                color: colorScheme(
                                                    context).onPrimary,
                                              ),),
                                            ),
                                          ],
                                        )
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            Container(
                              width: screenWidth(context),
                              height: 265,
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("Prezados Pais e Responsáveis,",style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400
                                    ),),
                                    const SizedBox(height: 20,),
                                    Text("Gostaríamos de informar que o calendário de atividades para o próximo mês já está disponível no site da escola. Pedimos que acessem e confiram as datas de eventos, reuniões e demais atividades importantes. Em caso de dúvidas, estamos à disposição para esclarecimentos.",style: GoogleFonts.poppins(
                                      fontSize: 14,
                                      fontWeight: FontWeight.w400
                                    ),textAlign: TextAlign.start,),
                                    const SizedBox(height: 15,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text("Atenciosamente,",style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400
                                            ),),
                                            Text("A Direção",style: GoogleFonts.poppins(
                                                fontSize: 14,
                                                fontWeight: FontWeight.w400
                                            ),),
                                          ],
                                        ),
                                        if(listDiaries[index].fileUri != null)
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
                                                            Text("Arquivo em PDF",
                                                              style: GoogleFonts.poppins(
                                                                  fontSize: 22,
                                                                  fontWeight: FontWeight.w600,
                                                                  color: colorScheme(context)
                                                                      .surface
                                                              ),)
                                                          ],
                                                        ),
                                                        const SizedBox(height: 32,),
                                                        const BotaoAzul(text: "Visualizar"),
                                                        const SizedBox(height: 16,),
                                                        const BotaoBranco(text: "Baixar"),
                                                        const SizedBox(height: 16,),
                                                        const BotaoBranco(text: "Compartilhar"),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              },
                                            );
                                          },
                                          child: Container(
                                            width: 36,
                                            height: 36,
                                            decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: colorScheme(context).secondary,
                                            ),
                                            alignment: Alignment.center,
                                            child: Icon(Symbols.attach_file,color: colorScheme(context).surface,size: 20,),
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      );
    }
  }
}
