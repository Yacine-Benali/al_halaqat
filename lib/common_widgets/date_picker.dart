import 'dart:async';

import 'package:alhalaqat/common_widgets/input_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({
    Key key,
    @required this.labelText,
    @required this.selectedDate,
    @required this.onSelectedDate,
  }) : super(key: key);

  final String labelText;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelectedDate;

  static String date(DateTime date) {
    return DateFormat.yMMMd().format(date);
  }

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2019, 1),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      onSelectedDate(pickedDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final valueStyle = Theme.of(context).textTheme.bodyText1;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Expanded(
          flex: 5,
          child: InputDropdown(
            labelText: labelText,
            valueText: date(selectedDate),
            //valueStyle: valueStyle,
            onPressed: () => _selectDate(context),
          ),
        ),
      ],
    );
  }
}
