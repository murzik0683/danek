import 'dart:async';
import 'package:danek/helpers/audio.dart';
import 'package:danek/helpers/colors.dart';
import 'package:danek/helpers/user_preferences.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class CoverScreenPage extends StatefulWidget {
  const CoverScreenPage({super.key});

  @override
  State<CoverScreenPage> createState() => _CoverScreenPageState();
}

class _CoverScreenPageState extends State<CoverScreenPage> {
  Timer? timer;
  bool foneMusic = true;
  @override
  void initState() {
    super.initState();
    foneMusic = UserPreferences().getFoneticMusic() ?? true;
    checkFoneMusic(foneMusic);
    timer = Timer(const Duration(seconds: 3), () {
      Navigator.pushNamed(context, '/menupage');
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
      // padding: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
          image: DecorationImage(
              image: AssetImage("assets/images/menubackground.png"),
              fit: BoxFit.cover)),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Image(
                image: AssetImage('assets/images/coverpage.png'),
                fit: BoxFit.cover),
            SizedBox(height: 40),
            SpinKitFadingCircle(
              color: CustomColors.whiteColor,
              size: 50,
            )
          ],
        ),
      ),
    ));
  }
}
