import 'package:educarte/core/enum/modal_type_enum.dart';
import 'package:educarte/Services/helpers/file_management_helper.dart';
import 'package:educarte/Ui/components/bnt_branco.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../core/base/constants.dart';
import '../../../core/base/store.dart';
import '../../../Interector/models/document.dart';
import '../bnt_azul.dart';
import '../molecules/modal_application_bar.dart';

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
              BotaoAzul(
                text: "Visualizar",
                onPressed: () async{
                  XFile xFile = await FileManagement.createTemporaryXFile(
                    url: "http://www.pdf995.com/samples/pdf.pdf",
                    document: widget.document
                  );
                  //  XFile xFile = await FileManage.createTemporaryXFile(
                  //   url: document.fileUri!,
                  //   document: document
                  // );

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
                child: BotaoBranco(
                  text: "Baixar",
                  onPressed: () async {
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
              BotaoBranco(
                text: "Compartilhar",
                onPressed: () => FileManagement.share(
                  url: widget.document.fileUri!,
                  document: widget.document
                )
              ),
            ],
          ),
        ),
      ),
    );
  }
}