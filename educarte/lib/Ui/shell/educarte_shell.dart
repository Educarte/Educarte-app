import 'package:educarte/Ui/components/bntAzul.dart';
import 'package:educarte/Ui/components/bntBranco.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../Interector/base/constants.dart';
import '../components/input.dart';

class EducarteShell extends StatefulWidget {
  EducarteShell({super.key, required this.child});

  final Widget child;

  @override
  State<EducarteShell> createState() => _EducarteShellState();
}

class _EducarteShellState extends State<EducarteShell> {
  int selectedIndex = 2;
  TextEditingController nome = TextEditingController();
  TextEditingController sala = TextEditingController();
  TextEditingController responsavel = TextEditingController();
  TextEditingController auxiliar = TextEditingController();


  Future<bool> _onWillPop() async {
    return false;
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
        showModalBottomSheet(
          useRootNavigator: true,
          isScrollControlled: true,
          context: context,
          backgroundColor: Colors.black.withOpacity(0.3),
          builder: (BuildContext context){
            return Container(
              width: screenWidth(context),
              height: 461,
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
                    Input(name: "Nome", obscureText: false, onChange: nome),
                    const SizedBox(height: 16,),
                    Input(name: "Sala", obscureText: false, onChange: sala),
                    const SizedBox(height: 16,),
                    Input(name: "Responsável pela sala", obscureText: false, onChange: responsavel),
                    const SizedBox(height: 16,),
                    Input(name: "Auxiliar", obscureText: false, onChange: auxiliar),
                    const SizedBox(height: 32,),
                    BotaoAzul(text: "Atualizar informações")
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
        break;
      case 0:
        GoRouter.of(context).go("/recados");
        break;
      default:
        GoRouter.of(context).go("/home");
    }
  }
}