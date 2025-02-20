import 'package:flutter/material.dart';
import 'package:showcaseview/showcaseview.dart';

class ShowCaseView extends StatelessWidget {
  const ShowCaseView({super.key,
      required this.globalKey,
      required this.title,
      required this.desc,
      required this.child,
      this.shapeBorder = const CircleBorder()});


  final GlobalKey globalKey;
  final String title;
  final String desc;
  final Widget child;
  final ShapeBorder shapeBorder;

  @override
  Widget build(BuildContext context) {
    return Showcase(
        key: globalKey,
        title: title,
        description: desc,
        child: child
    );
  }
}
