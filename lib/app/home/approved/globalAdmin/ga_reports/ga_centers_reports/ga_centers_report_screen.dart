import 'package:al_halaqat/app/home/approved/globalAdmin/ga_reports/ga_centers_reports/ga_center_report_row.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_reports/ga_centers_reports/ga_centers_report_bloc.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_reports/ga_centers_reports/ga_centers_report_card.dart';
import 'package:al_halaqat/app/home/approved/globalAdmin/ga_reports/ga_centers_reports/ga_centers_report_provider.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_report_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class GaCentersReportScreen extends StatefulWidget {
  GaCentersReportScreen._({Key key, this.bloc}) : super(key: key);

  final GaCentersReportBloc bloc;

  static Widget create({
    @required BuildContext context,
  }) {
    Database database = Provider.of<Database>(context, listen: false);

    GaCentersReportProvider provider =
        GaCentersReportProvider(database: database);
    GaCentersReportBloc bloc = GaCentersReportBloc(provider: provider);
    return GaCentersReportScreen._(
      bloc: bloc,
    );
  }

  @override
  _GaCentersReportScreenState createState() => _GaCentersReportScreenState();
}

class _GaCentersReportScreenState extends State<GaCentersReportScreen> {
  GaCentersReportBloc get bloc => widget.bloc;
  ProgressDialog pr;
  Future<List<GaCenterReportRow>> rowListFuture;
  List<GaCenterReportRow> rowList;

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
      body: FutureBuilder<List<GaCenterReportRow>>(
        future: rowListFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            rowList = snapshot.data;
            if (rowList.isNotEmpty) {
              return GaCentersReportCard(
                rowList: rowList,
                columnTitleList: bloc.getColumnTitle(),
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
    );
  }
}
