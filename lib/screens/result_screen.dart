import 'package:flutter/material.dart';
import 'package:quiz_buzz/models/result.dart';
import 'package:quiz_buzz/screens/home_screen.dart';

class ResultScreen extends StatefulWidget {
  final QuizResult result;
  const ResultScreen({super.key, required this.result});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> scaleAnimation;
  late Animation<double> opacityAnimation;

  String get _gradeMessage {
    switch (widget.result.grade) {
      case 'A+':
        return 'Excellent work! You have a strong grasp of the material.';
      case 'A-':
        return 'Great job! You have a good understanding of the content.';
      case 'A':
        return 'Well done! You have a good understanding of the material.';
      case 'B':
        return 'Good job! You have a solid understanding of the content.';
      case 'C':
        return 'Not bad! You have a basic understanding, but there\'s room for improvement.';
      case 'D':
        return 'Needs improvement. Consider reviewing the material and trying again.';
      default:
        return 'Don\'t be discouraged! Keep practicing and you\'ll get better with time.';
    }
  }

  IconData get _emoji {
    switch (widget.result.grade) {
      case 'A+':
        return Icons.emoji_events_rounded;
      case 'A-':
        return Icons.sentiment_very_satisfied_rounded;
      case 'A':
        return Icons.sentiment_satisfied_rounded;
      case 'B':
        return Icons.sentiment_satisfied_alt_rounded;
      case 'C':
        return Icons.sentiment_neutral_rounded;
      case 'D':
        return Icons.sentiment_dissatisfied_rounded;
      default:
        return Icons.sentiment_very_dissatisfied_rounded;
    }
  }

  @override
  void initState() {
    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );
    scaleAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );
    opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: animationController, curve: Interval(0.0, 0.5)),
    );
    _runAnimation();
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    // TODO: implement dispose
    super.dispose();
  }

  Future<void> _runAnimation() async {
    await Future.delayed(Duration(milliseconds: 200));
    await animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              AnimatedBuilder(
                animation: animationController,
                builder: (BuildContext context, Widget? child) {
                  return Opacity(
                    opacity: opacityAnimation.value,
                    child: Transform.scale(
                      scale: scaleAnimation.value,
                      child: Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: Icon(_emoji, size: 100, color: Colors.blue[800]),
                      ),
                    ),
                  );
                },
              ),

              SizedBox(height: 30),

              Text(
                'Congratulations!',
                style: TextTheme.of(context).headlineMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),

              SizedBox(height: 20),

              Text(
                'You scored ${widget.result.totalScore} out of ${widget.result.maxScore}!',
                style: TextTheme.of(
                  context,
                ).titleMedium?.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              Text(
                'You Grade ${widget.result.grade}!',
                style: TextTheme.of(context).displayMedium?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),

              SizedBox(height: 20),

              Container(
                padding: EdgeInsets.symmetric(horizontal: 50),
                child: Text(
                  _gradeMessage,
                  style: TextTheme.of(context).bodyMedium?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => HomeScreen()),
                  );
                },
                child: Icon(Icons.refresh_rounded, size: 30),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
