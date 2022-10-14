import 'package:danek/helpers/user_preferences.dart';
import 'package:danek/pages/choose_heroes.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';
import 'package:danek/models/activity_button.dart';

class GamePage extends StatefulWidget {
  const GamePage({super.key});

  @override
  State<GamePage> createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  String heroImage = '';

  @override
  void initState() {
    super.initState();
    heroImage = UserPreferences().getHero() ?? '';
    print(heroImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          padding: EdgeInsets.only(top: 60),
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/menubackground.png"),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: [
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/');
                    },
                    child: const CircleAvatar(
                      radius: 30.0,
                      backgroundImage:
                          AssetImage("assets/images/backbutton.png"),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/mypurchases');
                    },
                    child: const CircleAvatar(
                      radius: 30.0,
                      backgroundImage:
                          AssetImage("assets/images/shopbutton.png"),
                    ),
                  ),
                  // SizedBox(
                  //   height: 20,
                  //   width: MediaQuery.of(context).size.width * 0.4,
                  // ),
                  InkWell(
                    enableFeedback: false,
                    onTap: () {
                      FlameAudio.play('zvukmonet.wav', volume: 5);
                    },
                    child: CircleAvatar(
                      radius: 30.0,
                      backgroundImage:
                          const AssetImage("assets/images/coin.png"),
                      child: Text(
                        "$value",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.60,
                child: Image.asset(heroImage),
              ),
//героя выбираем из списка и картинка меняется
              //далее  привязать к индексу в shared preferences

              Expanded(
                child: ListView.builder(
                    padding: const EdgeInsets.only(left: 25, right: 25),
                    itemCount: act.length,
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (BuildContext context, int index) {
                      return SizedBox(
                          child: ActivityButton(
                              image: act[index].image, cash: act[index].cash));
                    }),
              ),
              SizedBox(height: 60),
            ],
          )),
    );
  }
}
