import 'package:al_halaqat/common_widgets/menu_button_widget.dart';
import 'package:flutter/material.dart';

class GlobalAdminHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: Text('')),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                SizedBox(height: 32.0),
                Container(
                    height: 100,
                    width: 100,
                    color: Colors.grey[300],
                    child: Center(
                        child: Text(
                      'logo',
                      style: TextStyle(fontSize: 40),
                    ))),
                SizedBox(height: 50.0),
                SizedBox(height: 10),
                MenuButtonWidget(
                  text: 'إدارة المدراء',
                  onPressed: () {},
                ),
                SizedBox(height: 10),
                MenuButtonWidget(
                  text: 'إداراة المدراء عاميين',
                  onPressed: () {},
                ),
                SizedBox(height: 10),
                MenuButtonWidget(
                  text: ' المراكز',
                  onPressed: () {},
                ),
                SizedBox(height: 10),
                MenuButtonWidget(
                  text: 'تقارير',
                  onPressed: () {},
                ),
                SizedBox(height: 10),
                MenuButtonWidget(
                  text: 'دعوات',
                  onPressed: () {},
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
