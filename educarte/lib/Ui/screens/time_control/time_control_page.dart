import 'package:educarte/Interector/validations/convertter.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_symbols_icons/material_symbols_icons.dart';

import '../../../Interector/base/constants.dart';
import 'widgets/card_time_control.dart';

class TimeControlPage extends StatefulWidget {
  const TimeControlPage({super.key});

  @override
  State<TimeControlPage> createState() => _TimeControlPageState();
}

class _TimeControlPageState extends State<TimeControlPage> {
  List<String> currentDate = List.empty(growable: true);
  bool loading = false;

  Future<void> getInitialData() async{
    try {
      setLoading(load: true);

      currentDate = await Convertter.getCurrentDate();

      setLoading(load: false);
    } catch (e) {
      setLoading(load: false);
    }
  }

  void setLoading({required bool load}){
    setState(() {
      loading = load;
    });
  }

  @override
  void initState() {
    getInitialData();
    super.initState();
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
      body: Padding(
        padding: const EdgeInsets.all(16),
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
            const CardTimeControl()
          ]
        ),
      ),
    );
    }
  }
}