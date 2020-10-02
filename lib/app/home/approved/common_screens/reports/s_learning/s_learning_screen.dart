import 'package:alhalaqat/app/home/approved/common_screens/reports/s_learning/s_learning_bloc.dart';
import 'package:alhalaqat/app/home/approved/common_screens/reports/s_learning/s_learning_card.dart';
import 'package:alhalaqat/app/home/approved/common_screens/reports/s_learning/s_learning_provider.dart';
import 'package:alhalaqat/app/models/halaqa.dart';
import 'package:alhalaqat/app/models/report_card.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/common_widgets/platform_exception_alert_dialog.dart';
import 'package:alhalaqat/common_widgets/platform_report_dialog.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

class SLearningScreen extends StatefulWidget {
  SLearningScreen._({Key key, this.bloc}) : super(key: key);

  final SLearningBloc bloc;

  static Widget create({
    @required BuildContext context,
    @required List<Halaqa> halaqatList,
  }) {
    Database database = Provider.of<Database>(context, listen: false);

    SLearningProvider provider = SLearningProvider(database: database);
    SLearningBloc bloc = SLearningBloc(
      provider: provider,
      halaqatList: halaqatList,
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
  Halaqa chosenHalaqa;
  DateTime firstDate;
  DateTime lastDate;
  bool showPercentages;
  List<ReportCard> reportCardList;
  ProgressDialog pr;

  @override
  void initState() {
    reportCardList = List();
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
        String filePath = await bloc.saveReport(reportCardList, chosenHalaqa);
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
            onPressed: () => reportCardList.isEmpty ? null : downloadReport(),
          ),
        ],
      ),
      body: Padding(
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
              items: bloc.halaqatList
                  .map<DropdownMenuItem<Halaqa>>((Halaqa value) {
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
                    if (snapshot.hasData) {
                      reportCardList = snapshot.data;
                      if (reportCardList.isNotEmpty) {
                        return SLearningCard(
                          bloc: bloc,
                          list: reportCardList,
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
              ),
            ],
          ],
        ),
      ),
    );
  }
}
