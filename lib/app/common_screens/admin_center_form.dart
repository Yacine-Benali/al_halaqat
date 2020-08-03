import 'package:al_halaqat/app/home/models/admin.dart';
import 'package:al_halaqat/app/home/models/study_center.dart';
import 'package:flutter/material.dart';

class AdminCenterForm extends StatefulWidget {
  @override
  _AdminCenterFormState createState() => _AdminCenterFormState();
}

class _AdminCenterFormState extends State<AdminCenterForm> {
  Admin admin;
  StudyCenter center;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text('fill info'),
          actions: <Widget>[
            Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: InkWell(
                onTap: () => {},
                child: Icon(
                  Icons.save,
                  size: 26.0,
                ),
              ),
            ),
          ],
        ),
        body: Column(
          children: <Widget>[
            Container(),
          ],
        ));
  }
}
