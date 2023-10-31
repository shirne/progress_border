import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:progress_border/progress_border.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ProbressBorder Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'ProbressBorder Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage>
    with SingleTickerProviderStateMixin {
  late final animationController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  );
  double borderWidth = 8;

  @override
  void initState() {
    super.initState();
    animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  void restart() {
    if (animationController.status == AnimationStatus.forward ||
        animationController.value >= 1) {
      animationController.reverse();
    } else {
      animationController.forward();
    }
  }

  Widget createSquare(
    double strokeAlign,
    String text, {
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Gradient? gradient,
    BoxShape shape = BoxShape.circle,
    BorderRadiusGeometry? borderRadius,
    bool clockwise = true,
  }) {
    return Container(
      width: 100,
      height: 100,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.blue.withAlpha(100),
        shape: shape,
        borderRadius: borderRadius,
        border: ProgressBorder.all(
          color: Colors.blue,
          width: borderWidth,
          progress: animationController.value,
          strokeAlign: strokeAlign,
          backgroundColor: backgroundColor,
          backgroundGradient: backgroundGradient,
          gradient: gradient,
          clockwise: clockwise,
        ),
      ),
      child: Text(text),
    );
  }

  Widget createRow({
    Color? backgroundColor,
    Gradient? backgroundGradient,
    Gradient? gradient,
    BoxShape shape = BoxShape.circle,
    BorderRadiusGeometry? borderRadius,
    bool clockwise = true,
  }) {
    return Row(
      children: [
        Expanded(
          child: Center(
            child: createSquare(
              BorderSide.strokeAlignInside,
              'Inside',
              backgroundColor: backgroundColor,
              backgroundGradient: backgroundGradient,
              gradient: gradient,
              shape: shape,
              borderRadius: borderRadius,
              clockwise: clockwise,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: createSquare(
              BorderSide.strokeAlignCenter,
              'Center',
              backgroundColor: backgroundColor,
              backgroundGradient: backgroundGradient,
              gradient: gradient,
              shape: shape,
              borderRadius: borderRadius,
              clockwise: clockwise,
            ),
          ),
        ),
        Expanded(
          child: Center(
            child: createSquare(
              BorderSide.strokeAlignOutside,
              'Outside',
              backgroundColor: backgroundColor,
              backgroundGradient: backgroundGradient,
              gradient: gradient,
              shape: shape,
              borderRadius: borderRadius,
              clockwise: clockwise,
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 8),
              child: Text('BoxShape.circle'),
            ),
            createRow(),
            const SizedBox(height: 20),
            createRow(
              gradient: SweepGradient(
                transform: const GradientRotation(-math.pi / 2 - 0.1),
                colors: [Colors.blue[200]!, Colors.blue],
              ),
              backgroundGradient: const SweepGradient(
                transform: GradientRotation(-math.pi / 2),
                colors: [Colors.black26, Colors.black87],
                stops: [0, 0.95],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 8),
              child: Text('BoxShape.rectangle(RRect)'),
            ),
            createRow(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16),
              clockwise: false,
            ),
            const SizedBox(height: 20),
            createRow(
              shape: BoxShape.rectangle,
              borderRadius: BorderRadius.circular(16),
              backgroundColor: Colors.black38,
              clockwise: false,
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 8),
              child: Text('BoxShape.rectangle(Rect)'),
            ),
            createRow(
              shape: BoxShape.rectangle,
            ),
            const SizedBox(height: 20),
            createRow(
              shape: BoxShape.rectangle,
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [Colors.blue[200]!, Colors.blue],
              ),
              backgroundGradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [Colors.black26, Colors.black54],
              ),
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 8),
              child: Text('Normal border'),
            ),
            Row(
              children: [
                Expanded(
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(100),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.blue,
                          width: borderWidth,
                        ),
                      ),
                      child: const Text('Inside with background'),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(100),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.blue,
                          width: borderWidth,
                          strokeAlign: BorderSide.strokeAlignCenter,
                        ),
                      ),
                      child: const Text('Center with background'),
                    ),
                  ),
                ),
                Expanded(
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: Colors.blue.withAlpha(100),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: Colors.blue,
                          width: borderWidth,
                          strokeAlign: BorderSide.strokeAlignOutside,
                        ),
                      ),
                      child: const Text('Outside with background'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: restart,
        tooltip: 'start',
        child: const Icon(Icons.refresh),
      ),
      bottomNavigationBar: BottomAppBar(
        height: kBottomNavigationBarHeight,
        child: Row(
          children: [
            const SizedBox(width: 16),
            const Text('BorderWidth:'),
            Expanded(
              child: Slider(
                value: borderWidth,
                min: 0.5,
                max: 50,
                onChanged: (v) {
                  setState(
                    () {
                      borderWidth = v;
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
