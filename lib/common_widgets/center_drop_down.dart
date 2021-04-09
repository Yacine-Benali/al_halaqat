import 'dart:ui';

import 'package:alhalaqat/app/models/study_center.dart';
import 'package:flutter/material.dart';
import 'package:menu_button/menu_button.dart';

class CenterDropDown extends StatefulWidget {
  const CenterDropDown(
      {Key key, @required this.centers, @required this.onChanged})
      : super(key: key);
  final List<StudyCenter> centers;
  final ValueChanged<StudyCenter> onChanged;

  @override
  _CenterDropDownState createState() => _CenterDropDownState();
}

class _CenterDropDownState extends State<CenterDropDown> {
  StudyCenter chosenCenter;
  @override
  initState() {
    chosenCenter = widget.centers[0];
    widget.onChanged(chosenCenter);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget normalChildButton = SizedBox(
      width: 130,
      child: Container(
        color: Colors.indigo,
        height: 40,
        padding: const EdgeInsets.only(left: 16, right: 11),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Flexible(
              child: Text(
                chosenCenter.name,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(
              width: 12,
              height: 17,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return MenuButton<String>(
      child: normalChildButton,
      items: widget.centers.map((e) => e.name).toList(),
      topDivider: true,
      crossTheEdge: true,
      edgeMargin: 12,
      itemBuilder: (String value) {
        if (value != chosenCenter.name) {
          return Container(
            color: Colors.indigo,
            height: 40,
            padding: const EdgeInsets.symmetric(vertical: 0.0, horizontal: 16),
            child: Text(
              value,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(color: Colors.white),
            ),
          );
        } else {
          return Container();
        }
      },
      toggledChild: Container(
        child: normalChildButton,
      ),
      divider: Container(
        height: 1,
        color: Colors.grey,
      ),
      onItemSelected: (String value) {
        setState(() {
          chosenCenter =
              widget.centers.firstWhere((element) => element.name == value);
        });
        widget.onChanged(chosenCenter);
      },
      onMenuButtonToggle: (bool isToggle) {
        print(isToggle);
      },
    );
  }
}
