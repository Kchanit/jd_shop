import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:jd_shop/themes/color.dart';
import 'package:jd_shop/widgets/main_btn_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:percent_indicator/circular_percent_indicator.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import '../themes/color.dart';

class TestScreen extends StatefulWidget {
  const TestScreen({super.key});

  @override
  State<TestScreen> createState() => _TestScreenState();
}

class _TestScreenState extends State<TestScreen> {
  double currentProg = 1690;
  double target = 2100;
  @override
  Widget build(BuildContext context) {
    double result = currentProg / target;
    int perc = (result * 100).toInt();
    print(result);
    return Scaffold(
        // backgroundColor: kColorsWhite2,
        backgroundColor: Color(0xFF3E3E3E),
        appBar: AppBar(
          backgroundColor: Color(0xFF3E3E3E),
          leading: IconButton(
            icon: (NeumorphicIcon(Icons.arrow_back_ios_new)),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          actions: [
            IconButton(
              onPressed: () {
                Navigator.pushNamed(context, "/profile-screen");
              },
              // icon: SvgPicture.asset(
              //   "assets/icons/edit.svg",
              //   color: kColorsWhite,
              // )
              icon: NeumorphicIcon(
                Icons.manage_accounts,
                size: 25,
              ),
            ),
          ],
          title: Text(
            "Neumorphism Test",
            style: GoogleFonts.getFont('Poppins',
                fontSize: 20, fontWeight: FontWeight.w600),
          ),
        ),
        body: InkWell(
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: ListView(
            children: [
              Padding(
                padding: EdgeInsets.all(25),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Neumorphic(
                    style: NeumorphicStyle(
                        shape: NeumorphicShape.concave,
                        boxShape: NeumorphicBoxShape.roundRect(
                            BorderRadius.circular(50)),
                        lightSource: LightSource.topLeft,
                        depth: 4),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          CircularPercentIndicator(
                            animation: true,
                            animationDuration: 1000,
                            radius: 100,
                            lineWidth: 20,
                            percent: result,
                            progressColor: Color(0xFF3E3E3E),
                            circularStrokeCap: CircularStrokeCap.round,
                            center: Text(
                              '$perc%',
                              style:
                                  GoogleFonts.getFont('Poppins', fontSize: 40),
                            ),
                          ),
                          SizedBox(height: 5),
                          LinearPercentIndicator(
                            animation: true,
                            animationDuration: 1000,
                            lineHeight: 30,
                            barRadius: Radius.circular(20),
                            percent: result,
                            progressColor: Color(0xFF3E3E3E),
                          ),
                          // NeumorphicProgress(
                          //   height: 20,

                          // )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              Center(
                child: NeumorphicText('Warta',
                    style: NeumorphicStyle(
                      depth: 1.5,
                    ),
                    textStyle: NeumorphicTextStyle(
                        fontSize: 48, fontWeight: FontWeight.w700)),
              )
            ],
          ),
        ));
  }
}
