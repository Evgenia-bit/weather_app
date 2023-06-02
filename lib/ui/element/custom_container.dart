import 'package:flutter/material.dart';

//обертка для блоков с текущей погодой и спиской погоды за 3 дня
class ContentWrapper extends StatelessWidget {
  final Widget child;

  const ContentWrapper({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).dialogBackgroundColor,
        borderRadius: const BorderRadius.all(Radius.circular(14)),
      ),
      child: child,
    );
  }
}
