import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher_string.dart';

import '../../Interector/base/store.dart';
import '../../Interector/models/document.dart';


class FileManagement {
  static Future<XFile> createTemporaryXFile({required String url, required Document document}) async{
    final response = await http.get(Uri.parse(url));

    final directory = await getTemporaryDirectory();

    final file = File('${directory.path}/${document.id}.pdf');
    await file.writeAsBytes(response.bodyBytes);

    return XFile(file.path);
  }

  static Future<void> share({required String url, required Document document}) async{
    XFile xFile = await createTemporaryXFile(
      url: url, 
      document: document
    );

    await Share.shareXFiles([xFile]).then((value) => File(xFile.path).delete());
  }

  static Future<void> launchUri({required String link, required BuildContext context}) async{
    String errorMessage = 'Não foi possível abrir o link: $link';
    
    try {
      if (await canLaunchUrlString(link)) {
        await launchUrlString(link);
      } else {
        if(context.mounted) Store().showErrorMessage(context, errorMessage);
      }
    } catch (e) {
      if(context.mounted) Store().showErrorMessage(context, errorMessage);
    }
  }

  static Future<void> ensureDirectoryExists({required Directory directory}) async {
    if (!directory.existsSync()) {
      await directory.create();
    }
  }

  static Future<String> download({required String url, required String fileName}) async{
    try {
      String externalStorage = (await getApplicationDocumentsDirectory()).absolute.path;
      final Directory directory = Directory(externalStorage);
      final dio = Dio();
      String filePath = '';
      bool isIOS = Platform.isIOS;

      if (isIOS) {
        filePath = '${directory.path}/$fileName.pdf';
      }else{
        filePath = directory.absolute.path;
      }
      await ensureDirectoryExists(directory: directory);

      if(isIOS){
        await dio.download(
          url,
          filePath,
        );
      }else{
        await FlutterDownloader.enqueue(
            url: url,
            saveInPublicStorage: true,
            savedDir: filePath,
            fileName: fileName
        );
      }

      return "Arquivo baixado com sucesso";
    } catch (e) {
      return "Erro ao baixar arquivo";
    }
  }
}