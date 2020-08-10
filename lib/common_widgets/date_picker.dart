import 'dart:async';

import 'package:al_halaqat/common_widgets/format.dart';
import 'package:flutter/material.dart';
import 'package:al_halaqat/common_widgets/input_dropdown.dart';

class DatePicker extends StatefulWidget {
  const DatePicker({
    Key key,
    @required this.title,
    @required this.onSelectedDate,
    @required this.isEnabled,
  }) : super(key: key);

  final String title;
  final ValueChanged<int> onSelectedDate;
  final bool isEnabled;

  @override
  _DatePickerState createState() => _DatePickerState();
}

class _DatePickerState extends State<DatePicker> {
  List<int> possibleValues;
  int from;
  int to;
  int value;

  @override
  void initState() {
    from = 1950;
    to = DateTime.now().year;
    possibleValues = List();
    for (int i = 1950; i <= to; i++) possibleValues.add(i);

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.title;

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 8,
          ),
          DropdownButtonFormField<int>(
            decoration: InputDecoration(
              enabledBorder: widget.isEnabled
                  ? UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: widget.isEnabled ? 2.5 : 1.2,
                      ),
                      borderRadius: BorderRadius.circular(10.0),
                    )
                  : UnderlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey),
                      borderRadius: BorderRadius.circular(10.0),
                    ),
            ),
            itemHeight: 70,
            value: value ?? possibleValues[0],
            isExpanded: true,
            icon: widget.isEnabled ? Icon(Icons.arrow_drop_down) : Container(),
            iconSize: 24,
            onSaved: (value) => widget.onSelectedDate(value),
            onChanged: (int newValue) {},
            items: possibleValues.map<DropdownMenuItem<int>>((int value) {
              return DropdownMenuItem<int>(
                value: value,
                child: Text('$value'),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}
