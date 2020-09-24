import 'package:alhalaqat/app/home/approved/common_screens/user_instances/instance_tile_widget.dart';
import 'package:alhalaqat/app/home/approved/common_screens/user_instances/intances_bloc.dart';
import 'package:alhalaqat/app/home/approved/common_screens/user_instances/intances_provider.dart';
import 'package:alhalaqat/app/logs_helper/logs_helper_bloc.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/instance.dart';
import 'package:alhalaqat/app/models/study_center.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class InstancesScreen extends StatefulWidget {
  const InstancesScreen._({
    Key key,
    @required this.bloc,
    @required this.halaqatList,
  }) : super(key: key);

  final InstancesBloc bloc;
  final List<Halaqa> halaqatList;
  static Widget create({
    @required BuildContext context,
    @required Halaqa halaqa,
    @required StudyCenter chosenCenter,
    @required List<Halaqa> halaqatList,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);

    InstancesProvider provider = InstancesProvider(database: database);
    LogsHelperBloc logsHelperBloc =
        Provider.of<LogsHelperBloc>(context, listen: false);
    InstancesBloc bloc = InstancesBloc(
      user: user,
      provider: provider,
      halaqa: halaqa,
      logsHelperBloc: logsHelperBloc,
      chosenCenter: chosenCenter,
    );

    return InstancesScreen._(
      bloc: bloc,
      halaqatList: halaqatList,
    );
  }

  @override
  _InstancesScreenState createState() => _InstancesScreenState();
}

class _InstancesScreenState extends State<InstancesScreen> {
  InstancesBloc get bloc => widget.bloc;
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

//
  Stream<List<Instance>> instancesStream;
  final ScrollController listScrollController = ScrollController();
  List<Instance> instances;
  bool isLoadingNextInstances;
  ProgressDialog pr;
  //

  @override
  void initState() {
    instancesStream = bloc.instancesStream;
    isLoadingNextInstances = false;
    bloc.fetchFirstInstances();

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
    listScrollController.addListener(() {
      double maxScroll = listScrollController.position.maxScrollExtent;
      double currentScroll = listScrollController.position.pixels;
      if (maxScroll == currentScroll) {
        print('load more messages');

        if (instances.isNotEmpty) {
          setState(() {
            isLoadingNextInstances = true;
          });
          bloc.fetchNextMessages(instances.last).then((value) {
            setState(() {
              isLoadingNextInstances = false;
            });
          });
        }
      }
    });
    super.initState();
  }

  void createInstance() async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: 'هل تريد إنشاء جلسة الآن',
      content: 'هل أنت متأكد ؟',
      cancelActionText: 'إلغاء',
      defaultActionText: 'حسنا',
    ).show(context);
    if (didRequestSignOut == true) {
      try {
        await pr.show();
        bloc.createNewInstance();
        await Future.delayed(Duration(seconds: 1));
        await pr.hide();

        PlatformAlertDialog(
          title: 'تم إنشاء جلسة ',
          content: 'يرجى إدخال المعلومات',
          defaultActionText: 'حسنا',
        ).show(context);
        Navigator.of(context).pop();
      } catch (e) {
        await pr.hide();
        if (e is PlatformException) {
          PlatformExceptionAlertDialog(
            title: 'فشلت العملية',
            exception: e,
          ).show(context);
        } else if (e is FirebaseException)
          FirebaseExceptionAlertDialog(
            title: 'فشلت العملية',
            exception: e,
          ).show(context);
        else
          PlatformAlertDialog(
            title: 'فشلت العملية',
            content: 'فشلت العملية',
            defaultActionText: 'حسنا',
          ).show(context);
      }
    }
  }

  //void createInstance() {}

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
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => createInstance(),
        tooltip: 'add',
        child: Icon(Icons.add),
      ),
      body: StreamBuilder<List<Instance>>(
        stream: instancesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            instances = snapshot.data;
            if (instances.isNotEmpty) {
              return ListView.separated(
                separatorBuilder: (_, __) => Divider(height: 0.5),
                itemBuilder: (context, index) {
                  if (index == instances.length) {
                    // oups u have reached the top of messages list
                    return _buildProgressIndicator();
                  } else {
                    return InstanceTileWidget(
                      bloc: bloc,
                      instance: instances[index],
                      scaffoldKey: _scaffoldKey,
                      index: index,
                      halaqatList: widget.halaqatList,
                      chosenCenter: bloc.chosenCenter,
                    );
                  }
                },
                // +1 to include the loading widget
                itemCount: instances.length + 1,
                controller: listScrollController,
              );
            } else {
              return EmptyContent(
                title: '',
                message: 'لا يوجد جلسات بعد، لإضافة جلسة إضغط على إشارة +',
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
