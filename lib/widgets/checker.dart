import 'package:flutter/material.dart';

class Checker extends StatelessWidget {
  const Checker({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Container(
    width: 70,
    height: 70,
    padding: const EdgeInsets.all(10),
    child: Image.asset('images/checker.png', width: 50, height: 50,),
  );
}