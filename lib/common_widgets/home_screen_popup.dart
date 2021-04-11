import 'package:alhalaqat/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:update_available/update_available.dart';

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
              PopupMenuItem<int>(
                value: 3,
                child: Text("فحص التحديثات"),
              ),
              PopupMenuItem<int>(
                value: 4,
                child: Text(
                  " الإصدار ${Strings.appVersion}",
                ),
              ),
            ],
        onSelected: (value) {
          if (value == 1)
            PlatformAlertDialog(
              content:
                  """هذا البرنامج صدقة عن روح المرحومة وفاء خليل صديق نرجو  لها الدعاء
                  """,
              defaultActionText: 'حسنا',
              title: 'حول التطبيق',
            ).show(context);
          else if (value == 2) {
            PlatformAlertDialog(
              content:
                  "للاستفسارات والملاحظات يرجى التواصل عبر الإيميل على العنوان Alhalaqatt@gmail.com" +
                      "\nأو عبر الفيسبوك على صفحتنا: facebook.com/alhalaqatapp  \n",
              defaultActionText: 'حسنا',
              title: 'اتصل بنا',
            ).show(context);
          } else if (value == 3) {
            getUpdateAvailability().then((value) {
              final text = value.fold(
                available: () => ".هناك تحديث جديد، قم بالتحديث ",
                notAvailable: () => '.لا تحديث جديد، لديك آخر إصدار',
                unknown: () =>
                    ".لم نتمكن من التأكد من وجود تحديثات، يرجى المحاولة لاحقاً",
              );
              PlatformAlertDialog(
                content: text,
                defaultActionText: 'حسنا',
                title: 'فحص التحديثات',
              ).show(context);
            });
          }
        });
  }
}
