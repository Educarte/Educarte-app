import 'package:educarte/Ui/components/molecules/changing_of_the_guard_modal.dart';
import 'package:educarte/Ui/components/molecules/confirm_entry_or_exit_modal.dart';
import 'package:educarte/Ui/components/molecules/file_modal.dart';
import 'package:educarte/Ui/components/molecules/my_data_modal.dart';
import 'package:flutter/material.dart';

import '../../../Interactor/models/document.dart';
import '../../../Interactor/models/students_model.dart';
import '../../../core/base/constants.dart';
import '../../../core/enum/modal_type_enum.dart';
import '../../screens/time_control/widgets/card_time_control.dart';

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
      ModalType.myData => MyDataModal(modalType: modalType)
    };

    double modalHeight = MediaQuery.of(context).viewInsets.bottom > 0 ? modalType.height * 1.1 : modalType.height;

    show(
      context: context, 
      modal: modal,
      modalType: modalType,
      modalHeight: modalHeight
    );
  }

  static show({
    required BuildContext context, 
    required Widget modal,
    required ModalType modalType,
    required double modalHeight
  }) {
    Radius radiusModal = const Radius.circular(8);
    Color backgroundColor = colorScheme(context).onSurfaceVariant;

    return showModalBottomSheet(
      context: context, 
      isScrollControlled: true,
      useRootNavigator: !(modalType == ModalType.guard || modalType == ModalType.myData),
      isDismissible: false,
      builder: (_) => Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom
        ),
        child: Container(
          height: modalHeight,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.only(
              topLeft: radiusModal,
              topRight: radiusModal
            ),
          ),
          child: Scaffold(
            backgroundColor: backgroundColor,
            body: SingleChildScrollView(
              physics: modalType == ModalType.myData ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
              child: modal
            )
          )
        )
      )
    );
  }
}