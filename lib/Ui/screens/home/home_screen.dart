import 'dart:convert';

import 'package:educarte/Interactor/providers/menu_provider.dart';
import 'package:educarte/Ui/components/atoms/custom_button.dart';
import 'package:educarte/core/config/api_config.dart';
import 'package:educarte/core/base/constants.dart';
import 'package:educarte/Interactor/models/students_model.dart';
import 'package:educarte/core/enum/button_type.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:http/http.dart' as http;

import '../../../Interactor/models/api_diaries.dart';
import '../../../Interactor/providers/user_provider.dart';
import '../../../Interactor/validations/convertter.dart';
import '../../../Services/helpers/file_management_helper.dart';
import '../../../Ui/components/atoms/custom_pop_scope.dart';
import '../../../Ui/components/atoms/result_not_found.dart';
import '../../../core/enum/modal_type_enum.dart';
import '../../components/organisms/modal.dart';
import '../../global/global.dart' as globals;
import '../../global/global.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final menuProvider = GetIt.instance.get<MenuProvider>();
  final userProvider = GetIt.instance.get<UserProvider>();
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

  Student student = Student();
  void getStudentId() async{
    setState(() {
      listDiaries.clear();
      globals.currentStudent.value.listDiaries!.clear();
    });
    try{
      var response = await http.get(Uri.parse("$apiUrl/Students/${globals.currentStudent.value.id}"),
          headers: {
            // "Authorization": "Bearer ${globals.token}"
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
        // "Authorization": "Bearer ${globals.token}"
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

  String dateConvertData(String date){
    DateTime dateTime = DateTime.parse(date);

    String formattedDate = DateFormat('HH', 'pt_BR').format(dateTime);
    String formattedTime = DateFormat('mm', 'pt_BR').format(dateTime);

    String result = '${formattedDate}h. ${formattedTime}min';

    return result;

  }

  @override
  void initState() {
    super.initState();
    studentGet();
    menuProvider.getMenu(context: context);
  }

  @override
  Widget build(BuildContext context) {
    TextStyle diaryStyle = GoogleFonts.poppins(
      fontSize: 14,
      color: colorScheme(context).onInverseSurface,
      fontWeight: FontWeight.w400
    );
    Radius radius = const Radius.circular(8);

    if (loading) {
      return const Center(
        child: CircularProgressIndicator()
      );
    } else {
      return CustomPopScope(
        child: CustomPopScope(
          child: Scaffold(
            resizeToAvoidBottomInset: false ,
            backgroundColor: colorScheme(context).surface,
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
              child: Column(
                children: [
                  const SizedBox(height: 32),
                  ListenableBuilder(
                    listenable: userProvider,
                    builder: (_, __) {
                      return Expanded(
                        flex: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Olá,", 
                                  style: GoogleFonts.poppins(
                                    color: colorScheme(context).onInverseSurface,
                                    fontWeight: FontWeight.w400,
                                    fontSize: 16,
                                  )
                                ),
                                Text(
                                  userProvider.currentLegalGuardian.name!,
                                  style: GoogleFonts.poppins(
                                    color: colorScheme(context).primary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 25,
                                  )
                                ),
                              ],
                            ),
                            IconButton(
                              onPressed: () => ModalEvent.build(
                                context: context,
                                modalType: ModalType.myData
                              ),
                              icon: const Icon(
                                Symbols.account_circle,
                                size: 30
                              )
                            )
                          ],
                        ),
                      );
                    }
                  ),
                  const SizedBox(height: 24),
                  Expanded(
                    flex: 1,
                    child: Container(
                      width: screenWidth(context),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: colorScheme(context).onSurfaceVariant,
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.3),
                            spreadRadius: 0,
                            blurRadius: 4,
                            offset: const Offset(
                              0, 4
                            ),
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
                                borderRadius: BorderRadius.only(
                                  topLeft: radius,
                                  topRight: radius
                                )
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
                                Image.asset("assets/imgRecados.png")
                              ],
                            ),
                          ),
                          if(globals.currentStudent.value.listDiaries != null)...[
                            Expanded(
                              child: globals.currentStudent.value.listDiaries!.isEmpty ? const ResultNotFound(
                                description: "O dia passou tranquilo por aqui, sem recados. Mas agradecemos por lembrar de nós!",
                                iconData: Symbols.diagnosis
                              ) : Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 12),
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
                                              color: colorScheme(context).outline.withOpacity(0.5)
                                            )
                                          )
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
                                                Text(
                                                  switch(globals.currentStudent.value.listDiaries![index].diaryType){
                                                    0 => globals.currentStudent.value.name!,
                                                    1 => globals.nomeSala.toString(),
                                                    _ => "Escola"
                                                  },
                                                  style: diaryStyle
                                                )
                                              ],
                                            ),
                                            const SizedBox(height: 6),
                                            Text(
                                              globals.currentStudent.value.listDiaries![index].description!,
                                              style: diaryStyle.copyWith(
                                                fontWeight: FontWeight.w300
                                              ),
                                              maxLines: 3,
                                              overflow: TextOverflow.ellipsis
                                            ),
                                            const SizedBox(height: 12)
                                          ],
                                        ),
                                      );
                                    },
            
                                  ),
                                ),
                              ),
                            )
                          ]
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
                            color: colorScheme(context).onSurfaceVariant,
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
                                  borderRadius: BorderRadius.only(
                                    topLeft: radius,
                                    topRight: radius
                                  )
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
                                            Text(
                                              "Entrada",
                                              style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xffF5F5F5),
                                              )
                                            ),
                                            Text(
                                              "e saída",
                                              style: GoogleFonts.poppins(
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xffF5F5F5),
                                              )
                                            ),
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
                                          Text(dateConvertData(globals.currentStudent.value.horaEntrada!),
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
                                            Text(dateConvertData(globals.currentStudent.value.horaSaida!),
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
                                      color: colorScheme(context).onSurfaceVariant,
                                      borderRadius: BorderRadius.only(
                                        topRight: radius,
                                        topLeft: radius
                                      )
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(16),
                                      child: Column(
                                        children: [
                                          Row(
                                            children: [
                                              IconButton(
                                                onPressed: () => Navigator.pop(context),
                                                icon: Icon(
                                                  Symbols.close,
                                                  color: colorScheme(context).onInverseSurface
                                                )
                                              ),
                                              Text(
                                                "Cardápio em PDF",
                                                style: GoogleFonts.poppins(
                                                  fontSize: 22,
                                                  fontWeight: FontWeight.w600,
                                                  color: colorScheme(context).onInverseSurface
                                                )
                                              )
                                            ],
                                          ),
                                          const SizedBox(height: 32),
                                          CustomButton(
                                            title: "Visualizar", 
                                            loading: loadingDownload,
                                            onPressed: () async => await FileManagement.launchUri(
                                              link: menuProvider.currentMenu.fileUri.toString(), 
                                              context: context
                                            )
                                          ),
                                          const SizedBox(height: 16),
                                          CustomButton(
                                            title: "Baixar", 
                                            onPressed: () async{
                                              setstate((){
                                                loadingDownload = true;
                                              });
        
                                              await FileManagement.download(
                                                url: menuProvider.currentMenu.fileUri.toString(), 
                                                fileName: "Cardápio"
                                              );
        
                                              await Future.delayed(const Duration(seconds: 2)).then((value) {
                                                setstate((){
                                                  loadingDownload = false;
                                                });
                                              });
                                            },
                                            loading: loadingDownload,
                                          ),
                                          const SizedBox(height: 16,),
                                          CustomButton(
                                            title: "Compartilhar", 
                                            buttonType: ButtonType.secondary,
                                            onPressed:  () async => await FileManagement.share(
                                              url: menuProvider.currentMenu.fileUri.toString(),
                                              document: menuProvider.currentMenu
                                            )
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
                              color: colorScheme(context).onSurfaceVariant,
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
                                    borderRadius: BorderRadius.only(
                                      topLeft: radius,
                                      topRight: radius
                                    )
                                  ),
                                  child: Stack(
                                    children: [
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Image.asset(
                                          "assets/imgAtualizacao.png"
                                        )
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
          ),
        ),
      );
    }
  }
}