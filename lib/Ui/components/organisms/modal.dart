import 'package:educarte/Interector/models/students_model.dart';
import 'package:educarte/Ui/components/organisms/changing_of_the_guard_modal.dart';
import 'package:educarte/Ui/components/organisms/confirm_entry_or_exit_modal.dart';
import 'package:flutter/material.dart';

import '../../../core/base/constants.dart';
import '../../../core/enum/modal_type_enum.dart';
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
      ModalType.confirmEntry || ModalType.confirmExit => ConfirmEntryOrExitModal(
        modalType: modalType,
        cardTimeControl: cardTimeControl!,
        student: student!,
        callback:(result) => callback!(result)
      ),
      ModalType.menu || ModalType.archive => FileModal(
        modalType: modalType,
        document: document!
      ),
      ModalType.guard => ChangingOfTheGuardModal(modalType: modalType),
    };

    double modalHeight = MediaQuery.of(context).viewInsets.bottom > 0 ? modalType.height * 1.1 : modalType.height;

    show(
      context: context, 
      modal: modal,
      modalHeight: modalHeight
    );
  }

  static show({
    required BuildContext context, 
    required Widget modal,
    required double modalHeight
  }) {
    Radius radiusModal = const Radius.circular(8);

    return showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      useRootNavigator: true,
      isDismissible: false,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom
        ),
        child: Container(
          height: modalHeight,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: colorScheme(context).onSurfaceVariant,
            borderRadius: BorderRadius.only(
              topLeft: radiusModal,
              topRight: radiusModal
            ),
          ),
          child: Scaffold(
            body: modal
          )
        )
      )
    );
  }
}