import 'package:flutter/material.dart';

class DropdownButtonFormField2 extends StatelessWidget {
  const DropdownButtonFormField2({
    Key key,
    @required this.value,
    @required this.possibleValues,
    @required this.title,
    @required this.onSaved,
    @required this.isEnabled,
  }) : super(key: key);
  final String title;
  final List<String> possibleValues;
  final String value;
  final bool isEnabled;
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
            decoration: InputDecoration(
              enabledBorder: isEnabled
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: isEnabled ? 2.5 : 1.2,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    )
                  : UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
            ),
            itemHeight: 70,
            disabledHint: Text(
              value ?? possibleValues[0],
              style: TextStyle(color: Colors.black),
            ),
            value: value ?? possibleValues[0],
            isExpanded: true,
            icon: isEnabled ? Icon(Icons.arrow_drop_down) : Container(),
            iconSize: 24,
            onSaved: (value) => onSaved(value),
            onChanged: isEnabled ? (d) {} : null,
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
