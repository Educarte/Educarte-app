import 'dart:async';

import 'package:educarte/Interactor/providers/auth_provider.dart';
import 'package:educarte/Interactor/providers/user_provider.dart';
import 'package:educarte/Ui/components/atoms/custom_button.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';

import '../../../core/base/constants.dart';
import '../../../core/enum/button_type.dart';
import '../../../core/enum/modal_type_enum.dart';
import '../atoms/input.dart';

class MyDataModal extends StatefulWidget {
  final ModalType modalType;
  const MyDataModal({
    super.key,
    required this.modalType
  });

  @override
  State<MyDataModal> createState() => _MyDataModalState();
}

class _MyDataModalState extends State<MyDataModal> {
  final authProvider = GetIt.instance.get<AuthProvider>();
  final userProvider = GetIt.instance.get<UserProvider>();
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController? telefoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Timer.run(() => userProvider.getMyData(
      context: context, 
      nomeController: nomeController, 
      emailController: emailController, 
      telefoneController: telefoneController
    ));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      height: widget.modalType.height,
      decoration: BoxDecoration(color: colorScheme(context).onSurfaceVariant),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                widget.modalType.title,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: colorScheme(context).onInverseSurface
                )
              )
            ]
          ),
          const SizedBox(height: 32),
          Input(
            name: "Nome",
            onChange: nomeController
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: Input(
              name: "E-mail",
              onChange: emailController
            ),
          ),
          Input(
            name: "Telefone",
            onChange: telefoneController!
          ),
          const SizedBox(height: 32),
          CustomButton(
            title: "Atualizar informações",
            onPressed: () async {
              await userProvider.updateData(
                context: context, 
                nomeController: nomeController, 
                emailController: emailController, 
                telefoneController: telefoneController
              );
      
              Navigator.pop(context);
            },
            loading: userProvider.loading
          ),
          const SizedBox(height: 16),
          CustomButton(
            title: "Sair do aplicativo",
            buttonType: ButtonType.secondary,
            onPressed: () async => await authProvider.logout(context: context)
          )
        ],
      ),
    );
  }
}