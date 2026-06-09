import 'package:flutter/material.dart';
import 'package:quiz_buzz/models/question.dart';
import 'package:quiz_buzz/models/result.dart';
import 'package:quiz_buzz/screens/result_screen.dart';
import 'package:quiz_buzz/theme/theme_data.dart';
import 'package:quiz_buzz/widgets/answer_button.dart';
import 'package:quiz_buzz/widgets/header.dart';

class QuizScreen extends StatefulWidget {
  final List<Question> questions;
  final String title;
  const QuizScreen({super.key, required this.questions, required this.title});

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  int _score = 0;
  int? _selectedIndex;
  bool _answered = false;
  final List<AnswerRecord> _records = [];

  Question get _currentQuestion => widget.questions[_currentIndex];

  static const List<String> _letters = ['A', 'B', 'C', 'D'];

  AnswerState _stateForOption(int index) {
    if (!_answered) return AnswerState.neutral;
    if (index == _currentQuestion.correctIndex) {
      return _selectedIndex == index
          ? AnswerState.correct
          : AnswerState.revealed;
    }
    if (index == _selectedIndex) return AnswerState.wrong;
    return AnswerState.neutral;
  }

  void _selectAnswer(int index) {
    if (_answered) return;

    final isCorrect = index == _currentQuestion.correctIndex;
    final points = isCorrect ? _currentQuestion.difficulty.points : 0;

    setState(() {
      _selectedIndex = index;
      _answered = true;
      _score += points;
    });

    _records.add(
      AnswerRecord(
        questionId: _currentQuestion.id,
        selectedIndex: index,
        correctIndex: _currentQuestion.correctIndex,
        isCorrect: isCorrect,
        pointsEarned: points,
      ),
    );
  }

  void _nextQuestion() {
    if (_currentIndex < widget.questions.length - 1) {
      setState(() {
        _currentIndex++;
        _selectedIndex = null;
        _answered = false;
      });
    } else {
      _finishQuiz();
    }
  }

  void _finishQuiz() {
    final maxScore = widget.questions.fold<int>(
      0,
      (sum, q) => sum + q.difficulty.points,
    );

    final result = QuizResult(
      totalQuestions: widget.questions.length,
      correctAnswers: _records.where((r) => r.isCorrect).length,
      totalScore: _score,
      maxScore: maxScore,
      answers: _records,
    );

    print(_score);

    // navigate to result screen with fade transition

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => ResultScreen(result: result)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLast = _currentIndex == widget.questions.length - 1;
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: _nextQuestion,
        backgroundColor: _answered
            ? AppTheme.primaryBlue
            : isLast
            ? AppTheme.primaryBlue.withAlpha(100)
            : AppTheme.primaryBlue.withAlpha(50),
        foregroundColor: Colors.white,
        child: Icon(isLast ? Icons.check : Icons.arrow_forward),
      ),
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: Column(
          spacing: 20,
          children: [
            Header(),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                ),
                child: Column(
                  children: [
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFFE8EDF8)),
                        boxShadow: [
                          BoxShadow(
                            color: AppTheme.primaryBlue.withOpacity(0.06),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: .start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 10,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F4FF),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '+${_currentQuestion.difficulty.points} pts',
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: AppTheme.primaryBlue,
                                    fontFamily: 'Nunito',
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 14),
                          Text(
                            'Q${_currentIndex + 1}. ${_currentQuestion.text}',
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: Color(0xFF0D1B2A),
                              fontFamily: 'Nunito',
                              height: 1.4,
                            ),
                          ),

                          // Answer options
                          ...List.generate(
                            _currentQuestion.options.length,
                            (i) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: AnswerButton(
                                label: _currentQuestion.options[i],
                                optionLetter: _letters[i],
                                state: _stateForOption(i),
                                onTap: () => _selectAnswer(i),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
