import 'dart:convert';

import 'package:educarte/Interector/validations/convertter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:http/http.dart' as http;

import '../../../Interector/base/constants.dart';
import '../../../Interector/models/students_model.dart';
import '../../../Services/config/api_config.dart';
import '../../components/custom_dropdown.dart';
import '../../components/search_input.dart';
import 'widgets/card_time_control.dart';

class TimeControlPage extends StatefulWidget {
  const TimeControlPage({super.key});

  @override
  State<TimeControlPage> createState() => _TimeControlPageState();
}

class _TimeControlPageState extends State<TimeControlPage> {
  List<String> currentDate = List.empty(growable: true);
  TextEditingController search = TextEditingController();
  bool loading = false;
  String selected = "";
  List<String> exampleRoomName = List.empty(growable: true);
  List<Student> students = List.empty(growable: true);

  @override
  void initState() {
    getInitialData();
    super.initState();
  }

  void setLoading({required bool load}){
    setState(() {
      loading = load;
    });
  }

  Future<void> getInitialData() async{
    try {
      setLoading(load: true);

      await getStudents();

      currentDate = await Convertter.getCurrentDate();

      exampleRoomName = ["um", "dois", "tres"];
      selected = exampleRoomName.first;

      setLoading(load: false);
    } catch (e) {
      setLoading(load: false);
    }
  }

  Future<void> getStudents() async{
    try {
      students.clear();
      String tok = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJzdWIiOiIwOGRjM2Y3YS0yMWNkLTRmODctODVmNy1lM2ZiNDE2ZmIyNWMiLCJuYW1lIjoiUGFpIiwiZW1haWwiOiJwYWlAZW1haWwuY29tIiwicm9sZSI6IkxlZ2FsR3VhcmRpYW4iLCJwcm9maWxlIjoiTGVnYWxHdWFyZGlhbiIsImlzRmlyc3RBY2Nlc3MiOiJUcnVlIiwiZXhwIjoxNzExMDUxNzMyLCJpc3MiOiJFZHVjYXJ0ZSIsImF1ZCI6IkVkdWNhcnRlIn0.4sp9CII1nn1fDwq5fG9ys7ShH88aAngw3osCjgtD5wY";
      var response = await http.get(Uri.parse("${baseUrl}Students"),
        headers: {
          "Authorization": "Bearer $tok",
        }
      );
      if(response.statusCode == 200){
        Map<String,dynamic> jsonData = jsonDecode(response.body);
        (jsonData["items"] as List).where((element) {
          students.add(Student.fromJson(element));

          return true;
        }).toList();

        setLoading(load: false);
        // setState(() {
        //   nome.text = jsonData["name"];
        //   email.text = jsonData["email"];
        //   if(jsonData["cellphone"] != null){
        //     telefone?.text = jsonData["cellphone"];
        //   }
        // });
      }
    } catch (e) {
      setLoading(load: false);
    }
  }

  @override
  Widget build(BuildContext context) {
    double iconSize = 30;
    Color colorIcon = const Color(0xFFA0A4A8);
    TextStyle style ({FontWeight? fontWeight}) => GoogleFonts.poppins(
      color: colorScheme(context).surface,
      fontWeight: fontWeight ?? FontWeight.w300
    );

    if (loading) {
      return const CircularProgressIndicator();
    } else {
      return Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 48),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: currentDate[0],
                        style: style()
                      ),
                      TextSpan(
                        text: currentDate[1],
                        style: style(fontWeight: FontWeight.w600)
                      ),
                      TextSpan(
                        text: currentDate[2],
                        style: style()
                      )
                    ]
                  )
                ),
                const SizedBox(height: 32),
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text("Olá,",style: GoogleFonts.poppins(
                            color: colorScheme(context).surface,
                            fontWeight: FontWeight.w400,
                            fontSize: 16,
                          ),),
                          Text(
                            "Antonio",
                            style: GoogleFonts.poppins(
                              color: colorScheme(context).primary,
                              fontWeight: FontWeight.w800,
                              fontSize: 25,
                            )
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Row(
                        children: [
                          GestureDetector(
                            onTap: () { },
                            child: Icon(
                              Symbols.nutrition,
                              size: iconSize,
                              color: colorIcon
                            )
                          ),
                          const SizedBox(width: 32),
                          GestureDetector(
                            onTap: () { },
                            child: Icon(
                              Symbols.account_circle_rounded,
                              size: iconSize,
                              color: colorIcon
                            )
                          )
                        ]
                      )
                    )
                  ],
                ),
                const SizedBox(height: 12),
                CustomSearchInput(
                  controller: search, 
                  action: () {  }
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: CustomDropdown(
                    list: exampleRoomName,
                    selected: selected,
                    callback: (result) {
                      
                    },
                  )
                ),
                ListView.builder(
                  padding: EdgeInsets.zero,
                  primary: false,
                  shrinkWrap: true,
                  itemCount: students.length,
                  itemBuilder:(_, index) {
                    return CardTimeControl(
                      student: students[index],
                    );
                  }
                )
              ]
            ),
          ),
        ),
      );
    }
  }
}