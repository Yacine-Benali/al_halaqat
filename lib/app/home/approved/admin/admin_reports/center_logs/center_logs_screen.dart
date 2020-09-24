import 'package:alhalaqat/app/home/approved/admin/admin_reports/center_logs/center_log_tile.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_reports/center_logs/center_logs_bloc.dart';
import 'package:alhalaqat/app/home/approved/admin/admin_reports/center_logs/center_logs_provider.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/teacher_log.dart';
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

class CenterLogsScreen extends StatefulWidget {
  const CenterLogsScreen._({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  final CenterLogsBloc bloc;
  static Widget create({
    @required BuildContext context,
    @required StudyCenter chosenCenter,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);

    CenterLogsProvider provider = CenterLogsProvider(database: database);

    CenterLogsBloc bloc = CenterLogsBloc(
      user: user,
      provider: provider,
      chosenCenter: chosenCenter,
    );

    return CenterLogsScreen._(
      bloc: bloc,
    );
  }

  @override
  _CenterLogsState createState() => _CenterLogsState();
}

class _CenterLogsState extends State<CenterLogsScreen> {
  CenterLogsBloc get bloc => widget.bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//
  Stream<List<TeacherLog>> teacherLogsStream;
  final ScrollController listScrollController = ScrollController();
  List<TeacherLog> teacherLogsList;
  bool isLoadingNextInstances;
  ProgressDialog pr;
  //

  @override
  void initState() {
    teacherLogsStream = bloc.teacherLogsStream;
    isLoadingNextInstances = false;
    bloc.fetchFirstInstances();
    listScrollController.addListener(() {
      double maxScroll = listScrollController.position.maxScrollExtent;
      double currentScroll = listScrollController.position.pixels;
      if (maxScroll == currentScroll) {
        print('load more messages');

        if (teacherLogsList.isNotEmpty) {
          setState(() {
            isLoadingNextInstances = true;
          });
          bloc.fetchNextMessages(teacherLogsList.last).then((value) {
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
          teacherLogsList,
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
        title: Text('السجلات'),
        centerTitle: true,
        actions: [
          IconButton(
              icon: Icon(Icons.cloud_download),
              onPressed: () {
                if (teacherLogsList != null) if (teacherLogsList.isNotEmpty)
                  downloadReport();
              }),
        ],
      ),
      body: StreamBuilder<List<TeacherLog>>(
        stream: teacherLogsStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            teacherLogsList = snapshot.data;
            if (teacherLogsList.isNotEmpty) {
              return ListView.separated(
                separatorBuilder: (_, __) => Divider(height: 0.5),
                itemBuilder: (context, index) {
                  if (index == teacherLogsList.length) {
                    // oups u have reached the top of messages list
                    return _buildProgressIndicator();
                  } else {
                    return CenterLogTile(teacherLog: teacherLogsList[index]);
                  }
                },
                // +1 to include the loading widget
                itemCount: teacherLogsList.length + 1,
                controller: listScrollController,
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

  @override
  void dispose() {
    bloc.dispose();
    listScrollController.dispose();
    super.dispose();
  }
}
