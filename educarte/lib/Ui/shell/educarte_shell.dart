import 'dart:convert';

import 'package:educarte/Ui/components/bnt_azul.dart';
import 'package:educarte/Ui/components/bnt_branco.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../Interector/base/constants.dart';
import '../global/global.dart' as globals;
import 'package:http/http.dart' as http;
import '../components/input.dart';

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

  String id = "";
  void student()async{
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
      print(response.body);
      setState(() {
        sala.text = jsonData["classroom"]["name"];
        globals.nomeSala = jsonData["classroom"]["name"];
        globals.nomeAluno = jsonData["name"];
      });
    }
  }


  Future<bool> _onWillPop() async {
    return false;
  }

  @override
  void initState() {
    super.initState();
    student();
  }
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        height: 65,
        labelBehavior:  NavigationDestinationLabelBehavior.alwaysHide,
        backgroundColor: colorScheme.primary,
        indicatorColor: colorScheme.onBackground.withOpacity(0.25),
        destinations: <NavigationDestination>[
          NavigationDestination(
            icon: Icon(Symbols.diagnosis,color: colorScheme.onPrimary),
            selectedIcon: Icon(
              Symbols.diagnosis,
              color: colorScheme.onPrimary,
            ),
            label: 'Recados',
          ),
          NavigationDestination(
            icon: Icon(Symbols.nutrition,color: colorScheme.onPrimary,),
            selectedIcon: Icon(
              Symbols.nutrition,
              color: colorScheme.onPrimary,
            ),
            label: 'Cardápio',
          ),
          NavigationDestination(
            icon: Icon(Symbols.cottage,color: colorScheme.onPrimary),
            selectedIcon: Icon(
              Symbols.cottage,
              color: colorScheme.onPrimary,
            ),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Symbols.alarm_on,color: colorScheme.onPrimary),
            selectedIcon: Icon(
              Symbols.alarm_on,
              color: colorScheme.onPrimary,
            ),
            label: 'EntradaSaida',
          ),
          NavigationDestination(
            icon: Icon(Symbols.switch_account,color: colorScheme.onPrimary),
            selectedIcon: Icon(
              Symbols.switch_account,
              color: colorScheme.onPrimary,
            ),
            label: 'Troca de Guarda',
          ),
        ],
        selectedIndex: selectedIndex,
        onDestinationSelected: (int idx) => _ontItemTapped(idx, context),
      ),
    );
  }

  void _ontItemTapped(int index, BuildContext context) {
    setState(() {
      selectedIndex = index;
    });

    switch (index) {
      case 4:
        student();
        showModalBottomSheet(
          useRootNavigator: true,
          isScrollControlled: true,
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
                          setState(() {
                            selectedIndex = 2;
                          });
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
                    const BotaoAzul(text: "Atualizar informações")
                  ],
                ),
              ),
            );
          },
        );
        break;
      case 3:
        print("Entrada e saida");
        break;
      case 1:
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.black.withOpacity(0.3),
          builder: (BuildContext context){
            return Container(
              width: screenWidth(context),
              height: 277,
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
                          setState(() {
                            selectedIndex = 2;
                          });
                          Navigator.pop(context);
                        }, icon: Icon(Symbols.close,color: colorScheme(context).surface,)),
                        Text("Cardápio em PDF",style: GoogleFonts.poppins(
                            fontSize: 22,
                            fontWeight: FontWeight.w600,
                            color: colorScheme(context).surface
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
        break;
      case 0:
        GoRouter.of(context).go("/recados");
        break;
      default:
        GoRouter.of(context).go("/home");
    }
  }
}