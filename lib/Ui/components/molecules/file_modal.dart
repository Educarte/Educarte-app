import 'package:educarte/Ui/components/atoms/custom_button.dart';
import 'package:educarte/core/enum/modal_type_enum.dart';
import 'package:educarte/Services/helpers/file_management_helper.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/enum/button_type.dart';
import '../atoms/modal_application_bar.dart';
import '../../../core/base/constants.dart';
import '../../../core/base/store.dart';
import '../../../Interactor/models/document.dart';

class FileModal extends StatefulWidget {
  const FileModal({
    super.key, 
    required this.modalType, 
    required this.document
  });
  final ModalType modalType;
  final Document document;

  @override
  State<FileModal> createState() => _FileModalState();
}

class _FileModalState extends State<FileModal> {
  @override
  Widget build(BuildContext context) {
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
            CustomButton(
              title: "Visualizar",
              onPressed: () async{
                if(widget.document.fileUri! == "null"){
                  return Store().showErrorMessage(context, "Documento não encontrado"); 
                }

                 XFile xFile = await FileManagement.createTemporaryXFile(
                  url: widget.document.fileUri!,
                  document: widget.document
                );
      
                if(context.mounted){
                  context.push("/pdfViewer", extra: {
                    "pdfPath": xFile.path,
                    "document": widget.document,
                    "xFile": xFile
                  });
                }
              }
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: CustomButton(
                title: "Baixar",
                buttonType: ButtonType.secondary,
                onPressed: () async {
                  if(widget.document.fileUri! == "null"){
                    return Store().showErrorMessage(context, "Documento não encontrado"); 
                  }

                  String result = await FileManagement.download(
                    url: widget.document.fileUri!,
                    fileName: "${widget.document.name}_${widget.document.id!.substring(0,6)}"
                  );
      
                  if(context.mounted){
                    result.toLowerCase().contains("erro") ? Store().showErrorMessage(context, result) : Store().showSuccessMessage(context, result);
                  }
                }
              ),
            ),
            CustomButton(
              title: "Compartilhar",
              buttonType: ButtonType.secondary,
              onPressed: () async{
                if(widget.document.fileUri! == "null"){
                  return Store().showErrorMessage(context, "Documento não encontrado"); 
                }

                await FileManagement.share(
                  url: widget.document.fileUri!,
                  document: widget.document
                );
              }
            ),
          ],
        ),
      ),
    );
  }
}