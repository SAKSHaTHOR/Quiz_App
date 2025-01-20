import 'package:flutter/material.dart';
import 'package:quiz_app/const/colors.dart';
import 'package:quiz_app/const/text_style.dart';

class SummaryScreen extends StatelessWidget {
  final int points;

  const SummaryScreen({super.key, required this.points});

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    // Determine badge text and color based on points
    String badgeText;
    Color badgeColor;

    if ((points / 100) * 100 >= 80) {
      badgeText = '🏅 You earned a Gold Badge!';
      badgeColor = const Color.fromARGB(255, 219, 184, 9);
    } else if ((points / 100) * 100 >= 50) {
      badgeText = '🥈 You earned a Silver Badge!';
      badgeColor = const Color.fromARGB(255, 129, 246, 234);
    } else {
      badgeText = '🔰 Keep practicing to earn a badge!';
      badgeColor = Colors.red;
    }

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [blue, darkBlue],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/trophy.png',
                width: size.width * 0.6,
              ),
              const SizedBox(height: 20),

              headingText(
                color: Colors.white,
                size: 28,
                text: 'Congratulations!',
              ),
              const SizedBox(height: 10),
              normalText(
                color: lightgrey,
                size: 18,
                text: 'You scored:',
              ),
              const SizedBox(height: 20),

              // Gamified score display
              Stack(
                alignment: Alignment.center,
                children: [
                  // Circular progress indicator for score
                  SizedBox(
                    width: 150,
                    height: 150,
                    child: CircularProgressIndicator(
                      value: points /100, // Assume 100 is max points so that we can use 100 as percentage
                      strokeWidth: 10,
                      valueColor: AlwaysStoppedAnimation(Colors.yellow),
                      backgroundColor: lightgrey,
                    ),
                  ),
                  // Points in the center
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      headingText(
                        color: Colors.white,
                        size: 32,
                        text: "$points",
                      ),
                      normalText(
                        color: Colors.yellow,
                        size: 18,
                        text: "Points",
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 30),

              // Badge feature
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: badgeColor,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  badgeText,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 30),

              // Play again button
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 221, 255),
                  padding: const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 24,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: normalText(
                  color: Colors.white,
                  size: 18,
                  text: 'Play Again',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
