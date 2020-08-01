import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TextFormField2 extends StatelessWidget {
  const TextFormField2({
    Key key,
    @required this.title,
    @required this.hintText,
    @required this.errorText,
    @required this.maxLength,
    @required this.inputFormatter,
    @required this.onSaved,
    this.isPhoneNumber = false,
    this.initialValue,
  }) : super(key: key);

  final String title;
  final String initialValue;
  final String hintText;
  final String errorText;
  final int maxLength;
  final TextInputFormatter inputFormatter;
  final ValueChanged<String> onSaved;
  final bool isPhoneNumber;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 8,
          ),
          TextFormField(
            initialValue: initialValue,
            keyboardType:
                isPhoneNumber ? TextInputType.phone : TextInputType.text,
            inputFormatters: [inputFormatter],
            maxLength: maxLength,
            decoration: InputDecoration(
              hintText: hintText,
              counterText: '',
            ),
            onSaved: (value) => onSaved(value),
            onChanged: (value) => onSaved(value),
            validator: (value) => value.isEmpty ? errorText : null,
          ),
        ],
      ),
    );
  }
}
