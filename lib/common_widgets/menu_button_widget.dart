import 'package:al_halaqat/common_widgets/custom_raised_button.dart';
import 'package:flutter/material.dart';

class MenuButtonWidget extends CustomRaisedButton {
  MenuButtonWidget({
    Key key,
    @required String text,
    @required VoidCallback onPressed,
  }) : super(
          color: Colors.indigo,
          onPressed: onPressed,
          key: key,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  letterSpacing: .3,
                  wordSpacing: -.5,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        );
}
