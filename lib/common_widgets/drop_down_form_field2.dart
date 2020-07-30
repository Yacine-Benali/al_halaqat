import 'package:flutter/material.dart';

class DropdownButtonFormField2 extends StatelessWidget {
  const DropdownButtonFormField2({
    Key key,
    @required this.value,
    @required this.possibleValues,
    @required this.title,
    @required this.onSaved,
  }) : super(key: key);
  @required
  final String value;
  final List<String> possibleValues;
  final String title;
  // final String hintText;
  // final String errorText;
  // final int maxLength;
  // final TextInputFormatter inputFormatter;
  final ValueChanged<String> onSaved;

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
          DropdownButtonFormField<String>(
            itemHeight: 70,
            value: value ?? possibleValues[0],
            isExpanded: true,
            icon: Icon(Icons.arrow_drop_down),
            iconSize: 24,
            onSaved: (value) => onSaved(value),
            onChanged: (String newValue) {},
            items: possibleValues.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
