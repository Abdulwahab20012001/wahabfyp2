import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:fyp/utils/app_colors.dart';

class AttemptQuizScreen extends StatefulWidget {
  final String category;
  final String courseId;

  AttemptQuizScreen({required this.category, required this.courseId});

  @override
  // ignore: library_private_types_in_public_api
  _AttemptQuizScreenState createState() => _AttemptQuizScreenState();
}

class _AttemptQuizScreenState extends State<AttemptQuizScreen> {
  Map<String, String> quizQuestions = {};
  Map<String, String> correctAnswers = {};
  List<TextEditingController> answerControllers = [];

  @override
  void initState() {
    super.initState();
    _fetchQuizQuestions();
  }

  void _fetchQuizQuestions() async {
    DataSnapshot snapshot = await FirebaseDatabase.instance
        .ref()
        .child('courses')
        .child(widget.category)
        .child(widget.courseId)
        .child('quiz')
        .get();

    if (snapshot.exists && snapshot.value != null) {
      final data = snapshot.value as Map<dynamic, dynamic>;

      setState(() {
        quizQuestions = {
          for (int i = 1; i <= 3; i++)
            'question$i':
                (data['question$i'] as Map?)?['question']?.toString() ?? '',
        };
        correctAnswers = {
          for (int i = 1; i <= 3; i++)
            'answer$i':
                (data['question$i'] as Map?)?['answer']?.toString() ?? '',
        };

        answerControllers = List.generate(
          quizQuestions.length,
          (index) => TextEditingController(),
        );
      });
    } else {
      print("No quiz data found for this course.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Attempt Quiz'),
        backgroundColor: Mycolors.primary_cyan,
      ),
      body: quizQuestions.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  for (int i = 0; i < quizQuestions.length; i++)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${i + 1}. ${quizQuestions['question${i + 1}']}',
                          style: const TextStyle(
                              fontSize: 30, color: Colors.black),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          style: const TextStyle(color: Colors.black),
                          controller: answerControllers[i],
                          decoration: const InputDecoration(
                            hintText: 'Your Answer',
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],
                    ),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                            title: const Text(
                              'Quiz Completed',
                              style: TextStyle(color: Mycolors.Text_black),
                            ),
                            content: const Text(
                                'Your quiz is completed. View answers now!',
                                style: TextStyle(color: Mycolors.Text_black)),
                            actions: [
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor: MaterialStateProperty.all(
                                      Mycolors.primary_cyan),
                                ),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => ViewAnswersScreen(
                                        quizQuestions: quizQuestions,
                                        correctAnswers: correctAnswers,
                                      ),
                                    ),
                                  );
                                },
                                child: const Text(
                                  'View Answers',
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                      child: const Text('Submit Quiz'),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

class ViewAnswersScreen extends StatelessWidget {
  final Map<String, String> quizQuestions;
  final Map<String, String> correctAnswers;

  ViewAnswersScreen({
    required this.quizQuestions,
    required this.correctAnswers,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Mycolors.primary_cyan,
        title: const Text('View Answers'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            for (int i = 0; i < quizQuestions.length; i++)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Question ${i + 1}: ${quizQuestions['question${i + 1}']}',
                      style: const TextStyle(
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Correct Answer: ${correctAnswers['answer${i + 1}']}',
                      style: const TextStyle(fontSize: 20, color: Colors.green),
                    ),
                    const SizedBox(height: 8),
                  ],
                ),
              ),
          ],
        ),
      ),
    );
  }
}
