import 'dart:convert';

import 'package:educarte/Ui/components/bnt_azul.dart';
import 'package:educarte/Ui/components/bnt_branco.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../Interector/base/constants.dart';
import '../../Interector/models/document.dart';
import '../../Services/helpers/file_management_helper.dart';
import '../global/global.dart' as globals;
import 'package:http/http.dart' as http;
import '../components/input.dart';
import '../global/global.dart';

int selectedIndex = 0;

class EducarteShell extends StatefulWidget {
  const EducarteShell({
    super.key, 
    required this.child
  });
  final Widget child;

  @override
  State<EducarteShell> createState() => _EducarteShellState();
}
List<String> list = <String>[""];
class _EducarteShellState extends State<EducarteShell> {
  int selectedIndex = 2;
  TextEditingController nome = TextEditingController();
  TextEditingController sala = TextEditingController();
  TextEditingController responsavel = TextEditingController();
  TextEditingController auxiliar = TextEditingController();
  List<String> listId = [];
  int valueIndex = 0;

  String dropdownValue = "";
  double iconSize = 30;

  bool loadingDownload = false;
  // void setLoading({required bool load}){
  //   setState(() {
  //     loading = load;
  //   });
  // }

  String id = "";
  void student() async{
    var response = await http.get(Uri.parse("http://64.225.53.11:5000/Students?LegalGuardianId=${globals.id}"),
        headers: {
          "Authorization": "Bearer ${globals.token}"
        }
    );

    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);
      setState(() {
        list = List.empty(growable: true);

        for(var i=0;i < jsonData["items"].length; i++){
          list.add(jsonData["items"][i]["name"]);
          listId.add(jsonData["items"][i]["id"]);
        } 
        
        dropdownValue = list.first;
        studentId(valueIndex);
      });
    }

  }

  void studentId(int index)async{
    var response = await http.get(
      Uri.parse("http://64.225.53.11:5000/Students/${listId[index]}"),
      headers: {
        "Authorization": "Bearer ${globals.token}"
      }
    );

    if(response.statusCode == 200){
      var jsonData = jsonDecode(response.body);

      setState(() {
        var listTeachers = jsonData["classroom"]["teachers"];
        if(listTeachers.length != 0){
          for(var i=0; i< listTeachers.length; i++){
            if(listTeachers[i]["profile"] == 3){
              responsavel.text = jsonData["classroom"]["teachers"][i]["name"];
            }
            if(listTeachers[i]["profile"] == 2){
              responsavel.text = jsonData["classroom"]["teachers"][i]["name"];
            }
          }
        }
        globals.idStudent = jsonData["id"];
        responsavel.text = jsonData["classroom"]["teachers"][0]["name"];
        sala.text = jsonData["classroom"]["name"];
        globals.nomeSala = jsonData["classroom"]["name"];
        globals.nomeAluno = jsonData["name"];
      });
    }
  }

  void changeSelectedIndex(int index){
    setState(() {
      selectedIndex = index;
    });
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

  Future<bool> _onWillPop() async {
    return false;
  }
  Widget selectedIcon({
    required IconData icon,
    required double iconSize,
    required BuildContext context
  }) {

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          color: colorScheme(context).onPrimary.withOpacity(0.30)
      ),
      child: Icon(
          icon,
          color: colorScheme(context).onPrimary,
          size: iconSize
      ),
    );
  }

  @override
  void initState() {
    super.initState();
    student();
    getMenu();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.child,
      bottomNavigationBar: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: NavigationBar(
          height: 65,
          labelBehavior:  NavigationDestinationLabelBehavior.alwaysHide,
          backgroundColor: colorScheme(context).primary,
          indicatorColor: colorScheme(context).primary,
          destinations: <NavigationDestination>[
            NavigationDestination(
              icon: Icon(Symbols.diagnosis,color: colorScheme(context).onPrimary),
              selectedIcon: selectedIcon(
                  context: context,
                  icon: Symbols.diagnosis,
                  iconSize: iconSize
              ),
              label: 'Recados',
            ),
            NavigationDestination(
              icon: Icon(Symbols.nutrition,color: colorScheme(context).onPrimary,),
              selectedIcon: selectedIcon(
                  context: context,
                  icon: Symbols.nutrition,
                  iconSize: iconSize
              ),
              label: 'Cardápio',
            ),
            NavigationDestination(
              icon: Icon(Symbols.cottage,color: colorScheme(context).onPrimary),
              selectedIcon: selectedIcon(
                  context: context,
                  icon: Symbols.cottage,
                  iconSize: iconSize
              ),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Icon(Symbols.alarm_on,color: colorScheme(context).onPrimary),
              selectedIcon: selectedIcon(
                  context: context,
                  icon: Symbols.alarm_on,
                  iconSize: iconSize
              ),
              label: 'EntradaSaida',
            ),
            NavigationDestination(
              icon: Icon(Symbols.switch_account,color: colorScheme(context).onPrimary),
              selectedIcon: selectedIcon(
                  context: context,
                  icon: Symbols.switch_account,
                  iconSize: iconSize
              ),
              label: 'Troca de Guarda',
            ),
          ],
          selectedIndex: selectedIndex,
          onDestinationSelected: (int idx) => _ontItemTapped(idx, context),
        ),
      ),
    );
  }

  void _ontItemTapped(int index, BuildContext context) {
    switch (index) {
      case 4:
        changeSelectedIndex(index);

        student();
        showModalBottomSheet(
          useRootNavigator: true,
          isScrollControlled: true,
          isDismissible: false,
          context: context,
          backgroundColor: Colors.black.withOpacity(0.3),
          builder: (BuildContext context){
            return Container(
              width: screenWidth(context),
              height: 465,
              decoration: BoxDecoration(
                  color: colorScheme(context).onBackground,
                  borderRadius: const BorderRadius.only(topRight: Radius.circular(8),topLeft: Radius.circular(8))
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
                child: Column(
                  children: [
                    Row(
                      children: [
                        IconButton(onPressed: (){
                          _ontItemTapped(2, context);

                          Navigator.pop(context);
                        }, icon: Icon(Symbols.close,color: colorScheme(context).surface,)),
                        Text("Trocar Guarda",style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: colorScheme(context).surface
                        ),)
                      ],
                    ),
                    const SizedBox(height: 32,),
                    SizedBox(
                      height: 55,
                      child: DropdownButtonFormField<String>(
                        value: dropdownValue,
                        icon: const Icon(Symbols.expand_more),
                        elevation: 16,
                        style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                            color: const Color(0xff474C51),
                          height: 1.3
                        ),
                        decoration: InputDecoration(
                            labelText: "Nome",
                            labelStyle: GoogleFonts.poppins(
                                fontWeight: FontWeight.w400,
                                fontSize: 16,
                                color: const Color(0xff474C51),
                                height: 1.3
                            ),
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                    color: Color(0xffA0A4A8)
                                )
                            ),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(4),
                                borderSide: const BorderSide(
                                    color: Color(0xffA0A4A8)
                                )
                            )
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            dropdownValue = value!;
                            valueIndex = list.indexWhere((element) => element ==  value);

                            studentId(valueIndex);
                          });
                        },
                        items: list.map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(height: 16,),
                    Input(name: "Sala", obscureText: false, onChange: sala),
                    const SizedBox(height: 16,),
                    Input(name: "Responsável pela sala", obscureText: false, onChange: responsavel),
                    const SizedBox(height: 16,),
                    Input(name: "Auxiliar", obscureText: false, onChange: auxiliar),
                    const SizedBox(height: 32,),
                    BotaoAzul(text: "Atualizar informações",onPressed: (){
                      Navigator.pop(context);

                      updateHomeScreen = true;
                      _ontItemTapped(2, context);
                    },)
                  ],
                ),
              ),
            );
          },
        );
        break;
      case 3:
        changeSelectedIndex(index);
        
        context.go("/entryAndExit");
        break;
      case 1:
        changeSelectedIndex(index);

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
                              _ontItemTapped(2, context);

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
        break;
      case 0:
        changeSelectedIndex(index);

        context.go("/recados");
        break;
      default:
        changeSelectedIndex(index);

        context.go("/home");
    }
  }
}