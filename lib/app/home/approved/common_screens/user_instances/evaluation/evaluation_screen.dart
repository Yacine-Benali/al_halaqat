import 'package:alhalaqat/app/home/approved/common_screens/user_instances/evaluation/evaluation_bloc.dart';
import 'package:alhalaqat/app/home/approved/common_screens/user_instances/evaluation/evaluation_provider.dart';
import 'package:alhalaqat/app/home/approved/common_screens/user_instances/evaluation/new_evaluation_screen.dart';
import 'package:alhalaqat/app/models/evaluation.dart';
import 'package:alhalaqat/app/models/instance.dart';
import 'package:alhalaqat/app/models/quran.dart';
import 'package:alhalaqat/app/models/user.dart';
import 'package:alhalaqat/common_widgets/empty_content.dart';
import 'package:alhalaqat/common_widgets/progress_dialog.dart';
import 'package:alhalaqat/common_widgets/size_config.dart';
import 'package:alhalaqat/services/database.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EvaluationScreen extends StatefulWidget {
  const EvaluationScreen._({Key key, @required this.bloc}) : super(key: key);

  final EvaluationBloc bloc;
  static Widget create({
    @required BuildContext context,
    @required Instance instance,
    @required String studentId,
    @required String studentName,
    @required Quran quran,
  }) {
    Database database = Provider.of<Database>(context, listen: false);
    User user = Provider.of<User>(context, listen: false);

    EvaluationProvider provider = EvaluationProvider(database: database);
    EvaluationBloc bloc = EvaluationBloc(
      instance: instance,
      provider: provider,
      user: user,
      studentId: studentId,
      quran: quran,
      studentName: studentName,
    );

    return EvaluationScreen._(
      bloc: bloc,
    );
  }

  @override
  _AttendanceScreenState createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<EvaluationScreen> {
  EvaluationBloc get bloc => widget.bloc;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  //
  ProgressDialog pr;
  Stream<List<Evaluation>> evaluationsListFuture;
  List<Evaluation> evaluationsList;
  Future<Quran> quranFuture;

  @override
  void initState() {
    evaluationsListFuture = bloc.fetchEvaluations();

    pr = ProgressDialog(
      context,
      type: ProgressDialogType.Normal,
      textDirection: TextDirection.ltr,
      isDismissible: false,
    );
    pr.style(
      message: 'جاري الرفع',
      messageTextStyle: TextStyle(fontSize: 14),
      progressWidget: Container(
        padding: EdgeInsets.all(8.0),
        child: CircularProgressIndicator(),
      ),
    );
    super.initState();
  }

  TableRow buildColumnBlock() {
    List<String> columnTitleList = bloc.getColumnTitle();
    List<TableCell> cells = [];

    for (int i = 0; i < columnTitleList.length; i++) {
      if (i == 2) {
        TableCell cell = TableCell(
          child: Container(
            decoration: BoxDecoration(
              border: Border(
                left: BorderSide(color: Colors.grey, width: 2),
              ),
            ),
            padding: EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                '${columnTitleList[i]}',
                wrapWords: false,
              ),
            ),
          ),
        );
        cells.add(cell);
      } else {
        TableCell cell = TableCell(
          child: Container(
            padding: EdgeInsets.all(8),
            child: Align(
              alignment: Alignment.centerLeft,
              child: AutoSizeText(
                '${columnTitleList[i]}',
                wrapWords: false,
              ),
            ),
          ),
        );
        cells.add(cell);
      }
    }
    return TableRow(children: cells);
  }

  List<TableRow> buildRowList() {
    List<TableRow> tableRowList = List();

    for (Evaluation evaluation in evaluationsList) {
      TableRow tableRow = TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            alignment: Alignment.center,
            child: AutoSizeText(
              bloc.format(
                evaluation?.createdAt?.toDate() ?? DateTime.now(),
              ),
              wrapWords: false,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              bloc.format2(evaluation.memorized),
              maxLines: 2,
              minFontSize: 3,
              wrapWords: true,
            ),
          ),
        ),
        Container(
          height: kMinInteractiveDimension,
          decoration: BoxDecoration(
            border: Border(
              left: BorderSide(color: Colors.grey, width: 2),
            ),
          ),
          alignment: Alignment.center,
          child: Text(
            evaluation.memorized.mark.toString(),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: AutoSizeText(
              bloc.format2(evaluation.rehearsed),
              maxLines: 2,
              minFontSize: 3,
              wrapWords: true,
            ),
          ),
        ),
        Container(
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              evaluation.rehearsed.mark.toString(),
            ),
          ),
        ),
      ]);

      tableRowList.add(tableRow);
    }
    return tableRowList;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('تقييم'),
          centerTitle: true,
        ),
        body: StreamBuilder<List<Evaluation>>(
          stream: evaluationsListFuture,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              evaluationsList = snapshot.data;
              return Scaffold(
                floatingActionButton: FloatingActionButton(
                  onPressed: () =>
                      Navigator.of(context, rootNavigator: false).push(
                    MaterialPageRoute(
                      builder: (context) => NewEvaluationScreen(
                        bloc: bloc,
                        evaluationsList: evaluationsList,
                      ),
                      fullscreenDialog: true,
                    ),
                  ),
                  tooltip: 'add',
                  child: Icon(Icons.add),
                ),
                body: SingleChildScrollView(
                  child: Card(
                    margin: EdgeInsets.all(4.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        minWidth: SizeConfig.screenWidth,
                        maxWidth: SizeConfig.screenWidth,
                      ),
                      child: Form(
                        key: _formKey,
                        autovalidate: true,
                        child: Table(
                          defaultVerticalAlignment:
                              TableCellVerticalAlignment.middle,
                          border: TableBorder(
                            horizontalInside:
                                BorderSide(width: 1.0, color: Colors.grey[350]),
                            bottom:
                                BorderSide(width: 1.0, color: Colors.grey[350]),
                          ),
                          children: [
                                buildColumnBlock(),
                              ] +
                              buildRowList(),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            } else if (snapshot.hasError) {
              return EmptyContent(
                title: 'Something went wrong',
                message: 'Can\'t load items right now',
              );
            }
            return Center(child: CircularProgressIndicator());
          },
        ));
  }
}
