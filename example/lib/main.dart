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
      body: SingleChildScrollView(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 8),
              child: Text('BoxShape.circle'),
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
                        shape: BoxShape.circle,
                        border: ProgressBorder.all(
                          color: Colors.blue,
                          width: 8,
                          progress: animationController.value,
                        ),
                      ),
                      child: const Text('Inside'),
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
                        shape: BoxShape.circle,
                        border: ProgressBorder.all(
                          color: Colors.blue,
                          width: 8,
                          progress: animationController.value,
                          strokeAlign: BorderSide.strokeAlignCenter,
                        ),
                      ),
                      child: const Text('Center'),
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
                        shape: BoxShape.circle,
                        border: ProgressBorder.all(
                          color: Colors.blue,
                          width: 8,
                          progress: animationController.value,
                          strokeAlign: 0.5,
                        ),
                      ),
                      child: const Text('Half out(0.5)'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                        shape: BoxShape.circle,
                        border: ProgressBorder.all(
                          color: Colors.blue,
                          width: 8,
                          progress: animationController.value,
                          backgroundBorder: Border.all(
                            color: Colors.black38,
                            width: 8,
                          ),
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
                        shape: BoxShape.circle,
                        border: ProgressBorder.all(
                          color: Colors.blue,
                          width: 8,
                          progress: animationController.value,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          backgroundBorder: Border.all(
                            color: Colors.black38,
                            width: 8,
                            strokeAlign: BorderSide.strokeAlignCenter,
                          ),
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
                        shape: BoxShape.circle,
                        border: ProgressBorder.all(
                          color: Colors.blue,
                          width: 8,
                          progress: animationController.value,
                          strokeAlign: BorderSide.strokeAlignOutside,
                          backgroundBorder: Border.all(
                            color: Colors.black38,
                            width: 8,
                            strokeAlign: BorderSide.strokeAlignOutside,
                          ),
                        ),
                      ),
                      child: const Text('Outside with background'),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 8),
              child: Text('BoxShape.rectangle(RRect)'),
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
                        border: ProgressBorder.all(
                          color: Colors.blue,
                          width: 8,
                          progress: animationController.value,
                        ),
                      ),
                      child: const Text('Inside'),
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
                        border: ProgressBorder.all(
                          color: Colors.blue,
                          width: 8,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          progress: animationController.value,
                        ),
                      ),
                      child: const Text('Center'),
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
                        border: ProgressBorder.all(
                          color: Colors.blue,
                          width: 8,
                          strokeAlign: BorderSide.strokeAlignOutside,
                          progress: animationController.value,
                        ),
                      ),
                      child: const Text('Outside'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                        border: ProgressBorder.all(
                          color: Colors.blue,
                          width: 8,
                          progress: animationController.value,
                          backgroundBorder: Border.all(
                            color: Colors.black38,
                            width: 8,
                          ),
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
                        border: ProgressBorder.all(
                          color: Colors.blue,
                          width: 8,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          progress: animationController.value,
                          backgroundBorder: Border.all(
                            color: Colors.black38,
                            width: 8,
                            strokeAlign: BorderSide.strokeAlignCenter,
                          ),
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
                        border: ProgressBorder.all(
                          color: Colors.blue,
                          width: 8,
                          strokeAlign: BorderSide.strokeAlignOutside,
                          progress: animationController.value,
                          backgroundBorder: Border.all(
                              color: Colors.black38,
                              width: 8,
                              strokeAlign: BorderSide.strokeAlignOutside),
                        ),
                      ),
                      child: const Text('Outside with background'),
                    ),
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.only(top: 16, bottom: 8),
              child: Text('BoxShape.rectangle(Rect)'),
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
                        border: ProgressBorder.all(
                          color: Colors.blue,
                          width: 8,
                          progress: animationController.value,
                        ),
                      ),
                      child: const Text('Inside'),
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
                        border: ProgressBorder.all(
                          color: Colors.blue,
                          width: 8,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          progress: animationController.value,
                        ),
                      ),
                      child: const Text('Center'),
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
                        border: ProgressBorder.all(
                          color: Colors.blue,
                          width: 8,
                          strokeAlign: BorderSide.strokeAlignOutside,
                          progress: animationController.value,
                        ),
                      ),
                      child: const Text('Outside'),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
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
                        border: ProgressBorder.all(
                          color: Colors.blue,
                          width: 8,
                          progress: animationController.value,
                          backgroundColor: Colors.black38,
                        ),
                      ),
                      child: const Text('Inside'),
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
                        border: ProgressBorder.all(
                          color: Colors.blue,
                          width: 8,
                          strokeAlign: BorderSide.strokeAlignCenter,
                          progress: animationController.value,
                          backgroundColor: Colors.black38,
                        ),
                      ),
                      child: const Text('Center'),
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
                        border: ProgressBorder.all(
                          color: Colors.blue,
                          width: 8,
                          strokeAlign: BorderSide.strokeAlignOutside,
                          progress: animationController.value,
                          backgroundColor: Colors.black38,
                        ),
                      ),
                      child: const Text('Outside'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: restart,
        tooltip: 'start',
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
