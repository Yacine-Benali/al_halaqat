import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/common_widgets/center_state_tile.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class CenterStateForm extends StatefulWidget {
  const CenterStateForm({
    Key key,
    @required this.centersList,
    @required this.statesList,
    @required this.centerState,
    @required this.onSavedCenterStates,
    @required this.onSavedCentersIds,
    @required this.isEnabled,
  }) : super(key: key);

  final List<StudyCenter> centersList;
  final List<String> statesList;
  final Map<String, String> centerState;
  final ValueChanged<Map<String, String>> onSavedCenterStates;
  final ValueChanged<List<String>> onSavedCentersIds;
  final bool isEnabled;

  @override
  _CenterStateFormState createState() => _CenterStateFormState();
}

class _CenterStateFormState extends State<CenterStateForm> {
  Map<String, String> newCenterState;
  List<Widget> rows;
  @override
  void initState() {
    rows = List();
    newCenterState = Map();
    newCenterState.addAll(widget.centerState);
    if (newCenterState == null) {
      newCenterState = Map();
    }

    save();
    _buildDefaultRows();
    super.initState();
  }

  void onTileSaved(
      Tuple2<MapEntry<StudyCenter, String>, MapEntry<StudyCenter, String>>
          changeResult) {
    MapEntry<StudyCenter, String> oldValue = changeResult.item1;
    MapEntry<StudyCenter, String> newValue = changeResult.item2;
    Map<String, String> temp = Map();
    bool isFound = false;

    newCenterState.forEach((key, value) {
      if (key == oldValue?.key?.id && value == oldValue?.value) {
        temp[newValue.key.id] = newValue.value;
        isFound = true;
      } else {
        temp[key] = value;
      }
    });
    if (!isFound && newValue.key != null) {
      temp[newValue.key.id] = newValue?.value;
    }

    newCenterState = temp;
    print(newCenterState);

    save();
  }

  void save() {
    widget.onSavedCenterStates(newCenterState);
    widget.onSavedCentersIds(newCenterState.keys.toList());
  }

  void _buildDefaultRows() async {
    rows.clear();
    setState(() {});
    await Future.delayed(Duration(milliseconds: 60));
    newCenterState.forEach((key, value) {
      StudyCenter defaultCenter = widget.centersList
          .firstWhere((center) => center.id == key, orElse: () => null);

      if (defaultCenter != null) {
        Widget temp = Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: CenterStateTile(
            centersList: widget.centersList,
            statesList: widget.statesList,
            defaultCenter: defaultCenter,
            defaultState: value,
            onSaved: onTileSaved,
            onRemove: removeRow,
            isEnabled: widget.isEnabled,
          ),
        );
        rows.add(temp);
      } else {}
    });
    setState(() {});
  }

  void addRow() {
    MapEntry<String, String> lastEntry = MapEntry(
      widget.centersList.first.id,
      widget.statesList.first,
    );
    StudyCenter defaultCenter = widget.centersList
        .firstWhere((center) => center.id == lastEntry.key, orElse: () => null);
    if (defaultCenter != null) {
      Widget temp = Padding(
        padding: const EdgeInsets.only(top: 8, bottom: 8),
        child: CenterStateTile(
          centersList: widget.centersList,
          statesList: widget.statesList,
          defaultCenter: null,
          defaultState: null,
          isEnabled: widget.isEnabled,
          onSaved: onTileSaved,
          onRemove: removeRow,
        ),
      );
      rows.add(temp);
    } else {}

    setState(() {});
  }

  void removeRow(MapEntry<StudyCenter, String> mapEntryToRemove) {
    Map<String, String> temp = Map();

    newCenterState.forEach((key, value) {
      if (key == mapEntryToRemove?.key?.id && value == mapEntryToRemove.value) {
      } else
        temp[key] = value;
    });
    newCenterState = temp;

    _buildDefaultRows();
    save();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: <Widget>[
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              'مراكز',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Column(
            children: rows,
          ),
          widget.isEnabled
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      alignment: Alignment.centerLeft,
                      padding: const EdgeInsets.fromLTRB(0, 16, 8, 8),
                      child: FloatingActionButton(
                        mini: true,
                        onPressed: () => addRow(),
                        child: Icon(Icons.add),
                      ),
                    ),
                  ],
                )
              : Container(),
        ],
      ),
    );
  }
}
