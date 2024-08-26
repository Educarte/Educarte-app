import 'dart:convert';

import 'package:educarte/ui/components/bnt_azul.dart';
import 'package:educarte/ui/components/bnt_branco.dart';
import 'package:educarte/ui/components/organisms/modal.dart';
import 'package:educarte/core/enum/modal_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../core/base/constants.dart';
import '../../Interactor/models/document.dart';
import '../../Services/helpers/file_management_helper.dart';
import '../global/global.dart' as globals;
import 'package:http/http.dart' as http;

int selectedIndex = 0;
int? previousIndex;

class EducarteShell extends StatefulWidget {
  const EducarteShell({
    super.key, 
    required this.child
  });
  final Widget child;

  @override
  State<EducarteShell> createState() => _EducarteShellState();
}

class _EducarteShellState extends State<EducarteShell> {
  int selectedIndex = 2;
  
  List<String> listId = [];
  int pageIndex = 0;

  double iconSize = 30;
  bool loadingDownload = false;

  String id = "";
  
  void changeSelectedIndex(int index){
    setState(() {
      previousIndex = selectedIndex;
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
        setState(() {
          pageIndex = selectedIndex;
        });
        ModalEvent.build(
          context: context, 
          modalType: ModalType.guard
        );
        break;
      case 3:
        changeSelectedIndex(index);
        
        context.go("/entryAndExit");
        break;
      case 1:
        setState(() {
          pageIndex = selectedIndex;
        });
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
                    color: colorScheme(context).onSurfaceVariant,
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
                              _ontItemTapped(pageIndex, context);
                              Navigator.pop(context);


                            }
                          }, icon: Icon(Symbols.close, color: colorScheme(
                              context).onInverseSurface,)),
                          Text("Cardápio em PDF", style: GoogleFonts.poppins(
                              fontSize: 22,
                              fontWeight: FontWeight.w600,
                              color: colorScheme(context).onInverseSurface
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