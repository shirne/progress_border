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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(100),
                  shape: BoxShape.circle,
                  border: ProgressBorder.all(
                    color: Colors.blue,
                    width: 8,
                    progress: animationController.value,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(100),
                  borderRadius: BorderRadius.circular(16),
                  border: ProgressBorder.all(
                    color: Colors.blue,
                    width: 8,
                    progress: animationController.value,
                    backgroundBorder: Border.all(
                      color: Colors.grey[350]!,
                      width: 8,
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(100),
                  border: ProgressBorder.all(
                    color: Colors.blue,
                    width: 8,
                    progress: animationController.value,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: Colors.blue.withAlpha(100),
                  border: ProgressBorder.all(
                    color: Colors.blue,
                    width: 8,
                    strokeAlign: StrokeAlign.outside,
                    progress: animationController.value,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: restart,
        tooltip: 'start',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
