import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:share/share.dart';

class PlatformReportDialog extends PlatformWidget {
  PlatformReportDialog({@required this.filePath}) : assert(filePath != null);

  final String filePath;

  Future<bool> show(BuildContext context) async {
    return
        // Platform.isIOS
        //     ? await showCupertinoDialog<bool>(
        //         context: context,
        //         builder: (context) => this,
        //       )
        //     :
        await showDialog<bool>(
      context: context,
      barrierDismissible: true,
      builder: (context) => this,
    );
  }

  @override
  Widget buildCupertinoWidget(BuildContext context) {
    return CupertinoAlertDialog(
      title: Text('title'),
      content: Text('content'),
      actions: [Text('')],
    );
  }

  @override
  Widget buildMaterialWidget(BuildContext context) {
    return AlertDialog(
      title: Text('نجح الحفظ'),
      contentPadding: const EdgeInsets.all(16.0),
      content: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text('نجح الحفظ'),
          Text(filePath),
        ],
      ),
      actions: _buildActions(context),
    );
  }

  List<Widget> _buildActions(BuildContext context) {
    return <Widget>[
      FlatButton(
        child: const Text('إلغاء'),
        onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
      ),
      FlatButton(
          child: const Text('فتح الملف'),
          onPressed: () async {
            OpenResult b = await OpenFile.open(filePath);
            if (b.type == ResultType.noAppToOpen)
              PlatformExceptionAlertDialog(
                title: 'فشلت العملية',
                exception: PlatformException(
                  code: 'excel is required',
                  message: 'يرجى تحميل إكسل',
                ),
              ).show(context);
          }),
      FlatButton(
        child: const Text('مشاركة الملف'),
        onPressed: () => Share.shareFiles([filePath], text: 'report'),
      ),
    ];
  }
}
