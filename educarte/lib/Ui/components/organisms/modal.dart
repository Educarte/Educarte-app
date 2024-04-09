import 'package:educarte/Interector/models/students_model.dart';
import 'package:educarte/Ui/components/organisms/confirm_entry_or_exit_modal.dart';
import 'package:flutter/material.dart';

import '../../../Interector/enum/modal_type_enum.dart';
import '../../../Interector/models/document.dart';
import '../../screens/time_control/widgets/card_time_control.dart';
import 'file_modal.dart';

class ModalEvent {
  static build({
    required BuildContext context,
    required ModalType modalType,
    CardTimeControl? cardTimeControl,
    Function(bool result)? callback,
    Student? student,
    Document? document
  }){
    Widget modal;

    modal = switch(modalType){
      ModalType.confirmEntry => ConfirmEntryOrExitModal(
        modalType: modalType,
        cardTimeControl: cardTimeControl!,
        student: student!,
        callback:(result) => callback!(result)
      ),
      ModalType.menu || ModalType.archive => FileModal(
        modalType: modalType,
        document: document!
      ),
    };

    show(
      context: context, 
      modal: modal
    );
  }

  static show({
    required BuildContext context, 
    required Widget modal
  }) => showModalBottomSheet(
    context: context, 
    isScrollControlled: true,
    useRootNavigator: true,
    isDismissible: false,
    builder: (_) {
      return Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom
        ),
        child: modal
      );
    }
  );
}