import 'package:flutter/material.dart';
import 'package:quiz_buzz/screens/home_screen.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoAnimationController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoOpacityAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _logoAnimationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 800),
    );

    _logoScaleAnimation = Tween(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _logoOpacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _logoAnimationController,
        curve: Interval(0.0, 0.5),
      ),
    );

    _runAnimation();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _logoAnimationController.dispose();
    super.dispose();
  }

  Future<void> _runAnimation() async {
    await Future.delayed(Duration(microseconds: 200));
    await _logoAnimationController.forward();

    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          transitionDuration: Duration(milliseconds: 500),
          pageBuilder: (context, animation, secondaryAnimation) =>
              const HomeScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: SafeArea(
        child: Center(
          child: Column(
            spacing: 50,
            mainAxisAlignment: .center,
            crossAxisAlignment: .center,
            children: [
              AnimatedBuilder(
                animation: _logoAnimationController,
                builder: (BuildContext context, Widget? child) {
                  return Opacity(
                    opacity: _logoOpacityAnimation.value,
                    child: Transform.scale(
                      scale: _logoScaleAnimation.value,
                      child: Container(
                        height: 300,
                        width: 300,
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.circular(40),
                        ),
                        child: Icon(
                          Icons.quiz_rounded,
                          size: 300,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),

              Column(
                children: [
                  Text(
                    'Quiz Master',
                    style: TextTheme.of(context).headlineLarge,
                  ),
                  Text(
                    "Test Your Flutter Knowledge with Quiz Master!",

                    style: TextTheme.of(context).titleMedium,
                  ),
                ],
              ),

              Row(
                mainAxisAlignment: .center,
                children: List.generate(
                  3,
                  (index) => Container(
                    margin: const EdgeInsets.symmetric(
                      horizontal: 4,
                      vertical: 20,
                    ),
                    width: 25,
                    height: 25,
                    decoration: BoxDecoration(
                      color: Colors.white.withAlpha(234),
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
