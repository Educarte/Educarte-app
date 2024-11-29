import 'package:educarte/Ui/components/organisms/modal.dart';
import 'package:educarte/core/enum/modal_type_enum.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../Interactor/providers/menu_provider.dart';
import '../../core/base/constants.dart';

ValueNotifier selectedIndex = ValueNotifier<int>(0);
ValueNotifier? previousIndex = ValueNotifier<int>(0);

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
  final menuProvider = GetIt.instance.get<MenuProvider>();  
  ValueNotifier selectedIndex = ValueNotifier<int>(2);
  
  List<String> listId = [];

  double iconSize = 30;
  bool loadingDownload = false;

  String id = "";
  
  void changeSelectedIndex(int index){
    previousIndex!.value = selectedIndex.value;
    selectedIndex.value = index;
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
        color: colorScheme(context).onPrimary.withOpacity(0.3)
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
  }
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: selectedIndex,
      builder: (_, __, ___) {
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
              selectedIndex: selectedIndex.value,
              onDestinationSelected: (int idx) async => _ontItemTapped(idx, context),
            ),
          ),
        );
      }
    );
  }

  void _ontItemTapped(int index, BuildContext context) async{
    changeSelectedIndex(index);

    switch (index) {
      case 4:
        ModalEvent.build(
          context: context, 
          modalType: ModalType.guard
        );
        break;
      case 3:
        context.push("/entryAndExit");
        break;
      case 1:
        // await menuProvider.getMenu(context: context);

        if(menuProvider.currentMenu.fileUri != null){
          ModalEvent.build(
            context: context, 
            modalType: ModalType.menu,
            document: menuProvider.currentMenu
          );
        }else{
          menuProvider.showErrorMessage(context, "Nenhum cardápio encontrado");
        }
       
        break;
      case 0:
        context.go("/recados");
        break;
      default:
        context.go("/home");
    }
  }
}