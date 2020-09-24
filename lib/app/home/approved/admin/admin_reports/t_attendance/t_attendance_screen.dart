import 'package:alhalaqat/app/home/approved/admin/admin_reports/t_attendance/t_attendance_bloc.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_reports/t_attendance/t_attendance_provider.dart';
import 'package:alhalaqat/app/home/approved/common_screens/reports/s_attendance/s_attendance_card.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/user_attendance_summery.dart';
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

class TAttendanceScreen extends StatefulWidget {
  TAttendanceScreen._({Key key, this.bloc}) : super(key: key);

  final TAttendanceBloc bloc;

  static Widget create({
    @required BuildContext context,
    @required StudyCenter center,
    @required List<Halaqa> halaqatList,
  }) {
    Database database = Provider.of<Database>(context, listen: false);

    TAttendanceProvider provider = TAttendanceProvider(database: database);
    TAttendanceBloc bloc = TAttendanceBloc(
      provider: provider,
      center: center,
      halaqatList: halaqatList,
    );
    return TAttendanceScreen._(
      bloc: bloc,
    );
  }

  @override
  _TAttendanceScreenState createState() => _TAttendanceScreenState();
}

class _TAttendanceScreenState extends State<TAttendanceScreen> {
  TAttendanceBloc get bloc => widget.bloc;
  Halaqa chosenHalaqa;
  DateTime firstDate;
  DateTime lastDate;
  bool showPercentages;
  List<UsersAttendanceSummery> userSummeryList;
  ProgressDialog pr;

  @override
  void initState() {
    userSummeryList = List();
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
    showPercentages = false;
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
            await bloc.getReportasCsv(userSummeryList, firstDate, lastDate);
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
            onPressed: () => userSummeryList.isEmpty ? null : downloadReport(),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text('النسبة المئوية'),
              trailing: Switch(
                value: showPercentages,
                onChanged: (value) {
                  showPercentages = value;
                  setState(() {});
                },
              ),
            ),
            DropdownButton<Halaqa>(
              itemHeight: 67,
              value: chosenHalaqa,
              hint: Text('إختر الحلقة'),
              isExpanded: true,
              icon: Icon(Icons.arrow_drop_down),
              iconSize: 24,
              underline: Container(
                height: 2,
                color: Colors.grey[400],
              ),
              onChanged: (Halaqa newValue) =>
                  setState(() => chosenHalaqa = newValue),
              items: bloc.halaqatList
                  .map<DropdownMenuItem<Halaqa>>((Halaqa value) {
                return DropdownMenuItem<Halaqa>(
                  value: value,
                  child: Text(value.name + '-' + value.readableId),
                );
              }).toList(),
            ),
            DateRangePicker(
              firstDate: (value) => setState(() => firstDate = value),
              lastDate: (value) => setState(() => lastDate = value),
            ),
            SizedBox(height: 8),
            if (chosenHalaqa != null) ...[
              Expanded(
                child: FutureBuilder<List<UsersAttendanceSummery>>(
                  future: bloc.fetchInstances(
                    chosenHalaqa,
                    firstDate,
                    lastDate,
                    showPercentages,
                  ),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      userSummeryList = snapshot.data;
                      if (userSummeryList.isNotEmpty) {
                        return SAttendanceCard(
                          halaqa: chosenHalaqa,
                          firstDate: firstDate,
                          lastDate: lastDate,
                          showPercentages: showPercentages,
                          list: userSummeryList,
                        );
                      } else {
                        return EmptyContent(
                          title: 'empty',
                          message: 'empty',
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
              ),
            ]
          ],
        ),
      ),
    );
  }
}
