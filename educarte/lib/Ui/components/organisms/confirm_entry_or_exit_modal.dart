import 'package:educarte/Interector/enum/input_type.dart';
import 'package:educarte/Interector/enum/modal_type_enum.dart';
import 'package:educarte/Interector/models/students_model.dart';
import 'package:educarte/Ui/components/bnt_branco.dart';
import 'package:educarte/Ui/components/input.dart';
import 'package:educarte/Ui/components/molecules/modal_application_bar.dart';
import 'package:educarte/Ui/global/global.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

import '../../../Interector/base/constants.dart';
import '../../../Services/config/api_config.dart';
import '../../screens/time_control/widgets/card_time_control.dart';
import '../bnt_azul.dart';

class ConfirmEntryOrExitModal extends StatefulWidget {
  const ConfirmEntryOrExitModal({
    super.key, 
    required this.modalType, 
    required this.cardTimeControl, 
    required this.student, 
    required this.callback
  });
  final ModalType modalType;
  final CardTimeControl cardTimeControl;
  final Student student;
  final Function(bool result) callback;

  @override
  State<ConfirmEntryOrExitModal> createState() => _ConfirmEntryOrExitModalState();
}

class _ConfirmEntryOrExitModalState extends State<ConfirmEntryOrExitModal> {
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

  void setLoading({required bool load}){
    setState(() {
      loading = load;
    });
  }

  Future<void> registerHour() async{
    try {
      setLoading(load: true);

      var response = await http.post(
        Uri.parse("$baseUrl/AccessControls/${widget.student.id}"),
        headers: {
          "Authorization": "Bearer $token",
        },
        body: {
          "time": DateTime.now()
        }
      );
      if(response.statusCode == 200){
        setLoading(load: false);
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
        color: colorScheme(context).onBackground,
        borderRadius: const BorderRadius.only(
          topRight: Radius.circular(8),
          topLeft: Radius.circular(8)
        )
      ),
      child: Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16, vertical: 16),
        child: SingleChildScrollView(
          child: Column(
            children: [
              ModalApplicationBar(title: widget.modalType.title),
              const SizedBox(height: 32),
              Input(
                name: "Horário", 
                obscureText: false, 
                enabled: false,
                isInputModal: true,
                inputType: InputType.hour,
                onChange: _hour
              ),
              const SizedBox(height: 16),
              Input(
                name: "Data", 
                enabled: false,
                obscureText: false, 
                isInputModal: true,
                inputType: InputType.date,
                onChange: _date
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 32),
                child: widget.cardTimeControl
              ),
              BotaoAzul(
                text: "Registrar horário",
                onPressed: () => widget.callback(true),
                // onPressed: () => registerHour(),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: BotaoBranco(
                  text: "Cancelar",
                  onPressed: () => context.pop(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}