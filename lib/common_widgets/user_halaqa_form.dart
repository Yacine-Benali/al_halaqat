import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/common_widgets/user_halaqa_tile.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class UserHalaqaForm extends StatefulWidget {
  const UserHalaqaForm({
    Key key,
    @required this.halaqatList,
    @required this.onSaved,
    @required this.currentHalaqatIdsList,
    @required this.title,
    this.isRemovable = true,
    @required this.isEnabled,
  }) : super(key: key);

  final List<Halaqa> halaqatList;
  final List<String> currentHalaqatIdsList;
  final ValueChanged<List<String>> onSaved;
  final String title;
  final bool isRemovable;
  final bool isEnabled;

  @override
  _UserHalaqaFormState createState() => _UserHalaqaFormState();
}

class _UserHalaqaFormState extends State<UserHalaqaForm> {
  List<String> halaqatIdsList;
  List<Widget> rows;
  @override
  void initState() {
    rows = List();
    halaqatIdsList = List();
    halaqatIdsList.addAll(widget.currentHalaqatIdsList);
    _buildDefaultRows();
    super.initState();
  }

  void onSaved(Tuple2<Halaqa, Halaqa> changeResult) {
    Halaqa oldHalaqa = changeResult.item1;
    Halaqa newHalaqa = changeResult.item2;
    List<String> temp = List();
    bool isFound = false;
    for (String halaqaId in halaqatIdsList) {
      if (halaqaId == oldHalaqa?.id) {
        temp.add(newHalaqa.id);
        isFound = true;
      } else {
        temp.add(halaqaId);
      }
    }
    if (!isFound && !halaqatIdsList.contains(newHalaqa.id)) {
      temp.add(newHalaqa.id);
    }

    halaqatIdsList.clear();
    halaqatIdsList.addAll(temp);

    save();
  }

  void save() {
    widget.onSaved(halaqatIdsList);
  }

  void _buildDefaultRows() async {
    rows.clear();
    setState(() {});
    await Future.delayed(Duration(milliseconds: 60));
    halaqatIdsList.forEach((String halaqaId) {
      Halaqa defaultHalaqa = widget.halaqatList
          .firstWhere((halaqa) => halaqa.id == halaqaId, orElse: () => null);

      if (defaultHalaqa != null) {
        Widget temp = Padding(
          padding: const EdgeInsets.only(top: 8, bottom: 8),
          child: UserHalaqaTile(
            isRemovable: widget.isRemovable,
            halaqatList: widget.halaqatList,
            defaultHalaqa: defaultHalaqa,
            onSaved: (Tuple2<Halaqa, Halaqa> value) => onSaved(value),
            onRemove: (Halaqa value) => removeRow(value),
            isEnabled: widget.isEnabled,
          ),
        );
        rows.add(temp);
      } else {
        //print('could not find center for this id $key');
      }
    });
    setState(() {});
  }

  void addRow() {
    Widget temp = Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 8),
      child: UserHalaqaTile(
        isRemovable: widget.isRemovable,
        halaqatList: widget.halaqatList,
        defaultHalaqa: null,
        onSaved: (Tuple2<Halaqa, Halaqa> value) => onSaved(value),
        onRemove: (Halaqa value) => removeRow(value),
        isEnabled: widget.isEnabled,
      ),
    );
    rows.add(temp);

    setState(() {});
  }

  void removeRow(Halaqa halaqaToRemove) {
    List<String> temp = List();
    bool isRemoved = false;
    halaqatIdsList.forEach((String halaqaId) {
      if (halaqaId == halaqaToRemove.id && !isRemoved) {
        isRemoved = true;
      } else
        temp.add(halaqaId);
    });
    halaqatIdsList.clear();
    halaqatIdsList.addAll(temp);

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
              widget.title,
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
