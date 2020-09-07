import 'package:al_halaqat/app/models/teacher.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/menu_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AdminReportsScreen extends StatefulWidget {
  @override
  _AdminReportsState createState() => _AdminReportsState();
}

class _AdminReportsState extends State<AdminReportsScreen> {
  @override
  initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context, listen: false);
    Teacher teacher;
    if (user is Teacher) teacher = user;
    return Scaffold(
        appBar: AppBar(
          title: Center(child: Text('تقارير')),
        ),
        body: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              SizedBox(height: 70.0),
              MenuButtonWidget(
                text: 'المركز',
                onPressed: () {},
              ),
              SizedBox(height: 10),
              MenuButtonWidget(
                text: 'حضور المعلمين',
                onPressed: () {},
              ),
              SizedBox(height: 10),
              MenuButtonWidget(
                text: 'حضور الطلاب',
                onPressed: () {},
              ),
              SizedBox(height: 10),
              MenuButtonWidget(
                text: 'حفظ الطلاب',
                onPressed: () {},
              ),
              SizedBox(height: 10),
              MenuButtonWidget(
                text: 'السجلات',
                onPressed: () {},
              ),
            ],
          ),
        ));
  }
}
