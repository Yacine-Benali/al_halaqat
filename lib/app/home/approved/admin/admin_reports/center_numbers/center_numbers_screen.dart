import 'package:al_halaqat/app/home/approved/admin/admin_reports/center_numbers/center_numbers_bloc.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_reports/center_numbers/center_numbers_card.dart';
import 'package:al_halaqat/app/home/approved/admin/admin_reports/center_numbers/center_numbers_provider.dart';
import 'package:al_halaqat/app/models/center_numbers.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class CenterNumbersScreen extends StatefulWidget {
  CenterNumbersScreen._({Key key, this.bloc}) : super(key: key);

  final CenterNumbersBloc bloc;

  static Widget create({
    @required BuildContext context,
    @required StudyCenter center,
  }) {
    Database database = Provider.of<Database>(context, listen: false);

    CenterNumbersProvider provider = CenterNumbersProvider(database: database);
    CenterNumbersBloc bloc = CenterNumbersBloc(
      provider: provider,
      center: center,
    );
    return CenterNumbersScreen._(
      bloc: bloc,
    );
  }

  @override
  _CenterNumbersScreenState createState() => _CenterNumbersScreenState();
}

class _CenterNumbersScreenState extends State<CenterNumbersScreen> {
  CenterNumbersBloc get bloc => widget.bloc;
  ProgressDialog pr;
  Future<CenterNumbers> centerNumbersFuture;
  CenterNumbers centerNumbers;
  bool showArchived;

  @override
  void initState() {
    showArchived = false;
    centerNumbersFuture = bloc.fetchCenterNumbers();
    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      textDirection: TextDirection.ltr,
      isDismissible: false,
    );
    pr.style(
      message: 'جاري تحميل',
      messageTextStyle: TextStyle(fontSize: 14),
      progressWidget: Container(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
    );
    super.initState();
  }

  Future<void> downloadReport() async {
    try {
      final isPermissionStatusGranted = await _requestPermissions();

      if (isPermissionStatusGranted) {
        await pr.show();
        String filePath =
            await bloc.getReportasCsv(showArchived, centerNumbers);
        await pr.hide();
        bool isConfirm = await showDialog<bool>(
          context: context,
          child: AlertDialog(
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
            actions: <Widget>[
              FlatButton(
                child: const Text('إلغاء'),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(false),
              ),
              FlatButton(
                child: const Text('فتح الملف'),
                onPressed: () =>
                    Navigator.of(context, rootNavigator: true).pop(true),
              ),
            ],
          ),
        );
        if (isConfirm) {
          OpenResult b = await OpenFile.open(filePath);
          print(b.type);
          if (b.type == ResultType.noAppToOpen)
            PlatformExceptionAlertDialog(
              title: 'فشلت العملية',
              exception: PlatformException(
                code: 'excel is required',
                message: 'يرجى تحميل إكسل',
              ),
            ).show(context);
        }
      } else {
        throw PlatformException(
          code: 'storage permission are required',
          message: 'storage permission are required',
        );
      }
    } on Exception catch (e) {
      await pr.hide();
      if (e is PlatformException)
        PlatformExceptionAlertDialog(
          title: 'فشلت العملية',
          exception: e,
        ).show(context);
    }
  }

  Future<bool> _requestPermissions() async {
    var permission = await Permission.storage.status;

    if (permission != PermissionStatus.granted)
      permission = await Permission.storage.request();

    return permission == PermissionStatus.granted;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.cloud_download),
            onPressed: () => centerNumbers == null ? null : downloadReport(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ListTile(
                title: Text('show archived'),
                trailing: Switch(
                  value: showArchived,
                  onChanged: (value) {
                    showArchived = value;
                    setState(() {});
                  },
                ),
              ),
              FutureBuilder<CenterNumbers>(
                future: centerNumbersFuture,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    centerNumbers = snapshot.data;
                    return CenterNumbersCard(
                      centerNumbers: centerNumbers,
                      showArchived: showArchived,
                    );
                  } else if (snapshot.hasError) {
                    return Expanded(
                      child: Center(
                        child: EmptyContent(
                          title: 'Something went wrong',
                          message: 'Can\'t load items right now',
                        ),
                      ),
                    );
                  }
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ]),
      ),
    );
  }
}
