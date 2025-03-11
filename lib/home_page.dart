import 'package:flutter/material.dart';
import 'package:qr_code/game_button.dart';
import 'dart:math';
import 'package:qr_code/custom_dialog.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late List<GameButton> buttonsList;
  List<int> player1 = [];
  List<int> player2 = [];
  int activePlayer = 1;

  @override
  void initState() {
    super.initState();
    buttonsList = doInit();
  }

  List<GameButton> doInit() {
    player1 = [];
    player2 = [];
    activePlayer = 1;

    return List<GameButton>.generate(9, (index) => GameButton(id: index + 1));
  }

  void playGame(GameButton gb) {
    setState(() {
      if (gb.enabled) {
        if (activePlayer == 1) {
          gb.text = "X";
          gb.bg = Colors.red; // Set to red for player 1
          player1.add(gb.id);
          activePlayer = 2;
        } else {
          gb.text = "O";
          gb.bg = Colors.black; // Set to black for player 2
          player2.add(gb.id);
          activePlayer = 1;
        }
        gb.enabled = false; // Disable the button
      }

      int winner = checkWinner();
      if (winner == -1) {
        if (buttonsList.every((p) => p.text.isNotEmpty)) {
          showDialog(
            context: context,
            builder: (_) => CustomDialog(
              "Game Tied",
              "Press the reset button to start again.",
              resetGame,
            ),
          );
        } else if (activePlayer == 2) {
          autoPlay();
        }
      }
    });
  }

  void autoPlay() {
    // Check for all available empty cells
    var emptyCells = <int>[];
    for (var i = 0; i < 9; i++) {
      if (!player1.contains(i + 1) && !player2.contains(i + 1)) {
        emptyCells.add(i + 1);
      }
    }

    if (emptyCells.isEmpty) return; // No empty cells left, do nothing.

    var randIndex = Random().nextInt(emptyCells.length);
    var cellID = emptyCells[randIndex];
    int i = buttonsList.indexWhere((p) => p.id == cellID);
    playGame(buttonsList[i]);
  }

  int checkWinner() {
    const winningCombinations = [
      [1, 2, 3],
      [4, 5, 6],
      [7, 8, 9],
      [1, 4, 7],
      [2, 5, 8],
      [3, 6, 9],
      [1, 5, 9],
      [3, 5, 7],
    ];

    for (var combo in winningCombinations) {
      if (combo.every((cell) => player1.contains(cell))) {
        // Player 1 wins
        showDialog(
            context: context,
            builder: (_) => CustomDialog("Player 1 Won",
                "Press the reset button to start again.", resetGame));
        return 1; // Player 1 won
      } else if (combo.every((cell) => player2.contains(cell))) {
        // Player 2 wins
        showDialog(
            context: context,
            builder: (_) => CustomDialog("Player 2 Won",
                "Press the reset button to start again.", resetGame));
        return 2; // Player 2 won
      }
    }

    return -1; // No winner yet
  }

  void resetGame() {
    if (Navigator.canPop(context)) Navigator.pop(context);
    setState(() {
      buttonsList = doInit();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black, // Set background color to black
        title: const Text(
          "Tic Tac Toe",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.white), // Set text color to white
        ),
        centerTitle: true, // Center the title
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                childAspectRatio: 1.0,
                crossAxisSpacing: 9.0,
                mainAxisSpacing: 9.0,
              ),
              itemCount: buttonsList.length,
              itemBuilder: (context, i) => SizedBox(
                width: 100.0,
                height: 100.0,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonsList[i].enabled
                        ? buttonsList[i]
                            .bg // Apply the background color for active buttons
                        : Colors.grey, // Use grey for disabled buttons
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.zero, // Keep it square
                    ),
                  ),
                  onPressed: buttonsList[i].enabled
                      ? () => playGame(buttonsList[i])
                      : null,
                  child: Text(
                    buttonsList[i].text,
                    style: const TextStyle(color: Colors.white, fontSize: 20.0),
                  ),
                ),
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor:
                  Colors.red, // Changed color to blue for reset button
              padding: const EdgeInsets.all(20.0),
            ),
            onPressed: resetGame,
            child: const Text(
              "Reset",
              style: TextStyle(color: Colors.white, fontSize: 20.0),
            ),
          ),
        ],
      ),
    );
  }
}
