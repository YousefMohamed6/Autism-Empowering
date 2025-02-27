import 'package:autism_empowering/Model/game_data_model.dart';
import 'package:autism_empowering/View/drag_and_drob_game/game_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeGamePage extends StatefulWidget {
  const HomeGamePage({super.key});

  @override
  State<HomeGamePage> createState() => _HomeGamePageState();
}

class _HomeGamePageState extends State<HomeGamePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration: const BoxDecoration(
          image: DecorationImage(
            fit: BoxFit.cover,
            image: AssetImage(
              "assets/animals/game.jpg",
            ),
          ),
        ),
        child: ListView(
          children: [
            InkWell(
              onTap: () {
                GameData.list = GameData.animals;
                GameData.image = "assets/animals/forest.jpg";
                Get.to(() => const GamePage(), transition: Transition.zoom);
              },
              child:
                  gameContainer("Animals Game", "assets/animals/animals.png"),
            ),
            InkWell(
              onTap: () {
                GameData.list = GameData.fruits;
                GameData.image = "assets/fruits/fruit_background.jpg";
                Get.to(() => const GamePage(), transition: Transition.zoom);
              },
              child: gameContainer("Fruits Game", "assets/fruits/fruits.png"),
            ),
          ],
        ),
      ),
    );
  }

  gameContainer(name, image) {
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.4),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.brown.shade700, width: 5),
      ),
      child: Column(
        children: [
          SizedBox(height: 210, child: Image.asset(image)),
          Text(
            name,
            style: TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Colors.brown.shade700,
            ),
          )
        ],
      ),
    );
  }
}
