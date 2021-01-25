import 'package:alhalaqat/app/home/approved/globalAdmin/ga_config/ga_config_bloc.dart';
import 'package:alhalaqat/app/home/approved/globalAdmin/ga_config/ga_config_provider.dart';
import 'package:alhalaqat/app/models/ga_config.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/common_widgets/firebase_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class GaConfigScreen extends StatefulWidget {
  const GaConfigScreen._({
    Key key,
    @required this.bloc,
  }) : super(key: key);

  final GaConfigBloc bloc;

  static Widget create({@required BuildContext context}) {
    Database database = Provider.of<Database>(context, listen: false);
    GaConfigProvider provider = GaConfigProvider(database: database);
    GaConfigBloc bloc = GaConfigBloc(
      provider: provider,
    );
    return GaConfigScreen._(
      bloc: bloc,
    );
  }

  @override
  _GaConfigScreenState createState() => _GaConfigScreenState();
}

class _GaConfigScreenState extends State<GaConfigScreen> {
  final GlobalKey<FormState> globalAdminFormKey = GlobalKey<FormState>();
  GaConfigBloc get bloc => widget.bloc;

  ProgressDialog pr;
  Future<GaConfig> gaConfigFuture;
  GaConfig gaConfig;
  @override
  void initState() {
    gaConfigFuture = bloc.readgaConfig();
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

  void save() async {
    try {
      await pr.show();
      await bloc.updategaConfig(gaConfig);
      await Future.delayed(Duration(seconds: 1));
      await pr.hide();

      PlatformAlertDialog(
        title: 'نجح الحفظ',
        content: 'تم حفظ البيانات',
        defaultActionText: 'حسنا',
      ).show(context);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('إعدادات التطبيق'),
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(left: 20.0),
            child: InkWell(
              onTap: () => save(),
              child: Icon(
                Icons.save,
                size: 26.0,
              ),
            ),
          ),
        ],
      ),
      body: FutureBuilder(
        future: gaConfigFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            gaConfig = snapshot.data;
            return SwitchListTile(
              title: Text('قبول تلقائي لطلبات'),
              value: gaConfig.autoAccept,
              onChanged: (bool value) {
                setState(() {
                  gaConfig.autoAccept = value;
                });
              },
            );
          } else if (snapshot.hasError) {
            return EmptyContent(
              title: 'Something went wrong',
              message: 'Can\'t load items right now',
            );
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
