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
  List<String> centerNames;
  @override
  initState() {
    chosenCenter = widget.centers[0];
    widget.onChanged(chosenCenter);
    centerNames = widget.centers.map((e) => e.name).toList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Widget normalChildButton = SizedBox(
      width: 130,
      child: Container(
        color: Colors.indigo,
        height: 40,
        padding: const EdgeInsets.all(8),
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
              width: 20,
              height: 20,
              child: FittedBox(
                fit: BoxFit.fill,
                child: Icon(
                  Icons.arrow_drop_down,
                  color: Colors.white,
                  size: 50,
                ),
              ),
            ),
          ],
        ),
      ),
    );

    return MenuButton<String>(
      child: normalChildButton,
      items: centerNames,
      topDivider: true,
      crossTheEdge: true,
      edgeMargin: 12,
      itemBuilder: (String value) {
        if (value != chosenCenter.name) {
          return Container(
            color: Colors.indigo,
            height: 40,
            padding: const EdgeInsets.all(8),
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
      decoration: BoxDecoration(),
      toggledChild: normalChildButton,
      divider: Container(
        height: 0,
        color: Colors.white,
      ),
      onItemSelected: (String value) {
        chosenCenter =
            widget.centers.firstWhere((element) => element.name == value);
        setState(() {});
        widget.onChanged(chosenCenter);
      },
      onMenuButtonToggle: (bool isToggle) {
        print(isToggle);
      },
    );
  }
}
