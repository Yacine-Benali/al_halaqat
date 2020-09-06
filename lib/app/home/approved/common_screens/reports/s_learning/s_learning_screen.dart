import 'package:al_halaqat/app/home/approved/common_screens/reports/s_learning/s_learning_bloc.dart';
import 'package:al_halaqat/app/home/approved/common_screens/reports/s_learning/s_learning_card.dart';
import 'package:al_halaqat/app/home/approved/common_screens/reports/s_learning/s_learning_provider.dart';
import 'package:al_halaqat/app/models/halaqa.dart';
import 'package:al_halaqat/app/models/report_card.dart';
import 'package:al_halaqat/common_widgets/empty_content.dart';
import 'package:al_halaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:al_halaqat/common_widgets/progress_dialog.dart';
import 'package:al_halaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SLearningScreen extends StatefulWidget {
  SLearningScreen._({Key key, this.bloc}) : super(key: key);

  final SLearningBloc bloc;

  static Widget create({
    @required BuildContext context,
    @required List<String> halaqatId,
  }) {
    Database database = Provider.of<Database>(context, listen: false);

    SLearningProvider provider = SLearningProvider(database: database);
    SLearningBloc bloc = SLearningBloc(
      provider: provider,
      halaqatId: halaqatId,
    );
    return SLearningScreen._(
      bloc: bloc,
    );
  }

  @override
  _SLearningScreenState createState() => _SLearningScreenState();
}

class _SLearningScreenState extends State<SLearningScreen> {
  SLearningBloc get bloc => widget.bloc;
  Future<List<List<Halaqa>>> halaqatFuture;
  Halaqa chosenHalaqa;
  DateTime firstDate;
  DateTime lastDate;
  bool showPercentages;
  List<ReportCard> reportCardList;
  ProgressDialog pr;

  @override
  void initState() {
    reportCardList = List();
    halaqatFuture = bloc.fetchHalaqat();
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
        String filePath = '';
        // await bloc.getReportasCsv(reportCardList, firstDate, lastDate);
        await pr.hide();

        bool isConfirm = await showDialog<bool>(
          context: context,
          child: AlertDialog(
            title: Text('نجح الحفظ'),
            contentPadding: const EdgeInsets.all(16.0),
            content: Text('نجح الحفظ'),
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
        if (isConfirm) OpenFile.open(filePath);
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
        title: Text('d'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(Icons.cloud_download),
            onPressed: () => reportCardList.isEmpty ? null : downloadReport(),
          ),
        ],
      ),
      body: FutureBuilder(
          future: halaqatFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              final List<List<Halaqa>> temp = snapshot.data;
              final List<Halaqa> items = temp.expand((x) => x).toList();
              if (items.isNotEmpty) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                        items:
                            items.map<DropdownMenuItem<Halaqa>>((Halaqa value) {
                          return DropdownMenuItem<Halaqa>(
                            value: value,
                            child: Text(value.name + '-' + value.readableId),
                          );
                        }).toList(),
                      ),
                      SizedBox(height: 8),
                      if (chosenHalaqa != null) ...[
                        Expanded(
                          child: FutureBuilder(
                            future: bloc.fetchReportCards(chosenHalaqa),
                            builder: (context, snapshot) {
                              print(snapshot);
                              if (snapshot.hasData) {
                                reportCardList = snapshot.data;
                                if (reportCardList.isNotEmpty) {
                                  return SLearningCard(
                                    bloc: bloc,
                                    list: reportCardList,
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
                      ],
                    ],
                  ),
                );
              } else {
                return EmptyContent(
                  title: 'empty',
                  message: 'mesemptysage',
                );
              }
            } else if (snapshot.hasError) {
              return EmptyContent(
                title: 'Something went wrong',
                message: 'Can\'t load items right now',
              );
            }
            return Center(child: CircularProgressIndicator());
          }),
    );
  }
}
