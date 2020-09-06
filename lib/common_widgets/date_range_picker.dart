import 'package:al_halaqat/common_widgets/format.dart';
import 'package:date_range_picker/date_range_picker.dart'
    as DateRangePickerPopUp;
import 'package:flutter/material.dart';

class DateRangePicker extends StatefulWidget {
  const DateRangePicker({
    Key key,
    @required this.firstDate,
    @required this.lastDate,
  }) : super(key: key);

  final ValueChanged<DateTime> firstDate;
  final ValueChanged<DateTime> lastDate;

  @override
  _DateRangePickerState createState() => _DateRangePickerState();
}

class _DateRangePickerState extends State<DateRangePicker> {
  List<DateTime> dateTimeRange;
  TextStyle textStyle;

  void save() {
    widget.firstDate(dateTimeRange[0]);

    widget.lastDate(dateTimeRange[0]);
  }

  @override
  void initState() {
    dateTimeRange = List(2);
    dateTimeRange[0] = DateTime.now().subtract(Duration(days: 7));
    dateTimeRange[1] = DateTime.now();
    textStyle = TextStyle(fontSize: 18);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        final List<DateTime> picked = await DateRangePickerPopUp.showDatePicker(
          context: context,
          initialFirstDate: dateTimeRange[0],
          initialLastDate: dateTimeRange[1],
          firstDate: DateTime(DateTime.now().year - 1),
          lastDate: DateTime.now(),
        );
        if (picked != null && picked.length == 2) {
          dateTimeRange[0] = picked[0];
          dateTimeRange[1] = picked[1];
          setState(() {});
        }
      },
      child: Column(
        children: [
          SizedBox(
            height: 65,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      Format.date(dateTimeRange[0]),
                      style: textStyle,
                    ),
                  ),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      Format.date(dateTimeRange[1]),
                      style: textStyle,
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey.shade700,
                ),
              ],
            ),
          ),
          Container(
            height: 2,
            color: Colors.grey[400],
          ),
        ],
      ),
    );
  }
}
