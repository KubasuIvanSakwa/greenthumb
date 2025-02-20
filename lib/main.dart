import 'package:flutter/material.dart';
import 'package:greenthumb/pages/home_page.dart';
import 'package:showcaseview/showcaseview.dart';
import 'package:toastification/toastification.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ToastificationWrapper(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const StartWidget(), // ✅ Wraps `ShowCaseWidget` inside a separate widget
      ),
    );
  }
}

class StartWidget extends StatelessWidget {
  const StartWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return ShowCaseWidget(
      builder: (context) => const HomePage(), // ✅ This is now correct
    );
  }
}
