import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:tuple/tuple.dart';

class UserHalaqaTile extends StatefulWidget {
  const UserHalaqaTile({
    Key key,
    @required this.halaqatList,
    @required this.defaultHalaqa,
    @required this.onSaved,
    @required this.onRemove,
    @required this.isRemovable,
  }) : super(key: key);

  final List<Halaqa> halaqatList;
  final Halaqa defaultHalaqa;
  final ValueChanged<Tuple2<Halaqa, Halaqa>> onSaved;
  final ValueChanged<Halaqa> onRemove;
  final bool isRemovable;

  @override
  _UserHalaqaTileState createState() => _UserHalaqaTileState();
}

class _UserHalaqaTileState extends State<UserHalaqaTile> {
  Halaqa chosenHalaqa;
  String chosenState;

  @override
  void initState() {
    chosenHalaqa = widget.defaultHalaqa;

    super.initState();
  }

  void onSaved(Halaqa value) {
    widget.onSaved(Tuple2<Halaqa, Halaqa>(chosenHalaqa, value));
    chosenHalaqa = value;
    setState(() {});
  }

  void onRemoved() {
    widget.onRemove(chosenHalaqa);
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          flex: 3,
          child: DropdownButton<Halaqa>(
            isExpanded: true,
            underline: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.grey,
                  width: 0.5,
                ),
              ),
            ),
            value: chosenHalaqa,
            hint: Text('إختر حلقة'),
            icon: Icon(Icons.arrow_drop_down, color: Colors.indigo),
            iconSize: 24,
            elevation: 0,
            style: TextStyle(color: Colors.black, fontSize: 20),
            onChanged: (Halaqa newValue) {
              onSaved(newValue);
            },
            items: widget.halaqatList
                .map<DropdownMenuItem<Halaqa>>((Halaqa value) {
              return DropdownMenuItem<Halaqa>(
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
        SizedBox(
          width: 10,
        ),
        widget.isRemovable
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
