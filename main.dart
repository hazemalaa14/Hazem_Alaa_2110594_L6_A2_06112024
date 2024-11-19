import 'dart:math';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const Dicerollerapp(),
    );
  }
}

class Dicerollerapp extends StatefulWidget {
  const Dicerollerapp({super.key});

  @override
  State<Dicerollerapp> createState() => _DiceGameState();
}

class _DiceGameState extends State<Dicerollerapp> {
  List<int> diceValues = [1];
  int numberOfDice = 1;
  String? playerColor;
  String? message;
  int rolls = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dice Game'),
        titleTextStyle: TextStyle(fontWeight: FontWeight.bold),
        backgroundColor: Colors.black,
        centerTitle: true,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(getBackgroundImage()),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => changeDiceCount(1),
                    child: const Text('1 Die'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => changeDiceCount(2),
                    child: const Text('2 Dice'),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: () => changeDiceCount(3),
                    child: const Text('3 Dice'),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < diceValues.length; i++)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: getDiceBorderColor(i),
                          ),
                        ),
                        child: Image.asset(
                          getDiceImage(diceValues[i]),
                          width: 100,
                          height: 100,
                        ),
                      ),
                    ),
                ],
              ),
              if (numberOfDice == 2) ...[
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () => chooseColor('blue'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Left'),
                    ),
                    const SizedBox(width: 20),
                    ElevatedButton(
                      onPressed: () => chooseColor('red'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Right'),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: getRollButtonCallback(),
                child: const Text('Roll Dice'),
              ),

              if (message != null) ...[
                const SizedBox(height: 20),
                Text(
                  message!,
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: getMessageColor(),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String getDiceImage(int number) {
    return 'assets/images/dice_$number.png';
  }
    String getBackgroundImage() {
    return 'assets/images/dice$numberOfDice.jpg';
  }

  Color getDiceBorderColor(int index) {
    if (numberOfDice == 2) {
      if (index == 0) {
        return Colors.blue;
      } else {
        return Colors.red;
      }
    } else {
      return Colors.black;
    }
  }

  void Function()? getRollButtonCallback() {
    if (numberOfDice == 2 && playerColor == null) {
      return null;
    } else {
      return rollDice;
    }
  }

  void chooseColor(String color) {
    setState(() {
      playerColor = color;
      message = null;
    });
  }

  void changeDiceCount(int count) {
    setState(() {
      numberOfDice = count;
      diceValues = List.generate(count, (_) => 1);
      playerColor = null;
      message = null;
      rolls = 0;
    });
  }

  void rollDice() {
    setState(() {
      if (numberOfDice == 3) {
        rolls++;
        if (rolls == 3) {
          diceValues = [6, 6, 6];
          message = 'Jackpot!!!!!';
        } else {
          diceValues = List.generate(3, (_) => Random().nextInt(6) + 1);
          if (diceValues.toSet().length == 1) {
            message = 'Jackpot!!!!!';
          } else {
            message = '99% of gamblers quit before hitting it big ';
          }
        }
      } else if (numberOfDice == 2) {
        diceValues = List.generate(2, (_) => Random().nextInt(6) + 1);
        if (playerColor != null) {
          bool leftWon = diceValues[0] > diceValues[1];
          if (playerColor == 'blue') {
            if (leftWon) {
              message = 'You Win';
            } else {
              message = 'You Lose';
            }
          } else {
            if (leftWon) {
              message = 'You Lose';
            } else {
              message = 'You Win';
            }
          }
        }
      } else {
        diceValues = [Random().nextInt(6) + 1];
      }
    });
  }

  Color getMessageColor() {
    Color messageColor;
    if (message == 'Jackpot!!!!!') {
      messageColor = Colors.amber;
    } 
    else if (message == '99% of gamblers quit before hitting it big ') {
      messageColor = Colors.green;
    }
    else {
      if (playerColor == 'blue') {
        messageColor = Colors.blue;
      } else {
        messageColor = Colors.red;
      }
    }
    return messageColor;
}}