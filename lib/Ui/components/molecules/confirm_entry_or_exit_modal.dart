import 'dart:convert';

import 'package:educarte/Ui/components/atoms/custom_button.dart';
import 'package:educarte/core/base/store.dart';
import 'package:educarte/core/config/api_config.dart';
import 'package:educarte/core/enum/input_type.dart';
import 'package:educarte/core/enum/modal_type_enum.dart';
import 'package:educarte/Interactor/models/students_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../Interactor/providers/student_provider.dart';
import '../../../core/enum/button_type.dart';
import '../atoms/input.dart';
import '../atoms/modal_application_bar.dart';
import '../../../core/base/constants.dart';
import '../../screens/time_control/widgets/card_time_control.dart';

class ConfirmEntryOrExitModal extends StatefulWidget {
  const ConfirmEntryOrExitModal(
      {super.key,
      required this.modalType,
      required this.cardTimeControl,
      required this.student,
      required this.callback});
  final ModalType modalType;
  final CardTimeControl cardTimeControl;
  final Student student;
  final Function(bool result) callback;

  @override
  State<ConfirmEntryOrExitModal> createState() =>
      _ConfirmEntryOrExitModalState();
}

class _ConfirmEntryOrExitModalState extends State<ConfirmEntryOrExitModal> {
  final studentProvider = GetIt.instance.get<StudentProvider>();
  bool loading = false;
  DateTime dateTimeNow = DateTime.now();
  final TextEditingController _hour = TextEditingController();
  final TextEditingController _date = TextEditingController();

  @override
  void initState() {
    _hour.text = DateFormat("dd/MM/yyyy").format(dateTimeNow);
    _date.text = DateFormat("HH:mm").format(dateTimeNow);
    super.initState();
  }

  void setLoading({required bool load}) {
    setState(() {
      loading = load;
    });
  }

  Future<void> registerHour() async {
    try {
      setLoading(load: true);
      Map corpo = {};
      var response = await http.post(
        Uri.parse("$apiUrl/Students/AccessControl/${widget.student.id}"),
        headers: {
          // "Authorization": "Bearer $token",
          "Content-Type": "application/json"
        },
        body: jsonEncode(corpo)
      );
      setLoading(load: false);
      
      if(context.mounted) context.pop();

      if (response.statusCode == 200) {
        if (widget.modalType == ModalType.confirmEntry) {
          Store() .showSuccessMessage(context, "Entrada confirmada com sucesso!");
        } else {
          Store().showSuccessMessage(context, "Saída confirmada com sucesso!");
        }
      } else {
        String errorMessage = "Erro ao confirmar entrada e saída!";

        setState(() {
          var decodeJson = jsonDecode(response.body);
          errorMessage = decodeJson["description"];
        });
        
        Store().showErrorMessage(context, errorMessage);
      }
    } catch (e) {
      setLoading(load: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context),
      height: widget.modalType.height,
      decoration: BoxDecoration(
          color: colorScheme(context).onSurfaceVariant,
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8), topLeft: Radius.circular(8))),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ModalApplicationBar(title: widget.modalType.title),
              const SizedBox(height: 32),
              Input(
                  name: "Horário",
                  enabled: false,
                  isInputModal: true,
                  inputType: InputType.hour,
                  onChange: _hour),
              const SizedBox(height: 16),
              Input(
                  name: "Data",
                  enabled: false,
                  isInputModal: true,
                  inputType: InputType.date,
                  onChange: _date),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: widget.cardTimeControl
              ),
              CustomButton(
                title: "Registrar horário",
                onPressed: () async {
                  await registerHour();

                  if(context.mounted) {
                    await studentProvider.getStudents(
                      context: context,
                      customUrl: "/Students"
                    );
                  }
                }
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: CustomButton(
                  title: "Cancelar",
                  buttonType: ButtonType.secondary,
                  onPressed: () => context.pop()
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
