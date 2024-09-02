import 'dart:async';

import 'package:educarte/Interactor/models/classroom_model.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../Interactor/providers/menu_provider.dart';
import '../../../Interactor/providers/student_provider.dart';
import '../../../Interactor/providers/user_provider.dart';
import '../../../Interactor/validations/intl_formatter.dart';
import '../../../core/base/constants.dart';
import '../../../Interactor/models/students_model.dart';
import '../../../core/config/api_config.dart';
import '../../components/atoms/custom_dropdown.dart';
import '../../components/atoms/result_not_found.dart';
import '../../components/atoms/search_input.dart';
import '../../components/organisms/header_home.dart';
import 'widgets/card_time_control.dart';

enum TimeControlPageLoading { none, initial, getStudents, filter, loaded }

class TimeControlPage extends StatefulWidget {
  const TimeControlPage({super.key});

  @override
  State<TimeControlPage> createState() => _TimeControlPageState();
}

class _TimeControlPageState extends State<TimeControlPage> {
  final userProvider = GetIt.instance.get<UserProvider>();
  final menuProvider = GetIt.instance.get<MenuProvider>();
  final studentProvider = GetIt.instance.get<StudentProvider>();

  TextEditingController nomeController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController? telefoneController = TextEditingController();
  (String, String, String) currentDate = ("", "", "");
  final TextEditingController _search = TextEditingController();
  TimeControlPageLoading loading = TimeControlPageLoading.none;
  late Classroom classroomSelected = Classroom.empty();
  List<Student> students = [];
  List<Student> studentsFilter = [];
  bool carregando = false;
  String getStudentsUrl = "/Students";

  @override
  void initState() {
    super.initState();
    studentProvider.getClassrooms(
      context: context
    );
    getInitialData();
  }

  Future<void> getInitialData() async {
    currentDate = await IntlFormatter.getCurrentDate(
      isDe: true, 
      data: DateTime.now().toString()
    );

    await studentProvider.getStudents(
      context: context,
      customUrl: getStudentsUrl
    );
  }

  @override
  Widget build(BuildContext context) {
    TextStyle style({FontWeight? fontWeight}) => GoogleFonts.poppins(
      color: colorScheme(context).onInverseSurface,
      fontWeight: fontWeight ?? FontWeight.w300
    );

    return ListenableBuilder(
      listenable: studentProvider,
      builder: (_, __) {
        if (studentProvider.loading) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return Scaffold(
            resizeToAvoidBottomInset: false,
            backgroundColor: colorScheme(context).onSurfaceVariant,
            body: Padding(
              padding: const EdgeInsets.all(16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    if (currentDate.$1.isNotEmpty)...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: RichText(
                          text: TextSpan(
                            children: [
                              TextSpan(
                                text: "${IntlFormatter.getDayWeek(DateTime.now())}, ${currentDate.$1}", 
                                style: style()
                              ),
                              TextSpan(
                                text: currentDate.$2,
                                style: style(fontWeight: FontWeight.w600)
                              ),
                              TextSpan(
                                text: " de ${currentDate.$3}", 
                                style: style()
                              )
                            ]
                          )
                        ),
                      ),
                    ],
                    HeaderHome(
                      userProvider: userProvider,
                      secondProfile: true,
                      menuProvider: menuProvider
                    ),
                    const SizedBox(height: 12),
                    CustomSearchInput(
                      controller: _search,
                      action: () {
                        setState(() {
                          studentProvider.students = studentsFilter.where((element) => element.name!
                                  .toLowerCase()
                                  .contains(
                                      _search.text.toString().toLowerCase()))
                              .toList();
                        });
                      }
                    ),
                    if(studentProvider.classrooms.isNotEmpty)...[
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child: CustomDropdown(
                          list: studentProvider.classrooms,
                          selected: studentProvider.classrooms[studentProvider.classroomSelectedIndex],
                          callback: (result) async{
                            studentProvider.classroomSelected = result;
                            studentProvider.classroomSelectedIndex = studentProvider.classrooms.indexWhere((element) => element.id == result.id);

                            var params = {
                              "ClassroomId": result.id
                            };

                            Uri customUri = Uri.parse("$apiUrl/Students").replace(queryParameters: params);
                            
                            await studentProvider.getStudents(
                              context: context,
                              customUrl: "$apiUrl/Students",
                              customResponse: await ApiConfig.request(
                                customUri: customUri
                              )
                            );
                          },
                        )
                      )
                    ],
                    if(studentProvider.students.isEmpty)...[
                      const SizedBox(
                        height: 500,
                        child: Center(
                          child: ResultNotFound(
                              description: "Nenhum usuário encontrado!",
                              iconData: Symbols.error),
                        ),
                      )
                    ]else...[
                      ListView.builder(
                        padding: EdgeInsets.zero,
                        primary: false,
                        shrinkWrap: true,
                        itemCount: studentProvider.students.length,
                        itemBuilder: (_, index) {
                          return CardTimeControl(
                            student: studentProvider.students[index],
                            callback: (bool result) async{
                              if (result) {
                                await studentProvider.getStudents(
                                  context: context,
                                  customUrl: getStudentsUrl
                                );
                              }
                            }
                          );
                        }
                      )
                    ]
                  ]
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
