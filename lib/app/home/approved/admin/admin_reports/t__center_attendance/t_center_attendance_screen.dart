import 'package:alhalaqat/app/home/approved/admin/admin_reports/t__center_attendance/t_center_attendance_bloc.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_reports/t__center_attendance/t_center_attendance_card.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_reports/t__center_attendance/t_center_attendance_provider.dart';
import 'package:alhalaqat/app/models/local_t_c_a_report.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/common_widgets/date_range_picker.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_report_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class TCenterAttendanceScreen extends StatefulWidget {
  TCenterAttendanceScreen._({Key key, this.bloc}) : super(key: key);

  final TCenterAttendanceBloc bloc;

  static Widget create({
    @required BuildContext context,
    @required StudyCenter center,
  }) {
    Database database = Provider.of<Database>(context, listen: false);

    TCenterAttendanceProvider provider =
        TCenterAttendanceProvider(database: database);
    TCenterAttendanceBloc bloc = TCenterAttendanceBloc(
      provider: provider,
      center: center,
    );
    return TCenterAttendanceScreen._(
      bloc: bloc,
    );
  }

  @override
  _TCenterAttendanceScreenState createState() =>
      _TCenterAttendanceScreenState();
}

class _TCenterAttendanceScreenState extends State<TCenterAttendanceScreen> {
  TCenterAttendanceBloc get bloc => widget.bloc;
  DateTime firstDate;
  DateTime lastDate;
  ProgressDialog pr;
  List<LocalTCAReport> list;

  @override
  void initState() {
    DateTime defaulte = DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day,
      0,
      0,
      0,
    );
    firstDate = defaulte.subtract(Duration(days: 7));
    lastDate = DateTime.now();
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
        String filePath = await bloc.getReportasCsv(list, firstDate, lastDate);
        await pr.hide();
        await PlatformReportDialog(filePath: filePath).show(context);
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
            onPressed: () {
              list.isEmpty ? null : downloadReport();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<LocalTCAReport>>(
        future: bloc.fetchTeachers(firstDate, lastDate),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            list = snapshot.data;
            if (list.isNotEmpty) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DateRangePicker(
                      firstDate: (value) => setState(() => firstDate = value),
                      lastDate: (value) => setState(() => lastDate = value),
                    ),
                    SizedBox(height: 8),
                    TCenterAttendanceCard(
                      bloc: bloc,
                      list: list,
                    )
                  ],
                ),
              );
            } else {
              return EmptyContent(
                title: '',
                message: '',
              );
            }
          } else if (snapshot.hasError) {
            return EmptyContent(
              title: 'Something went wrong',
              message: 'Can\'t load items right now',
            );
          }
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      ),
    );
  }
}
