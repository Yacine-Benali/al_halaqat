import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      width: 150,
      child: Center(
        child: Image.asset('assets/logo.png'),
      ),
    );
  }
}
