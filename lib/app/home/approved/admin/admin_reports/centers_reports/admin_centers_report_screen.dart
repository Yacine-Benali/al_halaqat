import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_report_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import 'admin_center_report_row.dart';
import 'admin_centers_report_bloc.dart';
import 'admin_centers_report_card.dart';
import 'admin_centers_report_provider.dart';

class AdminCentersReportScreen extends StatefulWidget {
  AdminCentersReportScreen._({Key key, this.bloc}) : super(key: key);

  final AdminCentersReportBloc bloc;

  static Widget create({
    @required BuildContext context,
    @required List<StudyCenter> centersList,
  }) {
    Database database = Provider.of<Database>(context, listen: false);

    AdminCentersReportProvider provider =
        AdminCentersReportProvider(database: database);
    AdminCentersReportBloc bloc = AdminCentersReportBloc(
      provider: provider,
      centersList: centersList,
    );
    return AdminCentersReportScreen._(
      bloc: bloc,
    );
  }

  @override
  _GaCentersReportScreenState createState() => _GaCentersReportScreenState();
}

class _GaCentersReportScreenState extends State<AdminCentersReportScreen> {
  AdminCentersReportBloc get bloc => widget.bloc;
  ProgressDialog pr;
  Future<List<AdminCenterReportRow>> rowListFuture;
  List<AdminCenterReportRow> rowList;

  @override
  void initState() {
    rowListFuture = bloc.getCenterReports();
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
        String filePath = await bloc.getReportasCsv(rowList);
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
            onPressed: () => rowList.isEmpty ? null : downloadReport(),
          ),
        ],
      ),
      body: FutureBuilder<List<AdminCenterReportRow>>(
        future: rowListFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            rowList = snapshot.data;
            if (rowList.isNotEmpty) {
              return AdminCentersReportCard(
                rowList: rowList,
                columnTitleList: bloc.getColumnTitle(),
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
