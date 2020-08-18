import 'package:al_halaqat/app/home/approved/common_screens/user_instances/instance_tile_widget.dart';
import 'package:al_halaqat/app/home/approved/common_screens/user_instances/intances_bloc.dart';
import 'package:al_halaqat/app/home/approved/common_screens/user_instances/intances_provider.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/instance.dart';
import 'package:al_halaqat/app/models/student_attendance.dart';
import 'package:al_halaqat/app/models/students_attendance_summery.dart';
import 'package:al_halaqat/app/models/study_center.dart';
import 'package:al_halaqat/app/models/user.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/common_widgets/platform_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class InstancesScreen extends StatefulWidget {
  const InstancesScreen._({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  final InstancesBloc bloc;
  static Widget create({
    @required BuildContext context,
    @required Halaqa halaqa,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);

    InstancesProvider provider = InstancesProvider(database: database);
    InstancesBloc bloc =
        InstancesBloc(user: user, provider: provider, halaqa: halaqa);

    return InstancesScreen._(
      bloc: bloc,
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
        await bloc.createNewInstance();
        await pr.hide();

        PlatformAlertDialog(
          title: 'نجح الحفظ',
          content: 'تم حفظ البيانات',
          defaultActionText: 'حسنا',
        ).show(context);
      } on PlatformException catch (e) {
        await pr.hide();
        PlatformExceptionAlertDialog(
          title: 'فشلت العملية',
          exception: e,
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
                    );
                  }
                },
                // +1 to include the loading widget
                itemCount: instances.length + 1,
                controller: listScrollController,
              );
            } else {
              return EmptyContent(
                title: 'welcom to the messages screen',
                message:
                    'here you can send and recieve message from the teachers',
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
