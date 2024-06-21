import 'dart:async';
import 'dart:convert';

import 'package:educarte/Interector/enum/modal_type_enum.dart';
import 'package:educarte/Interector/models/classroom_model.dart';
import 'package:educarte/Interector/validations/convertter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:http/http.dart' as http;

import '../../../Interector/base/constants.dart';
import '../../../Interector/enum/persistence_enum.dart';
import '../../../Interector/models/document.dart';
import '../../../Interector/models/students_model.dart';
import '../../../Services/config/api_config.dart';
import '../../../Services/config/repositories/persistence_repository.dart';
import '../../../Services/helpers/file_management_helper.dart';
import '../../components/bnt_azul.dart';
import '../../components/bnt_branco.dart';
import '../../components/custom_dropdown.dart';
import '../../components/input.dart';
import '../../components/organisms/modal.dart';
import '../../components/result_not_found.dart';
import '../../components/search_input.dart';
import '../../global/global.dart';
import '../../global/global.dart'as globals;
import 'widgets/card_time_control.dart';

enum TimeControlPageLoading{
  none,
  initial,
  getStudents,
  filter,
  loaded
}

class TimeControlPage extends StatefulWidget {
  const TimeControlPage({super.key});

  @override
  State<TimeControlPage> createState() => _TimeControlPageState();
}

class _TimeControlPageState extends State<TimeControlPage> {
  TextEditingController nome = TextEditingController();
  TextEditingController email = TextEditingController();
  TextEditingController? telefone = TextEditingController();
  List<String> currentDate = List.empty(growable: true);
  final TextEditingController _search = TextEditingController();
  TimeControlPageLoading loading = TimeControlPageLoading.none;
  late Classroom classroomSelected = Classroom.empty();
  List<Classroom> classrooms = List.empty(growable: true);
  List<Student> students = [];
  List<Student> students2 = [];
  List<Student> studentsFilter = [];
  Document? menu;
  bool carregando = false;
  bool carregandoData = false;

  @override
  void initState() {
    getInitialData();
    getClassrooms();
    meusDados();
    Future.delayed(const Duration(milliseconds: 1200),(){
      setState(() {
        carregandoData = true;
      });
    });
    super.initState();
  }

  void setLoading({required TimeControlPageLoading load}){
    setState(() {
      loading = load;
    });
  }

  Future<void> getInitialData() async{
    try {
      setLoading(load: TimeControlPageLoading.initial);

      await getStudents(timeControlPageLoading: TimeControlPageLoading.initial);
      await getMenu();

      currentDate = await Convertter.getCurrentDate();

      classroomSelected = classrooms.first;

      setLoading(load: TimeControlPageLoading.loaded);
    } catch (e) {
      setLoading(load: TimeControlPageLoading.loaded);
    }
  }
  bool loadingDownload = false;

  Document document = Document.empty();

