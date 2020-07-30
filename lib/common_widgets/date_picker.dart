import 'dart:async';

import 'package:al_halaqat/common_widgets/format.dart';
import 'package:flutter/material.dart';
import 'package:al_halaqat/common_widgets/input_dropdown.dart';

class DatePicker extends StatelessWidget {
  const DatePicker({
    Key key,
    this.title,
    this.selectedDate,
    this.onSelectedDate,
  }) : super(key: key);

  final String title;
  final DateTime selectedDate;
  final ValueChanged<DateTime> onSelectedDate;

  Future<void> _selectDate(BuildContext context) async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(1900, 1),
      lastDate: DateTime(2100),
    );
    if (pickedDate != null && pickedDate != selectedDate) {
      onSelectedDate(pickedDate);
    }
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
            title,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          SizedBox(
            height: 8,
          ),
          InputDropdown(
            labelText: title,
            valueText: Format.date(selectedDate),
            valueStyle: valueStyle,
            onPressed: () => _selectDate(context),
          ),
        ],
      ),
    );
  }
}
