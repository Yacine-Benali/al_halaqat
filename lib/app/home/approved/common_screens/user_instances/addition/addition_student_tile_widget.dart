import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/student.dart';
import 'package:flutter/material.dart';

class AdditionStudentTileWidget extends StatefulWidget {
  AdditionStudentTileWidget({
    Key key,
    @required this.student,
    @required this.halaqa,
    @required this.onStudentSelected,
  }) : super(key: key);

  final Student student;
  final Halaqa halaqa;
  final ValueChanged<Student> onStudentSelected;

  @override
  _AdminStudentTileWidgetState createState() => _AdminStudentTileWidgetState();
}

class _AdminStudentTileWidgetState extends State<AdditionStudentTileWidget> {
  bool isSelected;

  @override
  void initState() {
    isSelected = widget.student.halaqatLearningIn.contains(widget.halaqa.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CheckboxListTile(
          title: Text(widget.student.name),
          subtitle: Text(widget.student.readableId),
          onChanged: (bool value) {
            isSelected = !isSelected;
            widget.onStudentSelected(widget.student);
            setState(() {});
          },
          value: isSelected,
        ),
        Divider(
          height: 0.5,
        )
      ],
    );
  }
}
