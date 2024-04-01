import 'dart:convert';

import 'package:educarte/Interector/base/constants.dart';
import 'package:flutter/material.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:table_calendar/table_calendar.dart';

import '../../../Interector/models/api_diaries.dart';
import '../../components/table_Calendar.dart';
import 'package:http/http.dart' as http;
import '../../global/global.dart' as globals;

class MessagesScreen extends StatefulWidget {
  MessagesScreen({super.key, this.idStudent});
  String? idStudent;
  @override
  State<MessagesScreen> createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen> {
  DateTime today = DateTime.now();
  void _onDaySelected(DateTime day, DateTime focusDay){
    setState(() {
      today = day;
    });
  }
  bool loading = false;

  void setLoading({required bool load}){
    setState(() {
      loading = load;
    });
  }
  List<ApiDiaries> listDiaries = [];
  void getStudentId()async{
    setState(() {
      listDiaries = [];
    });
    try{
      var response = await http.get(Uri.parse("http://64.225.53.11:5000/Students/${widget.idStudent}"),
          headers: {
            "Authorization": "Bearer ${globals.token}"
          }
      );
      if(response.statusCode == 200){
        var decodeJson = jsonDecode(response.body);
        (decodeJson["diaries"] as List).where((diary) {
          listDiaries.add(ApiDiaries.fromJson(diary));
          return true;
        }).toList();
        setLoading(load: false);

      }
    }catch (e){
      print("erro -----------");
      print(e);
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: screenWidth(context),
        height: screenHeight(context),
        color: colorScheme(context).background,
        alignment: Alignment.center,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 16),
          child: Column(
            children: [
              const SizedBox(height: 20,),
              CustomTableCalendar(callback: (DateTime? start, DateTime? end) {

              },),
            ],
          ),
        ),
      ),
    );
  }
}
