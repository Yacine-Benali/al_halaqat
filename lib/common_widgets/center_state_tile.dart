import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/constants/key_translate.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class CenterStateTile extends StatefulWidget {
  const CenterStateTile({
    Key key,
    @required this.centersList,
    @required this.statesList,
    @required this.defaultCenter,
    @required this.defaultState,
    @required this.onSaved,
    @required this.onRemove,
    @required this.isEnabled,
  }) : super(key: key);

  final List<StudyCenter> centersList;
  final List<String> statesList;
  final StudyCenter defaultCenter;
  final String defaultState;
  final bool isEnabled;
  final ValueChanged<
          Tuple2<MapEntry<StudyCenter, String>, MapEntry<StudyCenter, String>>>
      onSaved;
  final ValueChanged<MapEntry<StudyCenter, String>> onRemove;

  @override
  _CenterStateTileState createState() => _CenterStateTileState();
}

class _CenterStateTileState extends State<CenterStateTile> {
  StudyCenter chosenCenter;
  String chosenState;

  @override
  void initState() {
    chosenCenter = widget.defaultCenter;
    chosenState = widget.defaultState;
    chosenState = chosenState ?? widget.statesList[0];

    super.initState();
  }

  void onSaved(dynamic updatedValue, bool isCenters) {
    if (isCenters == true) {
      final result =
          Tuple2<MapEntry<StudyCenter, String>, MapEntry<StudyCenter, String>>(
        MapEntry(chosenCenter, chosenState),
        MapEntry(updatedValue, chosenState),
      );

      chosenCenter = updatedValue;
      setState(() {});

      widget.onSaved(result);
    } else {
      final result =
          Tuple2<MapEntry<StudyCenter, String>, MapEntry<StudyCenter, String>>(
              MapEntry(chosenCenter, chosenState),
              MapEntry(chosenCenter, updatedValue));
      chosenState = updatedValue;
      setState(() {});

      widget.onSaved(result);
    }
  }

  void onRemoved() {
    widget.onRemove(MapEntry(chosenCenter, chosenState));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: IgnorePointer(
            ignoring: !widget.isEnabled,
            child: DropdownButton<StudyCenter>(
              isExpanded: true,
              underline: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              value: chosenCenter,
              hint: Text('إختر مركز'),
              icon: Icon(Icons.arrow_drop_down, color: Colors.indigo),
              iconSize: 24,
              elevation: 0,
              style: TextStyle(color: Colors.black, fontSize: 20),
              onChanged: (StudyCenter newValue) {
                onSaved(newValue, true);
              },
              items: widget.centersList
                  .map<DropdownMenuItem<StudyCenter>>((StudyCenter value) {
                return DropdownMenuItem<StudyCenter>(
                  value: value,
                  child: AutoSizeText(
                    value.name,
                    minFontSize: 16,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        SizedBox(
          width: 10,
        ),
        Expanded(
          flex: 1,
          child: IgnorePointer(
            ignoring: !widget.isEnabled,
            child: DropdownButton<String>(
              underline: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.grey,
                    width: 0.5,
                  ),
                ),
              ),
              isExpanded: true,
              value: chosenState ?? widget.statesList[0],
              icon: Icon(Icons.arrow_drop_down, color: Colors.indigo),
              iconSize: 24,
              elevation: 0,
              style: TextStyle(color: Colors.black, fontSize: 20),
              onChanged: (String newValue) {
                onSaved(newValue, false);
              },
              items: widget.statesList
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: AutoSizeText(
                    KeyTranslate.userStateList[value],
                    minFontSize: 16,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        widget.isEnabled
            ? Container(
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.fromLTRB(0, 16, 8, 8),
                child: FloatingActionButton(
                  mini: true,
                  onPressed: () => onRemoved(),
                  child: Icon(Icons.remove),
                ),
              )
            : Container(),
      ],
    );
  }
}
