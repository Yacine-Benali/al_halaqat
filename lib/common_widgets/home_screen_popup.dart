import 'package:flutter/material.dart';

import 'platform_alert_dialog.dart';

class HomeScreenPopUp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<int>(
        itemBuilder: (BuildContext context) => [
              PopupMenuItem<int>(
                value: 1,
                child: Text("حول التطبيق"),
              ),
              PopupMenuItem<int>(
                value: 2,
                child: Text("اتصل بنا"),
              ),
            ],
        onSelected: (value) {
          if (value == 1)
            PlatformAlertDialog(
              content:
                  'هذا البرنامج صدقة عن روح المرحومة وفاء خليل صديق نرجو  لها الدعاء\n الإصدار 1.0.3 ',
              defaultActionText: 'حسنا',
              title: 'حول التطبيق',
            ).show(context);
          else
            PlatformAlertDialog(
              content:
                  "للاستفسارات والملاحظات يرجى التواصل عبر الإيميل على العنوان Alhalaqatt@gmail.com",
              defaultActionText: 'حسنا',
              title: 'اتصل بنا',
            ).show(context);
        });
  }
}
