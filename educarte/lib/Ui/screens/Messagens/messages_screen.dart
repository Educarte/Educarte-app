import 'dart:convert';

import 'package:educarte/Interector/base/constants.dart';
import 'package:educarte/Ui/components/card_messages.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../Interector/models/api_diaries.dart';
import '../../../Services/config/api_config.dart';
import '../../../Services/helpers/file_management_helper.dart';
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
  bool loadingDownload = false;

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
    }

  }

  void diaryId(DateTime startDate, DateTime? endDate)async{
    setLoading(load: Loadings.list);
    setState(() {
      listDiaries = [];
    });

    var params = {
      'StudentId': globals.idStudent,
      "StartDate": startDate.toString(),
      "EndDate": endDate == null ? startDate.toString() : endDate.toString()
    };
    var response = await http.get(Uri.parse("$baseUrl/Diary").replace(queryParameters: params),
        headers: {
          "Authorization": "Bearer ${globals.token}"
        }
    );
    print(startDate);
    if(response.statusCode == 200){
      var decodeJson = jsonDecode(response.body);
      print(decodeJson);
      if(decodeJson["items"] != null){
        (decodeJson["items"] as List).where((diary) {
          listDiaries.add(ApiDiaries.fromJson(diary));
          return true;
        }).toList();
      }
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


        diaryId(DateTime.now(), null);

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
      diaryId(DateTime.now(), DateTime.now());
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
        body: SafeArea(
          child: Container(
            width: screenWidth(context),
            height: screenHeight(context),
            color: colorScheme(context).background,
            alignment: Alignment.center,
            child: Column(
              children: [
                CustomTableCalendar(
                  paddingTop: 16,
                  callback: (DateTime? startDate, DateTime? endDate) {
                    if (endDate != null) {
                      if (startDate != null && startDate.isAfter(endDate)) {
                        DateTime temp = startDate;
                        startDate = endDate;
                        endDate = temp;
                      }
                    }
                    diaryId(startDate!, endDate);
                  },),
                const SizedBox(height: 16,),
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
                    padding: const EdgeInsets.only(top: 10,right: 8,left: 8),
                    shrinkWrap: true,
                    itemCount: listDiaries.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        width: screenWidth(context),
                        margin: const EdgeInsets.only(bottom: 16,left: 8,right: 8),
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
                           CardMessages(
                               encaminhado: "ESCOLA",
                               color: colorScheme(context).onSecondary,
                               assets: "assets/imgRecados1.png"
                           ),
                            if(listDiaries[index].diaryType == 1)
                              CardMessages(
                                  encaminhado: globals.nomeSala.toString().toUpperCase(),
                                  color: colorScheme(context).primary,
                                  assets: "assets/imgRecados2.png"
                              ),
                            if(listDiaries[index].diaryType == 0)
                              CardMessages(
                                  encaminhado: globals.nomeAluno.toString().toUpperCase(),
                                  color: colorScheme(context).secondary,
                                  assets: "assets/imgRecados3.png"
                              ),
                            Container(
                              width: screenWidth(context),
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12,vertical: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(listDiaries[index].description.toString(),
                                    style: GoogleFonts.poppins(
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
                                        if(listDiaries[index].fileUri != "null")
                                          GestureDetector(
                                          onTap: () {
                                            print(listDiaries[index].fileUri);
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
                                                        BotaoAzul(text: "Visualizar", onPressed: () {
                                                          print(listDiaries[index].fileUri.toString());
                                                          if(loadingDownload == false){
                                                            FileManagement.launchUri(link: listDiaries[index].fileUri
                                                                .toString(), context: context);
                                                          }
                                                        },),
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
