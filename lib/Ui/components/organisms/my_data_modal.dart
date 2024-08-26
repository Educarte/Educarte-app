import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:http/http.dart' as http;

import '../../../Interactor/models/students_model.dart';
import '../../../Services/config/repositories/persistence_repository.dart';
import '../../../core/base/constants.dart';
import '../../../core/base/store.dart';
import '../../../core/enum/modal_type_enum.dart';
import '../../../core/enum/persistence_enum.dart';
import '../bnt_azul.dart';
import '../bnt_branco.dart';
import '../input.dart';
import '../../global/global.dart' as globals;

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
  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController? telefoneController = TextEditingController();

  bool loading = false;

  void setLoading({required bool load}){
    setState(() {
      loading = load;
    });
  }

  Future<void> meusDados() async{
    setLoading(load: true);

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
        nomeController.text = jsonData["name"];
        emailController.text = jsonData["email"];
        if(jsonData["cellphone"] != null){
          telefoneController?.text = jsonData["cellphone"];
        }
      });
    }

    setLoading(load: false);
  }

  Future<void> putDados() async{
    setLoading(load: true);

    String errorMessage = "Erro ao atualizar informações"; 

    try{
      Map corpo = {
        "name": nomeController.text,
        "email": emailController.text,
        "cellphone": telefoneController?.text
      };

      var response = await http.put(Uri.parse("http://64.225.53.11:5000/Users/${globals.id}"),
          body: jsonEncode(corpo),
          headers: {
            "Authorization": "Bearer ${globals.token}",
            "Content-Type":"application/json"
          }
      );

      if(response.statusCode == 200){
        await meusDados();

        // getStudentId();
      }else{
        Store().showErrorMessage(context, errorMessage);
      }
    }catch(e){
      Store().showErrorMessage(context, errorMessage);
    }

    setLoading(load: false);
  }

  Future<void> logout()async{
    PersistenceRepository persistenceRepository = PersistenceRepository();

    await persistenceRepository.delete(key: SecureKey.token);
    setState(() {
      globals.currentStudent.value = Student.empty();
      globals.id = "";
      globals.nomeAluno = "";
      globals.idStudent = "";
      globals.nomeSala = "";
      globals.token = "";
    });

    if(context.mounted){
      context.go("/login");
    }
  }

  @override
  void initState() {
    meusDados();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool focusInput = MediaQuery.of(context).viewInsets.bottom > 0;

    return Container(
      width: screenWidth(context),
      height: widget.modalType.height * (focusInput ? 1.1 : 1),
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
          BotaoAzul(
            text: "Atualizar informações",
            onPressed: () async {
              await putDados();
      
              Navigator.pop(context);
            },
            loading: loading
          ),
          const SizedBox(height: 16,),
          BotaoBranco(text: "Sair do aplicativo",
            onPressed: () async => await logout()
          )
        ],
      ),
    );
  }
}