  Future<void> getMenu()async{
    var response = await http.get(Uri.parse("$baseUrl/Menus"),
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

  Future<void> getStudents({required TimeControlPageLoading timeControlPageLoading}) async{
    try {
      setLoading(load: timeControlPageLoading);

      students.clear();

      var response = await http.get(Uri.parse("$baseUrl/Students"),
        headers: {
          "Authorization": "Bearer $token",
        }
      );

      if(response.statusCode == 200){
        Map<String,dynamic> jsonData = jsonDecode(response.body);
        jsonData["items"].forEach((item)=> students.add(Student.fromJson(item)));
        setState(() {
          studentsFilter = students;
          students2 = students;
        });



        await getClassrooms();
      }
      setLoading(load: TimeControlPageLoading.loaded);
    } catch (e) {
      setLoading(load: TimeControlPageLoading.loaded);
    }
  }


  Future<void> getStudentsReset() async{
    try {
      students.clear();

      var response = await http.get(Uri.parse("$baseUrl/Students"),
          headers: {
            "Authorization": "Bearer $token",
          }
      );

      if(response.statusCode == 200){
        Map<String,dynamic> jsonData = jsonDecode(response.body);
        jsonData["items"].forEach((item)=> students.add(Student.fromJson(item)));
        setState(() {
          studentsFilter = students;
          students2 = students;
        });



        await getClassrooms();
      }
      setLoading(load: TimeControlPageLoading.loaded);
    } catch (e) {
      setLoading(load: TimeControlPageLoading.loaded);
    }
  }
  Future<void> getClassrooms() async{
    try {
      classrooms.clear();

      var response = await http.get(Uri.parse("$baseUrl/Classroom"),
        headers: {
          "Authorization": "Bearer $token",
        }
      );
      if(response.statusCode == 200){
        Map<String,dynamic> jsonData = jsonDecode(response.body);
        classrooms.add(Classroom.empty());

        jsonData["items"].forEach((item)=> classrooms.add(Classroom.fromJson(item)));
        setState(() {

        });
      }
    } catch (e) {
      setLoading(load: TimeControlPageLoading.loaded);
    }
  }



  Future<void> meusDados()async{
    setLoading(load: TimeControlPageLoading.loaded);
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


  Future<void> putDados()async{
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

  String id = "";

  Future<void> postAccessControl()async{

  }


  @override
  Widget build(BuildContext context) {
    bool focusInput = MediaQuery.of(context).viewInsets.bottom > 0;
    double iconSize = 30;
    Color colorIcon = const Color(0xFFA0A4A8);
    TextStyle style ({FontWeight? fontWeight}) => GoogleFonts.poppins(
      color: colorScheme(context).surface,
      fontWeight: fontWeight ?? FontWeight.w300
    );

    if (loading == TimeControlPageLoading.initial) {
      return const Center(child: CircularProgressIndicator());
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        backgroundColor: colorScheme(context).onBackground,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 48),
                if(currentDate.isNotEmpty)
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: currentDate[0],
                        style: style()
                      ),
                      TextSpan(
                        text: currentDate[1],
                        style: style(fontWeight: FontWeight.w600)
                      ),
                      TextSpan(
                        text: currentDate[2],
                        style: style()
                      )
                    ]
                  )
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Olá,",style: GoogleFonts.poppins(
                            color: colorScheme(context).surface,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),),
                          Text(
                            globals.nome.toString(),
                            style: GoogleFonts.poppins(
                              color: colorScheme(context).primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 25,
                            )
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: (){
                              showModalBottomSheet(
                                context: context,
                                isDismissible: false,
                                useRootNavigator: true,
                                isScrollControlled: true,
                                backgroundColor: Colors.black.withOpacity(0.3),
                                builder: (BuildContext context){
                                  return StatefulBuilder(builder: (context,setstate)
                                  {
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
                                        child:
                                        Column(
                                          children: [
                                            Row(
                                              children: [
                                                IconButton(onPressed: () {
                                                  if(loadingDownload == false){
                                                    Navigator.pop(context);


                                                  }
                                                }, icon: Icon(Symbols.close, color: colorScheme(
                                                    context).surface,)),
                                                Text("Cardápio em PDF", style: GoogleFonts.poppins(
                                                    fontSize: 22,
                                                    fontWeight: FontWeight.w600,
                                                    color: colorScheme(context).surface
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
                                              print(document.fileUri);
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
                            child: Icon(
                              Symbols.nutrition,
                              size: iconSize,
                              color: colorIcon
                            )
                          ),
                          const SizedBox(width: 32),
                          GestureDetector(
                            onTap: () {
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
                                                PersistenceRepository persistenceRepository = PersistenceRepository();

                                                await persistenceRepository.delete(key: SecureKey.token);

                                                if(context.mounted){
                                                  context.go("/login");
                                                }
                                              }
                                          )
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                            child: Icon(
                              Symbols.account_circle_rounded,
                              size: iconSize,
                              color: colorIcon
                            )
                          )
                        ]
                      )
                    )
                  ],
                ),
                const SizedBox(height: 12),
                CustomSearchInput(
                  controller: _search, 
                  action: () {
                    setState(() {
                      students = studentsFilter.where((element) => element.name!.toLowerCase().contains(_search.text.toString().toLowerCase())).toList();

                    });
                  }
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: CustomDropdown(
                    list: classrooms,
                    selected: classroomSelected,
                    callback: (result) => setState(() {
                      classroomSelected = result;
                      print(classroomSelected.name);
                      if(classroomSelected.name == null){
                        students = students2;
                      }else{
                        students = studentsFilter.where((element) => element.classrooms!.name.toString().toLowerCase().contains(classroomSelected.name!.toLowerCase())).toList();
                      }
                    }),
                  )
                ),
                students.isEmpty ?SizedBox(
                  height: 500,
                  child: Center(
                    child: const ResultNotFound(
                        description: "Nenhum usuário encontrado!",
                        iconData: Symbols.error
                    ),
                  ),
                ) : ListView.builder(
                  padding: EdgeInsets.zero,
                  primary: false,
                  shrinkWrap: true,
                  itemCount: students.length,
                  itemBuilder:(_, index) {
                    return CardTimeControl(
                      student: students[index],
                      callback: (bool result) {  
                        if(result){
                          getStudents(timeControlPageLoading: TimeControlPageLoading.filter);
                        }
                      },
                    );
                  }
                )
              ]
            ),
          ),
        ),
      );
    }
  }
}