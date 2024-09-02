import 'package:educarte/Ui/components/atoms/custom_button.dart';
import 'package:educarte/core/enum/input_type.dart';
import 'package:educarte/core/enum/modal_type_enum.dart';
import 'package:educarte/Interactor/models/students_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

import '../../../Interactor/providers/student_provider.dart';
import '../../../core/enum/button_type.dart';
import '../atoms/input.dart';
import '../atoms/modal_application_bar.dart';
import '../../../core/base/constants.dart';
import '../../screens/time_control/widgets/card_time_control.dart';

class ConfirmEntryOrExitModal extends StatefulWidget {
  final ModalType modalType;
  final CardTimeControl cardTimeControl;
  final Student student;
  final Function(bool result) callback;

  const ConfirmEntryOrExitModal({
    super.key,
    required this.modalType,
    required this.cardTimeControl,
    required this.student,
    required this.callback
  });
  
  @override
  State<ConfirmEntryOrExitModal> createState() => _ConfirmEntryOrExitModalState();
}

class _ConfirmEntryOrExitModalState extends State<ConfirmEntryOrExitModal> {
  final studentProvider = GetIt.instance.get<StudentProvider>();
  bool loading = false;
  DateTime dateTimeNow = DateTime.now();
  final TextEditingController hourController = TextEditingController();
  final TextEditingController dateController = TextEditingController();

  @override
  void initState() {
    hourController.text = DateFormat("dd/MM/yyyy").format(dateTimeNow);
    dateController.text = DateFormat("HH:mm").format(dateTimeNow);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: studentProvider,
      builder: (_, __) {
        return Container(
          width: screenWidth(context),
          height: widget.modalType.height,
          decoration: BoxDecoration(
            color: colorScheme(context).onSurfaceVariant,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(8), 
              topLeft: Radius.circular(8)
            )
          ),
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
                  onChange: hourController
                ),
                const SizedBox(height: 16),
                Input(
                  name: "Data",
                  enabled: false,
                  isInputModal: true,
                  inputType: InputType.date,
                  onChange: dateController
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 32),
                  child: widget.cardTimeControl
                ),
                CustomButton(
                  title: "Registrar horário",
                  loading: studentProvider.loading,
                  onPressed: () async {
                    await studentProvider.registerHour(
                      context: context,
                      studentId: widget.student.id!,
                      modalType: widget.modalType
                    );
                  
                    widget.callback(true);
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
        );
      }
    );
  }
}
