
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:go_router/go_router.dart';
import 'package:share_plus/share_plus.dart';

import '../../../Interactor/models/document.dart';
import '../../../core/base/constants.dart';
import '../atoms/custom_app_bar.dart';

class PDFViewerPage extends StatefulWidget {
  final String pdfPath;
  final Document document;
  final XFile xFile;
  const PDFViewerPage({
    super.key, 
    required this.pdfPath,
    required this.document, 
    required this.xFile
  });

  @override
  State<PDFViewerPage> createState() => _PDFViewerPageState();
}

class _PDFViewerPageState extends State<PDFViewerPage> {
  int? currentPage = 0;
  int? totalPage = 0;
  bool error = false;
  bool isReady = false;
  late final Completer<PDFViewController> _controller;

  @override
  void initState() {
    _controller = Completer<PDFViewController>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        context: context, 
        title: widget.document.name!,
        action: () {
          File(widget.xFile.path).delete();

          context.pop();
        }
      ),
      body: error ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 48,
              color: colorScheme(context).error
            ),
            Text(
              "Erro ao carregar PDF",
              style: textTheme(context).titleSmall!.copyWith(
                color: colorScheme(context).outline,
                fontWeight: FontWeight.w500
              )
            )
          ],
        ),
      ): Stack(
        children: [
          PDFView(
            filePath: widget.pdfPath,
            pageFling: false,
            pageSnap: false,
            defaultPage: 0,
            fitPolicy: FitPolicy.BOTH,
            onRender: (pages) {
              setState(() {
                isReady = true;
              });
            },
            onViewCreated: (PDFViewController viewController) async {
              if(Platform.isIOS){
                totalPage = await viewController.getPageCount();
                totalPage = totalPage!-1;
              }

              setState(() {
                totalPage = totalPage == 0 ? 1 : totalPage;
              });
              _controller.complete(viewController);
            },
            onError: (errorString) {
              setState(() {
                error = true;
              });
            },
            onPageChanged: (int? page, int? total) {
              setState(() {
                if(Platform.isAndroid){
                  totalPage = total!-1;
                }

                totalPage = totalPage == 0 ? 1 : totalPage;
                currentPage = page == 0 ? 1 : page;
              });
            },
          ),
          !isReady ? const Center(
            child: CircularProgressIndicator()
          ) : const Text("")
        ],
      ),
      floatingActionButton: error ? null : FutureBuilder<PDFViewController>(
        future: _controller.future,
        builder: (context, AsyncSnapshot<PDFViewController> snapshot) {
          if (snapshot.hasData) {
            return Container(
              width: MediaQuery.of(context).size.width * .3,
              height: MediaQuery.of(context).size.height * 0.05,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: colorScheme(context).outline
              ),
              alignment: Alignment.center,
              child: Text(
                "$currentPage / $totalPage",
                textAlign: TextAlign.center,
                style: textTheme(context).bodyLarge!.copyWith(
                  color: colorScheme(context).surface,
                  fontWeight: FontWeight.w600
                ),
              ),
            );
          }

          return Container();
        },
      )
    );
  }
}
