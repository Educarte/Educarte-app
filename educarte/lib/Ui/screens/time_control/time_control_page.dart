import 'dart:convert';

import 'package:educarte/Interector/base/store.dart';
import 'package:educarte/Interector/enum/modal_type_enum.dart';
import 'package:educarte/Interector/models/classroom_model.dart';
import 'package:educarte/Interector/validations/convertter.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';
import 'package:http/http.dart' as http;

import '../../../Interector/base/constants.dart';
import '../../../Interector/models/document.dart';
import '../../../Interector/models/students_model.dart';
import '../../../Services/config/api_config.dart';
import '../../components/custom_dropdown.dart';
import '../../components/organisms/modal.dart';
import '../../components/search_input.dart';
import '../../global/global.dart';
import 'widgets/card_time_control.dart';

enum TimeControlPageLoading{
  none,
  initial,
  getStudents,
  filter,
  loaded
}

class TimeControlPage extends StatefulWidget {
  const TimeControlPage({super.key});

  @override
  State<TimeControlPage> createState() => _TimeControlPageState();
}

class _TimeControlPageState extends State<TimeControlPage> {
  List<String> currentDate = List.empty(growable: true);
  final TextEditingController _search = TextEditingController();
  TimeControlPageLoading loading = TimeControlPageLoading.none;
  Classroom classroomSelected = Classroom.empty();
  List<Classroom> classrooms = List.empty(growable: true);
  List<Student> students = List.empty(growable: true);
  Document? menu;

  @override
  void initState() {
    getInitialData();
    super.initState();
  }

  void setLoading({required TimeControlPageLoading load}){
    setState(() {
      loading = load;
    });
  }

  Future<void> getInitialData() async{
    try {
      setLoading(load: TimeControlPageLoading.initial);

      await getStudents(timeControlPageLoading: TimeControlPageLoading.initial);
      await getMenu();

      currentDate = await Convertter.getCurrentDate();

      classroomSelected = classrooms.first;

      setLoading(load: TimeControlPageLoading.loaded);
    } catch (e) {
      setLoading(load: TimeControlPageLoading.loaded);
    }
  }

  Future<void> getMenu() async{
    try {
      setLoading(load: TimeControlPageLoading.initial);

      var params = {
        'Status': "0"
      };
      
      var response = await http.get(Uri.parse("$baseUrl/Menus").replace(queryParameters: params),
        headers: {
          "Authorization": "Bearer $token",
        }
      );

      if(response.statusCode == 200){
        Map<String,dynamic> jsonData = jsonDecode(response.body);
        List<Document> menus = List.empty(growable: true); 

        (jsonData["items"] as List).where((element) {
          menus.add(Document(
            id: element["id"],
            name: element["name"],
            fileUri: element["uri"],
            startDate: jsonData["startDate"] != null ? DateTime.parse(element["startDate"]) : null,
            validUntil: jsonData["validUntil"] != null ? DateTime.parse(jsonData["validUntil"]) : null
          ));

          return true;
        }).toList();

        menus.sort((a, b) => b.startDate!.compareTo(a.startDate!));
        menus.sort((a, b) => b.validUntil!.compareTo(a.validUntil!));
        
        menu =  menus.first;
      }
      
      setLoading(load: TimeControlPageLoading.loaded);
    } catch (e) {
      setLoading(load: TimeControlPageLoading.loaded);
    }
  }

  Future<void> getStudents({required TimeControlPageLoading timeControlPageLoading}) async{
    try {
      setLoading(load: timeControlPageLoading);

      students.clear();
      var params = {
        'Search': _search.text
      };

      var response = await http.get(Uri.parse("$baseUrl/Students").replace(queryParameters: params),
        headers: {
          "Authorization": "Bearer $token",
        }
      );

      if(response.statusCode == 200){
        Map<String,dynamic> jsonData = jsonDecode(response.body);
        (jsonData["items"] as List).where((element) {
          students.add(Student.fromJson(element));

          return true;
        }).toList();

        await getClassrooms();
      }
      setLoading(load: TimeControlPageLoading.loaded);
    } catch (e) {
      setLoading(load: TimeControlPageLoading.loaded);
    }
  }

  Future<void> getClassrooms() async{
    try {
      classrooms.clear();

      var response = await http.get(Uri.parse("$baseUrl/Classroom"),
        headers: {
          "Authorization": "Bearer $token",
        }
      );
      if(response.statusCode == 200){
        Map<String,dynamic> jsonData = jsonDecode(response.body);
        classrooms.add(Classroom.empty());
        
        (jsonData["items"] as List).where((element) {
          classrooms.add(Classroom.fromJson(element));

          return true;
        }).toList();
      }
    } catch (e) {
      setLoading(load: TimeControlPageLoading.loaded);
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

    if (loading == TimeControlPageLoading.initial) {
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
                            onTap: menu == null || menu!.id == null ? null : () => ModalEvent.build(
                              context: context, 
                              modalType: ModalType.menu
                            ),
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
                  controller: _search, 
                  action: () => getStudents(timeControlPageLoading: TimeControlPageLoading.filter)
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: CustomDropdown(
                    list: classrooms,
                    selected: classroomSelected,
                    callback: (result) => setState(() {
                      classroomSelected = result;
                    }),
                  )
                ),
                students.isEmpty ? const Text("data") : ListView.builder(
                  padding: EdgeInsets.zero,
                  primary: false,
                  shrinkWrap: true,
                  itemCount: students.length,
                  itemBuilder:(_, index) {
                    return CardTimeControl(
                      student: students[index], 
                      callback: (bool result) {  
                        if(result){
                          context.pop();
                          
                          getStudents(timeControlPageLoading: TimeControlPageLoading.filter);
                        }
                      },
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