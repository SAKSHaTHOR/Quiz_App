import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:quiz_app/api_services.dart';
import 'package:quiz_app/const/colors.dart';
import 'package:quiz_app/const/images.dart';
import 'package:quiz_app/const/text_style.dart';
import 'package:quiz_app/summary_screen.dart';

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int seconds = 60;
  Timer? timer;
  var currentQuestionIndex = 0;
  late Future quiz;

  int points = 0;

  var isLoaded = false;

  var optionsColor = [
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
    Colors.white,
  ];

  @override
  void initState() {
    super.initState();
    quiz = getQuiz();
    startTimer();
  }

  @override
  void dispose() {
    // Ensure the timer is canceled properly
    timer?.cancel();
    super.dispose();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (seconds > 0) {
          seconds--;
        } else {
          timer.cancel(); // Stop the current timer

          // Check if there are more questions
          if (currentQuestionIndex < 10 - 1) {
            currentQuestionIndex++; // Move to the next question
            resetColors(); // Reset option colors
            seconds = 60; // Reset timer
            startTimer(); // Start timer again for the new question
          } else {
            // Navigate to the Summary Screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => SummaryScreen(points: points),
              ),
            );
          }
        }
      });
    });
  }

  resetColors() {
    optionsColor = [
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
      Colors.white,
    ];
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [blue, darkBlue],
            ),
          ),
          child: FutureBuilder(
            future: quiz,
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(Colors.white),
                  ),
                );
              } else if (snapshot.hasData) {
                var data = snapshot.data["questions"];

                return SingleChildScrollView(
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: Border.all(color: lightgrey, width: 2),
                            ),
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              icon: const Icon(
                                CupertinoIcons.xmark,
                                color: Colors.white,
                                size: 20,
                              ),
                            ),
                          ),
                          Stack(
                            alignment: Alignment.center,
                            children: [
                              normalText(
                                color: Colors.white,
                                size: 28,
                                text: "$seconds",
                              ),
                              SizedBox(
                                width: 80,
                                height: 80,
                                child: CircularProgressIndicator(
                                  value: seconds / 60,
                                  valueColor: const AlwaysStoppedAnimation(
                                      Colors.white),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: lightgrey, width: 2),
                            ),
                            child: TextButton.icon(
                              onPressed: () {},
                              icon: const Icon(
                                CupertinoIcons.heart_fill,
                                color: Colors.white,
                                size: 18,
                              ),
                              label: normalText(
                                color: Colors.white,
                                size: 14,
                                text: "Like",
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Image.asset(target, width: 300),
                      const SizedBox(height: 20),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: normalText(
                          color: lightgrey,
                          size: 18,
                          text:
                              "Question ${currentQuestionIndex + 1} of ${data.length}",
                        ),
                      ),
                      const SizedBox(height: 20),
                      normalText(
                        color: Colors.white,
                        size: 20,
                        text: data[currentQuestionIndex]["description"],
                      ),
                      const SizedBox(height: 20),
                      ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: data[currentQuestionIndex]["options"].length,
                        itemBuilder: (BuildContext context, int index) {
                          String? answer;

                          if (data[currentQuestionIndex]["options"][index]
                                  ["is_correct"] ==
                              true) {
                            answer = data[currentQuestionIndex]["options"]
                                    [index]["description"]
                                .toString();
                          }

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                if (answer != null &&
                                    answer ==
                                        data[currentQuestionIndex]["options"]
                                                [index]["description"]
                                            .toString()) {
                                  optionsColor[index] = Colors.green;

                                  points += 10;
                                } else {
                                  optionsColor[index] = Colors.red;
                                }
                              });

                              if (currentQuestionIndex < data.length - 1) {
                                Future.delayed(Duration(milliseconds: 20), () {
                                  isLoaded = false;
                                  currentQuestionIndex++;
                                  resetColors();
                                  timer!.cancel();
                                  seconds = 60;
                                  startTimer();
                                });
                              } else {
                                timer!.cancel();
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        SummaryScreen(points: points),
                                  ),
                                );
                              }
                            },
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 20),
                              alignment: Alignment.center,
                              width: size.width - 100,
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: optionsColor[index],
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: headingText(
                                  color: blue,
                                  size: 18,
                                  text: data[currentQuestionIndex]["options"]
                                          [index]["description"]
                                      .toString()),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                );
              } else {
                return const Center(
                  child: Text(
                    'Error loading data',
                    style: TextStyle(color: Colors.white),
                  ),
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
