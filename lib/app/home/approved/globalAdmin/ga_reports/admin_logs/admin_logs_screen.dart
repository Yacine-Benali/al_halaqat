import 'package:alhalaqat/app/home/approved/globalAdmin/ga_reports/admin_logs/admin_log_tile.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_reports/admin_logs/admin_logs_bloc.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_reports/admin_logs/admin_logs_provider.dart';
import 'package:alhalaqat/app/models/admin_log.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_report_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class AdminLogsScreen extends StatefulWidget {
  const AdminLogsScreen._({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  final AdminLogsBloc bloc;
  static Widget create({
    @required BuildContext context,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);

    AdminLogsProvider provider = AdminLogsProvider(database: database);

    AdminLogsBloc bloc = AdminLogsBloc(
      user: user,
      provider: provider,
    );

    return AdminLogsScreen._(
      bloc: bloc,
    );
  }

  @override
  _CenterLogsState createState() => _CenterLogsState();
}

class _CenterLogsState extends State<AdminLogsScreen> {
  AdminLogsBloc get bloc => widget.bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//
  Stream<List<AdminLog>> adminLogsStream;
  final ScrollController listScrollController = ScrollController();
  List<AdminLog> adminLogsList;
  bool isLoadingNextInstances;
  ProgressDialog pr;
  //

  @override
  void initState() {
    adminLogsStream = bloc.adminLogsStream;
    isLoadingNextInstances = false;
    bloc.fetchFirstInstances();
    listScrollController.addListener(() {
      double maxScroll = listScrollController.position.maxScrollExtent;
      double currentScroll = listScrollController.position.pixels;
      if (maxScroll == currentScroll) {
        print('load more messages');

        if (adminLogsList.isNotEmpty) {
          setState(() {
            isLoadingNextInstances = true;
          });
          bloc.fetchNextMessages(adminLogsList.last).then((value) {
            setState(() {
              isLoadingNextInstances = false;
            });
          });
        }
      }
    });
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
        String filePath = await bloc.getReportasCsv(
          adminLogsList,
        );
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

  /// show progress indicator when user upload old messages
  Widget _buildProgressIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(
        child: Opacity(
          opacity: isLoadingNextInstances ? 1 : 0,
          child: CircularProgressIndicator(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('الجلسات'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.cloud_download),
              onPressed: () {
                if (adminLogsList != null) if (adminLogsList.isNotEmpty)
                  downloadReport();
              }),
        ],
      ),
      body: StreamBuilder<List<AdminLog>>(
        stream: adminLogsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            adminLogsList = snapshot.data;
            if (adminLogsList.isNotEmpty) {
              return ListView.separated(
                separatorBuilder: (_, __) => Divider(height: 0.5),
                itemBuilder: (context, index) {
                  if (index == adminLogsList.length) {
                    // oups u have reached the top of messages list
                    return _buildProgressIndicator();
                  } else {
                    return AdminLogTile(adminLog: adminLogsList[index]);
                  }
                },
                // +1 to include the loading widget
                itemCount: adminLogsList.length + 1,
                controller: listScrollController,
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

  @override
  void dispose() {
    bloc.dispose();
    listScrollController.dispose();
    super.dispose();
  }
}
